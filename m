Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbXCaN7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbXCaN7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 09:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXCaN7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 09:59:47 -0400
Received: from verein.lst.de ([213.95.11.210]:52596 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbXCaN73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 09:59:29 -0400
Date: Sat, 31 Mar 2007 15:59:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kprobes: kretprobes simplifcations
Message-ID: <20070331135929.GC17406@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - consolidate duplicate code in all arch_prepare_kretprobe instances
   into common code
 - replace various odd helpers that use hlist_for_each_entry to get
   the first elemenet of a list with either a hlist_for_each_entry_save
   or an opencoded access to the first element in the caller
 - inline add_rp_inst into it's only remaining caller
 - use kretprobe_inst_table_head instead of opencoding it


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/kprobes.c	2007-03-31 14:31:24.000000000 +0200
+++ linux-2.6/arch/i386/kernel/kprobes.c	2007-03-31 14:47:40.000000000 +0200
@@ -226,24 +226,15 @@ static void __kprobes prepare_singlestep
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	unsigned long *sara = (unsigned long *)&regs->esp;
 
-	struct kretprobe_instance *ri;
+	ri->ret_addr = (kprobe_opcode_t *) *sara;
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *) *sara;
-
-		/* Replace the return addr with trampoline addr */
-		*sara = (unsigned long) &kretprobe_trampoline;
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	/* Replace the return addr with trampoline addr */
+	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
 /*
Index: linux-2.6/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/kprobes.c	2007-03-31 14:31:24.000000000 +0200
+++ linux-2.6/arch/ia64/kernel/kprobes.c	2007-03-31 14:35:39.000000000 +0200
@@ -464,23 +464,13 @@ int __kprobes trampoline_probe_handler(s
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-	struct kretprobe_instance *ri;
+	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *)regs->b0;
-
-		/* Replace the return addr with trampoline addr */
-		regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
-
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	/* Replace the return addr with trampoline addr */
+	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
 }
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
Index: linux-2.6/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/kprobes.c	2007-03-31 14:31:24.000000000 +0200
+++ linux-2.6/arch/powerpc/kernel/kprobes.c	2007-03-31 14:35:21.000000000 +0200
@@ -124,22 +124,13 @@ static void __kprobes set_current_kprobe
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-	struct kretprobe_instance *ri;
+	ri->ret_addr = (kprobe_opcode_t *)regs->link;
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *)regs->link;
-
-		/* Replace the return addr with trampoline addr */
-		regs->link = (unsigned long)kretprobe_trampoline;
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	/* Replace the return addr with trampoline addr */
+	regs->link = (unsigned long)kretprobe_trampoline;
 }
 
 static int __kprobes kprobe_handler(struct pt_regs *regs)
Index: linux-2.6/arch/s390/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/kprobes.c	2007-03-31 14:31:24.000000000 +0200
+++ linux-2.6/arch/s390/kernel/kprobes.c	2007-03-31 14:35:09.000000000 +0200
@@ -271,23 +271,13 @@ static void __kprobes set_current_kprobe
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 					struct pt_regs *regs)
 {
-	struct kretprobe_instance *ri;
+	ri->ret_addr = (kprobe_opcode_t *) regs->gprs[14];
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *) regs->gprs[14];
-
-		/* Replace the return addr with trampoline addr */
-		regs->gprs[14] = (unsigned long)&kretprobe_trampoline;
-
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	/* Replace the return addr with trampoline addr */
+	regs->gprs[14] = (unsigned long)&kretprobe_trampoline;
 }
 
 static int __kprobes kprobe_handler(struct pt_regs *regs)
Index: linux-2.6/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/kprobes.c	2007-03-31 14:31:24.000000000 +0200
+++ linux-2.6/arch/x86_64/kernel/kprobes.c	2007-03-31 14:34:46.000000000 +0200
@@ -266,23 +266,14 @@ static void __kprobes prepare_singlestep
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	unsigned long *sara = (unsigned long *)regs->rsp;
-	struct kretprobe_instance *ri;
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *) *sara;
-
-		/* Replace the return addr with trampoline addr */
-		*sara = (unsigned long) &kretprobe_trampoline;
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	ri->ret_addr = (kprobe_opcode_t *) *sara;
+	/* Replace the return addr with trampoline addr */
+	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
 int __kprobes kprobe_handler(struct pt_regs *regs)
