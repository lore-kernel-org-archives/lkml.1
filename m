Return-Path: <linux-kernel-owner+w=401wt.eu-S964960AbYAaWPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbYAaWPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934509AbYAaWKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:49 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40303 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934364AbYAaWKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:38 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix section mismatch warnings when referencing notifiers
Date: Thu, 31 Jan 2008 23:10:40 +0100
Message-Id: <1201817440-5081-11-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings:
WARNING: arch/x86/kernel/built-in.o(.exit.text+0xf8): Section mismatch in reference from the function msr_exit() to the variable .cpuinit.data:msr_class_cpu_notifier
WARNING: arch/x86/kernel/built-in.o(.exit.text+0x158): Section mismatch in reference from the function cpuid_exit() to the variable .cpuinit.data:cpuid_class_cpu_notifier
WARNING: arch/x86/kernel/built-in.o(.exit.text+0x171): Section mismatch in reference from the function microcode_exit() to the variable .cpuinit.data:mc_cpu_notifier

In all three cases there were a function annotated __exit
that referenced a variable annotated __cpuinitdata.

The fix was to replace the annotation of the notifier
with __refdata to tell modpost that the reference to
a _cpuinit function in the notifier are OK.
The unregister call that references the notifier
variable will simple delete the function pointer
so there is no problem ignoring the reference.

Note: This looks like another case where __cpuinit
has been used as replacement for proper use
of CONFIG_HOTPLUG_CPU to decide what code are used for
HOTPLUG_CPU.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/cpuid.c     |    2 +-
 arch/x86/kernel/microcode.c |    2 +-
 arch/x86/kernel/msr.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index dec66e4..a63432d 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -170,7 +170,7 @@ static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpuid_class_cpu_notifier =
+static struct notifier_block __refdata cpuid_class_cpu_notifier =
 {
 	.notifier_call = cpuid_class_cpu_callback,
 };
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 6ff447f..f2702d0 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -797,7 +797,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata mc_cpu_notifier = {
+static struct notifier_block __refdata mc_cpu_notifier = {
 	.notifier_call = mc_cpu_callback,
 };
 
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 21f6e3c..bd82850 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -168,7 +168,7 @@ static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata msr_class_cpu_notifier = {
+static struct notifier_block __refdata msr_class_cpu_notifier = {
 	.notifier_call = msr_class_cpu_callback,
 };
 
-- 
1.5.4.rc3.14.g44397

