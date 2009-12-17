Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZLQODp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZLQODp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZLQODm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:03:42 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25420 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZLQODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:03:41 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 09:03:41 EST
X-IronPort-AV: E=Sophos;i="4.47,413,1257138000"; 
   d="scan'208";a="76879371"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] microcode: do not WARN_ON(cpu != 0) during resume
Date: Thu, 17 Dec 2009 13:53:44 +0000
Message-Id: <1261058024-32278-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 17 Dec 2009 13:53:50.0920 (UTC) FILETIME=[5CFC4C80:01CA7F20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

871b72dd "x86: microcode: use smp_call_function_single instead of
set_cpus_allowed, cleanup of synchronization logic" included:

 static int mc_sysdev_resume(struct sys_device *dev)
 {
[...]
+       /*
+        * All non-bootup cpus are still disabled,
+        * so only CPU 0 will apply ucode here.
+        *
+        * Moreover, there can be no concurrent
+        * updates from any other places at this point.
+        */
+       WARN_ON(cpu != 0);

However suspend/resume under Xen doesn't need to hot unplug all the CPUs, so we
don't; the hypervisor can manage the context save/restore for all CPUs.

It would be unnecessary to load microcode.ko in a Xen domU but if it does occur
(e.g. because a distro installs the tools by default) we would like to avoid
the warning on resume.

Since the real constraint here is that we are running on the CPU for which we
would like to load microcode (which in all practical circumstances is CPU0)
just check for that and return if we are resuming a different CPU.

There is no danger of concurrent updates, even if we ignore the fact that all
but one CPUs are unplugged on native, because sysdev_resume() is single
threaded.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_core.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 378e9a8..1153062 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -438,18 +438,9 @@ static int mc_sysdev_resume(struct sys_device *dev)
 	int cpu = dev->id;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	if (!cpu_online(cpu))
+	if (cpu != smp_processor_id())
 		return 0;
 
-	/*
-	 * All non-bootup cpus are still disabled,
-	 * so only CPU 0 will apply ucode here.
-	 *
-	 * Moreover, there can be no concurrent
-	 * updates from any other places at this point.
-	 */
-	WARN_ON(cpu != 0);
-
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
 
-- 
1.5.6.5