Index: linux-2.6/include/linux/kprobes.h
===================================================================
--- linux-2.6.orig/include/linux/kprobes.h	2007-03-31 14:36:00.000000000 +0200
+++ linux-2.6/include/linux/kprobes.h	2007-03-31 14:41:13.000000000 +0200
@@ -123,7 +123,8 @@ DECLARE_PER_CPU(struct kprobe *, current
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 #ifdef ARCH_SUPPORTS_KRETPROBES
-extern void arch_prepare_kretprobe(struct kretprobe *rp, struct pt_regs *regs);
+extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				   struct pt_regs *regs);
 #else /* ARCH_SUPPORTS_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
@@ -199,8 +200,6 @@ void jprobe_return(void);
 int register_kretprobe(struct kretprobe *rp);
 void unregister_kretprobe(struct kretprobe *rp);
 
-struct kretprobe_instance *get_free_rp_inst(struct kretprobe *rp);
-void add_rp_inst(struct kretprobe_instance *ri);
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 #else /* CONFIG_KPROBES */
Index: linux-2.6/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/kernel/kprobes.c	2007-03-31 14:26:22.000000000 +0200
+++ linux-2.6/kernel/kprobes.c	2007-03-31 14:46:54.000000000 +0200
@@ -357,46 +357,6 @@ void __kprobes kprobes_inc_nmissed_count
 }
 
 /* Called with kretprobe_lock held */
-struct kretprobe_instance __kprobes *get_free_rp_inst(struct kretprobe *rp)
-{
-	struct hlist_node *node;
-	struct kretprobe_instance *ri;
-	hlist_for_each_entry(ri, node, &rp->free_instances, uflist)
-		return ri;
-	return NULL;
-}
-
-/* Called with kretprobe_lock held */
-static struct kretprobe_instance __kprobes *get_used_rp_inst(struct kretprobe
-							      *rp)
-{
-	struct hlist_node *node;
-	struct kretprobe_instance *ri;
-	hlist_for_each_entry(ri, node, &rp->used_instances, uflist)
-		return ri;
-	return NULL;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes add_rp_inst(struct kretprobe_instance *ri)
-{
-	/*
-	 * Remove rp inst off the free list -
-	 * Add it back when probed function returns
-	 */
-	hlist_del(&ri->uflist);
-
-	/* Add rp inst onto table */
-	INIT_HLIST_NODE(&ri->hlist);
-	hlist_add_head(&ri->hlist,
-			&kretprobe_inst_table[hash_ptr(ri->task, KPROBE_HASH_BITS)]);
-
-	/* Also add this rp inst to the used list. */
-	INIT_HLIST_NODE(&ri->uflist);
-	hlist_add_head(&ri->uflist, &ri->rp->used_instances);
-}
-
-/* Called with kretprobe_lock held */
 void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 				struct hlist_head *head)
 {
@@ -449,7 +409,9 @@ void __kprobes kprobe_flush_task(struct 
 static inline void free_rp_inst(struct kretprobe *rp)
 {
 	struct kretprobe_instance *ri;
-	while ((ri = get_free_rp_inst(rp)) != NULL) {
+	struct hlist_node *pos, *next;
+
+	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, uflist) {
 		hlist_del(&ri->uflist);
 		kfree(ri);
 	}
@@ -731,7 +693,21 @@ static int __kprobes pre_handler_kretpro
 
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
 	spin_lock_irqsave(&kretprobe_lock, flags);
-	arch_prepare_kretprobe(rp, regs);
+	if (!hlist_empty(&rp->free_instances)) {
+		struct kretprobe_instance *ri;
+
+		ri = hlist_entry(rp->free_instances.first,
+				 struct kretprobe_instance, uflist);
+		ri->rp = rp;
+		ri->task = current;
+		arch_prepare_kretprobe(ri, regs);
+
+		/* XXX(hch): why is there no hlist_move_head? */
+		hlist_del(&ri->uflist);
+		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
+		hlist_add_head(&ri->hlist, kretprobe_inst_table_head(ri->task));
+	} else
+		rp->nmissed++;
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
 	return 0;
 }
@@ -794,11 +770,13 @@ void __kprobes unregister_kretprobe(stru
 {
 	unsigned long flags;
 	struct kretprobe_instance *ri;
+	struct hlist_node *pos, *next;
 
 	unregister_kprobe(&rp->kp);
+
 	/* No race here */
 	spin_lock_irqsave(&kretprobe_lock, flags);
-	while ((ri = get_used_rp_inst(rp)) != NULL) {
+	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
 		ri->rp = NULL;
 		hlist_del(&ri->uflist);
 	}
