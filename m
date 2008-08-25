Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYHYTiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYHYTiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbYHYTho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:37:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:46565 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685AbYHYThm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :mime-version:x-mailer:content-transfer-encoding:sender:message-id;
        b=JSVBpAhcgJ0Xeu9bsxjcazx/Q5VscHYnsC6VQ+jS5YYreMPEoDk2Dgbx7p2ynbxF8J
         bAnonYNPQg5felSPpBi89WUp1jmZGT73IIqIYb4dTfKIkh590jeprAoLqGTQztDo5vSX
         yCwL9cNbv8nO2g/3GP+fUAuqefJAu7mVInGCg=
References: <20080825191427.728251800@bohmer.net>>
User-Agent: quilt/0.46-1
Date: Mon, 25 Aug 2008 21:14:29 +0200
From: Remy Bohmer <linux@bohmer.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       u-boot@lists.denx.de, sam@ravnborg.org
Cc: Stefan Roese <sr@denx.de>, Remy Bohmer <linux@bohmer.net>
Subject: [patch 2/2] Add support for building the new U-boot uImage format
	(FIT-format)
Content-Disposition: inline; filename=add-u-boot-fit-image-support.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Message-ID: <48b30a00.1701d00a.4ee8.ffffa5f7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow building of the newer FIT-image format for U-boot, while keeping
it possible to build the legacy format, for people who do not want to (or can) 
upgrade to U-boot 1.3.3 or newer.

If an older mkimage is detected, or if there is no dtc (Device Tree Compiler)
then automagically the legacy format is created.
There is also a possibility to force the legacy format by means of a Kconfig
option.

Note: This patch only adapts this for ARM, AVR32, Blackfin and sh architectures.
      It does not adapt the PowerPC tree, because PowerPC does not use the
      script at scripts/mkuboot.sh

Signed-off-by: Remy Bohmer <linux@bohmer.net>
---
 arch/arm/Kconfig                |   10 ++
 arch/arm/boot/Makefile          |   10 ++
 arch/avr32/Kconfig              |   14 ++++
 arch/avr32/boot/images/Makefile |    8 ++
 arch/blackfin/Kconfig           |   10 ++
 arch/blackfin/boot/Makefile     |    8 ++
 arch/sh/Kconfig                 |   10 ++
 arch/sh/boot/Makefile           |    8 ++
 scripts/mkuboot.sh              |  140 ++++++++++++++++++++++++++++++++++++++--
 9 files changed, 209 insertions(+), 9 deletions(-)

Index: linux-2.6.27-rc4/arch/arm/Kconfig
===================================================================
--- linux-2.6.27-rc4.orig/arch/arm/Kconfig	2008-08-25 20:58:36.000000000 +0200
+++ linux-2.6.27-rc4/arch/arm/Kconfig	2008-08-25 20:58:40.000000000 +0200
@@ -977,6 +977,16 @@ config UNCOMPRESSED_UIMAGE
 
 	  If unsure, say N.
 
+config LEGACY_UIMAGE
+	bool "Use legacy format for building uImage"
+	default n
+	help
+	  Enable this option if you want uImage to be build in the legacy
+	  format. If this option is 'N' the uImage will be build in the newer
+	  FIT-image format. (Needs at least 'mkimage v1.3.3', and 'dtc v1.2.0')
+
+	  If unsure, say N.
+
 config XIP_PHYS_ADDR
 	hex "XIP Kernel Physical Location"
 	depends on XIP_KERNEL
Index: linux-2.6.27-rc4/arch/arm/boot/Makefile
===================================================================
--- linux-2.6.27-rc4.orig/arch/arm/boot/Makefile	2008-08-25 20:58:36.000000000 +0200
+++ linux-2.6.27-rc4/arch/arm/boot/Makefile	2008-08-25 20:58:40.000000000 +0200
@@ -59,10 +59,16 @@ $(obj)/zImage:	$(obj)/compressed/vmlinux
 
 endif
 
+ifeq ($(CONFIG_LEGACY_UIMAGE),y)
+UIMAGE_FORMAT=legacy
+else
+UIMAGE_FORMAT=fit
+endif
+
 quiet_cmd_uimage = UIMAGE  $@
       cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A arm -O linux -T kernel \
