Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbXLKWZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbXLKWZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbXLKWW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:22:58 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38528 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756919AbXLKWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:22:57 -0500
Date: Tue, 11 Dec 2007 23:22:54 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] idle_regs() must be __cpuinit
Message-ID: <20071211222254.GT14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x399a6): Section mismatch: reference to .init.text.5:idle_regs (between 'fork_idle' and 'get_task_mm')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/ia64/kernel/smpboot.c   |    2 +-
 arch/x86/kernel/cpu/common.c |    2 +-
 kernel/fork.c                |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

f89f74bbd2770a692e7efd8b4a50a063418759b7 
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 5f6f47d..f091761 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -476,7 +476,7 @@ start_secondary (void *unused)
 	return 0;
 }
 
-struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
+struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
 	return NULL;
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2fcf20..590d4c3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -631,7 +631,7 @@ void __init early_cpu_init(void)
 }
 
 /* Make sure %fs is initialized properly in idle threads */
-struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
+struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	regs->xfs = __KERNEL_PERCPU;
diff --git a/kernel/fork.c b/kernel/fork.c
index 8dd8ff2..2c12ce5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1359,7 +1359,7 @@ fork_out:
 	return ERR_PTR(retval);
 }
 
-noinline struct pt_regs * __devinit __attribute__((weak)) idle_regs(struct pt_regs *regs)
+noinline struct pt_regs * __cpuinit __attribute__((weak)) idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	return regs;

