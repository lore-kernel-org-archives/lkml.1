Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbXHUEYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbXHUEYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXHUEYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:24:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50773 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXHUEYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:24:46 -0400
Date: Tue, 21 Aug 2007 10:07:31 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       wbrana@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][bugzilla #8679] therm_throt.c: Fix section mismatch
Message-ID: <alpine.LFD.0.999.0708211003390.2774@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


WARNING: arch/i386/kernel/built-in.o(.data+0x2148): Section mismatch: reference
to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mtrr_mutex')

comes because struct notifier_block thermal_throttle_cpu_notifier in
arch/i386/kernel/cpu/mcheck/therm_throt.c goes in .data section but
the notifier callback function itself has been marked __cpuinit which
becomes __init == .init.text when HOTPLUG_CPU=n. The warning is bogus
because the callback will never be called out if HOTPLUG_CPU=n in the
first place (as one can see from kernel/cpu.c, the cpu_chain itself
is __cpuinitdata :-)

So, let's mark thermal_throttle_cpu_notifier as __cpuinitdata to fix
the section mismatch warning.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

[The other section mismatch mentioned in bugzilla #8679 is already fixed.]

 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/cpu/mcheck/therm_throt.c b/arch/i386/kernel/cpu/mcheck/therm_throt.c
index 1203dc5..494d320 100644
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -152,7 +152,7 @@ static __cpuinit int thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block thermal_throttle_cpu_notifier =
+static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = thermal_throttle_cpu_callback,
 };
