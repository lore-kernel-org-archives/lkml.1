Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYEaAPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYEaAPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYEaAOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:14:09 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:34114
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753738AbYEaANf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:13:35 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 4] xen: add mechanism to extend existing multicalls
X-Mercurial-Node: b3926110c03ab4f93367f31b10a81b5c6589eaf6
Message-Id: <b3926110c03ab4f93367.1212192272@localhost>
In-Reply-To: <patchbomb.1212192268@localhost>
Date: Sat, 31 May 2008 01:04:32 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Xen hypercalls accept an array of operations to work on.  In
general this is because its more efficient for the hypercall to the
work all at once rather than as separate hypercalls (even batched as a
multicall).

This patch adds a mechanism (xen_mc_extend_args()) to allocate more
argument space to the last-issued multicall, in order to extend its
argument list.

The user of this mechanism is xen/mmu.c, which uses it to extend the
args array of mmu_update.  This is particularly valuable when doing
the update for a large mprotect, which goes via
ptep_modify_prot_commit(), but it also manages to batch updates to
pgd/pmds as well.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c        |   56 ++++++++++++++++++++++++++++-----------------
 arch/x86/xen/multicalls.c |   40 +++++++++++++++++++++++++++-----
 arch/x86/xen/multicalls.h |   12 +++++++++
 3 files changed, 81 insertions(+), 27 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -218,19 +218,35 @@
 		BUG();
 }
 
-
-void xen_set_pmd(pmd_t *ptr, pmd_t val)
+static void extend_mmu_update(const struct mmu_update *update)
 {
 	struct multicall_space mcs;
 	struct mmu_update *u;
 
+	mcs = xen_mc_extend_args(__HYPERVISOR_mmu_update, sizeof(*u));
+
+	if (mcs.mc != NULL)
+		mcs.mc->args[1]++;
+	else {
+		mcs = __xen_mc_entry(sizeof(*u));
+		MULTI_mmu_update(mcs.mc, mcs.args, 1, NULL, DOMID_SELF);
+	}
+
+	u = mcs.args;
+	*u = *update;
+}
+
+void xen_set_pmd(pmd_t *ptr, pmd_t val)
+{
+	struct mmu_update u;
+
 	preempt_disable();
 
-	mcs = xen_mc_entry(sizeof(*u));
-	u = mcs.args;
-	u->ptr = virt_to_machine(ptr).maddr;
-	u->val = pmd_val_ma(val);
-	MULTI_mmu_update(mcs.mc, u, 1, NULL, DOMID_SELF);
+	xen_mc_batch();
+
+	u.ptr = virt_to_machine(ptr).maddr;
+	u.val = pmd_val_ma(val);
+	extend_mmu_update(&u);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
@@ -309,14 +325,13 @@
 void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 				 pte_t *ptep, pte_t pte)
 {
-	struct multicall_space mcs;
-	struct mmu_update *u;
+	struct mmu_update u;
 
-	mcs = xen_mc_entry(sizeof(*u));
-	u = mcs.args;
-	u->ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
-	u->val = pte_val_ma(pte);
-	MULTI_mmu_update(mcs.mc, u, 1, NULL, DOMID_SELF);
+	xen_mc_batch();
+
+	u.ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
+	u.val = pte_val_ma(pte);
+	extend_mmu_update(&u);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
@@ -367,16 +382,15 @@
 
 void xen_set_pud(pud_t *ptr, pud_t val)
 {
-	struct multicall_space mcs;
-	struct mmu_update *u;
+	struct mmu_update u;
 
 	preempt_disable();
 
-	mcs = xen_mc_entry(sizeof(*u));
-	u = mcs.args;
-	u->ptr = virt_to_machine(ptr).maddr;
-	u->val = pud_val_ma(val);
-	MULTI_mmu_update(mcs.mc, u, 1, NULL, DOMID_SELF);
+	xen_mc_batch();
+
+	u.ptr = virt_to_machine(ptr).maddr;
+	u.val = pud_val_ma(val);
+	extend_mmu_update(&u);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -29,14 +29,14 @@
 #define MC_DEBUG	1
 
 #define MC_BATCH	32
-#define MC_ARGS		(MC_BATCH * 16 / sizeof(u64))
+#define MC_ARGS		(MC_BATCH * 16)
 
 struct mc_buffer {
 	struct multicall_entry entries[MC_BATCH];
 #if MC_DEBUG
 	struct multicall_entry debug[MC_BATCH];
 #endif
-	u64 args[MC_ARGS];
+	unsigned char args[MC_ARGS];
 	struct callback {
 		void (*fn)(void *);
 		void *data;
@@ -107,20 +107,48 @@
 {
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	struct multicall_space ret;
-	unsigned argspace = (args + sizeof(u64) - 1) / sizeof(u64);
+	unsigned argidx = roundup(b->argidx, sizeof(u64));
 
 	BUG_ON(preemptible());
-	BUG_ON(argspace > MC_ARGS);
+	BUG_ON(b->argidx > MC_ARGS);
 
 	if (b->mcidx == MC_BATCH ||
-	    (b->argidx + argspace) > MC_ARGS)
+	    (argidx + args) > MC_ARGS) {
 		xen_mc_flush();
+		argidx = roundup(b->argidx, sizeof(u64));
+	}
 
 	ret.mc = &b->entries[b->mcidx];
 	b->mcidx++;
+	ret.args = &b->args[argidx];
+	b->argidx = argidx + args;
+
+	BUG_ON(b->argidx > MC_ARGS);
+	return ret;
+}
+
+struct multicall_space xen_mc_extend_args(unsigned long op, size_t size)
+{
+	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
+	struct multicall_space ret = { NULL, NULL };
+
+	BUG_ON(preemptible());
+	BUG_ON(b->argidx > MC_ARGS);
+
+	if (b->mcidx == 0)
+		return ret;
+
+	if (b->entries[b->mcidx - 1].op != op)
+		return ret;
+
+	if ((b->argidx + size) > MC_ARGS)
+		return ret;
+
+	ret.mc = &b->entries[b->mcidx - 1];
 	ret.args = &b->args[b->argidx];
-	b->argidx += argspace;
+	b->argidx += size;
 
+	BUG_ON(b->argidx > MC_ARGS);
 	return ret;
 }
 
diff --git a/arch/x86/xen/multicalls.h b/arch/x86/xen/multicalls.h
--- a/arch/x86/xen/multicalls.h
+++ b/arch/x86/xen/multicalls.h
@@ -45,4 +45,16 @@
 /* Set up a callback to be called when the current batch is flushed */
 void xen_mc_callback(void (*fn)(void *), void *data);
 
+/*
+ * Try to extend the arguments of the previous multicall command.  The
+ * previous command's op must match.  If it does, then it attempts to
+ * extend the argument space allocated to the multicall entry by
+ * arg_size bytes.
+ *
+ * The returned multicall_space will return with mc pointing to the
+ * command on success, or NULL on failure, and args pointing to the
+ * newly allocated space.
+ */
+struct multicall_space xen_mc_extend_args(unsigned long op, size_t arg_size);
+
 #endif /* _XEN_MULTICALLS_H */


