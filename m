Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbXJDNGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbXJDNGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 09:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXJDNGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 09:06:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:44452 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbXJDNGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 09:06:31 -0400
Date: Thu, 4 Oct 2007 15:05:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, jikos@jikos.cz
Subject: video resume stuff
Message-ID: <20071004130513.GA16076@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm thinking about how to clean up video resume/how to get it to work
for non-VESA video modes (jikos' case).

I guess the cleanest solution would be to just call set_mode from
wakeup.S.... but that is not as easy as I imagined, because bootup
code seems to be compiled separately.

Is there some easy way to retain bootup code in memory, so that wakeup
can use it? Or is there some easy solution I'm missing?

I came up with this, unfortunately it does not even link :-(.
									Pavel
diff --git a/arch/i386/kernel/acpi/Makefile b/arch/i386/kernel/acpi/Makefile
index 7f7be01..f6a0885 100644
--- a/arch/i386/kernel/acpi/Makefile
+++ b/arch/i386/kernel/acpi/Makefile
@@ -2,7 +2,10 @@ obj-$(CONFIG_ACPI)		+= boot.o
 ifneq ($(CONFIG_PCI),)
 obj-$(CONFIG_X86_IO_APIC)	+= earlyquirk.o
 endif
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o
+obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup.o ../../boot/a20.o       ../../boot/edd.o     ../../boot/pmjump.o      ../../boot/video-vesa.o ../../boot/apm.o  ../../boot/printf.o      ../../boot/video-vga.o ../../boot/cmdline.o    ../../boot/string.o      ../../boot/video.o ../../boot/copy.o      ../../boot/mca.o     ../../boot/tty.o         ../../boot/voyager.o ../../boot/cpu.o       ../../boot/memory.o  ../../boot/version.o ../../boot/cpucheck.o  ../../boot/pm.o      ../../boot/video-bios.o
+
+#   ../../boot/main.o
+
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o processor.o
diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
index f1c7484..3fd5cf6 100644
--- a/arch/i386/kernel/acpi/wakeup.S
+++ b/arch/i386/kernel/acpi/wakeup.S
@@ -2,6 +2,9 @@
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page.h>
+#include <asm/boot.h>
+#include "../../boot/boot.h"
+
 
 #
 # wakeup_code runs in real mode, and at unknown address (determined at run-time).
@@ -28,6 +31,9 @@ #define BEEP \
 	movb	$15, %al; 	\
 	outb	%al, $66;
 
+	.globl	set_video
+	.type	set_video, @function
+	
 ALIGN
 	.align	4096
 ENTRY(wakeup_start)
@@ -71,7 +77,8 @@ #	BEEP
 	testl	$2, realmode_flags - wakeup_code
 	jz	1f
 	mov	video_mode - wakeup_code, %ax
-	call	mode_set
+	calll	set_video
+#	call	mode_set
 1:
 
 	# set up page table




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
