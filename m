Return-Path: <linux-kernel-owner+w=401wt.eu-S1945907AbXCWOtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945907AbXCWOtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945901AbXCWOtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:49:47 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:55733 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945908AbXCWOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:49:43 -0400
Message-ID: <4603E810.10800@hitachi.com>
Date: Fri, 23 Mar 2007 23:45:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][Patch 2/4] kretprobe fast unregisteration
References: <4603E7A4.50300@hitachi.com>
In-Reply-To: <4603E7A4.50300@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces unregister_kretprobe_fast() for kretprobe.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---

 include/linux/kprobes.h |   12 +++++++++++-
 kernel/kprobes.c        |   44 ++++++++++++++++++++++++++++----------------
 2 files changed, 39 insertions(+), 17 deletions(-)

Index: linux-2.6.21-rc4-mm1/include/linux/kprobes.h
===================================================================
--- linux-2.6.21-rc4-mm1.orig/include/linux/kprobes.h
+++ linux-2.6.21-rc4-mm1/include/linux/kprobes.h
@@ -202,7 +202,14 @@ void unregister_jprobe(struct jprobe *p)
 void jprobe_return(void);

 int register_kretprobe(struct kretprobe *rp);
-void unregister_kretprobe(struct kretprobe *rp);
+static inline void unregister_kretprobe(struct kretprobe *rp)
+{
+	unregister_kprobe(&rp->kp);
+}
+static inline void unregister_kretprobe_fast(struct kretprobe *rp)
+{
+	unregister_kprobe_fast(&rp->kp);
+}

 struct kretprobe_instance *get_free_rp_inst(struct kretprobe *rp);
 void add_rp_inst(struct kretprobe_instance *ri);
@@ -245,6 +252,9 @@ static inline int register_kretprobe(str
 static inline void unregister_kretprobe(struct kretprobe *rp)
 {
 }
+static inline void unregister_kretprobe_fast(struct kretprobe *rp)
+{
+}
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
Index: linux-2.6.21-rc4-mm1/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/kprobes.c
+++ linux-2.6.21-rc4-mm1/kernel/kprobes.c
@@ -74,6 +74,8 @@ static struct notifier_block kprobe_page
 	.priority = 0x7fffffff /* we need to notified first */
 };

+static int __kprobes is_kretprobe(struct kprobe *p);
+
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -462,6 +464,20 @@ static inline void free_rp_inst(struct k
 	}
 }

+static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
+{
+	unsigned long flags;
+	struct kretprobe_instance *ri;
+	/* No race here */
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	while ((ri = get_used_rp_inst(rp)) != NULL) {
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
@@ -697,6 +713,9 @@ static void __kprobes __unregister_kprob
 	if (atomic_add_return(-1, &kprobe_count) == \
 				ARCH_INACTIVE_KPROBE_COUNT)
 		unregister_page_fault_notifier(&kprobe_page_fault_nb);
+	if (is_kretprobe(p)) {
+		cleanup_rp_inst(container_of(p, struct kretprobe, kp));
+	}
 	return;
 }

@@ -841,6 +860,11 @@ int __kprobes register_kretprobe(struct
 	return ret;
 }

+static int __kprobes is_kretprobe(struct kprobe *p)
+{
+	return p->pre_handler == pre_handler_kretprobe;
+}
+
 #else /* ARCH_SUPPORTS_KRETPROBES */

 int __kprobes register_kretprobe(struct kretprobe *rp)
@@ -854,24 +878,13 @@ static int __kprobes pre_handler_kretpro
 	return 0;
 }

-#endif /* ARCH_SUPPORTS_KRETPROBES */
-
-void __kprobes unregister_kretprobe(struct kretprobe *rp)
+static int __kprobes is_kretprobe(struct kprobe *p)
 {
-	unsigned long flags;
-	struct kretprobe_instance *ri;
-
-	unregister_kprobe(&rp->kp);
-	/* No race here */
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	while ((ri = get_used_rp_inst(rp)) != NULL) {
-		ri->rp = NULL;
-		hlist_del(&ri->uflist);
-	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	free_rp_inst(rp);
+	return 0;
 }

+#endif /* ARCH_SUPPORTS_KRETPROBES */
+
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
@@ -1003,4 +1016,3 @@ EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(jprobe_return);
 EXPORT_SYMBOL_GPL(register_kretprobe);
-EXPORT_SYMBOL_GPL(unregister_kretprobe);
