Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYJ3O0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYJ3O0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYJ3O0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:26:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41316 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbYJ3O0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:26:35 -0400
Date: Thu, 30 Oct 2008 14:26:33 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       benh@kernel.crashing.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot (bisected)
Message-ID: <20081030142632.GA15645@csn.ul.ie>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 09:10:29PM -0700, Linus Torvalds wrote:
> 
> It's been two weeks, so it's time to close the merge window. A 2.6.28-rc1 
> is out there, and it's hopefully all good.
> 

I first encountered this problem in SLES 11 Beta 2 but now I see it
affects 2.6.28-rc1 too.

On some ppc64 machines, NVRAM is being corrupted very early in boot (before
console is initialised). The machine reboots and then fails to find yaboot
printing the error "PReP-BOOT: Unable to load PRep image".  It's nowhere near
as serious as the ftrace+e1000 problem as the machine is not bricked but it's
fairly scary looking, the machine cannot boot and the fix is non-obvious. To
"fix" the machine;

1. Go to OpenFirmware prompt
2. type dev nvram
3. type wipe-nvram

The machine will reboot, reconstruct the NVRAM using some magic and yaboot
work again allowing an older kernel to be used. I bisected the problem down
to this commit.

>From 91a00302959545a9ae423e99732b1e46eb19e877 Mon Sep 17 00:00:00 2001
From: Paul Mackerras <paulus@samba.org>
Date: Wed, 8 Oct 2008 14:03:29 +0000
Subject: [PATCH] powerpc: Sync RPA note in zImage with kernel's RPA note

Commit 9b09c6d909dfd8de96b99b9b9c808b94b0a71614 ("powerpc: Change the
default link address for pSeries zImage kernels") changed the
real-base value in the CHRP note added by the addnote program from
12MB to 32MB to give more space for Open Firmware to load the zImage.
(The real-base value says where we want OF to position itself in
memory.)  However, this change was ineffective on most pSeries
machines, because the RPA note added by addnote has the "ignore me"
flag set to 1.  This was intended to tell OF to ignore just the RPA
note, but has the side effect of also making OF ignore the CHRP note
(at least on most pSeries machines).

To solve this we have to set the "ignore me" flag to 0 in the RPA
note.  (We can't just omit the RPA note because that is equivalent to
having an RPA note with default values, and the default values are not
what we want.)  However, then we have to make sure the values in the
zImage's RPA note match up with the values that the kernel supplies
later in prom_init.c with either the ibm,client-architecture-support
call or the process-elf-header call in prom_send_capabilities().

So this sets the "ignore me" flag in the RPA note in addnote to 0, and
adjusts the RPA note values in addnote.c and in prom_init.c to be
consistent with each other and with the values in ibm_architecture_vec.

However, since the wrapper is independent of the kernel, this doesn't
ensure that the notes will stay consistent.  To ensure that, this adds
code to addnote.c so that it can extract the kernel's RPA note from
the kernel binary and put that in the zImage.  To that end, we put the
kernel's fake ELF header (which contains the kernel's RPA note) into
its own section, and arrange for wrapper to pull out that section with
objcopy and pass it to addnote, which then extracts the RPA note from
it and transfers it to the zImage.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

diff --git a/arch/powerpc/boot/addnote.c b/arch/powerpc/boot/addnote.c
index b1e5611..dcc9ab2 100644
--- a/arch/powerpc/boot/addnote.c
+++ b/arch/powerpc/boot/addnote.c
@@ -11,7 +11,12 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  *
- * Usage: addnote zImage
+ * Usage: addnote zImage [note.elf]
+ *
+ * If note.elf is supplied, it is the name of an ELF file that contains
+ * an RPA note to use instead of the built-in one.  Alternatively, the
+ * note.elf file may be empty, in which case the built-in RPA note is
+ * used (this is to simplify how this is invoked from the wrapper script).
  */
 #include <stdio.h>
 #include <stdlib.h>
