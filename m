Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZE2Vgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZE2Vgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 17:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZE2Vfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 17:35:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60565 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZE2Vfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 17:35:41 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200905291135.124267638@firstfloor.org>
In-Reply-To: <200905291135.124267638@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [7/16] HWPOISON: Add various poison checks in mm/memory.c
Message-Id: <20090529213532.DD6471D0293@basil.firstfloor.org>
Date: Fri, 29 May 2009 23:35:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bail out early when hardware poisoned pages are found in page fault handling.
Since they are poisoned they should not be mapped freshly into processes,
because that would cause another (potentially deadly) machine check

This is generally handled in the same way as OOM, just a different
error code is returned to the architecture code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2009-05-29 23:32:10.000000000 +0200
+++ linux/mm/memory.c	2009-05-29 23:32:10.000000000 +0200
@@ -2659,6 +2659,9 @@
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
 
+	if (unlikely(PageHWPoison(vmf.page)))
+		return VM_FAULT_HWPOISON;
+
 	/*
 	 * For consistency in subsequent calls, make the faulted page always
 	 * locked.
