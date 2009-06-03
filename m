Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZFCSsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZFCSsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbZFCSqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:46:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbZFCSqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:46:52 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090603846.816684333@firstfloor.org>
In-Reply-To: <20090603846.816684333@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: [PATCH] [6/16] HWPOISON: Add various poison checks in mm/memory.c
Message-Id: <20090603184639.1933B1D028F@basil.firstfloor.org>
Date: Wed,  3 Jun 2009 20:46:38 +0200 (CEST)
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
--- linux.orig/mm/memory.c	2009-06-03 19:36:23.000000000 +0200
+++ linux/mm/memory.c	2009-06-03 19:36:23.000000000 +0200
@@ -2797,6 +2797,9 @@
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
 
+	if (unlikely(PageHWPoison(vmf.page)))
+		return VM_FAULT_HWPOISON;
+
 	/*
 	 * For consistency in subsequent calls, make the faulted page always
 	 * locked.
