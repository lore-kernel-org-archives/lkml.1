Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZBSRK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZBSRK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZBSRKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:10:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbZBSRKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:10:18 -0500
Date: Thu, 19 Feb 2009 18:10:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20090219171005.GA27922@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (3):
      x86, mce: reinitialize per cpu features on resume
      x86, mce: use force_sig_info to kill process in machine check
      x86, mce: fix ifdef for 64bit thermal apic vector clear on shutdown

Paul E. McKenney (1):
      x86, rcu: fix strange load average and ksoftirqd behavior


 arch/x86/kernel/apic.c              |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c |    5 +++--
 arch/x86/kernel/process_32.c        |    3 ---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 115449f..570f36e 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -862,7 +862,7 @@ void clear_local_APIC(void)
 	}
 
 	/* lets not touch this if we didn't frob it */
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(X86_MCE_INTEL)
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5) {
 		v = apic_read(APIC_LVTTHMR);
 		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 1c83803..25cf624 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -295,11 +295,11 @@ void do_machine_check(struct pt_regs * regs, long error_code)
 		 * If we know that the error was in user space, send a
 		 * SIGBUS.  Otherwise, panic if tolerance is low.
 		 *
-		 * do_exit() takes an awful lot of locks and has a slight
+		 * force_sig() takes an awful lot of locks and has a slight
 		 * risk of deadlocking.
 		 */
 		if (user_space) {
-			do_exit(SIGBUS);
+			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
 			mce_panic("Uncorrected machine check",
 				&panicm, mcestart);
@@ -734,6 +734,7 @@ __setup("mce=", mcheck_enable);
 static int mce_resume(struct sys_device *dev)
 {
 	mce_init(NULL);
+	mce_cpu_features(&current_cpu_data);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a546f55..bd4da2a 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -104,9 +104,6 @@ void cpu_idle(void)
 			check_pgt_cache();
 			rmb();
 
-			if (rcu_pending(cpu))
-				rcu_check_callbacks(cpu, 0);
-
 			if (cpu_is_offline(cpu))
 				play_dead();
 
