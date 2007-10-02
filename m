Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbXJBXlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbXJBXlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbXJBXlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:41:25 -0400
Received: from ozlabs.org ([203.10.76.45]:56681 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbXJBXlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:41:24 -0400
Subject: [PATCH 5/5] lguest: loading bzImage directly
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, lguest <lguest@ozlabs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1191368399.17826.51.camel@localhost.localdomain>
References: <1191368052.17826.40.camel@localhost.localdomain>
	 <1191368106.17826.43.camel@localhost.localdomain>
	 <1191368154.17826.44.camel@localhost.localdomain>
	 <1191368217.17826.47.camel@localhost.localdomain>
	 <1191368399.17826.51.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 09:40:57 +1000
Message-Id: <1191368457.17826.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now arch/i386/boot/compressed/head.S understands the hardware_platform field,
we can directly execute bzImages.  No more horrific unpacking code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c    |   97 ++++++++++++--------------------------
 arch/i386/boot/compressed/head.S |    6 ++
 drivers/lguest/lguest.c          |    5 +
 3 files changed, 42 insertions(+), 66 deletions(-)

diff -r b0480fd71a72 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Tue Oct 02 22:28:13 2007 +1000
+++ b/Documentation/lguest/lguest.c	Tue Oct 02 22:52:07 2007 +1000
@@ -326,74 +326,39 @@ static unsigned long map_elf(int elf_fd,
 	return ehdr->e_entry;
 }
 
-/*L:160 Unfortunately the entire ELF image isn't compressed: the segments
- * which need loading are extracted and compressed raw.  This denies us the
- * information we need to make a fully-general loader. */
-static unsigned long unpack_bzimage(int fd)
-{
-	gzFile f;
-	int ret, len = 0;
-	/* A bzImage always gets loaded at physical address 1M.  This is
-	 * actually configurable as CONFIG_PHYSICAL_START, but as the comment
-	 * there says, "Don't change this unless you know what you are doing".
-	 * Indeed. */
-	void *img = from_guest_phys(0x100000);
-
-	/* gzdopen takes our file descriptor (carefully placed at the start of
-	 * the GZIP header we found) and returns a gzFile. */
-	f = gzdopen(fd, "rb");
-	/* We read it into memory in 64k chunks until we hit the end. */
-	while ((ret = gzread(f, img + len, 65536)) > 0)
-		len += ret;
-	if (ret < 0)
-		err(1, "reading image from bzImage");
-
-	verbose("Unpacked size %i addr %p\n", len, img);
-
-	/* The entry point for a bzImage is always the first byte */
-	return (unsigned long)img;
-}
-
 /*L:150 A bzImage, unlike an ELF file, is not meant to be loaded.  You're
- * supposed to jump into it and it will unpack itself.  We can't do that
- * because the Guest can't run the unpacking code, and adding features to
- * lguest kills puppies, so we don't want to.
- *
- * The bzImage is formed by putting the decompressing code in front of the
- * compressed kernel code.  So we can simple scan through it looking for the
- * first "gzip" header, and start decompressing from there. */
+ * supposed to jump into it and it will unpack itself.  We used to have to
+ * perform some hairy magic because the unpacking code scared me.
+ *
+ * Fortunately, Jeremy Fitzhardinge convinced me it wasn't that hard and wrote
+ * a small patch to jump over the tricky bits in the guest, so now we just read
+ * the funky header so we know where in the file to load, and away we go! */
 static unsigned long load_bzimage(int fd)
 {
-	unsigned char c;
-	int state = 0;
-
-	/* GZIP header is 0x1F 0x8B <method> <flags>... <compressed-by>. */
-	while (read(fd, &c, 1) == 1) {
-		switch (state) {
-		case 0:
-			if (c == 0x1F)
-				state++;
-			break;
-		case 1:
-			if (c == 0x8B)
-				state++;
-			else
-				state = 0;
-			break;
-		case 2 ... 8:
-			state++;
-			break;
-		case 9:
-			/* Seek back to the start of the gzip header. */
-			lseek(fd, -10, SEEK_CUR);
-			/* One final check: "compressed under UNIX". */
-			if (c != 0x03)
-				state = -1;
-			else
-				return unpack_bzimage(fd);
-		}
-	}
-	errx(1, "Could not find kernel in bzImage");
+	u8 hdr[1024];
+	int r;
+	/* Modern bzImages get loaded at 1M. */
+	void *p = from_guest_phys(0x100000);
+
+	/* Go back to the start of the file and read the header.  It should be
+	 * a Linux boot header (see Documentation/i386/boot.txt) */
+	lseek(fd, 0, SEEK_SET);
+	read(fd, hdr, sizeof(hdr));
+
+	/* At offset 0x202, we expect the magic "HdrS" */
+	if (memcmp(hdr + 0x202, "HdrS", 4) != 0)
+		errx(1, "This doesn't look like a bzImage to me");
+
+	/* The byte at 0x1F1 tells us how many extra sectors of
+	 * header: skip over them all. */
+	lseek(fd, (unsigned long)(hdr[0x1F1]+1) * 512, SEEK_SET);
+
+	/* Now read everything into memory. in nice big chunks. */
+	while ((r = read(fd, p, 65536)) > 0)
+		p += r;
+
+	/* Finally, 0x214 tells us where to start the kernel. */
+	return *(unsigned long *)&hdr[0x214];
 }
 
 /*L:140 Loading the kernel is easy when it's a "vmlinux", but most kernels


