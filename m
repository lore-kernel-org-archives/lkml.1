Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbYCNUoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbYCNUoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758655AbYCNUoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:44:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615AbYCNUoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:44:06 -0400
Message-ID: <47DAE2E2.5000804@redhat.com>
Date: Fri, 14 Mar 2008 16:41:06 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Shaohua Li <shaohua.li@intel.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [PATCH -mm 3/5] kprobes: add (un)register_kretprobes for batch registration
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce unregister_/register_kretprobes() for kretprobe
batch registration.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 include/linux/kprobes.h |    9 ++++
 kernel/kprobes.c        |  108 +++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 97 insertions(+), 20 deletions(-)

Index: 2.6.25-rc5-mm1/kernel/kprobes.c
===================================================================
--- 2.6.25-rc5-mm1.orig/kernel/kprobes.c
+++ 2.6.25-rc5-mm1/kernel/kprobes.c
@@ -429,6 +429,21 @@ static inline void free_rp_inst(struct k
 	}
 }

+static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
+{
+	unsigned long flags;
+	struct kretprobe_instance *ri;
+	struct hlist_node *pos, *next;
+	/* No race here */
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
+		ri->rp = NULL;
+		hlist_del(&ri->uflist);
+	}
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	free_rp_inst(rp);
+}
+
 /*
  * Keep all fields in the kprobe consistent
  */
@@ -798,7 +813,8 @@ static int __kprobes pre_handler_kretpro
 	return 0;
 }

-int __kprobes register_kretprobe(struct kretprobe *rp)
+static int __kprobes __register_kretprobe(struct kretprobe *rp,
+					  unsigned long called_from)
 {
 	int ret = 0;
 	struct kretprobe_instance *inst;
@@ -844,43 +860,93 @@ int __kprobes register_kretprobe(struct

 	rp->nmissed = 0;
 	/* Establish function entry probe point */
-	if ((ret = __register_kprobe(&rp->kp,
-		(unsigned long)__builtin_return_address(0))) != 0)
+	ret = __register_kprobe(&rp->kp, called_from);
+	if (ret != 0)
 		free_rp_inst(rp);
 	return ret;
 }

+static int __register_kretprobes(struct kretprobe **rps, int num,
+	unsigned long called_from)
+{
+	int ret = 0, i;
+
+	if (num <= 0)
+		return -EINVAL;
+	for (i = 0; i < num; i++) {
+		ret = __register_kretprobe(rps[i], called_from);
+		if (ret < 0 && i > 0) {
+			unregister_kretprobes(rps, i);
+			break;
+		}
+	}
+	return ret;
+}
+
+int __kprobes register_kretprobe(struct kretprobe *rp)
+{
+	return __register_kretprobes(&rp, 1,
+			(unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kretprobe(struct kretprobe *rp)
+{
+	unregister_kretprobes(&rp, 1);
+}
+
+int __kprobes register_kretprobes(struct kretprobe **rps, int num)
+{
+	return __register_kretprobes(rps, num,
+			(unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
+{
+	int i;
+
+	if (num <= 0)
+		return;
+	mutex_lock(&kprobe_mutex);
+	for (i = 0; i < num; i++)
+		if (__unregister_kprobe_top(&rps[i]->kp) < 0)
+			rps[i]->kp.addr = NULL;
+	mutex_unlock(&kprobe_mutex);
+
+	synchronize_sched();
+	for (i = 0; i < num; i++) {
+		if (rps[i]->kp.addr) {
+			__unregister_kprobe_bottom(&rps[i]->kp);
+			cleanup_rp_inst(rps[i]);
+		}
+	}
+}
+
 #else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
 }

-static int __kprobes pre_handler_kretprobe(struct kprobe *p,
-					   struct pt_regs *regs)
+int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
-	return 0;
+	return -ENOSYS;
 }
-#endif /* CONFIG_KRETPROBES */
-
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
-	unsigned long flags;
-	struct kretprobe_instance *ri;
-	struct hlist_node *pos, *next;
+}

-	unregister_kprobe(&rp->kp);
+void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
+{
+}

-	/* No race here */
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
-		ri->rp = NULL;
-		hlist_del(&ri->uflist);
-	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	free_rp_inst(rp);
+static int __kprobes pre_handler_kretprobe(struct kprobe *p,
+					   struct pt_regs *regs)
+{
+	return 0;
 }

+#endif /* CONFIG_KRETPROBES */
+
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
@@ -1177,4 +1243,6 @@ EXPORT_SYMBOL_GPL(jprobe_return);
 #ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(register_kretprobe);
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
+EXPORT_SYMBOL_GPL(register_kretprobes);
+EXPORT_SYMBOL_GPL(unregister_kretprobes);
 #endif
Index: 2.6.25-rc5-mm1/include/linux/kprobes.h
===================================================================
--- 2.6.25-rc5-mm1.orig/include/linux/kprobes.h
+++ 2.6.25-rc5-mm1/include/linux/kprobes.h
@@ -245,6 +245,8 @@ unsigned long arch_deref_entry_point(voi

 int register_kretprobe(struct kretprobe *rp);
 void unregister_kretprobe(struct kretprobe *rp);
+int register_kretprobes(struct kretprobe **rps, int num);
+void unregister_kretprobes(struct kretprobe **rps, int num);

 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
@@ -287,9 +289,16 @@ static inline int register_kretprobe(str
 {
 	return -ENOSYS;
 }
+static inline int register_kretprobes(struct kretprobe **rps, int num)
+{
+	return -ENOSYS;
+}
 static inline void unregister_kretprobe(struct kretprobe *rp)
 {
 }
+static inline void unregister_kretprobes(struct kretprobe **rps, int num)
+{
+}
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com



