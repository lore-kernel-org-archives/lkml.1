Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbXHJWLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbXHJWLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760649AbXHJWBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:01:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759750AbXHJWBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:25 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 17/25 -v2] introduce paravirt_release_pgd()
Date: Fri, 10 Aug 2007 16:12:29 -0300
Message-Id: <11867732424024-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867732373232-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com> <11867731831138-git-send-email-gcosta@redhat.com> <11867731882768-git-send-email-gcosta@redhat.com> <11867731932688-git-send-email-gcosta@redhat.com> <11867731981891-git-send-email-gcosta@redhat.com> <1186773203887-git-send-email-gcosta@redhat.com> <11867732082735-git-send-email-gcosta@redhat.com> <11867732121974-git-send-email-gcosta@redhat.com> <1186773217875-git-send-email-gcosta@redhat.com> <11867732221652-git-send-email-gcosta@redhat.com> <11867732273108-git-send-email-gcosta@redhat.com> <11867732323106-git-send-email-gcosta@redhat.com> <11867732373232-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new macro/function that informs a paravirt
guest when its page table is not more in use, and can be released.
In case we're not paravirt, just do nothing.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/pgalloc.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86_64/pgalloc.h b/include/asm-x86_64/pgalloc.h
index b467be6..dbe1267 100644
--- a/include/asm-x86_64/pgalloc.h
+++ b/include/asm-x86_64/pgalloc.h
@@ -9,6 +9,12 @@
 #define QUICK_PGD 0	/* We preserve special mappings over free */
 #define QUICK_PT 1	/* Other page table pages that are zero on free */
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define paravirt_release_pgd(pgd) do { } while (0)
+#endif
+
 #define pmd_populate_kernel(mm, pmd, pte) \
 		set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)))
 #define pud_populate(mm, pud, pmd) \
@@ -100,6 +106,7 @@ static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 static inline void pgd_free(pgd_t *pgd)
 {
 	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
+	paravirt_release_pgd(pgd);
 	quicklist_free(QUICK_PGD, pgd_dtor, pgd);
 }
 
-- 
1.4.4.2

