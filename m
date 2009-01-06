Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZAFV5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZAFV5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZAFV5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:57:42 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:53661 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZAFV5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:57:40 -0500
Message-ID: <4963D3C3.9090503@knaff.lu>
Date: Tue, 06 Jan 2009 22:57:23 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [bzip2/lzma] fix for built-in initramfs issue
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <49615136.9080900@knaff.lu> <4961580A.1020301@zytor.com> <4961A816.40302@knaff.lu> <4961A997.10108@zytor.com> <4961ADC5.6030108@knaff.lu> <49622DE9.2010200@zytor.com> <496240DF.2010102@knaff.lu> <49624F6C.8010103@zytor.com> <4962522F.20804@knaff.lu> <496255B0.1050208@zytor.com> <4962580B.2080806@knaff.lu> <4962612C.8090405@zytor.com> <496284A2.9070003@knaff.lu> <4962858F.20207@zytor.com> <496285C8.7050503@knaff.lu> <496290E0.3020603@zytor.com>
In-Reply-To: <496290E0.3020603@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050107070403090009020002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050107070403090009020002
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

H. Peter Anvin wrote:
> Alain Knaff wrote:
>> H. Peter Anvin wrote:
>>> I'm thinking that with "preferred" we might just use the first one in
>>> the priority list "lzma, bzip2, gzip, uncompressed" depending on what is
>>> installed in the kernel.
>>>
>>> Using the kernel method may definitely not work, especially on
>>> architectures which don't do this style of kernel compression.
>>>
>>>     -hpa
>>
>> Ok. For the new change, may I do a diff against the current
>> x86/lzma-setup , or should I do the whole 5-part dance again?
>>
> 
> Go ahead and do an incremental patch at this point.
> 
>     -hpa

Here it is (see attachment)

Alain



--------------050107070403090009020002
Content-Type: text/x-diff;
 name="x86-builtin-initramfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86-builtin-initramfs.patch"

From: Alain Knaff <alain@knaff.lu>
Subject: [PATCH] init: fix built-in initramfs vs CONFIG_RD_GZIP

Impact: Consistency

Makes it possible to disable CONFIG_RD_GZIP . In that case, the
built-in initramfs will be compressed by whatever compressor is
available (bzip2 or lzma) or left uncompressed if none is available.

It also removes a couple of warnings which occur when no ramdisk
compression at all is chosen.

It also restores the select ZLIB_INFLATE in drivers/block/Kconfig
which somehow came missing. This is needed to activate compilation of
the stuff in zlib_deflate.

Signed-off-by: Alain Knaff <alain@knaff.lu>
---
diff -purN x86.ref/drivers/block/Kconfig x86-builtin-initramfs/drivers/block/Kconfig
--- x86.ref/drivers/block/Kconfig	2009-01-06 08:31:16.000000000 +0100
+++ x86-builtin-initramfs/drivers/block/Kconfig	2009-01-06 21:41:16.000000000 +0100
@@ -363,6 +363,7 @@ config RD_GZIP
 	default y
 	depends on BLK_DEV_INITRD=y
 	select DECOMPRESS_GZIP
+	select ZLIB_INFLATE
 	help
 	  Support loading of a gzip encoded initial ramdisk or cpio buffer.
 	  If unsure, say Y.
diff -purN x86.ref/init/initramfs.c x86-builtin-initramfs/init/initramfs.c
--- x86.ref/init/initramfs.c	2009-01-06 08:31:16.000000000 +0100
+++ x86-builtin-initramfs/init/initramfs.c	2009-01-06 22:27:26.000000000 +0100
@@ -389,7 +389,7 @@ static int __init write_buffer(char *buf
 	return len - count;
 }
 
-
+#if defined CONFIG_RD_GZIP || defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA
 static int __init flush_buffer(void *bufv, unsigned len)
 {
 	char *buf = (char *) bufv;
@@ -412,6 +412,7 @@ static int __init flush_buffer(void *buf
 	}
 	return origLen;
 }
+#endif
 
 static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
 
@@ -449,10 +450,12 @@ static char * __init unpack_to_rootfs(ch
 			continue;
 		}
 		this_header = 0;
+#ifdef CONFIG_RD_GZIP
 		if (!gunzip(buf, len, NULL, flush_buffer, NULL,
 			    &my_inptr, error) &&
 		    message == NULL)
 			goto ok;
