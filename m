Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZJQJ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZJQJ5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZJQJ5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:57:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:40282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbZJQJ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:57:42 -0400
Date: Sat, 17 Oct 2009 09:57:17 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090827172311.8246.92725.stgit@localhost.localdomain>
References: <20090827172311.8246.92725.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes/x86: Fix to add __kprobes to in-kernel fault handing functions
Message-ID: <tip-62c9295f9dd250ea1bb2c8078642a275a9ce82f8@git.kernel.org>
Git-Commit-ID: 62c9295f9dd250ea1bb2c8078642a275a9ce82f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:57:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62c9295f9dd250ea1bb2c8078642a275a9ce82f8
Gitweb:     http://git.kernel.org/tip/62c9295f9dd250ea1bb2c8078642a275a9ce82f8
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 27 Aug 2009 13:23:11 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 30 Aug 2009 03:08:26 +0200

kprobes/x86: Fix to add __kprobes to in-kernel fault handing functions

Add __kprobes to the functions which handle in-kernel fixable page
faults. Since kprobes can cause those in-kernel page faults by accessing
kprobe data structures, probing those fault functions will cause
fault-int3-loop (do_page_fault has already been marked as __kprobes).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090827172311.8246.92725.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/mm/fault.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index bfae139..c322e59 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -38,7 +38,8 @@ enum x86_pf_error_code {
  * Returns 0 if mmiotrace is disabled, or if the fault is not
  * handled by mmiotrace:
  */
-static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
+static inline int __kprobes
+kmmio_fault(struct pt_regs *regs, unsigned long addr)
 {
 	if (unlikely(is_kmmio_active()))
 		if (kmmio_handler(regs, addr) == 1)
@@ -46,7 +47,7 @@ static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
 	return 0;
 }
 
-static inline int notify_page_fault(struct pt_regs *regs)
+static inline int __kprobes notify_page_fault(struct pt_regs *regs)
 {
 	int ret = 0;
 
@@ -239,7 +240,7 @@ void vmalloc_sync_all(void)
  *
  *   Handle a fault on the vmalloc or module mapping area
  */
-static noinline int vmalloc_fault(unsigned long address)
+static noinline __kprobes int vmalloc_fault(unsigned long address)
 {
 	unsigned long pgd_paddr;
 	pmd_t *pmd_k;
@@ -361,7 +362,7 @@ void vmalloc_sync_all(void)
  *
  * This assumes no large pages in there.
  */
-static noinline int vmalloc_fault(unsigned long address)
+static noinline __kprobes int vmalloc_fault(unsigned long address)
 {
 	pgd_t *pgd, *pgd_ref;
 	pud_t *pud, *pud_ref;
@@ -858,7 +859,7 @@ static int spurious_fault_check(unsigned long error_code, pte_t *pte)
  * There are no security implications to leaving a stale TLB when
  * increasing the permissions on a page.
  */
-static noinline int
+static noinline __kprobes int
 spurious_fault(unsigned long error_code, unsigned long address)
 {
 	pgd_t *pgd;