-		   -C none -a $(LOADADDR) -e $(LOADADDR) \
-		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
+		   -C none -a $(LOADADDR) -e $(LOADADDR) -l $(UIMAGE_FORMAT) \
+		   -n 'Linux-$(KERNELRELEASE)' -d $< -i $@
 
 ifeq ($(CONFIG_ZBOOT_ROM),y)
 $(obj)/uImage: LOADADDR=$(CONFIG_ZBOOT_ROM_TEXT)
Index: linux-2.6.27-rc4/scripts/mkuboot.sh
===================================================================
--- linux-2.6.27-rc4.orig/scripts/mkuboot.sh	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/scripts/mkuboot.sh	2008-08-25 21:07:06.000000000 +0200
@@ -1,19 +1,151 @@
 #!/bin/bash
-
 #
 # Build U-Boot image when `mkimage' tool is available.
+# Check also if dtc exist and has the right version (at least v 1.2.0)
+#
+# 25 Aug 2008: Remy Bohmer <linux@bohmer.net>,
+#              Added support for FIT and legacy uImages
 #
 
 MKIMAGE=$(type -path "${CROSS_COMPILE}mkimage")
+DTC=$(type -path "${CROSS_COMPILE}dtc")
+
+function usage () {
+	echo "Usage: `basename $0` -A arch -O os -T type -C comp -a addr"
+	echo "                -e ep -l <legacy|fit> -n name "
+	echo "                -d data_file[:data_file...] -i image"
+	echo "       -A ==> set architecture to 'arch'"
+	echo "       -O ==> set operating system to 'os'"
+	echo "       -T ==> set image type to 'type'"
+	echo "       -C ==> set compression type 'comp'"
+	echo "       -a ==> set load address to 'addr' (hex)"
+	echo "       -e ==> set entry point to 'ep' (hex)"
+	echo "       -l ==> uImage format type <legacy|fit>"
+	echo "       -n ==> set image name to 'name'"
+	echo "       -d ==> use image data from 'datafile'"
+	echo "       -i ==> destination image"
+	exit 1
+}
+
+OPT_CNT=0
+OPT_MASK=0
+function track_opt () {
+	let OPT_CNT=${OPT_CNT}+1
+	let OPT_MASK=${OPT_MASK}+$1
+}
+
+function gen_tmp_specfile () {
+rm -f $1
+cat > $1 << EOF
+/ {
+        description = "kernel ${NAME}";
+        #address-cells = <1>;
+
+        images {
+                kernel@1 {
+                        description = "Linux Kernel";
+                        data = /incbin/("$(basename ${DATA})");
+                        type = "${TYPE}";
+                        arch = "${ARCH}";
+                        os = "${OS}";
+                        compression = "${COMPRESS}";
+                        load = <${LOADADDR}>;
+                        entry = <${ENTRY}>;
+                        hash@1 {
+                                algo = "crc32";
+                        };
+                        hash@2 {
+                                algo = "sha1";
+                        };
+                };
+        };
+
+        configurations {
+                default = "config@1";
+                config@1 {
+                        description = "Boot Linux kernel";
+                        kernel = "kernel@1";
+                };
+        };
+};
+EOF
+}
+
+#
+# Parse command line
+#
+while getopts ":A:O:T:C:a:e:l:n:d:i:" Option
+do
+	case $Option in
+		A  ) track_opt 1  ; ARCH=$OPTARG;;
+		O  ) track_opt 2  ; OS=$OPTARG;;
+		T  ) track_opt 4  ; TYPE=$OPTARG;;
+		C  ) track_opt 8  ; COMPRESS=$OPTARG;;
+		a  ) track_opt 16 ; LOADADDR=$OPTARG;;
+		e  ) track_opt 32 ; ENTRY=$OPTARG;;
+		l  ) track_opt 64 ; UIMAGE_FORMAT=$OPTARG;;
+		n  ) track_opt 128; NAME=$OPTARG;;
+		d  ) track_opt 256; DATA=$OPTARG;;
+		i  ) track_opt 512; IMAGE=$OPTARG;;
+		*  ) echo "Invalid option passed to '$0' (options:$@)"
+		     usage;;
+	esac
+done
+
+# strip off the 0x from the LOADADDR and ENTRY (if exists)
+LOADADDR=$(echo "${LOADADDR}" | sed s@'0x'@''@g)
+ENTRY=$(echo "${ENTRY}" | sed s@'0x'@''@g)
+
+# All arguments available ?
+if [ ${OPT_CNT} -ne 10 -o ${OPT_MASK} -ne 1023 ]; then
+	usage
+fi
 
 if [ -z "${MKIMAGE}" ]; then
 	MKIMAGE=$(type -path mkimage)
 	if [ -z "${MKIMAGE}" ]; then
 		# Doesn't exist
