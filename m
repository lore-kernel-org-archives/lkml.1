Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYA3C2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYA3C2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYA3C2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:28:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:5945 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYA3C2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EMxCKgiukAemAAcIpjDEuWm8eobWXX5IdQ/bH6nL9vncAUvqMnfX4NFNemXD/o4UtymV2CpTVfcYcsl4NvRagrdHlwo8cz9TNDeM63Dqb68W/y/2wuHhvZmPP3WPRaSIiviZw23cnvi2UGBOJGLXHFmc92q4ad1DX/QNsQEU6Zc=
Subject: Re: [PATCH] x86: Add a list for custom page fault handlers.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pekka Paalanen <pq@iki.fi>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
In-Reply-To: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 18:28:22 -0800
Message-Id: <1201660102.8837.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
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
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, ported Pekka's patch to current x86.git for review.  I have not
incorporated the RCU comments from Peter Zjistra, but I have folded
some of the static functions into on handle_custom_pf function that
will match the handle_kprobe_fault helper that will be ready for
RC1.

Harvey

 arch/x86/Kconfig.debug |    9 ++++++++
 arch/x86/mm/fault.c    |   51
++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2e1e3af..9b44bc5 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -225,4 +225,13 @@ config CPA_DEBUG
 	help
 	  Do change_page_attr self tests at boot.
 
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
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e28cc52..c6c8164 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -49,6 +49,54 @@
 #define PF_RSVD		(1<<3)
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
+#endif
+
+/* returns non-zero if do_page_fault() should return */
+static int handle_custom_pf(struct pt_regs *regs, unsigned long
error_code,
+			    unsigned long address)
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
@@ -588,6 +636,9 @@ void __kprobes do_page_fault(struct pt_regs *regs,
unsigned long error_code)
 	if (notify_page_fault(regs))
 		return;
 
+	if (handle_custom_pf(regs, error_code, address))
+		return;
+
 	/*
 	 * We fault-in kernel-space virtual memory on-demand. The
 	 * 'reference' page table is init_mm.pgd.
-- 
1.5.4.rc4.1142.gf5a97



