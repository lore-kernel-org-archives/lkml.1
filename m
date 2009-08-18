Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZHRPlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZHRPlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbZHRPle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:41:34 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46472 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZHRPld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:41:33 -0400
Message-Id: <4A8AE7CD020000780001054B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Aug 2009 16:41:33 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <robert.richter@amd.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix section mismatches for init code with
	 !HOTPLUG_CPU
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0e83815be719d3391bf5ea24b7fe696c07dbd417 changed the section the
initial_code variable gets allocated in, in an attempt to address a
section conflict warning. This, however created a new section conflict
when building without HOTPLUG_CPU. The apparently only (reasonable) way
to address this is to always use __REFDATA.

Once at it, also fix a second section mismatch when not using
HOTPLUG_CPU.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Robert Richter <robert.richter@amd.com>

---
 arch/x86/kernel/head_32.S |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- linux-2.6.31-rc6/arch/x86/kernel/head_32.S	2009-08-18 15:31:16.000000000 +0200
+++ 2.6.31-rc6-i386-head-sections/arch/x86/kernel/head_32.S	2009-08-18 10:38:31.000000000 +0200
@@ -261,9 +261,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
  * which will be freed later
  */
 
-#ifndef CONFIG_HOTPLUG_CPU
-.section .init.text,"ax",@progbits
-#endif
+__CPUINIT
 
 #ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
@@ -602,11 +600,7 @@ ignore_int:
 #endif
 	iret
 
-#ifndef CONFIG_HOTPLUG_CPU
-	__CPUINITDATA
-#else
 	__REFDATA
-#endif
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel



