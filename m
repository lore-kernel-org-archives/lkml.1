Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZFEOgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZFEOgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZFEOf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:35:59 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:59463 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZFEOf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hpsA2duiBU34i92E0sPC91Du2TZ0/Tq/3mdLv+LzaVQcvVWDIaLfMklFwIXLyOt6Kn
         B5EEf5ia1Trfzz+f/dpNf0mW8WtWyt+RIIISfl/sSJcEqAmVHk9vXsz4/Du/66r4pyDb
         lD5tQN2FDHpHuRR2j0sTReSOXBaSI39wMnWeM=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>
Subject: [RFC] remove page_table_lock in anon_vma_prepare
Date: Fri,  5 Jun 2009 23:35:53 +0900
Message-Id: <1244212553-21629-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I looked over the page_table_lock, it related to page table not anon_vma

I think anon_vma->lock can protect race against threads.
Do I miss something ?

If I am right, we can remove unnecessary page_table_lock holding
in anon_vma_prepare. We can get performance benefit. 

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
---
 mm/rmap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index b5c6e12..65b4877 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -113,14 +113,11 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 		}
 		spin_lock(&anon_vma->lock);
 
-		/* page_table_lock to protect against threads */
-		spin_lock(&mm->page_table_lock);
 		if (likely(!vma->anon_vma)) {
 			vma->anon_vma = anon_vma;
 			list_add_tail(&vma->anon_vma_node, &anon_vma->head);
 			allocated = NULL;
 		}
-		spin_unlock(&mm->page_table_lock);
 
 		spin_unlock(&anon_vma->lock);
 		if (unlikely(allocated))
-- 
1.5.6.5

