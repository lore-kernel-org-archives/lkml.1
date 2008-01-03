Return-Path: <linux-kernel-owner+w=401wt.eu-S1760553AbYACAwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbYACAwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbYACAuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:58343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbYACAuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:04 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [8/20] x86: Make TIF_MCE_NOTIFY optional
Message-Id: <20080103005003.915B414D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So that we don't have to implement it on 32bit.

I would actually like to remove it on 64bit too.


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/Kconfig                    |    5 +++++
 arch/x86/kernel/cpu/mcheck/mce_64.c |   16 ++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -148,6 +148,13 @@ static void mce_panic(char *msg, struct 
 	panic(msg);
 }
 
+static void mce_notify_userspace(void)
+{
+#ifdef CONFIG_MCE_NOTIFY
+	set_thread_flag(TIF_MCE_NOTIFY);
+#endif
+}
+
 static int mce_available(struct cpuinfo_x86 *c)
 {
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
@@ -305,8 +312,7 @@ void do_machine_check(struct pt_regs * r
 		}
 	}
 
-	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
+	mce_notify_userspace();
 
  out:
 	/* the last thing we do is clear state */
@@ -390,7 +396,9 @@ static void mcheck_timer(struct work_str
  */
 int mce_notify_user(void)
 {
+#ifdef CONFIG_MCE_NOTIFY
 	clear_thread_flag(TIF_MCE_NOTIFY);
+#endif
 	if (test_and_clear_bit(0, &notify_user)) {
 		static unsigned long last_print;
 		unsigned long now = jiffies;
@@ -410,6 +418,7 @@ int mce_notify_user(void)
 	return 0;
 }
 
+#ifdef CONFIG_MCE_NOTIFY
 /* see if the idle task needs to notify userspace */
 static int
 mce_idle_callback(struct notifier_block *nfb, unsigned long action, void *junk)
@@ -424,6 +433,7 @@ mce_idle_callback(struct notifier_block 
 static struct notifier_block mce_idle_notifier = {
 	.notifier_call = mce_idle_callback,
 };
+#endif
 
 static __init int periodic_mcheck_init(void)
 {
@@ -431,7 +441,9 @@ static __init int periodic_mcheck_init(v
 	if (next_interval)
 		schedule_delayed_work(&mcheck_work,
 				      round_jiffies_relative(next_interval));
+#ifdef CONFIG_MCE_NOTIFY
 	idle_notifier_register(&mce_idle_notifier);
+#endif
 	return 0;
 }
 __initcall(periodic_mcheck_init);
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -551,6 +551,11 @@ config X86_MCE
 	  to disable it.  MCE support simply ignores non-MCE processors like
 	  the 386 and 486, so nearly everyone can say Y here.
 
+config MCE_NOTIFY
+	bool
+	default y
+	depends on X86_64
+
 config X86_MCE_INTEL
 	def_bool y
 	prompt "Intel MCE features"