-		echo '"mkimage" command not found - U-Boot images will not be built' >&2
+		echo '"mkimage" command not found' >&2
+		echo '--> U-Boot images will not be built' >&2
 		exit 0;
 	fi
 fi
 
-# Call "mkimage" to create U-Boot image
-${MKIMAGE} "$@"
+if [ "${UIMAGE_FORMAT}" != "legacy" ]; then
+	if [ "x$(${MKIMAGE} 2>&1 | grep '\-f')" = "x" ]; then
+		echo "'${MKIMAGE}' does not support FIT images" >&2
+		echo "Building legacy U-Boot image..." >&2
+		UIMAGE_FORMAT=legacy
+	fi
+fi
+
+if [ "${UIMAGE_FORMAT}" != "legacy" ]; then
+	# for building FIT images we need the device tree compiler
+	if [ -z "${DTC}" ]; then
+		DTC=$(type -path dtc)
+		if [ -z "${DTC}" ]; then
+			# Doesn't exist
+			echo '"dtc" command not found' >&2
+			echo '--> Can only built legacy U-Boot images' >&2
+			UIMAGE_FORMAT=legacy
+		else
+			DTC_VER=$(dtc -v | cut -d' ' -f3 | sed s@'\.'@''@g)
+			if [ ${DTC_VER} -lt 120 ]; then
+				echo '"dtc" must be at least version 1.2.0' >&2
+				echo '-->Can only built legacy U-Boot images'>&2
+				UIMAGE_FORMAT=legacy
+			fi
+		fi
+	fi
+fi
+
+if [ "${UIMAGE_FORMAT}" = "legacy" ]; then
+	# Call "mkimage" in the legacy mode to create U-Boot image
+	${MKIMAGE} -A ${ARCH} -O ${OS} -T ${TYPE} \
+		   -C ${COMPRESS} -a 0x${LOADADDR} -e 0x${ENTRY} \
+		   -n "${NAME}" -d ${DATA} ${IMAGE}
+else
+	# Call "mkimage" in the FIT mode to create U-Boot image
+	gen_tmp_specfile ${IMAGE}.its
+	${MKIMAGE} -f ${IMAGE}.its ${IMAGE}
+fi
Index: linux-2.6.27-rc4/arch/blackfin/Kconfig
===================================================================
--- linux-2.6.27-rc4.orig/arch/blackfin/Kconfig	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/arch/blackfin/Kconfig	2008-08-25 20:58:40.000000000 +0200
@@ -286,6 +286,16 @@ config BOOT_LOAD
 	  memory region is used to capture NULL pointer references as well
 	  as some core kernel functions.
 
+config LEGACY_UIMAGE
+	bool "Use legacy format for building uImage"
+	default n
+	help
+	  Enable this option if you want uImage to be build in the legacy
+	  format. If this option is 'N' the uImage will be build in the newer
+	  FIT-image format. (Needs at least 'mkimage v1.3.3', and 'dtc v1.2.0')
+
+	  If unsure, say N.
+
 comment "Clock/PLL Setup"
 
 config CLKIN_HZ
Index: linux-2.6.27-rc4/arch/blackfin/boot/Makefile
===================================================================
--- linux-2.6.27-rc4.orig/arch/blackfin/boot/Makefile	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/arch/blackfin/boot/Makefile	2008-08-25 20:58:40.000000000 +0200
@@ -11,11 +11,17 @@ MKIMAGE := $(srctree)/scripts/mkuboot.sh
 targets := vmImage
 extra-y += vmlinux.bin vmlinux.gz
 
+ifeq ($(CONFIG_LEGACY_UIMAGE),y)
+UIMAGE_FORMAT=legacy
+else
+UIMAGE_FORMAT=fit
+endif
+
 quiet_cmd_uimage = UIMAGE  $@
       cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
                    -C gzip -n 'Linux-$(KERNELRELEASE)' -a $(CONFIG_BOOT_LOAD) \
                    -e $(shell $(NM) vmlinux | awk '$$NF == "__start" {print $$1}') \
