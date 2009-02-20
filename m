Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZBTBQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZBTBQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZBTBPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:15:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbZBTBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:15:22 -0500
Message-Id: <20090220011520.308476302@goodmis.org>
References: <20090220011316.379904625@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Feb 2009 20:13:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/6] x86: check PMD in spurious_fault handler
Content-Disposition: inline; filename=0001-x86-check-PMD-in-spurious_fault-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to prevent hard lockup on bad PMD permissions

If the PMD does not have the correct permissions for a page access,
but the PTE does, the spurious fault handler will mistake the fault
as a lazy TLB transaction. This will result in an infinite loop of:

 fault -> spurious_fault check (pass) -> return to code -> fault

This patch adds a check and a warn on if the PTE passes the permissions
but the PMD does not.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/mm/fault.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c76ef1d..7b579a6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -455,6 +455,7 @@ static int spurious_fault(unsigned long address,
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	int ret;
 
 	/* Reserved-bit violation or user access to kernel space? */
 	if (error_code & (PF_USER | PF_RSVD))
@@ -482,7 +483,17 @@ static int spurious_fault(unsigned long address,
 	if (!pte_present(*pte))
 		return 0;
 
-	return spurious_fault_check(error_code, pte);
+	ret = spurious_fault_check(error_code, pte);
+	if (!ret)
+		return 0;
+
+	/*
+	 * Make sure we have permissions in PMD
+	 * If not, then there's a bug in the page tables.
+	 */
+	ret = spurious_fault_check(error_code, (pte_t *) pmd);
+	WARN_ON(!ret);
+	return ret;
 }
 
 /*
-- 
1.5.6.5

-- 
