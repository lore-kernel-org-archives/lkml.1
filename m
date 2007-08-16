Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbXHPP7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbXHPP7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbXHPP6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:58:07 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56867 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764864AbXHPP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:58:01 -0400
Message-ID: <46C4740F.2050701@bull.net>
Date: Thu, 16 Aug 2007 17:58:07 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC 3/4]Introduce "account modifiers" mechanism
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net> <46C4725A.4070607@bull.net>
In-Reply-To: <46C4725A.4070607@bull.net>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:03:10,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:03:11,
	Serialize complete at 16/08/2007 18:03:11
Content-Type: multipart/mixed;
 boundary="------------020103020409060707070202"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020103020409060707070202
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

[PATCH 3/3] introduce "account modifiers" mechanism in the kernel allowing a
module to modify the collected accounting for a given task. This implementation
is based on the "preempt_notifier". "account_system_time()" and
"account_user_time()" can call functions registered by a module to modify the
cputime value.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------020103020409060707070202
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="accounting_modifiers"
Content-Disposition: inline;
 filename="accounting_modifiers"

Index: kvm/include/linux/sched.h
===================================================================
--- kvm.orig/include/linux/sched.h	2007-08-16 15:23:27.000000000 +0200
+++ kvm/include/linux/sched.h	2007-08-16 15:23:41.000000000 +0200
@@ -955,6 +955,10 @@
 	/* list of struct preempt_notifier: */
 	struct hlist_head preempt_notifiers;
 #endif
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	/* list of struct account_modifiers: */
+	struct hlist_head account_modifiers;
+#endif
 
 	unsigned short ioprio;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
@@ -1873,6 +1877,31 @@
 }
 #endif
 
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+struct account_modifier;
+struct account_ops {
+	cputime_t (*user_time)(struct account_modifier *,
+				struct task_struct *, cputime_t );
+	cputime_t (*system_time)(struct account_modifier *,
+				struct task_struct *, int, cputime_t);
+};
+
+struct account_modifier {
+	struct hlist_node link;
+	struct account_ops *ops;
+};
+
+void account_modifier_register(struct account_modifier *modifier);
+void account_modifier_unregister(struct account_modifier *modifier);
+
+static inline void account_modifier_init(struct account_modifier *modifier,
+					struct account_ops *ops)
+{
+	INIT_HLIST_NODE(&modifier->link);
+	modifier->ops = ops;
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c	2007-08-16 15:15:33.000000000 +0200
+++ kvm/kernel/sched.c	2007-08-16 15:23:28.000000000 +0200
@@ -1593,6 +1593,9 @@
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	INIT_HLIST_HEAD(&p->account_modifiers);
+#endif
 
 	/*
 	 * We mark the process as running here, but have not actually
@@ -1731,6 +1734,62 @@
 }
 
 #endif
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+
+void account_modifier_register(struct account_modifier *modifier)
+{
+	hlist_add_head(&modifier->link, &current->account_modifiers);
+}
+EXPORT_SYMBOL_GPL(account_modifier_register);
+
+void account_modifier_unregister(struct account_modifier *modifier)
+{
+	hlist_del(&modifier->link);
+}
+EXPORT_SYMBOL_GPL(account_modifier_unregister);
+
+static cputime_t fire_user_time_account_modifiers(struct task_struct *curr,
+						  cputime_t cputime)
+{
+	struct account_modifier *modifier;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(modifier, node, &curr->account_modifiers, link)
+		if (modifier->ops->user_time)
+			cputime = modifier->ops->user_time(modifier,
+							curr, cputime);
+	return cputime;
+}
+
+static cputime_t fire_system_time_account_modifiers(struct task_struct *curr,
+						      int hardirq_offset,
+						      cputime_t cputime)
+{
+	struct account_modifier *modifier;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(modifier, node, &curr->account_modifiers, link)
+		if (modifier->ops->system_time)
+			cputime = modifier->ops->system_time(modifier,
+						curr, hardirq_offset, cputime);
+	return cputime;
+}
+
+#else
+
+static inline cputime_t fire_user_time_account_modifiers(struct task_struct *curr, cputime_t cputime)
+{
+	return cputime;
+}
+
+static inline cputime_t fire_system_time_account_modifiers(struct task_struct *curr,
+						      int hardirq_offset,
+						      cputime_t cputime)
+{
+	return cputime;
+}
+
+#endif
 
 /**
  * prepare_task_switch - prepare to switch tasks
@@ -3223,6 +3282,8 @@
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
 	cputime64_t tmp;
 
+	cputime = fire_user_time_account_modifiers(p, cputime);
+
 	p->utime = cputime_add(p->utime, cputime);
 
 	/* Add user time to cpustat. */
@@ -3246,6 +3307,8 @@
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
+	cputime = fire_system_time_account_modifiers(p,hardirq_offset, cputime);
+
 	p->stime = cputime_add(p->stime, cputime);
 
 	/* Add system time to cpustat. */
@@ -6522,6 +6585,9 @@
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
 #endif
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	INIT_HLIST_HEAD(&init_task.account_modifiers);
+#endif
 
 #ifdef CONFIG_SMP
 	nr_cpu_ids = highest_cpu + 1;

--------------020103020409060707070202--
