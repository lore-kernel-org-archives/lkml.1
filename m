Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYHABPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYHABPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 21:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYHABPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 21:15:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:52391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYHABPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 21:15:23 -0400
Date: Fri, 1 Aug 2008 03:15:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com,
       hpa@zytor.com
Subject: [rfc][patch] x86: avoid highmem cache attribute aliasing
Message-ID: <20080801011521.GB20407@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Highmem code can leave ptes and tlb entries around for a given page even after
kunmap, and after it has been freed.

>From what I can gather, the PAT code may change the cache attributes of
arbitrary physical addresses (ie. including highmem pages), which would result
in aliases in the case that it operates on one of these lazy tlb highmem
pages.

Flushing kmaps should solve the problem.

I've also just added code for conditional flushing if we haven't got 
any dangling highmem aliases -- this should help performance if we
change page attributes frequently or systems that aren't using much
highmem pages (eg. if < 4G RAM). Should be turned into 2 patches, but
just for RFC...

---
Index: linux-2.6/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pageattr.c
+++ linux-2.6/arch/x86/mm/pageattr.c
@@ -777,6 +777,9 @@ static int change_page_attr_set_clr(unsi
 		WARN_ON_ONCE(1);
 	}
 
+	/* Must avoid aliasing mappings in the highmem code */
+	kmap_flush_unused();
+
 	cpa.vaddr = addr;
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
Index: linux-2.6/mm/highmem.c
===================================================================
--- linux-2.6.orig/mm/highmem.c
+++ linux-2.6/mm/highmem.c
@@ -70,6 +70,7 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map
 static void flush_all_zero_pkmaps(void)
 {
 	int i;
+	int need_flush = 0;
 
 	flush_cache_kmaps();
 
@@ -101,8 +102,10 @@ static void flush_all_zero_pkmaps(void)
 			  &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
+		need_flush = 1;
 	}
-	flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
+	if (need_flush)
+		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
 }
 
 /**
