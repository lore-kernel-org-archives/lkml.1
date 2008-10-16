Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbYJPXW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbYJPXW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbYJPXWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:22:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883AbYJPXWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:22:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86 ACPI: Fix breakage of resume on 64-bit UP systems with SMP kernel
Date: Fri, 17 Oct 2008 01:26:27 +0200
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810170126.27890.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

x86 ACPI: Fix breakage of resume on 64-bit UP systems with SMP kernel

We are now using per CPU GDT tables in head_64.S and the original
early_gdt_descr.address is invalidated after boot by 
setup_per_cpu_areas().  This breaks resume from suspend to RAM on
x86_64 UP systems using SMP kernels, because this part of head_64.S
is also executed during the resume and the invalid GDT address
causes the system to crash.  It doesn't break on 'true' SMP systems,
because early_gdt_descr.address is modified every time
native_cpu_up() runs.  However, during resume it should point to the
GDT of the boot CPU rather than to another CPU's GDT.

For this reason, during suspend to RAM always make
early_gdt_descr.address point to the boot CPU's GDT.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=11568, which
is a regression from 2.6.26.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-and-tested-by: Andy Wettstein <ajw1980@gmail.com>
---
 arch/x86/kernel/acpi/sleep.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/arch/x86/kernel/acpi/sleep.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6/arch/x86/kernel/acpi/sleep.c
@@ -10,6 +10,7 @@
 #include <linux/dmi.h>
 #include <linux/cpumask.h>
 #include <asm/segment.h>
+#include <asm/desc.h>
 
 #include "realmode/wakeup.h"
 #include "sleep.h"
@@ -100,6 +101,8 @@ int acpi_save_state_mem(void)
 	header->trampoline_segment = setup_trampoline() >> 4;
 #ifdef CONFIG_SMP
 	stack_start.sp = temp_stack + 4096;
+	early_gdt_descr.address =
+			(unsigned long)get_cpu_gdt_table(smp_processor_id());
 #endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
