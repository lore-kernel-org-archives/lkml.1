Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYA0Qwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYA0Qwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 11:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYA0Qwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 11:52:43 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:42076 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYA0Qwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 11:52:42 -0500
Date: Sun, 27 Jan 2008 18:52:38 +0200
From: Pekka Paalanen <pq@iki.fi>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, "Jan Beulich" <jbeulich@novell.com>,
       pq@iki.fi
Subject: [PATCH] x86: Add a list for custom page fault handlers.
Message-ID: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Paalanen <pq@iki.fi>

Provides kernel modules a way to register custom page fault handlers.
On every page fault, except those handled in vmalloc_fault(), this will
call a list of registered functions. The functions may handle the fault
and force do_page_fault() to return immediately.

This functionality is similar to the now removed page fault notifiers.
Custom page fault handlers are used by debugging and reverse engineering
tools. Mmio-trace is one such tool and a patch to add it into the tree
will follow.

The custom page fault handlers are called from the exact same points in
do_page_fault() as the page fault notifiers were.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

This change is x86 specific purely because my intended in-tree user of
it is mmio-trace, which AFAIK is really useful only on x86 for reverse
engineering binary drivers. If someone later wishes to merge this with
notify_page_fault() from kprobes, they can do that.

I am not subscribed to LKML, so please keep me in CC.

I will reply to this email with the next patch adding mmio-trace into
kernel.

Thanks,
pq

 arch/x86/Kconfig.debug   |    9 ++++++
 arch/x86/mm/fault_32.c   |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault_64.c   |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kdebug.h |    9 ++++++
 4 files changed, 146 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 761ca7b..920a63d 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -112,4 +112,13 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+config PAGE_FAULT_HANDLERS
+	bool "Custom page fault handlers"
+	depends on DEBUG_KERNEL
+	help
+	  Allow the use of custom page fault handlers. A kernel module may
+	  register a function that is called on every page fault not handled
+	  for vmalloc. Custom handlers are used by some debugging and reverse
+	  engineering tools.
+
 endmenu
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index a2273d4..19e16b0 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -33,6 +33,64 @@
 
 extern void die(const char *,struct pt_regs *,long);
 
+#ifdef CONFIG_PAGE_FAULT_HANDLERS
+static HLIST_HEAD(pf_handlers); /* protected by RCU */
+static DEFINE_SPINLOCK(pf_handlers_writer);
+
+void register_page_fault_handler(struct pf_handler *new_pfh)
+{
+	spin_lock(&pf_handlers_writer);
+	hlist_add_head_rcu(&new_pfh->hlist, &pf_handlers);
+	spin_unlock(&pf_handlers_writer);
+}
+EXPORT_SYMBOL_GPL(register_page_fault_handler);
+
+void unregister_page_fault_handler(struct pf_handler *old_pfh)
+{
+	might_sleep();
+	spin_lock(&pf_handlers_writer);
+	hlist_del_rcu(&old_pfh->hlist);
+	spin_unlock(&pf_handlers_writer);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(unregister_page_fault_handler);
+
+/* returns non-zero if do_page_fault() should return */
+static int call_pf_handlers(struct pt_regs *regs, unsigned long error_code,
+							unsigned long address)
+{
+	int ret = 0;
+	struct pf_handler *cur;
+	struct hlist_node *ncur;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(cur, ncur, &pf_handlers, hlist) {
+		ret = cur->handler(regs, error_code, address);
+		if (ret)
+			break;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static inline int custom_pf_handlers(void)
+{
+	return !hlist_empty(&pf_handlers);
+}
+#else
+static inline int call_pf_handlers(struct pt_regs *regs,
+						unsigned long error_code,
+						unsigned long address)
+{
+	return 0;
+}
+
+static inline int custom_pf_handlers(void)
+{
+	return 0;
+}
+#endif /* CONFIG_PAGE_FAULT_HANDLERS */
+
 #ifdef CONFIG_KPROBES
 static inline int notify_page_fault(struct pt_regs *regs)
 {
@@ -333,6 +391,9 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 			return;
 		if (notify_page_fault(regs))
 			return;
+		if (unlikely(custom_pf_handlers()))
+			if (call_pf_handlers(regs, error_code, address))
+				return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
@@ -342,6 +403,9 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 
 	if (notify_page_fault(regs))
 		return;
+	if (unlikely(custom_pf_handlers()))
+		if (call_pf_handlers(regs, error_code, address))
+			return;
 
 	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
 	   fault has been handled. */
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 0e26230..11f15cc 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -41,6 +41,64 @@
 #define PF_RSVD	(1<<3)
 #define PF_INSTR	(1<<4)
 
+#ifdef CONFIG_PAGE_FAULT_HANDLERS
+static HLIST_HEAD(pf_handlers); /* protected by RCU */
+static DEFINE_SPINLOCK(pf_handlers_writer);
+
+void register_page_fault_handler(struct pf_handler *new_pfh)
+{
+	spin_lock(&pf_handlers_writer);
+	hlist_add_head_rcu(&new_pfh->hlist, &pf_handlers);
+	spin_unlock(&pf_handlers_writer);
+}
+EXPORT_SYMBOL_GPL(register_page_fault_handler);
+
+void unregister_page_fault_handler(struct pf_handler *old_pfh)
+{
+	might_sleep();
+	spin_lock(&pf_handlers_writer);
+	hlist_del_rcu(&old_pfh->hlist);
+	spin_unlock(&pf_handlers_writer);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(unregister_page_fault_handler);
+
+/* returns non-zero if do_page_fault() should return */
+static int call_pf_handlers(struct pt_regs *regs, unsigned long error_code,
+							unsigned long address)
+{
+	int ret = 0;
+	struct pf_handler *cur;
+	struct hlist_node *ncur;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(cur, ncur, &pf_handlers, hlist) {
+		ret = cur->handler(regs, error_code, address);
+		if (ret)
+			break;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static inline int custom_pf_handlers(void)
+{
+	return !hlist_empty(&pf_handlers);
+}
+#else
+static inline int call_pf_handlers(struct pt_regs *regs,
+						unsigned long error_code,
+						unsigned long address)
+{
+	return 0;
+}
+
+static inline int custom_pf_handlers(void)
+{
+	return 0;
+}
+#endif /* CONFIG_PAGE_FAULT_HANDLERS */
+
 #ifdef CONFIG_KPROBES
 static inline int notify_page_fault(struct pt_regs *regs)
 {
@@ -345,6 +403,9 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 		}
 		if (notify_page_fault(regs))
 			return;
+		if (unlikely(custom_pf_handlers()))
+			if (call_pf_handlers(regs, error_code, address))
+				return;
 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
 		 * fault we could otherwise deadlock.
@@ -354,6 +415,9 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 
 	if (notify_page_fault(regs))
 		return;
+	if (unlikely(custom_pf_handlers()))
+		if (call_pf_handlers(regs, error_code, address))
+			return;
 
 	if (likely(regs->eflags & X86_EFLAGS_IF))
 		local_irq_enable();
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index e2f9b62..7449ad2 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -30,4 +30,13 @@ extern void dump_pagetable(unsigned long);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long);
 
+struct pf_handler {
+	struct hlist_node hlist;
+	int (*handler)(struct pt_regs *regs, unsigned long error_code,
+						unsigned long address);
+};
+
+extern void register_page_fault_handler(struct pf_handler *new_pfh);
+extern void unregister_page_fault_handler(struct pf_handler *old_pfh);
+
 #endif
-- 
1.5.3.7

