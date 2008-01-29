Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYA2Jeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYA2Jeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 04:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYA2Jeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 04:34:36 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:15253 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbYA2Jef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 04:34:35 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <479E5D22.1070109@goop.org>
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
	 <479E5D22.1070109@goop.org>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 09:34:11 +0000
Message-Id: <1201599251.5301.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 14:54 -0800, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> > I'm mainly interested in something along these lines to allow the Xen
> > bootloader to load a bzImage so that distros don't have to maintain two
> > kernel packages with the same basic bits in different file formats, I
> > think it would probably be of use to the kexec and/or lguest folks too.
> >
> > The patch boots on native 32 and 64 bit x86. I haven't done the matching
> > Xen domain builder work but the attached bzexplode.c is a trivial/ugly
> > (don't judge me based on it ;-)) test app which extracts the payload,
> > which I have been able to boot as a 32 bit Xen domU, as you'd expect.
> >   
> 
> I've got a bzImage-loading domain builder patch somewhere.  It's based 
> on my version of what you've done here, which isn't very different.

Thanks, I'll probably make use of that patch when I come to do the
domain builder bits.

> The problem I ran into is that 32-bit boot loaders expect to be able to 
> load the payload portion of the bzImage and simply jmp 0x100000, which 
> would start executing the ELF header.

The payload I'm changing is the payload from the point of view of
arch/x86/boot/compressed -- i.e. piggy.o which becomes part of the
vmlinux in that directory (too many files called vmlinux!). I that might
more accurately be described that as the "payload of the payload" from
the point of view of a bzImage file or the "payload of the compressor
portion" or something.

If you strip of setup_sects (+1?) from a bzImage, which I think is what
you are referring above, then you end up with essentially
arch/x86/boot/compressed/vmlinux (at address 0x100000 from one of the
bzImage header fields) which can still be jumped to by a 32 bit
bootloader. It will decompress and process the ELF bits correctly. I
think this is where my patch differs from your previous version, you
made the actual compressor portion an ELF file within the bzImage.

The thing which no longer works here is scanning the whole image looking
for a gzip header just past setup_sects and extracting that expecting to
find a raw binary because you will actually find an ELF file. I'm not
sure that's an "interface" which could be expected to continue to work
for all time anyway.

> > What would be the preferred way of allowing bootloaders/domain builders
> > to find the compressed payload? Tacking the offset from the end onto the
> > end as I have done for the moment seems pretty skanky...
> >   
> 
> The header format is extensible, so you just up the bootloader revision 
> and put the appropriate extra members.

That's what I figured. There will be some build system pain to extract
those offsets from boot/compressed/vmlinux and incorporate them into
boot/bzImage but I'll figure something out.

Ian.

-- 
Ian Campbell
Current Noise: Centurions Ghost - Specimen No.7

Psychoanalysis is that mental illness for which it regards itself a
therapy.
		-- Karl Kraus

