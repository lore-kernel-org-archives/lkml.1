Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZCAONP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZCAONP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZCAOM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:12:58 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:55742 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZCAOM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:12:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=U4c/VG6rehLlVQJ4UI7VQVvTVP+r51Uehy5k/UQFRMDNYMUsIgOtso0g57S+X9kyTY
         8OLpb8J0JdWib9SrVYr+SlkT52oApHYol/ytmKdllsaLIKnjP3FJzujXqU30ha7FKRBe
         iAb5RFLOc1VltO103ItxyYpG0IZmccTkmL4G8=
Date: Sun, 1 Mar 2009 16:12:48 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] x86 mmiotrace: split set_page_presence()
Message-ID: <20090301161248.4a2f24b2@daedalus.pq.iki.fi>
In-Reply-To: <20090301160643.05a2219b@daedalus.pq.iki.fi>
References: <20090301160643.05a2219b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 36772dcb6ffbbb68254cbfc379a103acd2fbfefc Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 28 Feb 2009 21:34:59 +0200
Subject: [PATCH] x86 mmiotrace: split set_page_presence()

Split set_page_presence() in kmmio.c into two more functions set_pmd_presence()
and set_pte_presence(). Purely code reorganization, no functional changes.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c |   41 ++++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index be361eb..d297775 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -107,12 +107,29 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
+static void set_pmd_presence(pmd_t *pmd, bool present, bool *old)
+{
+	pmdval_t v = pmd_val(*pmd);
+	*old = !!(v & _PAGE_PRESENT);
+	v &= ~_PAGE_PRESENT;
+	if (present)
+		v |= _PAGE_PRESENT;
+	set_pmd(pmd, __pmd(v));
+}
+
+static void set_pte_presence(pte_t *pte, bool present, bool *old)
+{
+	pteval_t v = pte_val(*pte);
+	*old = !!(v & _PAGE_PRESENT);
+	v &= ~_PAGE_PRESENT;
+	if (present)
+		v |= _PAGE_PRESENT;
+	set_pte_atomic(pte, __pte(v));
+}
+
 static int set_page_presence(unsigned long addr, bool present, bool *old)
 {
-	pteval_t pteval;
-	pmdval_t pmdval;
 	unsigned int level;
-	pmd_t *pmd;
 	pte_t *pte = lookup_address(addr, &level);
 
 	if (!pte) {
@@ -122,31 +139,17 @@ static int set_page_presence(unsigned long addr, bool present, bool *old)
 
 	switch (level) {
 	case PG_LEVEL_2M:
-		pmd = (pmd_t *)pte;
-		pmdval = pmd_val(*pmd);
-		*old = !!(pmdval & _PAGE_PRESENT);
-		pmdval &= ~_PAGE_PRESENT;
-		if (present)
-			pmdval |= _PAGE_PRESENT;
-		set_pmd(pmd, __pmd(pmdval));
+		set_pmd_presence((pmd_t *)pte, present, old);
 		break;
-
 	case PG_LEVEL_4K:
-		pteval = pte_val(*pte);
-		*old = !!(pteval & _PAGE_PRESENT);
-		pteval &= ~_PAGE_PRESENT;
-		if (present)
-			pteval |= _PAGE_PRESENT;
-		set_pte_atomic(pte, __pte(pteval));
+		set_pte_presence(pte, present, old);
 		break;
-
 	default:
 		pr_err("kmmio: unexpected page level 0x%x.\n", level);
 		return -1;
 	}
 
 	__flush_tlb_one(addr);
-
 	return 0;
 }
 
-- 
1.6.0.6

