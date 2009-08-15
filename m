Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbZHORIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbZHORIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZHORIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:08:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:33752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZHORIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:08:12 -0400
Date: Sat, 15 Aug 2009 17:07:17 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, hugh.dickins@tiscali.co.uk, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hugh.dickins@tiscali.co.uk, mingo@elte.hu
In-Reply-To: <12503552312611-git-send-email->
References: <12503552312611-git-send-email->
Subject: [tip:core/rcu] cpu hotplug: Introduce cpu_notifier() to handle !HOTPLUG_CPU case
Message-ID: <tip-799e64f05f4bfaad2bb3165cab95c8c992a1c296@git.kernel.org>
Git-Commit-ID: 799e64f05f4bfaad2bb3165cab95c8c992a1c296
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 17:07:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  799e64f05f4bfaad2bb3165cab95c8c992a1c296
Gitweb:     http://git.kernel.org/tip/799e64f05f4bfaad2bb3165cab95c8c992a1c296
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 15 Aug 2009 09:53:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 19:02:07 +0200

cpu hotplug: Introduce cpu_notifier() to handle !HOTPLUG_CPU case

This patch introduces a new cpu_notifier() API that is similar
to hotcpu_notifier(), but which also notifies of CPUs coming
online during boot in the !HOTPLUG_CPU case.

Reported-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Tested-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: josht@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: benh@kernel.crashing.org
LKML-Reference: <12503552312611-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/cpu.h |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..4753619 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -48,6 +48,15 @@ struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
+#if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
+#define cpu_notifier(fn, pri) {					\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
+		{ .notifier_call = fn, .priority = pri };	\
+	register_cpu_notifier(&fn##_nb);			\
+}
+#else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
+#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
@@ -74,6 +83,8 @@ extern void cpu_maps_update_done(void);
 
 #else	/* CONFIG_SMP */
 
+#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
@@ -99,11 +110,7 @@ extern struct sysdev_class cpu_sysdev_class;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
-#define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb __cpuinitdata =	\
-		{ .notifier_call = fn, .priority = pri };	\
-	register_cpu_notifier(&fn##_nb);			\
-}
+#define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
