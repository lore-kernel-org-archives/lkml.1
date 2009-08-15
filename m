Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbZHOQxx (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 15 Aug 2009 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZHOQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:53:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50750 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbZHOQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:53:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
   mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip/core/rcu 2/6] Introduce cpu_notifier() to handle !HOTPLUG_CPU case
Date: Sat, 15 Aug 2009 09:53:47 -0700
Message-Id: <12503552312611-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090815165153.GA8886@linux.vnet.ibm.com>
References: <20090815165153.GA8886@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This patch introduces a new cpu_notifier() API that is similar to
hotcpu_notifier(), but which also notifies of CPUs coming online during
boot in the !HOTPLUG_CPU case.

Reported-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Tested-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
-- 
1.5.2.5

