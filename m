Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZAMBzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZAMBzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZAMBz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:55:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38395 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbZAMBz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:55:26 -0500
Message-ID: <496BF498.7040001@redhat.com>
Date: Mon, 12 Jan 2009 20:55:36 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [RFC][PATCH -mm 1/6] kprobes: cleanup aggr_kprobe related code
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change old_p to ap in add_new_kprobe() for readability, copy flags member in
add_aggr_kprobe(), and simplify the code flow of register_aggr_kprobe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/kprobes.c |   60 +++++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

Index: 2.6.28-mm1/kernel/kprobes.c
===================================================================
--- 2.6.28-mm1.orig/kernel/kprobes.c
+++ 2.6.28-mm1/kernel/kprobes.c
@@ -517,20 +517,20 @@ static inline void copy_kprobe(struct kp
 }

 /*
-* Add the new probe to old_p->list. Fail if this is the
+* Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
 */
-static int __kprobes add_new_kprobe(struct kprobe *old_p, struct kprobe *p)
+static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	if (p->break_handler) {
-		if (old_p->break_handler)
+		if (ap->break_handler)
 			return -EEXIST;
-		list_add_tail_rcu(&p->list, &old_p->list);
-		old_p->break_handler = aggr_break_handler;
+		list_add_tail_rcu(&p->list, &ap->list);
+		ap->break_handler = aggr_break_handler;
 	} else
-		list_add_rcu(&p->list, &old_p->list);
-	if (p->post_handler && !old_p->post_handler)
-		old_p->post_handler = aggr_post_handler;
+		list_add_rcu(&p->list, &ap->list);
+	if (p->post_handler && !ap->post_handler)
+		ap->post_handler = aggr_post_handler;
 	return 0;
 }

@@ -543,6 +543,7 @@ static inline void add_aggr_kprobe(struc
 	copy_kprobe(p, ap);
 	flush_insn_slot(ap);
 	ap->addr = p->addr;
+	ap->flags = p->flags;
 	ap->pre_handler = aggr_pre_handler;
 	ap->fault_handler = aggr_fault_handler;
 	/* We don't care the kprobe which has gone. */
@@ -565,44 +566,43 @@ static int __kprobes register_aggr_kprob
 					  struct kprobe *p)
 {
 	int ret = 0;
-	struct kprobe *ap;
+	struct kprobe *ap = old_p;

-	if (kprobe_gone(old_p)) {
+	if (old_p->pre_handler != aggr_pre_handler) {
+		/* If old_p is not an aggr_probe, create new aggr_kprobe. */
+		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
+		if (!ap)
+			return -ENOMEM;
+		add_aggr_kprobe(ap, old_p);
+	}
+
+	if (kprobe_gone(ap)) {
 		/*
 		 * Attempting to insert new probe at the same location that
 		 * had a probe in the module vaddr area which already
 		 * freed. So, the instruction slot has already been
 		 * released. We need a new slot for the new probe.
 		 */
-		ret = arch_prepare_kprobe(old_p);
+		ret = arch_prepare_kprobe(ap);
 		if (ret)
+			/*
+			 * Even if fail to allocate new slot, don't need to
+			 * free aggr_probe. It will be used next time, or
+			 * freed by unregister_kprobe.
+			 */
 			return ret;
-	}
-	if (old_p->pre_handler == aggr_pre_handler) {
-		copy_kprobe(old_p, p);
-		ret = add_new_kprobe(old_p, p);
-		ap = old_p;
-	} else {
-		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
-		if (!ap) {
-			if (kprobe_gone(old_p))
-				arch_remove_kprobe(old_p);
-			return -ENOMEM;
-		}
-		add_aggr_kprobe(ap, old_p);
-		copy_kprobe(ap, p);
-		ret = add_new_kprobe(ap, p);
-	}
-	if (kprobe_gone(old_p)) {
+		/* Clear gone flag to prevent allocating new slot again. */
+		ap->flags &= ~KPROBE_FLAG_GONE;
 		/*
 		 * If the old_p has gone, its breakpoint has been disarmed.
 		 * We have to arm it again after preparing real kprobes.
 		 */
-		ap->flags &= ~KPROBE_FLAG_GONE;
 		if (kprobe_enabled)
 			arch_arm_kprobe(ap);
 	}
-	return ret;
+
+	copy_kprobe(ap, p);
+	return add_new_kprobe(ap, p);
 }

 static int __kprobes in_kprobes_functions(unsigned long addr)
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com




