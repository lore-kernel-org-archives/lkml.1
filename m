Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbYFSOck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbYFSOck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbYFSOca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:32:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:58273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbYFSOcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=ruhofhwHM3G8B8ep2tq5dKYuI8eGLFedK6nL1cqiWRIUvIA8Tc0wPZD26YCw7TfSRD
         7QIV0jvpuPDN/KGpOly26Naj8zX0VBRbSgXRovleWuqa5j7kyyziLJpAfH08ySD1LQJY
         M3RJVLJ5WPFoqFhv/YAe0QfkZbwRP9GlY9wQw=
Date: Thu, 19 Jun 2008 16:32:14 +0200
To: stable@kernel.org
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [stable PATCH 1/2] x86: remove mwait capability C-state check
Message-ID: <20080619143214.GA3243@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 May 2008 08:47:40 +0200
Subject: [PATCH] x86: remove mwait capability C-state check

Vegard Nossum reports:

| powertop shows between 200-400 wakeups/second with the description
| "<kernel IPI>: Rescheduling interrupts" when all processors have load (e.g.
| I need to run two busy-loops on my 2-CPU system for this to show up).
|
| The bisect resulted in this commit:
|
| commit 0c07ee38c9d4eb081758f5ad14bbffa7197e1aec
| Date:   Wed Jan 30 13:33:16 2008 +0100
|
|     x86: use the correct cpuid method to detect MWAIT support for C states

remove the functional effects of this patch and make mwait unconditional.

A future patch will turn off mwait on specific CPUs where that causes
power to be wasted.

Bisected-by: Vegard Nossum <vegard.nossum@gmail.com>
Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

[back-ported from upstream commit a738d897b7b03b83488ae74a9bc03d26a2875dc6]

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/process_32.c |   10 +---------
 arch/x86/kernel/process_64.c |   11 +----------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c8890b8..54bb813 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -259,14 +259,6 @@ static void mwait_idle(void)
 	mwait_idle_with_hints(0, 0);
 }
 
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-	if (force_mwait)
-		return 1;
-	/* Any C1 states supported? */
-	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int selected;
@@ -279,7 +271,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 			" performance may degrade.\n");
 	}
 #endif
-	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 1316f1c..fbb171f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -254,15 +254,6 @@ static void mwait_idle(void)
 	}
 }
 
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-	if (force_mwait)
-		return 1;
-	/* Any C1 states supported? */
-	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int selected;
@@ -275,7 +266,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 			" performance may degrade.\n");
 	}
 #endif
-	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
-- 
1.5.4.1

