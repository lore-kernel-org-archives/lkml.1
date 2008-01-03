Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbYACPq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbYACPq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYACPm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:48631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbYACPm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:26 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: hpa@rpath.com, linux-kernel@vger.kernel.org
Subject: [PATCH x86] [11/16] Compile apm and voyager module only when selected in Kconfig
Message-Id: <20080103154225.566C514DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously the complete files were #ifdef'ed, but now handle that in the 
Makefile.

May save a minor bit of compilation time.

Cc: hpa@rpath.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/Kconfig        |    5 +++++
 arch/x86/boot/Makefile  |    6 ++++--
 arch/x86/boot/apm.c     |    3 ---
 arch/x86/boot/voyager.c |    4 ----
 4 files changed, 9 insertions(+), 9 deletions(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -1219,6 +1219,11 @@ source "kernel/power/Kconfig"
 
 source "drivers/acpi/Kconfig"
 
+config X86_APM_BOOT
+	bool
+	default y
+	depends on APM
+
 menuconfig APM
 	tristate "APM (Advanced Power Management) BIOS support"
 	depends on X86_32 && PM_SLEEP && !X86_VISWS
Index: linux/arch/x86/boot/Makefile
===================================================================
--- linux.orig/arch/x86/boot/Makefile
+++ linux/arch/x86/boot/Makefile
@@ -28,9 +28,11 @@ SVGA_MODE := -DSVGA_MODE=NORMAL_VGA
 targets		:= vmlinux.bin setup.bin setup.elf zImage bzImage
 subdir- 	:= compressed
 
-setup-y		+= a20.o apm.o cmdline.o copy.o cpu.o cpucheck.o edd.o
+setup-y		+= a20.o cmdline.o copy.o cpu.o cpucheck.o edd.o
 setup-y		+= header.o main.o mca.o memory.o pm.o pmjump.o
-setup-y		+= printf.o string.o tty.o video.o version.o voyager.o
+setup-y		+= printf.o string.o tty.o video.o version.o
+setup-$(CONFIG_X86_APM_BOOT) += apm.o
+setup-$(CONFIG_X86_VOYAGER) += voyager.o
 
 # The link order of the video-*.o modules can matter.  In particular,
 # video-vga.o *must* be listed first, followed by video-vesa.o.
Index: linux/arch/x86/boot/apm.c
===================================================================
--- linux.orig/arch/x86/boot/apm.c
+++ linux/arch/x86/boot/apm.c
@@ -19,8 +19,6 @@
 
 #include "boot.h"
 
-#if defined(CONFIG_APM) || defined(CONFIG_APM_MODULE)
-
 int query_apm_bios(void)
 {
 	u16 ax, bx, cx, dx, di;
@@ -95,4 +93,3 @@ int query_apm_bios(void)
 	return 0;
 }
 
-#endif
Index: linux/arch/x86/boot/voyager.c
===================================================================
--- linux.orig/arch/x86/boot/voyager.c
+++ linux/arch/x86/boot/voyager.c
@@ -16,8 +16,6 @@
 
 #include "boot.h"
 
-#ifdef CONFIG_X86_VOYAGER
-
 int query_voyager(void)
 {
 	u8 err;
@@ -42,5 +40,3 @@ int query_voyager(void)
 	copy_from_fs(data_ptr, di, 7);	/* Table is 7 bytes apparently */
 	return 0;
 }
-
-#endif /* CONFIG_X86_VOYAGER */
