Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZDBHBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZDBHBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZDBHBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:01:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:58833 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZDBHBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QWHFAtdK2aFJjh71OpvwBvbzk7apDucNuWLT1esEWrcqRw03YpyHgpS2vMILRMg3BH
         EOcN6Pz4pKm7iSdPL/1ufGxqeJI2VDdMq5OB0y/PAJYmclH8scyZk4Ji1mFHgsT9ejD8
         mw/TZdCQvRt2QU8cMdv/Hs5GFqbliiKCrFilk=
Date: Thu, 2 Apr 2009 16:01:26 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: fix misuse of debug_kmap_atomic
Message-ID: <20090402070126.GA3951@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7ca43e7564679604d86e9ed834e7bbcffd8a4a3f (mm: use debug_kmap_atomic)
introduced some debug_kmap_atomic() in wrong places.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 5bc5d16..8126e8d 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -40,7 +40,6 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 
 	debug_kmap_atomic(type);
 
-	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index bff0c90..e331f77 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -39,6 +39,7 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
@@ -72,7 +73,6 @@ iounmap_atomic(void *kvaddr, enum km_type type)
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
 
-	debug_kmap_atomic(type);
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
 	 * without first remap it.  Keeping stale mappings around is a bad idea