@@ -43,27 +48,29 @@ char rpaname[] = "IBM,RPA-Client-Config";
  */
 #define N_RPA_DESCR	8
 unsigned int rpanote[N_RPA_DESCR] = {
-	0,			/* lparaffinity */
-	64,			/* min_rmo_size */
+	1,			/* lparaffinity */
+	128,			/* min_rmo_size */
 	0,			/* min_rmo_percent */
-	40,			/* max_pft_size */
+	46,			/* max_pft_size */
 	1,			/* splpar */
 	-1,			/* min_load */
-	0,			/* new_mem_def */
-	1,			/* ignore_my_client_config */
+	1,			/* new_mem_def */
+	0,			/* ignore_my_client_config */
 };
 
 #define ROUNDUP(len)	(((len) + 3) & ~3)
 
 unsigned char buf[512];
+unsigned char notebuf[512];
 
-#define GET_16BE(off)	((buf[off] << 8) + (buf[(off)+1]))
-#define GET_32BE(off)	((GET_16BE(off) << 16) + GET_16BE((off)+2))
+#define GET_16BE(b, off)	(((b)[off] << 8) + ((b)[(off)+1]))
+#define GET_32BE(b, off)	((GET_16BE((b), (off)) << 16) + \
+				 GET_16BE((b), (off)+2))
 
-#define PUT_16BE(off, v)	(buf[off] = ((v) >> 8) & 0xff, \
-				 buf[(off) + 1] = (v) & 0xff)
-#define PUT_32BE(off, v)	(PUT_16BE((off), (v) >> 16), \
-				 PUT_16BE((off) + 2, (v)))
+#define PUT_16BE(b, off, v)	((b)[off] = ((v) >> 8) & 0xff, \
+				 (b)[(off) + 1] = (v) & 0xff)
+#define PUT_32BE(b, off, v)	(PUT_16BE((b), (off), (v) >> 16), \
+				 PUT_16BE((b), (off) + 2, (v)))
 
 /* Structure of an ELF file */
 #define E_IDENT		0	/* ELF header */
@@ -88,15 +95,71 @@ unsigned char buf[512];
 
 unsigned char elf_magic[4] = { 0x7f, 'E', 'L', 'F' };
 
