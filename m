Return-Path: <linux-kernel-owner+w=401wt.eu-S935657AbXEVPZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935657AbXEVPZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934811AbXEVPTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:35 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:5005
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965714AbXEVPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:15 -0400
Message-Id: <20070522141250.930553805@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:43 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 02/33] xen: paravirt: add a hook for once the allocator is ready
Content-Disposition: inline; filename=paravirt-add-post_allocator_init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a hook so that the paravirt backend knows when the allocator is
ready.  This is useful for the obvious reason that the allocator is
available, but the other side-effect of having the bootmem allocator
available is that each page now has an associated "struct page".

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/setup.c    |    2 ++
 include/asm-i386/paravirt.h |    8 ++++++++
 include/asm-i386/setup.h    |    4 ++++
 3 files changed, 14 insertions(+)

===================================================================
--- a/arch/i386/kernel/setup.c
+++ b/arch/i386/kernel/setup.c
@@ -611,6 +611,8 @@ void __init setup_arch(char **cmdline_p)
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 
+	paravirt_post_allocator_init();
+
 	dmi_scan_machine();
 
 #ifdef CONFIG_X86_GENERICARCH
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -52,6 +52,8 @@ struct paravirt_ops
 	/* Basic arch-specific setup */
 	void (*arch_setup)(void);
 	char *(*memory_setup)(void);
+	void (*post_allocator_init)(void);
+
 	void (*init_IRQ)(void);
 	void (*time_init)(void);
 
@@ -669,6 +671,12 @@ static inline void setup_secondary_clock
 }
 #endif
 
+static inline void paravirt_post_allocator_init(void)
+{
+	if (paravirt_ops.post_allocator_init)
+		(*paravirt_ops.post_allocator_init)();
+}
+
 static inline void paravirt_pagetable_setup_start(pgd_t *base)
 {
 	if (paravirt_ops.pagetable_setup_start)
===================================================================
--- a/include/asm-i386/setup.h
+++ b/include/asm-i386/setup.h
@@ -79,6 +79,10 @@ void __init add_memory_region(unsigned l
 
 extern unsigned long init_pg_tables_end;
 
+#ifndef CONFIG_PARAVIRT
+#define paravirt_post_allocator_init()	do {} while(0)
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif  /*  __KERNEL__  */

-- 

