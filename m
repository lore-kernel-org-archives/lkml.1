Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbZDGPV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbZDGPV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759333AbZDGPKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:10:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41298 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317AbZDGPKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:10:10 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
In-Reply-To: <20090407509.382219156@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: [PATCH] [8/16] POISON: Add various poison checks in mm/memory.c
Message-Id: <20090407151005.4E24B1D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:10:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bail out early when poisoned pages are found in page fault handling.
Since they are poisoned they should not be mapped freshly
into processes.

This is generally handled in the same way as OOM, just a different
error code is returned to the architecture code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2009-04-07 16:39:39.000000000 +0200
+++ linux/mm/memory.c	2009-04-07 16:39:39.000000000 +0200
@@ -2560,6 +2560,10 @@
 		goto oom;
 	__SetPageUptodate(page);
 
+	/* Kludge for now until we take poisoned pages out of the free lists */
+	if (unlikely(PagePoison(page)))
+		return VM_FAULT_POISON;
+
 	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
 		goto oom_free_page;
 
@@ -2625,6 +2629,9 @@
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
 
+	if (unlikely(PagePoison(vmf.page)))
+		return VM_FAULT_POISON;
+
 	/*
 	 * For consistency in subsequent calls, make the faulted page always
 	 * locked.
