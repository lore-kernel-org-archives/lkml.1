Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYBHVtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYBHVtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYBHVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:49:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55207 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbYBHVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:49:38 -0500
Date: Fri, 8 Feb 2008 22:49:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080208214936.GK12923@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <200802070049.00461.rjw@sisk.pl> <200802072312.31430.rjw@sisk.pl> <20080207222833.GA23004@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207222833.GA23004@uranus.ravnborg.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This cleans up .lds, making use of constants...

								Pavel

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
index 4a26e27..ee7c68b 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -6,6 +6,7 @@
 #ifndef ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
 #define ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H
 
+#ifndef __ASSEMBLY__
 #include <linux/types.h>
 
 /* This must match data at wakeup.S */
@@ -27,5 +28,10 @@ struct wakeup_header {
 	u16 trampoline_segment;
 	u32 signature;		/* To check we have correct structure */
 } __attribute__((__packed__));
+#endif
+
+#define HEADER_OFFSET 0x3f00
+#define WAKEUP_SIZE   0x4000
+
 
 #endif /* ARCH_X86_KERNEL_ACPI_RM_WAKEUP_H */
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 24ebe75..22fab6c 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -4,6 +4,7 @@
  * Linker script for the real-mode wakeup code
  */
 #undef i386
+#include "wakeup.h"
 
 OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
 OUTPUT_ARCH(i386)
@@ -11,7 +12,7 @@ ENTRY(_start)
 
 SECTIONS
 {
-	. = 0x3f00;
+	. = HEADER_OFFSET;
 	.header : {
 		 *(.header)
 	}
@@ -56,7 +57,5 @@ SECTIONS
 		*(.note*)
 	}
 
-	/* Adjust this as appropriate */
-	/* This allows 4 pages (16K) */
-	. = ASSERT(_end <= 0x4000, "Wakeup too big!");
+	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
 }
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 1b282b1..561565e 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -53,9 +53,9 @@ int acpi_save_state_mem(void)
 		       "S3 disabled\n");
 		return -ENOMEM;
 	}
-	memcpy((void *)acpi_realmode, &wakeup_code_start, 4*PAGE_SIZE);
+	memcpy((void *)acpi_realmode, &wakeup_code_start, WAKEUP_SIZE);
 
-	header = (struct wakeup_header *)(acpi_realmode + 0x3f00);
+	header = (struct wakeup_header *)(acpi_realmode + HEADER_OFFSET);
 	if (header->signature != 0x51ee1111) {
 		printk(KERN_ERR "wakeup header does not match\n");
 		return -EINVAL;
@@ -111,13 +111,13 @@ void acpi_restore_state_mem(void)
  */
 void __init acpi_reserve_bootmem(void)
 {
-	if ((&wakeup_code_end - &wakeup_code_start) > PAGE_SIZE*4) {
+	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
 		printk(KERN_ERR
 		       "ACPI: Wakeup code way too big, S3 disabled.\n");
 		return;
 	}
 
-	acpi_realmode = (unsigned long)alloc_bootmem_low(PAGE_SIZE*4);
+	acpi_realmode = (unsigned long)alloc_bootmem_low(WAKEUP_SIZE);
 
 	if (!acpi_realmode) {
 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