+#endif
 
 #ifdef CONFIG_RD_BZIP2
 		message = NULL; /* Zero out message, or else cpio will
@@ -473,7 +476,9 @@ static char * __init unpack_to_rootfs(ch
 			goto ok;
 		}
 #endif
+#if defined CONFIG_RD_GZIP || defined CONFIG_RD_BZIP2 || defined CONFIG_RD_LZMA
 ok:
+#endif
 		if (state != Reset)
 			error("junk in compressed archive");
 		this_header = saved_offset + my_inptr;
diff -purN x86.ref/scripts/gen_initramfs_list.sh x86-builtin-initramfs/scripts/gen_initramfs_list.sh
--- x86.ref/scripts/gen_initramfs_list.sh	2009-01-05 01:21:06.000000000 +0100
+++ x86-builtin-initramfs/scripts/gen_initramfs_list.sh	2009-01-06 21:48:19.000000000 +0100
@@ -5,7 +5,7 @@
 # Released under the terms of the GNU GPL
 #
 # Generate a cpio packed initramfs. It uses gen_init_cpio to generate
-# the cpio archive, and gzip to pack it.
+# the cpio archive, and then compresses it.
 # The script may also be used to generate the inputfile used for gen_init_cpio
 # This script assumes that gen_init_cpio is located in usr/ directory
 
@@ -16,8 +16,8 @@ usage() {
 cat << EOF
 Usage:
 $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
-	-o <file>      Create gzipped initramfs file named <file> using
-		       gen_init_cpio and gzip
+	-o <file>      Create compressed initramfs file named <file> using
+		       gen_init_cpio and compressor depending on the extension
 	-u <uid>       User ID to map to user ID 0 (root).
 		       <uid> is only meaningful if <cpio_source> is a
 		       directory.  "squash" forces all files to uid 0.
@@ -225,6 +225,7 @@ cpio_list=
 output="/dev/stdout"
 output_file=""
 is_cpio_compressed=
+compr="gzip -9 -f"
 
 arg="$1"
 case "$arg" in
@@ -233,11 +234,15 @@ case "$arg" in
 		echo "deps_initramfs := \\"
 		shift
 		;;
-	"-o")	# generate gzipped cpio image named $1
+	"-o")	# generate compressed cpio image named $1
 		shift
 		output_file="$1"
 		cpio_list="$(mktemp ${TMPDIR:-/tmp}/cpiolist.XXXXXX)"
 		output=${cpio_list}
+		echo "$output_file" | grep -q "\.gz$" && compr="gzip -9 -f"
+		echo "$output_file" | grep -q "\.bz2$" && compr="bzip2 -9 -f"
+		echo "$output_file" | grep -q "\.lzma$" && compr="lzma -9 -f"
+		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
 esac
@@ -274,7 +279,7 @@ while [ $# -gt 0 ]; do
 	esac
 done
 
-# If output_file is set we will generate cpio archive and gzip it
+# If output_file is set we will generate cpio archive and compress it
 # we are carefull to delete tmp files
 if [ ! -z ${output_file} ]; then
 	if [ -z ${cpio_file} ]; then
@@ -287,7 +292,7 @@ if [ ! -z ${output_file} ]; then
 	if [ "${is_cpio_compressed}" = "compressed" ]; then
 		cat ${cpio_tfile} > ${output_file}
 	else
-		cat ${cpio_tfile} | gzip -f -9 - > ${output_file}
+		cat ${cpio_tfile} | ${compr}  - > ${output_file}
 	fi
 	[ -z ${cpio_file} ] && rm ${cpio_tfile}
 fi
diff -purN x86.ref/usr/initramfs_data.bz2.S x86-builtin-initramfs/usr/initramfs_data.bz2.S
--- x86.ref/usr/initramfs_data.bz2.S	1970-01-01 01:00:00.000000000 +0100
+++ x86-builtin-initramfs/usr/initramfs_data.bz2.S	2009-01-06 20:54:00.000000000 +0100
@@ -0,0 +1,30 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.bz2"
+
diff -purN x86.ref/usr/initramfs_data.gz.S x86-builtin-initramfs/usr/initramfs_data.gz.S
--- x86.ref/usr/initramfs_data.gz.S	1970-01-01 01:00:00.000000000 +0100
+++ x86-builtin-initramfs/usr/initramfs_data.gz.S	2009-01-05 01:21:06.000000000 +0100
@@ -0,0 +1,30 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.gz"
+
diff -purN x86.ref/usr/initramfs_data.lzma.S x86-builtin-initramfs/usr/initramfs_data.lzma.S
--- x86.ref/usr/initramfs_data.lzma.S	1970-01-01 01:00:00.000000000 +0100
+++ x86-builtin-initramfs/usr/initramfs_data.lzma.S	2009-01-06 20:54:13.000000000 +0100
@@ -0,0 +1,30 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.lzma"
+
diff -purN x86.ref/usr/initramfs_data.S x86-builtin-initramfs/usr/initramfs_data.S
--- x86.ref/usr/initramfs_data.S	2009-01-05 01:21:06.000000000 +0100
+++ x86-builtin-initramfs/usr/initramfs_data.S	2009-01-06 20:54:18.000000000 +0100
@@ -26,5 +26,5 @@ SECTIONS
 */
 
 .section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.gz"
