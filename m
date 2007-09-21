Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbXIUWsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbXIUWsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763301AbXIUWcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:57106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764058AbXIUWcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:41 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: satyam@infradead.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [40/50] i386: Fix section mismatch
Message-Id: <20070921223240.66AB31479D@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Satyam Sharma <satyam@infradead.org>

Fix bugzilla #8679

WARNING: arch/i386/kernel/built-in.o(.data+0x2148): Section mismatch: reference
to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mtrr_mutex')

comes because struct notifier_block thermal_throttle_cpu_notifier in
arch/i386/kernel/cpu/mcheck/therm_throt.c goes in .data section but the
notifier callback function itself has been marked __cpuinit which becomes
__init == .init.text when HOTPLUG_CPU=n.  The warning is bogus because the
callback will never be called out if HOTPLUG_CPU=n in the first place (as
one can see from kernel/cpu.c, the cpu_chain itself is __cpuinitdata :-)

So, let's mark thermal_throttle_cpu_notifier as __cpuinitdata to fix
the section mismatch warning.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/therm_throt.c
+++ linux/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -152,7 +152,7 @@ static __cpuinit int thermal_throttle_cp
 	return NOTIFY_OK;
 }
 
-static struct notifier_block thermal_throttle_cpu_notifier =
+static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = thermal_throttle_cpu_callback,
 };
