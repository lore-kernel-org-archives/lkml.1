Return-Path: <linux-kernel-owner+w=401wt.eu-S938699AbZDJOKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938699AbZDJOKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 10:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZDJOJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 10:09:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:32817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZDJOJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 10:09:55 -0400
Date: Fri, 10 Apr 2009 14:06:37 GMT
From: Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, ananth@in.ibm.com,
       garyhade@us.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       ananth@in.ibm.com, garyhade@us.ibm.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <49DE3695.6040800@redhat.com>
References: <49DE3695.6040800@redhat.com>
Subject: [tip:x86/urgent] x86: fix set_fixmap to use phys_addr_t
Message-ID: <tip-189cdc2b41fce3a780a6f3aa963cc4e8114aec6b@git.kernel.org>
Git-Commit-ID: 189cdc2b41fce3a780a6f3aa963cc4e8114aec6b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 14:06:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  189cdc2b41fce3a780a6f3aa963cc4e8114aec6b
Gitweb:     http://git.kernel.org/tip/189cdc2b41fce3a780a6f3aa963cc4e8114aec6b
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 9 Apr 2009 10:55:33 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 15:52:59 +0200

x86: fix set_fixmap to use phys_addr_t

Impact: fix kprobes crash on 32-bit with RAM above 4G

Use phys_addr_t for receiving a physical address argument
instead of unsigned long. This allows fixmap to handle
pages higher than 4GB on x86-32.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: systemtap-ml <systemtap@sources.redhat.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <49DE3695.6040800@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/fixmap.h   |    4 ++--
 arch/x86/include/asm/paravirt.h |    4 ++--
 arch/x86/mm/pgtable.c           |    3 ++-
 arch/x86/xen/mmu.c              |    2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 81937a5..2d81af3 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -151,11 +151,11 @@ extern pte_t *pkmap_page_table;
 
 void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
 void native_set_fixmap(enum fixed_addresses idx,
-		       unsigned long phys, pgprot_t flags);
+		       phys_addr_t phys, pgprot_t flags);
 
 #ifndef CONFIG_PARAVIRT
 static inline void __set_fixmap(enum fixed_addresses idx,
-				unsigned long phys, pgprot_t flags)
+				phys_addr_t phys, pgprot_t flags)
 {
 	native_set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 7727aa8..378e369 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -347,7 +347,7 @@ struct pv_mmu_ops {
 	/* Sometimes the physical address is a pfn, and sometimes its
 	   an mfn.  We can tell which is which from the index. */
 	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
-			   unsigned long phys, pgprot_t flags);
+			   phys_addr_t phys, pgprot_t flags);
 };
 
 struct raw_spinlock;
@@ -1432,7 +1432,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 void arch_flush_lazy_mmu_mode(void);
 
 static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
-				unsigned long phys, pgprot_t flags)
+				phys_addr_t phys, pgprot_t flags)
 {
 	pv_mmu_ops.set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 5b7c7c8..7aa03a5 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -345,7 +345,8 @@ void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
 	fixmaps_set++;
 }
 
-void native_set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
+void native_set_fixmap(enum fixed_addresses idx, phys_addr_t phys,
+		       pgprot_t flags)
 {
 	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index db3802f..2a81838 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1750,7 +1750,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 }
 #endif	/* CONFIG_X86_64 */
 
-static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
+static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 {
 	pte_t pte;
 
