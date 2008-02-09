Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYBIRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYBIRxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYBIRxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:53:09 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:39906 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbYBIRxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:53:08 -0500
Date: Sat, 9 Feb 2008 19:52:55 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, pq@iki.fi
Subject: [RFC PATCH] x86: explicit call to mmiotrace in do_page_fault()
Message-ID: <20080209195255.584d4157@daedalus.pq.iki.fi>
In-Reply-To: <20080207125622.GA7111@infradead.org>
References: <1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	<20080205223958.2cab8ce3@daedalus.pq.iki.fi>
	<20080207125327.GB27234@elte.hu>
	<20080207125622.GA7111@infradead.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The custom page fault handler list is replaced with a single function
pointer. All related functions and variables are renamed for
mmiotrace.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/Kconfig.debug   |   14 ++++-----
 arch/x86/mm/fault.c      |   66 +++++++++++++++++++++++----------------------
 arch/x86/mm/kmmio.c      |   14 +++++-----
 include/asm-x86/kdebug.h |   12 +++-----
 4 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 3daf6c1..0fe4120 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -169,20 +169,18 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-config PAGE_FAULT_HANDLERS
-	bool "Custom page fault handlers"
-	depends on DEBUG_KERNEL
-	help
-	  Allow the use of custom page fault handlers. A kernel module may
-	  register a function that is called on every page fault. Custom
-	  handlers are used by some debugging and reverse engineering tools.
+config MMIOTRACE_HOOKS
+	bool
+	default n
 
 config MMIOTRACE
 	tristate "Memory mapped IO tracing"
-	depends on DEBUG_KERNEL && PAGE_FAULT_HANDLERS && RELAY && DEBUG_FS
+	depends on DEBUG_KERNEL && RELAY && DEBUG_FS
+	select MMIOTRACE_HOOKS
 	default n
 	help
 	  This will build a kernel module called mmiotrace.
+	  Making this a built-in is heavily discouraged.
 
 	  Mmiotrace traces Memory Mapped I/O access and is meant for debugging
 	  and reverse engineering. The kernel module offers wrapped
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 1d3541d..1100a26 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -49,53 +49,55 @@
 #define PF_RSVD		(1<<3)
 #define PF_INSTR	(1<<4)
 
-#ifdef CONFIG_PAGE_FAULT_HANDLERS
-static HLIST_HEAD(pf_handlers); /* protected by RCU */
-static DEFINE_SPINLOCK(pf_handlers_writer);
+#ifdef CONFIG_MMIOTRACE_HOOKS
+static pf_handler_func mmiotrace_pf_handler; /* protected by RCU */
+static DEFINE_SPINLOCK(mmiotrace_handler_lock);
 
