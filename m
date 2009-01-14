Return-Path: <linux-kernel-owner+w=401wt.eu-S1762592AbZANOgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbZANOgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbZANOgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:36:18 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:52208 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbZANOgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:36:16 -0500
Date: Wed, 14 Jan 2009 17:36:27 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] alpha: make pte_alloc_one_kernel() inline
Message-ID: <20090114143627.GF10788@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it's just a single call to __get_free_page().

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/include/asm/pgalloc.h |    7 ++++++-
 arch/alpha/mm/init.c             |    7 -------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/include/asm/pgalloc.h b/arch/alpha/include/asm/pgalloc.h
index fd09015..bc2a0da 100644
--- a/arch/alpha/include/asm/pgalloc.h
+++ b/arch/alpha/include/asm/pgalloc.h
@@ -50,7 +50,12 @@ pmd_free(struct mm_struct *mm, pmd_t *pmd)
 	free_page((unsigned long)pmd);
 }
 
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long addr);
+static inline pte_t *
+pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+	return pte;
+}
 
 static inline void
 pte_free_kernel(struct mm_struct *mm, pte_t *pte)
diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 234e42b..5d7a16e 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -59,13 +59,6 @@ pgd_alloc(struct mm_struct *mm)
 	return ret;
 }
 
-pte_t *
-pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
-{
-	pte_t *pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
-	return pte;
-}
-
 
 /*
  * BAD_PAGE is the page that is used for page faults when linux