+unsigned char *read_rpanote(const char *fname, int *nnp)
+{
+	int notefd, nr, i;
+	int ph, ps, np;
+	int note, notesize;
+
+	notefd = open(fname, O_RDONLY);
+	if (notefd < 0) {
+		perror(fname);
+		exit(1);
+	}
+	nr = read(notefd, notebuf, sizeof(notebuf));
+	if (nr < 0) {
+		perror("read note");
+		exit(1);
+	}
+	if (nr == 0)		/* empty file */
+		return NULL;
+	if (nr < E_HSIZE ||
+	    memcmp(&notebuf[E_IDENT+EI_MAGIC], elf_magic, 4) != 0 ||
+	    notebuf[E_IDENT+EI_CLASS] != ELFCLASS32 ||
+	    notebuf[E_IDENT+EI_DATA] != ELFDATA2MSB)
+		goto notelf;
+	close(notefd);
+
+	/* now look for the RPA-note */
+	ph = GET_32BE(notebuf, E_PHOFF);
+	ps = GET_16BE(notebuf, E_PHENTSIZE);
+	np = GET_16BE(notebuf, E_PHNUM);
+	if (ph < E_HSIZE || ps < PH_HSIZE || np < 1)
+		goto notelf;
+
+	for (i = 0; i < np; ++i, ph += ps) {
+		if (GET_32BE(notebuf, ph + PH_TYPE) != PT_NOTE)
+			continue;
+		note = GET_32BE(notebuf, ph + PH_OFFSET);
+		notesize = GET_32BE(notebuf, ph + PH_FILESZ);
+		if (notesize < 34 || note + notesize > nr)
+			continue;
+		if (GET_32BE(notebuf, note) != strlen(rpaname) + 1 ||
+		    GET_32BE(notebuf, note + 8) != 0x12759999 ||
+		    strcmp((char *)&notebuf[note + 12], rpaname) != 0)
+			continue;
+		/* looks like an RPA note, return it */
+		*nnp = notesize;
+		return &notebuf[note];
+	}
+	/* no RPA note found */
+	return NULL;
+
+ notelf:
+	fprintf(stderr, "%s is not a big-endian 32-bit ELF image\n", fname);
+	exit(1);
+}
+
 int
 main(int ac, char **av)
 {
 	int fd, n, i;
 	int ph, ps, np;
 	int nnote, nnote2, ns;
+	unsigned char *rpap;
 
-	if (ac != 2) {
-		fprintf(stderr, "Usage: %s elf-file\n", av[0]);
+	if (ac != 2 && ac != 3) {
+		fprintf(stderr, "Usage: %s elf-file [rpanote.elf]\n", av[0]);
 		exit(1);
 	}
 	fd = open(av[1], O_RDWR);
@@ -107,6 +170,7 @@ main(int ac, char **av)
 
 	nnote = 12 + ROUNDUP(strlen(arch) + 1) + sizeof(descr);
 	nnote2 = 12 + ROUNDUP(strlen(rpaname) + 1) + sizeof(rpanote);
+	rpap = NULL;
 
 	n = read(fd, buf, sizeof(buf));
 	if (n < 0) {
@@ -124,16 +188,19 @@ main(int ac, char **av)
 		exit(1);
 	}
 
-	ph = GET_32BE(E_PHOFF);
-	ps = GET_16BE(E_PHENTSIZE);
-	np = GET_16BE(E_PHNUM);
+	if (ac == 3)
+		rpap = read_rpanote(av[2], &nnote2);
+
+	ph = GET_32BE(buf, E_PHOFF);
+	ps = GET_16BE(buf, E_PHENTSIZE);
+	np = GET_16BE(buf, E_PHNUM);
 	if (ph < E_HSIZE || ps < PH_HSIZE || np < 1)
 		goto notelf;
 	if (ph + (np + 2) * ps + nnote + nnote2 > n)
 		goto nospace;
 
 	for (i = 0; i < np; ++i) {
-		if (GET_32BE(ph + PH_TYPE) == PT_NOTE) {
+		if (GET_32BE(buf, ph + PH_TYPE) == PT_NOTE) {
 			fprintf(stderr, "%s already has a note entry\n",
 				av[1]);
 			exit(0);
@@ -148,37 +215,42 @@ main(int ac, char **av)
 
 	/* fill in the program header entry */
 	ns = ph + 2 * ps;
-	PUT_32BE(ph + PH_TYPE, PT_NOTE);
-	PUT_32BE(ph + PH_OFFSET, ns);
-	PUT_32BE(ph + PH_FILESZ, nnote);
+	PUT_32BE(buf, ph + PH_TYPE, PT_NOTE);
+	PUT_32BE(buf, ph + PH_OFFSET, ns);
+	PUT_32BE(buf, ph + PH_FILESZ, nnote);
 
 	/* fill in the note area we point to */
 	/* XXX we should probably make this a proper section */
-	PUT_32BE(ns, strlen(arch) + 1);
-	PUT_32BE(ns + 4, N_DESCR * 4);
-	PUT_32BE(ns + 8, 0x1275);
+	PUT_32BE(buf, ns, strlen(arch) + 1);
+	PUT_32BE(buf, ns + 4, N_DESCR * 4);
+	PUT_32BE(buf, ns + 8, 0x1275);
 	strcpy((char *) &buf[ns + 12], arch);
 	ns += 12 + strlen(arch) + 1;
 	for (i = 0; i < N_DESCR; ++i, ns += 4)
-		PUT_32BE(ns, descr[i]);
+		PUT_32BE(buf, ns, descr[i]);
 
 	/* fill in the second program header entry and the RPA note area */
 	ph += ps;
-	PUT_32BE(ph + PH_TYPE, PT_NOTE);
-	PUT_32BE(ph + PH_OFFSET, ns);
-	PUT_32BE(ph + PH_FILESZ, nnote2);
+	PUT_32BE(buf, ph + PH_TYPE, PT_NOTE);
+	PUT_32BE(buf, ph + PH_OFFSET, ns);
+	PUT_32BE(buf, ph + PH_FILESZ, nnote2);
 
 	/* fill in the note area we point to */
-	PUT_32BE(ns, strlen(rpaname) + 1);
-	PUT_32BE(ns + 4, sizeof(rpanote));
-	PUT_32BE(ns + 8, 0x12759999);
-	strcpy((char *) &buf[ns + 12], rpaname);
-	ns += 12 + ROUNDUP(strlen(rpaname) + 1);
-	for (i = 0; i < N_RPA_DESCR; ++i, ns += 4)
-		PUT_32BE(ns, rpanote[i]);
+	if (rpap) {
+		/* RPA note supplied in file, just copy the whole thing over */
+		memcpy(buf + ns, rpap, nnote2);
+	} else {
+		PUT_32BE(buf, ns, strlen(rpaname) + 1);
+		PUT_32BE(buf, ns + 4, sizeof(rpanote));
+		PUT_32BE(buf, ns + 8, 0x12759999);
+		strcpy((char *) &buf[ns + 12], rpaname);
+		ns += 12 + ROUNDUP(strlen(rpaname) + 1);
+		for (i = 0; i < N_RPA_DESCR; ++i, ns += 4)
+			PUT_32BE(buf, ns, rpanote[i]);
+	}
 
 	/* Update the number of program headers */
-	PUT_16BE(E_PHNUM, np + 2);
+	PUT_16BE(buf, E_PHNUM, np + 2);
 
 	/* write back */
 	lseek(fd, (long) 0, SEEK_SET);
diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index 965c237..ee0dc41 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -307,7 +307,9 @@ fi
 # post-processing needed for some platforms
 case "$platform" in
 pseries|chrp)
-    $objbin/addnote "$ofile"
+    ${CROSS}objcopy -O binary -j .fakeelf "$kernel" "$ofile".rpanote
+    $objbin/addnote "$ofile" "$ofile".rpanote
+    rm -r "$ofile".rpanote
     ;;
 coff)
     ${CROSS}objcopy -O aixcoff-rs6000 --set-start "$entry" "$ofile"
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 7cf274a..2fdbc18 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -732,7 +732,7 @@ static struct fake_elf {
 			u32	ignore_me;
 		} rpadesc;
 	} rpanote;
-} fake_elf = {
+} fake_elf __section(.fakeelf) = {
 	.elfhdr = {
 		.e_ident = { 0x7f, 'E', 'L', 'F',
 			     ELFCLASS32, ELFDATA2MSB, EV_CURRENT },
@@ -774,13 +774,13 @@ static struct fake_elf {
 		.type = 0x12759999,
 		.name = "IBM,RPA-Client-Config",
 		.rpadesc = {
-			.lpar_affinity = 0,
-			.min_rmo_size = 64,	/* in megabytes */
+			.lpar_affinity = 1,
+			.min_rmo_size = 128,	/* in megabytes */
 			.min_rmo_percent = 0,
-			.max_pft_size = 48,	/* 2^48 bytes max PFT size */
+			.max_pft_size = 46,	/* 2^46 bytes max PFT size */
 			.splpar = 1,
 			.min_load = ~0U,
-			.new_mem_def = 0
+			.new_mem_def = 1
 		}
 	}
 };
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index e6927fb..b39c27e 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -203,6 +203,9 @@ SECTIONS
 		*(.rela*)
 	}
 
+	/* Fake ELF header containing RPA note; for addnote */
+	.fakeelf : AT(ADDR(.fakeelf) - LOAD_OFFSET) { *(.fakeelf) }
+
 	/* freed after init ends here */
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
