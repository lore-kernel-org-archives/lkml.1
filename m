Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXGJDxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXGJDxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXGJDxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:53:30 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXGJDx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:53:28 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 31/33] Use the new x86 setup code for i386
Date: Mon,  9 Jul 2007 19:52:10 -0700
Message-Id: <1184039193417-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184039088816-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
 <11840381413065-git-send-email-hpa@zytor.com>
 <11840382473923-git-send-email-hpa@zytor.com>
 <11840383522914-git-send-email-hpa@zytor.com>
 <1184038457733-git-send-email-hpa@zytor.com>
 <1184038562864-git-send-email-hpa@zytor.com>
 <11840386682120-git-send-email-hpa@zytor.com>
 <11840387733386-git-send-email-hpa@zytor.com>
 <11840388782627-git-send-email-hpa@zytor.com>
 <11840389834063-git-send-email-hpa@zytor.com>
 <1184039088816-git-send-email-hpa@zytor.com>
Message-Id: <842bbe280e87886e7a1b187434841c7f7334244c.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

This patch hooks the new x86 setup code into the Makefile machinery.  It
also adapts boot/tools/build.c to a two-file (as opposed to three-file)
universe, and simplifies it substantially.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/Makefile            |   46 +++++++++--
 arch/i386/boot/compressed/Makefile |    7 ++-
 arch/i386/boot/tools/build.c       |  160 ++++++++++++++++--------------------
 3 files changed, 116 insertions(+), 97 deletions(-)

diff --git a/arch/i386/boot/Makefile b/arch/i386/boot/Makefile
index bfbc320..e9f46fd 100644
--- a/arch/i386/boot/Makefile
+++ b/arch/i386/boot/Makefile
@@ -25,27 +25,54 @@ SVGA_MODE := -DSVGA_MODE=NORMAL_VGA
 
 #RAMDISK := -DRAMDISK=512
 
-targets		:= vmlinux.bin bootsect bootsect.o \
-		   setup setup.o zImage bzImage
+targets		:= vmlinux.bin setup.bin setup.elf zImage bzImage
 subdir- 	:= compressed
 
+setup-y		+= a20.o apm.o cmdline.o copy.o cpu.o cpucheck.o edd.o
+setup-y		+= header.o main.o mca.o memory.o pm.o pmjump.o
+setup-y		+= printf.o string.o tty.o video.o version.o voyager.o
+
+# The link order of the video-*.o modules can matter.  In particular,
+# video-vga.o *must* be listed first, followed by video-vesa.o.
+# Hardware-specific drivers should follow in the order they should be
+# probed, and video-bios.o should typically be last.
+setup-y		+= video-vga.o
+setup-y		+= video-vesa.o
+setup-y		+= video-bios.o
+
 hostprogs-y	:= tools/build
 
 HOSTCFLAGS_build.o := $(LINUXINCLUDE)
 
 # ---------------------------------------------------------------------------
 
+# How to compile the 16-bit code.  Note we always compile for -march=i386,
+# that way we can complain to the user if the CPU is insufficient.
+cflags-i386   := 
+cflags-x86_64 := -m32
+CFLAGS		:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
+		   $(cflags-$(ARCH)) \
+		   -Wall -Wstrict-prototypes \
+		   -march=i386 -mregparm=3 \
+		   -include $(srctree)/$(src)/code16gcc.h \
+		   -fno-strict-aliasing -fomit-frame-pointer \
+		   $(call cc-option, -ffreestanding) \
+		   $(call cc-option, -fno-stack-protector) \
+		   $(call cc-option, -mpreferred-stack-boundary=2)
+AFLAGS		:= $(CFLAGS) -D__ASSEMBLY__
+
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
 $(obj)/zImage:  EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
