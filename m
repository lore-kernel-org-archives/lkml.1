Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYIWVWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYIWVWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYIWVVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:21:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:64530 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYIWVVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:21:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,295,1220252400"; 
   d="scan'208";a="619557671"
Message-Id: <20080923210035.413932000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 14:00:35 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, jeremy@goop.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/7] x86, cpa: cpa related changes to be inline with TLB Application note - v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TLB Application note[1] says:
	
"The TLBs may contain both ordinary and large-page translations for a 4-KByte
 range of linear addresses. This may occur if software modifies the paging
 structures so that the page size used for the address range changes. If the
 two translations differ with respect to page frame or attributes (e.g.,
 permissions), processor behavior is undefined and may be implementation 
 specific. The processor may use a page frame or attributes that correspond to
 neither translation; it may improperly set or fail to set the dirty bit in the
 appropriate paging-structure entry.
 
 Such undefined behavior is problematic because prefetches and memory accesses
 that are a result of speculative execution may occur, using the affected range
 of linear addresses. It is also problematic if software (including the software
 modifying the paging structures) is accessing data or executing code in the
 affected range of linear addresses. Software should not write to a
 paging-structure entry in a way that would change, for any linear address,
 both the page size and either the page frame or attributes."

Currently we violate this at:

a. kernel identity mapping, where large/small pages setup very early in the
   boot will be split up/merged into large pages along with attribute changes
   during the direct memory mapping init.

b. while doing cpa(), potentially we will split large page and change attribute
   both at the same time.

Following patches fixes this behavior.

[1] http://developer.intel.com/design/processor/applnots/317080.pdf

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
--- 
v2:
 1. Fix the deadlock associated with smp call function and spin_lock_irqsave()
    for pgd_lock.
 2. No alias checks for __set_pages_np()/__set_pages_p() avoiding the large
    text page split from atomic context in CONFIG_DEBUG_PAGEALLOC.
 3. Serialize cpa() for !CONFIG_DEBUG_PAGEALLOC, so that a cpu with stale
    large page tlb's(but small PTE's in memory) won't do a cpa() in parallel
    to some other cpu splitting large pages and changing page attribute for
    a small page.
    

