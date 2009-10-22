Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZJVGCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZJVGCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 02:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZJVGCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 02:02:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39470 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZJVGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 02:02:30 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] HWPOISON: fix invalid page count in printk output
Date: Thu, 22 Oct 2009 08:02:32 +0200
Message-Id: <1256191352-6903-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1256191352-6903-8-git-send-email-andi@firstfloor.org>
References: <i>
 <1256191352-6903-1-git-send-email-andi@firstfloor.org>
 <1256191352-6903-2-git-send-email-andi@firstfloor.org>
 <1256191352-6903-3-git-send-email-andi@firstfloor.org>
 <1256191352-6903-4-git-send-email-andi@firstfloor.org>
 <1256191352-6903-5-git-send-email-andi@firstfloor.org>
 <1256191352-6903-6-git-send-email-andi@firstfloor.org>
 <1256191352-6903-7-git-send-email-andi@firstfloor.org>
 <1256191352-6903-8-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

The madvise injector already holds a reference when passing in a page
to the memory-failure code. The code corrects for this additional reference
for its checks, but the final printk output didn't. Fix that.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/memory-failure.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e354b9f..dacc641 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -613,13 +613,16 @@ static int page_action(struct page_state *ps, struct page *p,
 			unsigned long pfn, int ref)
 {
 	int result;
+	int count;
 
 	result = ps->action(p, pfn);
 	action_result(pfn, ps->msg, result);
-	if (page_count(p) != 1 + ref)
+
+	count = page_count(p) - 1 - ref;
+	if (count != 0)
 		printk(KERN_ERR
 		       "MCE %#lx: %s page still referenced by %d users\n",
-		       pfn, ps->msg, page_count(p) - 1);
+		       pfn, ps->msg, count);
 
 	/* Could do more checks here if page looks ok */
 	/*
-- 
1.6.0.2

