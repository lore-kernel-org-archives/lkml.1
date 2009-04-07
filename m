Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbZDGPUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbZDGPUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759195AbZDGPKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:10:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41289 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186AbZDGPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:10:03 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
In-Reply-To: <20090407509.382219156@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: [PATCH] [3/16] POISON: Handle poisoned pages in page free
Message-Id: <20090407150959.C099D1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:09:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make sure no poisoned pages are put back into the free page
lists.  This can happen with some races.

This is allo slow path in the bad page bits path, so another
check doesn't really matter.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/page_alloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2009-04-07 16:39:26.000000000 +0200
+++ linux/mm/page_alloc.c	2009-04-07 16:39:39.000000000 +0200
@@ -228,6 +228,15 @@
 	static unsigned long nr_unshown;
 
 	/*
+	 * Page may have been marked bad before process is freeing it.
+	 * Make sure it is not put back into the free page lists.
+	 */
+	if (PagePoison(page)) {
+		/* check more flags here... */
+		return;
+	}
+
+	/*
 	 * Allow a burst of 60 reports, then keep quiet for that minute;
 	 * or allow a steady drip of one report per second.
 	 */
