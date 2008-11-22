Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYKVRab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYKVRab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbYKVRaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:30:22 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:57781 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758660AbYKVRaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:30:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type:from;
        b=tUTdX7x6dQRvLuqZ31dWZCKiuv06r+tJGX6WZKc5EICGzlEA3xU/h/s2E9E9xb1heQ
         sZxXbMIdErl2Gjoz6Ho2HoHbgf7i3VC1FkQJC9KvkOU8C2063aI6hMOuyaJfl4MXdHjU
         8tprs0YiDeuRrI9K0z7X4O7fXZU5gy0M2clyM=
Date: Sat, 22 Nov 2008 18:30:13 +0100 (CET)
X-X-Sender: frans@frans-desktop
To: linux-kernel@vger.kernel.org, rob@landley.net, dwmw2@infradead.org
Subject: [PATCH] create option to compress initramfs within the kernel
Message-ID: <alpine.DEB.1.00.0811221817560.3675@frans-desktop>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: frans <fransmeulenbroeks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch to make compression of the initramfs image optional.
Sumbitted to LKML as there is no MAINTAINER listed for initramfs.

Rationale is that if you create a compressed kernel image (e.g. by
make bzImage) it is not very efficient and useful to compress initramfs 
as the initramfs will be compressed anyway when the kernel image is 
compressed.

The patch below allows one to select whether compression is desired or not 
using a new boolean Kconfig option (INITRAMFS_COMPRESS). Default value: y

As the .cpio.gz extension of the generated initramfs.cpio.gz is also a 
little bit odd if you have no compression, the name of the initramfs image 
has been changed from initramfs.cpio.gz to initramfs.img

Signed-off-by: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 5f3415f..22f71ee 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -185,7 +185,7 @@ dir_filelist() {
 }

 # if only one file is specified and it is .cpio file then use it direct as fs
-# if a directory is specified then add all files in given direcotry to fs
+# if a directory is specified then add all files in given directory to fs
 # if a regular file is specified assume it is in gen_initramfs format
 input_file() {
 	source="$1"
@@ -225,6 +225,7 @@ cpio_list=
 output="/dev/stdout"
 output_file=""
 is_cpio_compressed=
+compress=0

 arg="$1"
 case "$arg" in
@@ -257,6 +258,9 @@ while [ $# -gt 0 ]; do
 			default_list="$arg"
 			${dep_list}default_initramfs
 			;;
+		"-c")	# compress
+			compress=1
+			;;
 		"-h")
 			usage
 			exit 0
@@ -287,7 +291,11 @@ if [ ! -z ${output_file} ]; then
 	if [ "${is_cpio_compressed}" = "compressed" ]; then
 		cat ${cpio_tfile} > ${output_file}
 	else
-		cat ${cpio_tfile} | gzip -f -9 - > ${output_file}
+		if [ ${compress} -eq 1 ]; then
+			cat ${cpio_tfile} | gzip -f -9 - > ${output_file}
+		else
+			cat ${cpio_tfile} > ${output_file}
+		fi
 	fi
 	[ -z ${cpio_file} ] && rm ${cpio_tfile}
 fi
diff --git a/usr/Kconfig b/usr/Kconfig
index 86cecb5..7f78577 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -44,3 +44,14 @@ config INITRAMFS_ROOT_GID
 	  owned by group root in the initial ramdisk image.

 	  If you are not sure, leave it set to "0".
+
+config INITRAMFS_COMPRESS
+	bool "Compress initramfs image"
+	default y
+	help
+	  If you want a compressed initramfs image in your kernel say y
+	  If you do not want your initramfs image to be compressed say n. 
+	  A compressed initramfs is generally not useful if you also have a
+	  compressed kernel (vmlinuz, bzImage).
+
+	  If you are not sure, levae it to y.
diff --git a/usr/Makefile b/usr/Makefile
index 201f27f..6609896 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -9,10 +9,10 @@ PHONY += klibcdirs
 # Generate builtin.o based on initramfs_data.o
 obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o

-# initramfs_data.o contains the initramfs_data.cpio.gz image.
+# initramfs_data.o contains the initramfs_data.img image.
 # The image is included using .incbin, a dependency which is not
 # tracked automatically.
-$(obj)/initramfs_data.o: $(obj)/initramfs_data.cpio.gz FORCE
+$(obj)/initramfs_data.o: $(obj)/initramfs_data.img FORCE

 #####
 # Generate the initramfs cpio archive
@@ -23,30 +23,31 @@ ramfs-input := $(if $(filter-out "",$(CONFIG_INITRAMFS_SOURCE)), \
 			$(shell echo $(CONFIG_INITRAMFS_SOURCE)),-d)
 ramfs-args  := \
         $(if $(CONFIG_INITRAMFS_ROOT_UID), -u $(CONFIG_INITRAMFS_ROOT_UID)) \
-        $(if $(CONFIG_INITRAMFS_ROOT_GID), -g $(CONFIG_INITRAMFS_ROOT_GID))
+        $(if $(CONFIG_INITRAMFS_ROOT_GID), -g $(CONFIG_INITRAMFS_ROOT_GID)) \
+        $(if $(CONFIG_INITRAMFS_COMPRESS), -c )

-# .initramfs_data.cpio.gz.d is used to identify all files included
+# .initramfs_data.img.d is used to identify all files included
 # in initramfs and to detect if any files are added/removed.
 # Removed files are identified by directory timestamp being updated
 # The dependency list is generated by gen_initramfs.sh -l
-ifneq ($(wildcard $(obj)/.initramfs_data.cpio.gz.d),)
-	include $(obj)/.initramfs_data.cpio.gz.d
+ifneq ($(wildcard $(obj)/.initramfs_data.img.d),)
+	include $(obj)/.initramfs_data.img.d
 endif

 quiet_cmd_initfs = GEN     $@
       cmd_initfs = $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)

-targets := initramfs_data.cpio.gz
+targets := initramfs_data.img
 # do not try to update files included in initramfs
 $(deps_initramfs): ;

 $(deps_initramfs): klibcdirs
-# We rebuild initramfs_data.cpio.gz if:
-# 1) Any included file is newer then initramfs_data.cpio.gz
+# We rebuild initramfs_data.img if:
+# 1) Any included file is newer then initramfs_data.img
 # 2) There are changes in which files are included (added or deleted)
-# 3) If gen_init_cpio are newer than initramfs_data.cpio.gz
+# 3) If gen_init_cpio are newer than initramfs_data.img
 # 4) arguments to gen_initramfs.sh changes
-$(obj)/initramfs_data.cpio.gz: $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
-	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.gz.d
+$(obj)/initramfs_data.img: $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
+	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.img.d
 	$(call if_changed,initfs)

diff --git a/usr/initramfs_data.S b/usr/initramfs_data.S
index c2e1ad4..5820d65 100644
--- a/usr/initramfs_data.S
+++ b/usr/initramfs_data.S
@@ -8,7 +8,7 @@


   ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+  -T initramfs_data.scr initramfs_data.img -o initramfs_data.o
    ld -m elf_i386  -r -o built-in.o initramfs_data.o

   initramfs_data.scr looks like this:
@@ -26,5 +26,5 @@ SECTIONS
 */

 .section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.gz"
+.incbin "usr/initramfs_data.img"

