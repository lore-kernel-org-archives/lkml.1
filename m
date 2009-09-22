Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbZIVTmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbZIVTmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZIVTmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:42:52 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZIVTib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F4jTsi1v7T6+RK/IOXzyzaSvSF0ipOM5xhzx7FWdLhzpv4luOPMEQdZoz4JLDJMvgR
         bC/8xeNvFRMMDXuhSyzkBdi16eKXv4y5cd+0XJwEAfKw1G9IXQNTvACb3jMj5sd0qE2i
         GqYpoATRubm0PXINu4TyzyQmijHPu/jx7/TTk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/24] kprobes/x86: Fix to add __kprobes to in-kernel fault handing functions
Date: Tue, 22 Sep 2009 21:38:01 +0200
Message-Id: <1253648302-5771-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
-- 
1.6.2.3

