Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbZL1EsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbZL1EsV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 23:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZL1EsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 23:48:20 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:59699 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZL1EsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 23:48:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=A8y08odV2HaLXzvgMqhg73A84w2eJ2mOMnhv3knPh9OEK9lyM0R0kZ12zcmyoVX5Ak
         PNUKcVnezeOet7OsuMUb01ZA+xQZhumVFC/Z9VD7HzpxUC8hMrqZK+jg64OQOziaR96X
         HipRll+kO5fJs9URnN9h0Gg1xE8tt8dOvKjKk=
Date: Mon, 28 Dec 2009 13:46:19 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Matt Mackall <mpm@selenic.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [PATCH -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
Message-Id: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am not sure we have to account zero page with file_rss. 
Hugh and Kame's new zero page doesn't do it. 
As side effect of this, we can prevent innocent process which have a lot
of zero page when OOM happens. 
(But I am not sure there is a process like this :)
So I think not file_rss counting is not bad. 

RSS counting zero page with file_rss helps any program using smaps?
If we have to keep the old behavior, I have to remake this patch. 

== CUT_HERE ==

Long time ago, We regards zero page as file_rss and
vm_normal_page doesn't return NULL.

But now, we reinstated ZERO_PAGE and vm_normal_page's implementation
can return NULL in case of zero page. Also we don't count it with
file_rss any more.

Then, RSS and PSS can't be matched.
For consistency, Let's ignore zero page in smaps_pte_range.

CC: Matt Mackall <mpm@selenic.com>
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
