Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZJVGCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZJVGCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZJVGCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:02:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39467 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZJVGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:02:30 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] HWPOISON: fix oops on ksm pages
Date: Thu, 22 Oct 2009 08:02:29 +0200
Message-Id: <1256191352-6903-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1256191352-6903-5-git-send-email-andi@firstfloor.org>
References: <i>
 <1256191352-6903-1-git-send-email-andi@firstfloor.org>
 <1256191352-6903-2-git-send-email-andi@firstfloor.org>
 <1256191352-6903-3-git-send-email-andi@firstfloor.org>
 <1256191352-6903-4-git-send-email-andi@firstfloor.org>
 <1256191352-6903-5-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Memory failure on a KSM page currently oopses on its NULL anon_vma in
page_lock_anon_vma(): that may not be much worse than the consequence
of ignoring it, but it is better to be consistent with how ZERO_PAGE
and hugetlb pages and other awkward cases are treated.  Just skip it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/memory-failure.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e17ec3f..e354b9f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -35,6 +35,7 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/sched.h>
+#include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
@@ -644,7 +645,7 @@ static void hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	int i;
 	int kill = 1;
 
-	if (PageReserved(p) || PageCompound(p) || PageSlab(p))
+	if (PageReserved(p) || PageCompound(p) || PageSlab(p) || PageKsm(p))
 		return;
 
 	/*
-- 
1.6.0.2

