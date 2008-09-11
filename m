Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYIKVT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYIKVT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYIKVTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:19:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:14161 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbYIKVTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:19:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,383,1217833200"; 
   d="scan'208";a="615328612"
Message-Id: <20080911203048.929515000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Sep 2008 13:30:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/7] x86, cpa: cpa related changes to be inline with TLB Application note
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
-- 

