Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbYAaQDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbYAaQDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763186AbYAaQC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:02:57 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:38084 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbYAaQC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:02:56 -0500
Date: Thu, 31 Jan 2008 18:02:53 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>,
       pq@iki.fi, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH v2] x86: Add a list for custom page fault handlers.
Message-ID: <20080131180253.6c007852@daedalus.pq.iki.fi>
In-Reply-To: <20080131150746.GB11996@elte.hu>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> could you please send us a patch for the whole mmiotrace kernel-side 
> feature, so that we can have a look at the general structure of this? 
> (and the interaction with change_page_attr(), etc.) Even if it's not 
> functional (and wont even build/boot) at the moment. Thanks,

Very well, first the revised custom page fault handler patch.
Changes since the previous submit:
- use spin_lock_irqsave instead of spin_lock
- Harvey Harrison's clean-up with the #ifdefs
- handler call site moved earlier
- remove sync RCU call

I'm not aware of any functional problems with this one.

Arjan, you said you don't like this. May I ask why?
This is most convinient for mmiotrace as it is meant to be a module.
I'm also using this as an excuse to let other people to get into the
page fault handler with their out-of-tree-today modules.


>From adeb0f4f95f176d97c1157031b5dd01f49d4cb66 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Wed, 30 Jan 2008 21:49:52 +0200
Subject: [PATCH] x86: Add a list for custom page fault handlers.

Provides kernel modules a way to register custom page fault handlers.
On every page fault this will call a list of registered functions. The
functions may handle the fault and force do_page_fault() to return
immediately.

This functionality is similar to the now removed page fault notifiers.
Custom page fault handlers are used by debugging and reverse engineering
tools. Mmiotrace is one such tool and a patch to add it into the tree
will follow.

The custom page fault handlers are called earlier in do_page_fault()
than the page fault notifiers were.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/Kconfig.debug   |    8 ++++++
 arch/x86/mm/fault.c      |   56 ++++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/kdebug.h |    9 +++++++
 3 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2e1e3af..1185dcc 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -138,6 +138,14 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+config PAGE_FAULT_HANDLERS
+	bool "Custom page fault handlers"
+	depends on DEBUG_KERNEL
+	help
+	  Allow the use of custom page fault handlers. A kernel module may
+	  register a function that is called on every page fault. Custom
+	  handlers are used by some debugging and reverse engineering tools.
+
 #
 # IO delay types:
 #
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e28cc52..11feebd 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -49,6 +49,60 @@
 #define PF_RSVD		(1<<3)
 #define PF_INSTR	(1<<4)
 
+#ifdef CONFIG_PAGE_FAULT_HANDLERS
+static HLIST_HEAD(pf_handlers); /* protected by RCU */
+static DEFINE_SPINLOCK(pf_handlers_writer);
+
+void register_page_fault_handler(struct pf_handler *new_pfh)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&pf_handlers_writer, flags);
+	hlist_add_head_rcu(&new_pfh->hlist, &pf_handlers);
+	spin_unlock_irqrestore(&pf_handlers_writer, flags);
+}
+EXPORT_SYMBOL_GPL(register_page_fault_handler);
+
+/**
+ * unregister_page_fault_handler:
+ * The caller must ensure @old_pfh is not in use anymore before freeing it.
+ * This function does not guarantee it. The list of handlers is protected by
+ * RCU, so you can do this by e.g. calling synchronize_rcu().
+ */
+void unregister_page_fault_handler(struct pf_handler *old_pfh)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&pf_handlers_writer, flags);
+	hlist_del_rcu(&old_pfh->hlist);
+	spin_unlock_irqrestore(&pf_handlers_writer, flags);
+}
+EXPORT_SYMBOL_GPL(unregister_page_fault_handler);
+#endif
+
+/* returns non-zero if do_page_fault() should return */
+static int handle_custom_pf(struct pt_regs *regs, unsigned long error_code,
+							unsigned long address)
+{
+#ifdef CONFIG_PAGE_FAULT_HANDLERS
+	int ret = 0;
+	struct pf_handler *cur;
+	struct hlist_node *ncur;
+
+	if (hlist_empty(&pf_handlers))
+		return 0;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(cur, ncur, &pf_handlers, hlist) {
+		ret = cur->handler(regs, error_code, address);
+		if (ret)
+			break;
+	}
+	rcu_read_unlock();
+	return ret;
+#else
+	return 0;
+#endif
+}
+
 static inline int notify_page_fault(struct pt_regs *regs)
 {
 #ifdef CONFIG_KPROBES
@@ -587,6 +641,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	if (notify_page_fault(regs))
 		return;
+	if (handle_custom_pf(regs, error_code, address))
+		return;
 
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index dd442a1..7ae2118 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -35,4 +35,13 @@ extern void dump_pagetable(unsigned long);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
 
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

