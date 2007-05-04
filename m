Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbXEDNH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbXEDNH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbXEDNH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:07:57 -0400
Received: from ozlabs.org ([203.10.76.45]:54518 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbXEDNHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:07:55 -0400
Subject: [RFC PATCH 3/3] boot bzImages under paravirt
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1178283724.23670.70.camel@localhost.localdomain>
References: <1178283582.23670.67.camel@localhost.localdomain>
	 <1178283724.23670.70.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 04 May 2007 23:07:32 +1000
Message-Id: <1178284052.23670.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(This is kind of a bonus, but it shows how minor the change is to boot
bzImages)

Skipping over the "cli" and segment loading is enough to allow lguest
to boot bzImages.  There are some "out" insns in the unpacking code,
but lguest already has to emulate/skip-over them because of random x86
probes during boot.

We can no longer assume the launcher has set the bss to zero: we now
need to zero it ourselves.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c    |  134 +++++++-------------------------------
 arch/i386/boot/compressed/head.S |    6 +
 drivers/lguest/core.c            |    8 +-
 drivers/lguest/lguest.c          |    2
 4 files changed, 41 insertions(+), 109 deletions(-)

diff -r 73d71b701360 arch/i386/boot/compressed/head.S
--- a/arch/i386/boot/compressed/head.S	Fri May 04 22:49:34 2007 +1000
+++ b/arch/i386/boot/compressed/head.S	Fri May 04 22:51:49 2007 +1000
@@ -32,6 +32,11 @@
 	.globl startup_32
 
 startup_32:
+#ifdef CONFIG_PARAVIRT
+        movl %cs,%eax
+        andl $0x3,%eax
+        jnz calc_delta
+#endif
 	cld
 	cli
 	movl $(__BOOT_DS),%eax
@@ -48,6 +53,7 @@ startup_32:
  * data at 0x34-0x3f are used as the stack for this calculation.
  * Only 4 bytes are needed.
  */
+calc_delta:
 	leal 0x40(%esi), %esp
 	call 1f
 1:	popl %ebp
diff -r 73d71b701360 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Fri May 04 22:49:34 2007 +1000
+++ b/drivers/lguest/lguest.c	Fri May 04 22:51:49 2007 +1000
@@ -805,6 +805,8 @@ static unsigned lguest_patch(u8 type, u1
  * every routine we have to override to avoid privileged instructions. */
 __init void do_lguest_init(void *boot)
 {
+	memset(__bss_start, 0, __bss_stop - __bss_start);
+
 	/* Copy boot parameters first: the Launcher put the physical location
 	 * in %esi, and head.S converted that to a virtual address and handed
 	 * it to us. */
diff -r 73d71b701360 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Fri May 04 22:49:34 2007 +1000
+++ b/Documentation/lguest/lguest.c	Fri May 04 22:53:31 2007 +1000
@@ -205,74 +205,30 @@ static unsigned long map_elf(int elf_fd,
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
-	void *img = (void *)0x100000;
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
-	/* Entry is physical address: convert to virtual */
-	return (unsigned long)img;
-}
-
-/*L:150 A bzImage, unlike an ELF file, is not meant to be loaded.  You're
- * supposed to jump into it and it will unpack itself.  We can't do that
- * because the Guest can't run the unpacking code, and adding features to
- * lguest kills puppies, so we don't want to.
- *
- * The bzImage is formed by putting the decompressing code in front of the
- * compressed kernel code.  So we can simple scan through it looking for the
- * first "gzip" header, and start decompressing from there. */
+/*L:150 A bzImage, unlike an ELF file, is not meant to be mapped into memory.
+ * You're supposed to jump into it and it will unpack itself.  We used to have
+ * to perform some hairy magic becuase we couldn't run the unpacking code, and
+ * adding features to lguest kills puppies, so we didn't want to.
+ *
+ * Fortunately, Jeremy Fitzhardinge convinced me it wasn't that hard to fix, so
+ * now we just read the funky header so we know where in the file to load, and
+ * away we go. */
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
+#warning document this with reference to Documentation/i386/boot.txt
+	u8 hdr[0x300];
+	int r;
+	void *p = (void *)0x100000;
+
+	lseek(fd, 0, SEEK_SET);
+	read(fd, hdr, sizeof(hdr));
+
+	lseek(fd, (unsigned long)(hdr[0x1F1]+1) * 512, SEEK_SET);
+
+	while ((r = read(fd, p, 65535)) > 0)
+		p += r;
+
+	return *(unsigned long *)&hdr[0x214];
 }
 
 /*L:140 Loading the kernel is easy when it's a "vmlinux", but most kernels


