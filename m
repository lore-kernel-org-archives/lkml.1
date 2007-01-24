Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbXAXMpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbXAXMpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 07:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXAXMpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 07:45:40 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:34904 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXAXMpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 07:45:39 -0500
Date: Wed, 24 Jan 2007 12:45:38 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Mundt <lethal@linux-sh.org>, Andrew Morton <akpm@osdl.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: [PATCH 2/3] ARM: Convert to use shared APM emulation.
Message-ID: <20070124124538.GA14917@linux-mips.org>
References: <20070115205935.GA5010@martell.zuzino.mipt.ru> <20070123164541.42faf54e.akpm@osdl.org> <20070124071337.GA21110@linux-sh.org> <20070124124422.GA14757@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124124422.GA14757@linux-mips.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/arm/Kconfig               |   29 ++----------------
 arch/arm/common/sharpsl_pm.c   |    2 -
 arch/arm/kernel/Makefile       |    1 
 arch/arm/mach-pxa/corgi_pm.c   |    2 -
 arch/arm/mach-pxa/sharpsl_pm.c |    2 -
 arch/arm/mach-pxa/spitz_pm.c   |    2 -
 include/asm-arm/apm.h          |   64 -----------------------------------------
 7 files changed, 8 insertions(+), 94 deletions(-)

Index: linux-apm/arch/arm/Kconfig
===================================================================
--- linux-apm.orig/arch/arm/Kconfig
+++ linux-apm/arch/arm/Kconfig
@@ -9,6 +9,7 @@ config ARM
 	bool
 	default y
 	select RTC_LIB
+	select SYS_SUPPORTS_APM_EMULATION
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
@@ -17,6 +18,9 @@ config ARM
 	  Europe.  There is an ARM Linux project with a web page at
 	  <http://www.arm.linux.org.uk/>.
 
+config SYS_SUPPORTS_APM_EMULATION
+	bool
+
 config GENERIC_TIME
 	bool
 	default n
@@ -856,31 +860,6 @@ menu "Power management options"
 
 source "kernel/power/Kconfig"
 
-config APM
-	tristate "Advanced Power Management Emulation"
-	---help---
-	  APM is a BIOS specification for saving power using several different
-	  techniques. This is mostly useful for battery powered laptops with
-	  APM compliant BIOSes. If you say Y here, the system time will be
-	  reset after a RESUME operation, the /proc/apm device will provide
-	  battery status information, and user-space programs will receive
-	  notification of APM "events" (e.g. battery status change).
-
-	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/pm.txt> and the
-	  Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  This driver does not spin down disk drives (see the hdparm(8)
-	  manpage ("man 8 hdparm") for that), and it doesn't turn off
-	  VESA-compliant "green" monitors.
-
-	  Generally, if you don't have a battery in your machine, there isn't
-	  much point in using this driver and you should say N. If you get
-	  random kernel OOPSes or reboots that don't seem to be related to
-	  anything, try disabling/enabling this option (or disabling/enabling
-	  APM in your BIOS).
-
 endmenu
 
 source "net/Kconfig"
Index: linux-apm/arch/arm/common/sharpsl_pm.c
===================================================================
--- linux-apm.orig/arch/arm/common/sharpsl_pm.c
+++ linux-apm/arch/arm/common/sharpsl_pm.c
@@ -27,7 +27,7 @@
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/arch/pm.h>
 #include <asm/arch/pxa-regs.h>
 #include <asm/arch/sharpsl.h>
Index: linux-apm/arch/arm/kernel/Makefile
===================================================================
--- linux-apm.orig/arch/arm/kernel/Makefile
+++ linux-apm/arch/arm/kernel/Makefile
@@ -10,7 +10,6 @@ obj-y		:= compat.o entry-armv.o entry-co
 		   process.o ptrace.o semaphore.o setup.o signal.o sys_arm.o \
 		   time.o traps.o
 
-obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
 obj-$(CONFIG_ARCH_ACORN)	+= ecard.o 
 obj-$(CONFIG_FIQ)		+= fiq.o
Index: linux-apm/arch/arm/mach-pxa/corgi_pm.c
===================================================================
--- linux-apm.orig/arch/arm/mach-pxa/corgi_pm.c
+++ linux-apm/arch/arm/mach-pxa/corgi_pm.c
@@ -16,7 +16,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/hardware.h>
Index: linux-apm/arch/arm/mach-pxa/sharpsl_pm.c
===================================================================
--- linux-apm.orig/arch/arm/mach-pxa/sharpsl_pm.c
+++ linux-apm/arch/arm/mach-pxa/sharpsl_pm.c
@@ -23,7 +23,7 @@
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/arch/pm.h>
 #include <asm/arch/pxa-regs.h>
 #include <asm/arch/sharpsl.h>
Index: linux-apm/arch/arm/mach-pxa/spitz_pm.c
===================================================================
--- linux-apm.orig/arch/arm/mach-pxa/spitz_pm.c
+++ linux-apm/arch/arm/mach-pxa/spitz_pm.c
@@ -16,7 +16,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/hardware.h>
Index: linux-apm/include/asm-arm/apm.h
===================================================================
--- linux-apm.orig/include/asm-arm/apm.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/* -*- linux-c -*-
- *
- * (C) 2003 zecke@handhelds.org
- *
- * GPL version 2
- *
- * based on arch/arm/kernel/apm.c
- * factor out the information needed by architectures to provide
- * apm status
- *
- *
- */
-#ifndef ARM_ASM_SA1100_APM_H
-#define ARM_ASM_SA1100_APM_H
-
-#include <linux/apm_bios.h>
-
-/*
- * This structure gets filled in by the machine specific 'get_power_status'
- * implementation.  Any fields which are not set default to a safe value.
- */
-struct apm_power_info {
-	unsigned char	ac_line_status;
-#define APM_AC_OFFLINE			0
-#define APM_AC_ONLINE			1
-#define APM_AC_BACKUP			2
-#define APM_AC_UNKNOWN			0xff
-
-	unsigned char	battery_status;
-#define APM_BATTERY_STATUS_HIGH		0
-#define APM_BATTERY_STATUS_LOW		1
-#define APM_BATTERY_STATUS_CRITICAL	2
-#define APM_BATTERY_STATUS_CHARGING	3
-#define APM_BATTERY_STATUS_NOT_PRESENT	4
-#define APM_BATTERY_STATUS_UNKNOWN	0xff
-
-	unsigned char	battery_flag;
-#define APM_BATTERY_FLAG_HIGH		(1 << 0)
-#define APM_BATTERY_FLAG_LOW		(1 << 1)
-#define APM_BATTERY_FLAG_CRITICAL	(1 << 2)
-#define APM_BATTERY_FLAG_CHARGING	(1 << 3)
-#define APM_BATTERY_FLAG_NOT_PRESENT	(1 << 7)
-#define APM_BATTERY_FLAG_UNKNOWN	0xff
-
-	int		battery_life;
-	int		time;
-	int		units;
-#define APM_UNITS_MINS			0
-#define APM_UNITS_SECS			1
-#define APM_UNITS_UNKNOWN		-1
-
-};
-
-/*
- * This allows machines to provide their own "apm get power status" function.
- */
-extern void (*apm_get_power_status)(struct apm_power_info *);
-
-/*
- * Queue an event (APM_SYS_SUSPEND or APM_CRITICAL_SUSPEND)
- */
-void apm_queue_event(apm_event_t event);
-
-#endif
