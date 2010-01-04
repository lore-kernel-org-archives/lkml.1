Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014Ab0ADBXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0ADBXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 20:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719Ab0ADBXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 20:23:30 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:50850 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0ADBX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 20:23:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=tWHHivueNnA2rSbLDivRxKI8yRkRCx8t6TXLTZgX0blspK0u7FG9EebPoCYPxvuKsd
         Ut+6/rttjo7eKBSwA3jarS9s9AyAcvpVxtV4sz4lR+KXO/QA9O30hmgMAwb6xUb6tUUW
         E2MvRBvJ2WPULJmMNzTvOfofcyr5gINn5mLlE=
Date: Mon, 4 Jan 2010 10:23:19 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Matt Mackall <mpm@selenic.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
Message-Id: <20100104102319.b878047d.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Long time ago, We regards zero page as file_rss and
vm_normal_page didn't return NULL in case of zero page

But now, we reinstated ZERO_PAGE and vm_normal_page's implementation
can return NULL in case of zero page.

Then, RSS and PSS can't be matched in smaps_pte_range.
This patch fixes it.

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 fs/proc/task_mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 47c03f4..f277c4a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -361,12 +361,11 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		if (!pte_present(ptent))
 			continue;
 
-		mss->resident += PAGE_SIZE;
-
 		page = vm_normal_page(vma, addr, ptent);
 		if (!page)
 			continue;
 
+		mss->resident += PAGE_SIZE;
 		/* Accumulate the size in pages that have been accessed. */
 		if (pte_young(ptent) || PageReferenced(page))
 			mss->referenced += PAGE_SIZE;
-- 
1.5.6.3



-- 
Kind regards,
Minchan Kim
