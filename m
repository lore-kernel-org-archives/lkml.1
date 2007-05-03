Return-Path: <linux-kernel-owner+w=401wt.eu-S1767311AbXECCBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767311AbXECCBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767312AbXECCBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:01:32 -0400
Received: from ozlabs.org ([203.10.76.45]:50397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767311AbXECCBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:01:30 -0400
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
	relocatable bzImage
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>, Gerd Hoffmann <kraxel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <4638FE1B.9050901@zytor.com>
References: <20070428758.455116000@suse.de>
	 <20070428175909.1D09D151CA@wotan.suse.de>	<46338D72.70402@garzik.org>
	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com>	<4634483E.9030307@goop.org>
	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>
	 <46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org>
	 <4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org>
	 <4638FE1B.9050901@zytor.com>
Content-Type: text/plain
Date: Thu, 03 May 2007 12:01:24 +1000
Message-Id: <1178157684.23670.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 14:09 -0700, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> > 
> > Hm, that's unfortunate.  How about an ELF file wrapped in some other
> > container, so that we can easily extract a properly formed ELF file?
> > 
> 
> Effectively the same thing as changing the magic number.  Note that the
> format for bzImage is pretty rigid, and it would be *highly* undesirable
> to muck that up.

To add some code to the debate, here's how lguest loads a bzImage (from
my draft documentation).  Almost anything would be an improvement:


/* A bzImage, unlike an ELF file, is not meant to be loaded.  You're
 * supposed to jump into it and it will unpack itself.  We can't do that
 * because the Guest can't run the unpacking code, and adding features to
 * lguest kills puppies, so we don't want to.
 *
 * The bzImage is formed by putting the decompressing code in front of the
 * compressed kernel code.  So we can simple scan through it looking for the
 * first "gzip" header, and start decompressing from there. */
static unsigned long load_bzimage(int fd, unsigned long *page_offset)
{
	unsigned char c;
	int state = 0;

	/* GZIP header is 0x1F 0x8B <method> <flags>... <compressed-by>. */
	while (read(fd, &c, 1) == 1) {
		switch (state) {
		case 0:
			if (c == 0x1F)
				state++;
			break;
		case 1:
			if (c == 0x8B)
				state++;
			else
				state = 0;
			break;
		case 2 ... 8:
			state++;
			break;
		case 9:
			/* Seek back to the start of the gzip header. */
			lseek(fd, -10, SEEK_CUR);
			/* One final check: "compressed under UNIX". */
			if (c != 0x03)
				state = -1;
			else
				return unpack_bzimage(fd, page_offset);
		}
	}
	errx(1, "Could not find kernel in bzImage");
}

/* Unfortunately the entire ELF image isn't compressed: the segments
 * which need loading are extracted and compressed raw.  This denies us the
 * information we need to make a fully-general loader. */
static unsigned long unpack_bzimage(int fd, unsigned long *page_offset)
{
	gzFile f;
	int ret, len = 0;
	/* A bzImage always gets loaded at physical address 1M.  This is
	 * actually configurable as CONFIG_PHYSICAL_START, but as the comment
	 * there says, "Don't change this unless you know what you are doing".
	 * Indeed. */
	void *img = (void *)0x100000;

	/* gzdopen takes our file descriptor (carefully placed at the start of
	 * the GZIP header we found) and returns a gzFile. */
	f = gzdopen(fd, "rb");
	/* Unfortunately, if we made a mistake and it wasn't really a gzip
	 * header, it will still read the file, but directly without
	 * decompressing it.  For us, that's a misfeature. */
	if (gzdirect(f))
		errx(1, "did not find correct gzip header");
	/* We read it into memory in 64k chunks until we hit the end. */
	while ((ret = gzread(f, img + len, 65536)) > 0)
		len += ret;
	if (ret < 0)
		err(1, "reading image from bzImage");

	verbose("Unpacked size %i addr %p\n", len, img);

	/* Without the ELF header, we can't tell virtual-physical gap.  This is
	 * CONFIG_PAGE_OFFSET, and people do actually change it.  Fortunately,
	 * I have a clever way of figuring it out from the code itself.  */
	*page_offset = intuit_page_offset(img, len);

	/* Entry is physical address: convert to virtual */
	return (unsigned long)img + *page_offset;
}

/* Prepare to be SHOCKED and AMAZED.  And possibly a trifle nauseated.
 *
 * We know that CONFIG_PAGE_OFFSET sets what virtual address the kernel expects
 * to be.  We don't know what that option was, but we can figure it out
 * approximately by looking at the addresses in the code.  I chose the common
 * case of reading a memory location into the %eax register:
 *
 *  movl <some-address>, %eax
 *
 * This gets encoded as five bytes: "0xA1 <4-byte-address>".  For example,
 * "0xA1 0x18 0x60 0x47 0xC0" reads the address 0xC0476018 into %eax.
 *
 * In this example can guess that the kernel was compiled with
 * CONFIG_PAGE_OFFSET set to 0xC0000000 (it's always a round number).  If the
 * kernel were larger than 16MB, we might see 0xC1 addresses show up, but our
 * kernel isn't that bloated yet.
 *
 * Unfortunately, x86 has variable-length instructions, so finding this
 * particular instruction properly involves writing a disassembler.  Instead,
 * we rely on statistics.  We look for "0xA1" and tally the different bytes
 * which occur 4 bytes later (the "0xC0" in our example above).  When one of
 * those bytes appears three times, we can be reasonably confident that it
 * forms the start of CONFIG_PAGE_OFFSET.
 *
 * This is amazingly reliable. */
static unsigned long intuit_page_offset(unsigned char *img, unsigned long len)
{
	unsigned int i, possibilities[256] = { 0 };

	for (i = 0; i + 4 < len; i++) {
		/* mov 0xXXXXXXXX,%eax */
		if (img[i] == 0xA1 && ++possibilities[img[i+4]] > 3)
			return (unsigned long)img[i+4] << 24;
	}
	errx(1, "could not determine page offset");
}