-void register_page_fault_handler(struct pf_handler *new_pfh)
+int mmiotrace_register_pf(pf_handler_func new_pfh)
 {
+	int ret = 0;
 	unsigned long flags;
-	spin_lock_irqsave(&pf_handlers_writer, flags);
-	hlist_add_head_rcu(&new_pfh->hlist, &pf_handlers);
-	spin_unlock_irqrestore(&pf_handlers_writer, flags);
+	spin_lock_irqsave(&mmiotrace_handler_lock, flags);
+	if (mmiotrace_pf_handler)
+		ret = -EBUSY;
+	else
+		mmiotrace_pf_handler = new_pfh;
+	spin_unlock_irqrestore(&mmiotrace_handler_lock, flags);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(register_page_fault_handler);
+EXPORT_SYMBOL_GPL(mmiotrace_register_pf);
 
 /**
- * unregister_page_fault_handler:
+ * mmiotrace_unregister_pf:
  * The caller must ensure @old_pfh is not in use anymore before freeing it.
- * This function does not guarantee it. The list of handlers is protected by
- * RCU, so you can do this by e.g. calling synchronize_rcu().
+ * This function does not guarantee it. The handler function pointer is
+ * protected by RCU, so you can do this by e.g. calling synchronize_rcu().
  */
-void unregister_page_fault_handler(struct pf_handler *old_pfh)
+int mmiotrace_unregister_pf(pf_handler_func old_pfh)
 {
+	int ret = 0;
 	unsigned long flags;
-	spin_lock_irqsave(&pf_handlers_writer, flags);
-	hlist_del_rcu(&old_pfh->hlist);
-	spin_unlock_irqrestore(&pf_handlers_writer, flags);
+	spin_lock_irqsave(&mmiotrace_handler_lock, flags);
+	if (mmiotrace_pf_handler != old_pfh)
+		ret = -EPERM;
+	else
+		mmiotrace_pf_handler = NULL;
+	spin_unlock_irqrestore(&mmiotrace_handler_lock, flags);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(unregister_page_fault_handler);
-#endif
+EXPORT_SYMBOL_GPL(mmiotrace_unregister_pf);
+#endif /* CONFIG_MMIOTRACE_HOOKS */
 
 /* returns non-zero if do_page_fault() should return */
-static int handle_custom_pf(struct pt_regs *regs, unsigned long error_code,
-							unsigned long address)
+static inline int call_mmiotrace(struct pt_regs *regs,
+					unsigned long error_code,
+					unsigned long address)
 {
-#ifdef CONFIG_PAGE_FAULT_HANDLERS
+#ifdef CONFIG_MMIOTRACE_HOOKS
 	int ret = 0;
-	struct pf_handler *cur;
-	struct hlist_node *ncur;
-
-	if (hlist_empty(&pf_handlers))
-		return 0;
-
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(cur, ncur, &pf_handlers, hlist) {
-		ret = cur->handler(regs, error_code, address);
-		if (ret)
-			break;
-	}
+	if (mmiotrace_pf_handler)
+		ret = mmiotrace_pf_handler(regs, error_code, address);
 	rcu_read_unlock();
 	return ret;
 #else
@@ -657,7 +659,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	if (notify_page_fault(regs))
 		return;
-	if (handle_custom_pf(regs, error_code, address))
+	if (call_mmiotrace(regs, error_code, address))
 		return;
 
 	/*
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 28411da..e759f7c 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -51,10 +51,6 @@ static LIST_HEAD(kmmio_probes);
 
 static struct kmmio_context kmmio_ctx[NR_CPUS];
 
-static struct pf_handler kmmio_pf_hook = {
-	.handler = kmmio_page_fault
-};
-
 static struct notifier_block nb_die = {
 	.notifier_call = kmmio_die_notifier
 };
@@ -77,7 +73,8 @@ void cleanup_kmmio(void)
 	 * kmmio_page_table, kmmio_probes
 	 */
 	if (handler_registered) {
-		unregister_page_fault_handler(&kmmio_pf_hook);
+		if (mmiotrace_unregister_pf(&kmmio_page_fault))
+			BUG();
 		synchronize_rcu();
 	}
 	unregister_die_notifier(&nb_die);
@@ -343,8 +340,11 @@ int register_kmmio_probe(struct kmmio_probe *p)
 	}
 
 	if (!handler_registered) {
-		register_page_fault_handler(&kmmio_pf_hook);
-		handler_registered++;
+		if (mmiotrace_register_pf(&kmmio_page_fault))
+			printk(KERN_ERR "mmiotrace: Cannot register page "
+					"fault handler.\n");
+		else
+			handler_registered++;
 	}
 
 out:
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index 7ae2118..4680817 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -35,13 +35,11 @@ extern void dump_pagetable(unsigned long);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
 
-struct pf_handler {
-	struct hlist_node hlist;
-	int (*handler)(struct pt_regs *regs, unsigned long error_code,
-						unsigned long address);
-};
+typedef int (*pf_handler_func)(struct pt_regs *regs,
+				unsigned long error_code,
+				unsigned long address);
 
-extern void register_page_fault_handler(struct pf_handler *new_pfh);
-extern void unregister_page_fault_handler(struct pf_handler *old_pfh);
+extern int mmiotrace_register_pf(pf_handler_func new_pfh);
+extern int mmiotrace_unregister_pf(pf_handler_func old_pfh);
 
 #endif
-- 
1.5.3.7

