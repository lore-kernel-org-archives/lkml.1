Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbXFBWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbXFBWGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXFBWGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:06:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32798 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbXFBWGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:06:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ACPI: preserve the ebx value in acpi_copy_wakeup_routine
Date: Sun, 3 Jun 2007 00:11:42 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
       Tian Kevin <kevin.tian@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706030011.43733.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tian Kevin <kevin.tian@intel.com>

Register %ebx serves as the "global offset table base register"
for position-independent code. For absolute code, %ebx serves
as a local register and has no specified role in the function
calling sequence. In either case, a function must preserve the
register value for the caller.

acpi_copy_wakeup_routine overrides %ebx without saving it,
this may corrupt the called data.

Kevin found that most time the value of Sx is saved in %esi,
however sometimes compiler also uses %ebx. When this happens,
suspends fails since sleep value in ebx is changed by
acpi_copy_wakeup_routine.

The same funtion in X86_64 doesn't have this problem.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Looks-okay-to: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/i386/kernel/acpi/wakeup.S |    2 ++
 1 files changed, 2 insertions(+)

Index: linux-2.6.22-rc3/arch/i386/kernel/acpi/wakeup.S
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/kernel/acpi/wakeup.S	2007-05-31 17:23:56.000000000 +0800
+++ linux-2.6.22-rc3/arch/i386/kernel/acpi/wakeup.S	2007-05-31 17:24:08.000000000 +0800
@@ -230,6 +230,7 @@ bogus_magic:
 #
 ENTRY(acpi_copy_wakeup_routine)
 
+	pushl	%ebx
 	sgdt	saved_gdt
 	sidt	saved_idt
 	sldt	saved_ldt
@@ -263,6 +264,7 @@ ENTRY(acpi_copy_wakeup_routine)
 	movl	%edx, video_flags - wakeup_start (%eax)
 	movl	$0x12345678, real_magic - wakeup_start (%eax)
 	movl	$0x12345678, saved_magic
+	popl	%ebx
 	ret
 
 save_registers:
-