-                   -d $< $@
+                   -l $(UIMAGE_FORMAT) -d $< -i $@
 
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
Index: linux-2.6.27-rc4/arch/avr32/Kconfig
===================================================================
--- linux-2.6.27-rc4.orig/arch/avr32/Kconfig	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/arch/avr32/Kconfig	2008-08-25 20:58:40.000000000 +0200
@@ -147,6 +147,20 @@ config PHYS_OFFSET
 	hex
 	default 0x10000000 if CPU_AT32AP700X=y
 
+if LOADER_U_BOOT
+
+config LEGACY_UIMAGE
+	bool "Use legacy format for building uImage"
+	default n
+	help
+	  Enable this option if you want uImage to be build in the legacy
+	  format. If this option is 'N' the uImage will be build in the newer
+	  FIT-image format. (Needs at least 'mkimage v1.3.3', and 'dtc v1.2.0')
+
+	  If unsure, say N.
+
+endif
+
 source "kernel/Kconfig.preempt"
 
 config QUICKLIST
Index: linux-2.6.27-rc4/arch/avr32/boot/images/Makefile
===================================================================
--- linux-2.6.27-rc4.orig/arch/avr32/boot/images/Makefile	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/arch/avr32/boot/images/Makefile	2008-08-25 20:58:40.000000000 +0200
@@ -17,10 +17,16 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 
+ifeq ($(CONFIG_LEGACY_UIMAGE),y)
+UIMAGE_FORMAT=legacy
+else
+UIMAGE_FORMAT=fit
+endif
+
 quiet_cmd_uimage = UIMAGE $@
       cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A avr32 -O linux -T kernel	\
 		-C gzip -a $(CONFIG_LOAD_ADDRESS) -e $(CONFIG_ENTRY_ADDRESS)	\
-		-n 'Linux-$(KERNELRELEASE)' -d $< $@
+		-l $(UIMAGE_FORMAT) -n 'Linux-$(KERNELRELEASE)' -d $< -i $@
 
 targets += uImage uImage.srec
 $(obj)/uImage: $(obj)/vmlinux.gz
Index: linux-2.6.27-rc4/arch/sh/Kconfig
===================================================================
--- linux-2.6.27-rc4.orig/arch/sh/Kconfig	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/arch/sh/Kconfig	2008-08-25 20:58:40.000000000 +0200
@@ -607,6 +607,16 @@ config CMDLINE
 	depends on CMDLINE_BOOL
 	default "console=ttySC1,115200"
 
+config LEGACY_UIMAGE
+	bool "Use legacy format for building uImage"
+	default n
+	help
+	  Enable this option if you want uImage to be build in the legacy
+	  format. If this option is 'N' the uImage will be build in the newer
+	  FIT-image format. (Needs at least 'mkimage v1.3.3', and 'dtc v1.2.0')
+
+	  If unsure, say N.
+
 endmenu
 
 menu "Bus options"
Index: linux-2.6.27-rc4/arch/sh/boot/Makefile
===================================================================
--- linux-2.6.27-rc4.orig/arch/sh/boot/Makefile	2008-08-25 20:58:33.000000000 +0200
+++ linux-2.6.27-rc4/arch/sh/boot/Makefile	2008-08-25 20:58:40.000000000 +0200
@@ -43,10 +43,16 @@ KERNEL_ENTRY	:= $(shell /bin/bash -c 'pr
 			$(CONFIG_MEMORY_START) + \
 			$(CONFIG_ZERO_PAGE_OFFSET) + $(CONFIG_ENTRY_OFFSET)]')
 
+ifeq ($(CONFIG_LEGACY_UIMAGE),y)
+UIMAGE_FORMAT=legacy
+else
+UIMAGE_FORMAT=fit
+endif
+
 quiet_cmd_uimage = UIMAGE  $@
       cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A sh -O linux -T kernel \
 		   -C gzip -a $(KERNEL_LOAD) -e $(KERNEL_ENTRY) \
-		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
+		   -l $(UIMAGE_FORMAT) -n 'Linux-$(KERNELRELEASE)' -d $< -i $@
 
 $(obj)/uImage: $(obj)/vmlinux.bin.gz FORCE
 	$(call if_changed,uimage)

-- 