+.incbin "usr/initramfs_data.cpio"
 
diff -purN x86.ref/usr/Makefile x86-builtin-initramfs/usr/Makefile
--- x86.ref/usr/Makefile	2009-01-05 01:21:06.000000000 +0100
+++ x86-builtin-initramfs/usr/Makefile	2009-01-06 22:23:48.000000000 +0100
@@ -5,14 +5,32 @@
 klibcdirs:;
 PHONY += klibcdirs
 
+# Find out "preferred" ramdisk compressor. Order of preference is
+#  1. bzip2 efficient, and likely to be present
+#  2. gzip former default
+#  3. lzma
+#  4. none
+
+# None of the above
+suffix_y                   =
+
+# Lzma, but no gzip nor bzip2
+suffix_$(CONFIG_RD_LZMA)   = .lzma
+
+# Gzip, but no bzip2
+suffix_$(CONFIG_RD_GZIP)   = .gz
+
+# Bzip2
+suffix_$(CONFIG_RD_BZIP2)  = .bz2
+
 
 # Generate builtin.o based on initramfs_data.o
-obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
+obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data$(suffix_y).o
 
-# initramfs_data.o contains the initramfs_data.cpio.gz image.
+# initramfs_data.o contains the compressed initramfs_data.cpio image.
 # The image is included using .incbin, a dependency which is not
 # tracked automatically.
-$(obj)/initramfs_data.o: $(obj)/initramfs_data.cpio.gz FORCE
+$(obj)/initramfs_data$(suffix_y).o: $(obj)/initramfs_data.cpio$(suffix_y) FORCE
 
 #####
 # Generate the initramfs cpio archive
@@ -25,28 +43,28 @@ ramfs-args  := \
         $(if $(CONFIG_INITRAMFS_ROOT_UID), -u $(CONFIG_INITRAMFS_ROOT_UID)) \
         $(if $(CONFIG_INITRAMFS_ROOT_GID), -g $(CONFIG_INITRAMFS_ROOT_GID))
 
-# .initramfs_data.cpio.gz.d is used to identify all files included
+# .initramfs_data.cpio.d is used to identify all files included
 # in initramfs and to detect if any files are added/removed.
 # Removed files are identified by directory timestamp being updated
 # The dependency list is generated by gen_initramfs.sh -l
-ifneq ($(wildcard $(obj)/.initramfs_data.cpio.gz.d),)
-	include $(obj)/.initramfs_data.cpio.gz.d
+ifneq ($(wildcard $(obj)/.initramfs_data.cpio.d),)
+	include $(obj)/.initramfs_data.cpio.d
 endif
 
 quiet_cmd_initfs = GEN     $@
       cmd_initfs = $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)
 
-targets := initramfs_data.cpio.gz
+targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio
 # do not try to update files included in initramfs
 $(deps_initramfs): ;
 
 $(deps_initramfs): klibcdirs
-# We rebuild initramfs_data.cpio.gz if:
-# 1) Any included file is newer then initramfs_data.cpio.gz
+# We rebuild initramfs_data.cpio if:
+# 1) Any included file is newer then initramfs_data.cpio
 # 2) There are changes in which files are included (added or deleted)
-# 3) If gen_init_cpio are newer than initramfs_data.cpio.gz
+# 3) If gen_init_cpio are newer than initramfs_data.cpio
 # 4) arguments to gen_initramfs.sh changes
-$(obj)/initramfs_data.cpio.gz: $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
-	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.gz.d
+$(obj)/initramfs_data.cpio$(suffix_y): $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
+	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.d
 	$(call if_changed,initfs)
 

--------------050107070403090009020002--
