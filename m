Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYCNUmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYCNUmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYCNUmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:42:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbYCNUmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:42:09 -0400
Message-ID: <47DAE2D6.9010404@redhat.com>
Date: Fri, 14 Mar 2008 16:40:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Shaohua Li <shaohua.li@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       David Miller <davem@davemloft.net>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [PATCH -mm 2/5] kprobes: add (un)register_kprobes for batch registration
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce unregister_/register_kprobes() for kprobe batch
registration. This can reduce waiting time for
synchronized_sched() when a lot of probes have to be
unregistered at once.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
I rewrote a patchset which had been discussed on LKML,
and simplified its interfaces.
 http://lkml.org/lkml/2007/3/23/181

 include/linux/kprobes.h |    9 +++
 kernel/kprobes.c        |  124 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 96 insertions(+), 37 deletions(-)

Index: 2.6.25-rc5-mm1/include/linux/kprobes.h
===================================================================
--- 2.6.25-rc5-mm1.orig/include/linux/kprobes.h
+++ 2.6.25-rc5-mm1/include/linux/kprobes.h
@@ -234,6 +234,8 @@ static inline struct kprobe_ctlblk *get_

 int register_kprobe(struct kprobe *p);
 void unregister_kprobe(struct kprobe *p);
+int register_kprobes(struct kprobe **kps, int num);
+void unregister_kprobes(struct kprobe **kps, int num);
 int setjmp_pre_handler(struct kprobe *, struct pt_regs *);
 int longjmp_break_handler(struct kprobe *, struct pt_regs *);
 int register_jprobe(struct jprobe *p);
@@ -261,9 +263,16 @@ static inline int register_kprobe(struct
 {
 	return -ENOSYS;
 }
+static inline int register_kprobes(struct kprobe **kps, int num)
+{
+	return -ENOSYS;
+}
 static inline void unregister_kprobe(struct kprobe *p)
 {
 }
+static inline void unregister_kprobes(struct kprobe **kps, int num)
+{
+}
 static inline int register_jprobe(struct jprobe *p)
 {
 	return -ENOSYS;
Index: 2.6.25-rc5-mm1/kernel/kprobes.c
===================================================================
--- 2.6.25-rc5-mm1.orig/kernel/kprobes.c
+++ 2.6.25-rc5-mm1/kernel/kprobes.c
@@ -580,6 +580,7 @@ static int __kprobes __register_kprobe(s
 	}

 	p->nmissed = 0;
+	INIT_LIST_HEAD(&p->list);
 	mutex_lock(&kprobe_mutex);
 	old_p = get_kprobe(p->addr);
 	if (old_p) {
@@ -606,35 +607,28 @@ out:
 	return ret;
 }

-int __kprobes register_kprobe(struct kprobe *p)
-{
-	return __register_kprobe(p, (unsigned long)__builtin_return_address(0));
-}
-
-void __kprobes unregister_kprobe(struct kprobe *p)
+/*
+ * Unregister a kprobe without a scheduler synchronization.
+ */
+static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 {
-	struct module *mod;
 	struct kprobe *old_p, *list_p;
-	int cleanup_p;

-	mutex_lock(&kprobe_mutex);
 	old_p = get_kprobe(p->addr);
-	if (unlikely(!old_p)) {
-		mutex_unlock(&kprobe_mutex);
-		return;
-	}
+	if (unlikely(!old_p))
+		return -EINVAL;
+
 	if (p != old_p) {
 		list_for_each_entry_rcu(list_p, &old_p->list, list)
 			if (list_p == p)
 			/* kprobe p is a valid probe */
 				goto valid_p;
-		mutex_unlock(&kprobe_mutex);
-		return;
+		return -EINVAL;
 	}
 valid_p:
 	if (old_p == p ||
 	    (old_p->pre_handler == aggr_pre_handler &&
-	     p->list.next == &old_p->list && p->list.prev == &old_p->list)) {
+	     list_singleton(&old_p->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
 		 * enabled - otherwise, the breakpoint would already have
@@ -643,43 +637,97 @@ valid_p:
 		if (kprobe_enabled)
 			arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
-		cleanup_p = 1;
 	} else {
+		if (p->break_handler)
+			old_p->break_handler = NULL;
+		if (p->post_handler) {
+			list_for_each_entry_rcu(list_p, &old_p->list, list) {
+				if ((list_p != p) && (list_p->post_handler))
+					goto noclean;
+			}
+			old_p->post_handler = NULL;
+		}
+noclean:
 		list_del_rcu(&p->list);
-		cleanup_p = 0;
 	}
+	return 0;
+}

-	mutex_unlock(&kprobe_mutex);
+static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
+{
+	struct module *mod;
+	struct kprobe *old_p;

-	synchronize_sched();
 	if (p->mod_refcounted) {
 		mod = module_text_address((unsigned long)p->addr);
 		if (mod)
 			module_put(mod);
 	}

-	if (cleanup_p) {
-		if (p != old_p) {
-			list_del_rcu(&p->list);
+	if (list_empty(&p->list) || list_singleton(&p->list)) {
+		if (!list_empty(&p->list)) {
+			/* "p" is the last child of an aggr_kprobe */
+			old_p = list_entry(p->list.next, struct kprobe, list);
+			list_del(&p->list);
 			kfree(old_p);
 		}
 		arch_remove_kprobe(p);
-	} else {
-		mutex_lock(&kprobe_mutex);
-		if (p->break_handler)
-			old_p->break_handler = NULL;
-		if (p->post_handler){
-			list_for_each_entry_rcu(list_p, &old_p->list, list){
-				if (list_p->post_handler){
-					cleanup_p = 2;
-					break;
-				}
-			}
-			if (cleanup_p == 0)
-				old_p->post_handler = NULL;
+	}
+}
+
+static int __register_kprobes(struct kprobe **kps, int num,
+	unsigned long called_from)
+{
+	int i, ret = 0;
+
+	if (num <= 0)
+		return -EINVAL;
+	for (i = 0; i < num; i++) {
+		ret = __register_kprobe(kps[i], called_from);
+		if (ret < 0 && i > 0) {
+			unregister_kprobes(kps, i);
+			break;
 		}
-		mutex_unlock(&kprobe_mutex);
 	}
+	return ret;
+}
+
+/*
+ * Registration and unregistration functions for kprobe.
+ */
+int __kprobes register_kprobe(struct kprobe *p)
+{
+	return __register_kprobes(&p, 1,
+				  (unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kprobe(struct kprobe *p)
+{
+	unregister_kprobes(&p, 1);
+}
+
+int __kprobes register_kprobes(struct kprobe **kps, int num)
+{
+	return __register_kprobes(kps, num,
+				  (unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kprobes(struct kprobe **kps, int num)
+{
+	int i;
+
+	if (num <= 0)
+		return;
+	mutex_lock(&kprobe_mutex);
+	for (i = 0; i < num; i++)
+		if (__unregister_kprobe_top(kps[i]) < 0)
+			kps[i]->addr = NULL;
+	mutex_unlock(&kprobe_mutex);
+
+	synchronize_sched();
+	for (i = 0; i < num; i++)
+		if (kps[i]->addr)
+			__unregister_kprobe_bottom(kps[i]);
 }

 static struct notifier_block kprobe_exceptions_nb = {
@@ -1118,6 +1166,8 @@ module_init(init_kprobes);

 EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
+EXPORT_SYMBOL_GPL(register_kprobes);
+EXPORT_SYMBOL_GPL(unregister_kprobes);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 #ifdef CONFIG_KPROBES
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com





