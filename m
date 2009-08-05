Return-Path: <linux-kernel-owner+w=401wt.eu-S934081AbZHEJjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbZHEJjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbZHEJgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:36:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977AbZHEJgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:36:33 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908051136.682859934@firstfloor.org>
In-Reply-To: <200908051136.682859934@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       hidehiro.kawai.ez@hitachi.com
Subject: [PATCH] [6/19] HWPOISON: Add various poison checks in mm/memory.c v2
Message-Id: <20090805093633.C6124B15D8@basil.firstfloor.org>
Date: Wed,  5 Aug 2009 11:36:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bail out early when hardware poisoned pages are found in page fault handling.
Since they are poisoned they should not be mapped freshly into processes,
because that would cause another (potentially deadly) machine check

This is generally handled in the same way as OOM, just a different
error code is returned to the architecture code.

v2: Do a page unlock if needed (Fengguang Wu)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c
+++ linux/mm/memory.c
@@ -2711,6 +2711,12 @@ static int __do_fault(struct mm_struct *
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
 
+	if (unlikely(PageHWPoison(vmf.page))) {
+		if (ret & VM_FAULT_LOCKED)
+			unlock_page(vmf.page);
+		return VM_FAULT_HWPOISON;
+	}
+
 	/*
 	 * For consistency in subsequent calls, make the faulted page always
 	 * locked.