+$(obj)/bzImage: EXTRA_CFLAGS := -D__BIG_KERNEL__
 $(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
-cmd_image = $(obj)/tools/build $(BUILDFLAGS) $(obj)/bootsect $(obj)/setup \
+cmd_image = $(obj)/tools/build $(BUILDFLAGS) $(obj)/setup.bin \
 	    $(obj)/vmlinux.bin $(ROOT_DEV) > $@
 
-$(obj)/zImage $(obj)/bzImage: $(obj)/bootsect $(obj)/setup \
+$(obj)/zImage $(obj)/bzImage: $(obj)/setup.bin \
 			      $(obj)/vmlinux.bin $(obj)/tools/build FORCE
 	$(call if_changed,image)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
@@ -53,12 +80,17 @@ $(obj)/zImage $(obj)/bzImage: $(obj)/bootsect $(obj)/setup \
 $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 	$(call if_changed,objcopy)
 
-LDFLAGS_bootsect := -Ttext 0x0 -s --oformat binary
-LDFLAGS_setup	 := -Ttext 0x0 -s --oformat binary -e begtext
+SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-$(obj)/setup $(obj)/bootsect: %: %.o FORCE
+LDFLAGS_setup.elf	:= -T
+$(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
 	$(call if_changed,ld)
 
+OBJCOPYFLAGS_setup.bin	:= -O binary
+
+$(obj)/setup.bin: $(obj)/setup.elf FORCE
+	$(call if_changed,objcopy)
+
 $(obj)/compressed/vmlinux: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed IMAGE_OFFSET=$(IMAGE_OFFSET) $@
 
diff --git a/arch/i386/boot/compressed/Makefile b/arch/i386/boot/compressed/Makefile
index a661217..189fa1d 100644
--- a/arch/i386/boot/compressed/Makefile
+++ b/arch/i386/boot/compressed/Makefile
@@ -9,9 +9,14 @@ targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o \
 EXTRA_AFLAGS	:= -traditional
 
 LDFLAGS_vmlinux := -T
-CFLAGS_misc.o += -fPIC
 hostprogs-y	:= relocs
 
+CFLAGS  := -m32 -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
+	   -fno-strict-aliasing -fPIC \
+	   $(call cc-option,-ffreestanding) \
+	   $(call cc-option,-fno-stack-protector)
+LDFLAGS := -m elf_i386
+
 $(obj)/vmlinux: $(src)/vmlinux.lds $(obj)/head.o $(obj)/misc.o $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
 	@:
diff --git a/arch/i386/boot/tools/build.c b/arch/i386/boot/tools/build.c
index 0579841..886f47d 100644
--- a/arch/i386/boot/tools/build.c
+++ b/arch/i386/boot/tools/build.c
@@ -1,13 +1,12 @@
 /*
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 1997 Martin Mares
+ *  Copyright (C) 2007 H. Peter Anvin
  */
 
 /*
  * This file builds a disk-image from three different files:
  *
- * - bootsect: compatibility mbr which prints an error message if
- *             someone tries to boot the kernel directly.
  * - setup: 8086 machine code, sets up system parm
  * - system: 80386 code for actual system
  *
@@ -21,6 +20,7 @@
  * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
  * Cross compiling fixes by Gertjan van Wingerde, July 1996
  * Rewritten by Martin Mares, April 1997
+ * Substantially overhauled by H. Peter Anvin, April 2007
  */
 
 #include <stdio.h>
@@ -32,23 +32,25 @@
 #include <sys/sysmacros.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sys/mman.h>
 #include <asm/boot.h>
 
-typedef unsigned char byte;
-typedef unsigned short word;
-typedef unsigned long u32;
+typedef unsigned char  u8;
+typedef unsigned short u16;
+typedef unsigned long  u32;
 
 #define DEFAULT_MAJOR_ROOT 0
 #define DEFAULT_MINOR_ROOT 0
 
-/* Minimal number of setup sectors (see also bootsect.S) */
-#define SETUP_SECTS 4
+/* Minimal number of setup sectors */
+#define SETUP_SECT_MIN 5
+#define SETUP_SECT_MAX 64
 
-byte buf[1024];
-int fd;
+/* This must be large enough to hold the entire setup */
+u8 buf[SETUP_SECT_MAX*512];
 int is_big_kernel;
 
-void die(const char * str, ...)
+static void die(const char * str, ...)
 {
 	va_list args;
 	va_start(args, str);
@@ -57,15 +59,9 @@ void die(const char * str, ...)
 	exit(1);
 }
 
-void file_open(const char *name)
+static void usage(void)
 {
-	if ((fd = open(name, O_RDONLY, 0)) < 0)
-		die("Unable to open `%s': %m", name);
-}
-
-void usage(void)
-{
-	die("Usage: build [-b] bootsect setup system [rootdev] [> image]");
+	die("Usage: build [-b] setup system [rootdev] [> image]");
 }
 
 int main(int argc, char ** argv)
@@ -73,27 +69,30 @@ int main(int argc, char ** argv)
 	unsigned int i, sz, setup_sectors;
 	int c;
 	u32 sys_size;
-	byte major_root, minor_root;
+	u8 major_root, minor_root;
 	struct stat sb;
+	FILE *file;
+	int fd;
+	void *kernel;
 
 	if (argc > 2 && !strcmp(argv[1], "-b"))
 	  {
 	    is_big_kernel = 1;
 	    argc--, argv++;
 	  }
-	if ((argc < 4) || (argc > 5))
+	if ((argc < 3) || (argc > 4))
 		usage();
-	if (argc > 4) {
-		if (!strcmp(argv[4], "CURRENT")) {
+	if (argc > 3) {
+		if (!strcmp(argv[3], "CURRENT")) {
 			if (stat("/", &sb)) {
 				perror("/");
 				die("Couldn't stat /");
 			}
 			major_root = major(sb.st_dev);
 			minor_root = minor(sb.st_dev);
-		} else if (strcmp(argv[4], "FLOPPY")) {
-			if (stat(argv[4], &sb)) {
-				perror(argv[4]);
+		} else if (strcmp(argv[3], "FLOPPY")) {
+			if (stat(argv[3], &sb)) {
+				perror(argv[3]);
 				die("Couldn't stat root device.");
 			}
 			major_root = major(sb.st_rdev);
@@ -108,79 +107,62 @@ int main(int argc, char ** argv)
 	}
 	fprintf(stderr, "Root device is (%d, %d)\n", major_root, minor_root);
 
-	file_open(argv[1]);
-	i = read(fd, buf, sizeof(buf));
-	fprintf(stderr,"Boot sector %d bytes.\n",i);
-	if (i != 512)
-		die("Boot block must be exactly 512 bytes");
+	/* Copy the setup code */
+	file = fopen(argv[1], "r");
+	if (!file)
+		die("Unable to open `%s': %m", argv[1]);
+	c = fread(buf, 1, sizeof(buf), file);
+	if (ferror(file))
+		die("read-error on `setup'");
+	if (c < 1024)
+		die("The setup must be at least 1024 bytes");
 	if (buf[510] != 0x55 || buf[511] != 0xaa)
 		die("Boot block hasn't got boot flag (0xAA55)");
+	fclose(file);
+
+	/* Pad unused space with zeros */
+	setup_sectors = (c + 511) / 512;
+	if (setup_sectors < SETUP_SECT_MIN)
+		setup_sectors = SETUP_SECT_MIN;
+	i = setup_sectors*512;
+	memset(buf+c, 0, i-c);
+
+	/* Set the default root device */
 	buf[508] = minor_root;
 	buf[509] = major_root;
-	if (write(1, buf, 512) != 512)
-		die("Write call failed");
-	close (fd);
-
-	file_open(argv[2]);				    /* Copy the setup code */
-	for (i=0 ; (c=read(fd, buf, sizeof(buf)))>0 ; i+=c )
-		if (write(1, buf, c) != c)
-			die("Write call failed");
-	if (c != 0)
-		die("read-error on `setup'");
-	close (fd);
-
-	setup_sectors = (i + 511) / 512;	/* Pad unused space with zeros */
-	/* for compatibility with ancient versions of LILO. */
-	if (setup_sectors < SETUP_SECTS)
-		setup_sectors = SETUP_SECTS;
-	fprintf(stderr, "Setup is %d bytes.\n", i);
-	memset(buf, 0, sizeof(buf));
-	while (i < setup_sectors * 512) {
-		c = setup_sectors * 512 - i;
-		if (c > sizeof(buf))
-			c = sizeof(buf);
-		if (write(1, buf, c) != c)
-			die("Write call failed");
-		i += c;
-	}
 
-	file_open(argv[3]);
-	if (fstat (fd, &sb))
-		die("Unable to stat `%s': %m", argv[3]);
+	fprintf(stderr, "Setup is %d bytes (padded to %d bytes).\n", c, i);
+
+	/* Open and stat the kernel file */
+	fd = open(argv[2], O_RDONLY);
+	if (fd < 0)
+		die("Unable to open `%s': %m", argv[2]);
+	if (fstat(fd, &sb))
+		die("Unable to stat `%s': %m", argv[2]);
 	sz = sb.st_size;
-	fprintf (stderr, "System is %d kB\n", sz/1024);
+	fprintf (stderr, "System is %d kB\n", (sz+1023)/1024);
+	kernel = mmap(NULL, sz, PROT_READ, MAP_SHARED, fd, 0);
+	if (kernel == MAP_FAILED)
+		die("Unable to mmap '%s': %m", argv[2]);
 	sys_size = (sz + 15) / 16;
 	if (!is_big_kernel && sys_size > DEF_SYSSIZE)
 		die("System is too big. Try using bzImage or modules.");
-	while (sz > 0) {
-		int l, n;
-
-		l = (sz > sizeof(buf)) ? sizeof(buf) : sz;
-		if ((n=read(fd, buf, l)) != l) {
-			if (n < 0)
-				die("Error reading %s: %m", argv[3]);
-			else
-				die("%s: Unexpected EOF", argv[3]);
-		}
-		if (write(1, buf, l) != l)
-			die("Write failed");
-		sz -= l;
-	}
+
+	/* Patch the setup code with the appropriate size parameters */
+	buf[0x1f1] = setup_sectors-1;
+	buf[0x1f4] = sys_size;
+	buf[0x1f5] = sys_size >> 8;
+	buf[0x1f6] = sys_size >> 16;
+	buf[0x1f7] = sys_size >> 24;
+
+	if (fwrite(buf, 1, i, stdout) != i)
+		die("Writing setup failed");
+
+	/* Copy the kernel code */
+	if (fwrite(kernel, 1, sz, stdout) != sz)
+		die("Writing kernel failed");
 	close(fd);
 
-	if (lseek(1, 497, SEEK_SET) != 497)		    /* Write sizes to the bootsector */
-		die("Output: seek failed");
-	buf[0] = setup_sectors;
-	if (write(1, buf, 1) != 1)
-		die("Write of setup sector count failed");
-	if (lseek(1, 500, SEEK_SET) != 500)
-		die("Output: seek failed");
-	buf[0] = (sys_size & 0xff);
-	buf[1] = ((sys_size >> 8) & 0xff);
-	buf[2] = ((sys_size >> 16) & 0xff);
-	buf[3] = ((sys_size >> 24) & 0xff);
-	if (write(1, buf, 4) != 4)
-		die("Write of image length failed");
-
-	return 0;					    /* Everything is OK */
+	/* Everything is OK */
+	return 0;
 }
-- 
1.5.2.2

