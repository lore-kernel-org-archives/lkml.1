Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbZFYJgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbZFYJgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbZFYJgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:36:36 -0400
Received: from mail-pz0-f189.google.com ([209.85.222.189]:34686 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbZFYJgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=HWL4Qlu/zrWXXRsO4JTZ1dvzrZxyWUU6V7KN20pVQjmHD1eo3mS8/6Ow4EoQuEKuik
         t2WWwnzH/Kcmibxat18j3WYyd1SgMs8PRLY1+oldAzcSX/wU+p7z+tDVTu0hnPU5ix8k
         lBub1TGpQtyAruCsLT+pjsj9fXqLzRPxWQHv0=
Date: Thu, 25 Jun 2009 18:36:16 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] prevent to reclaim anon page of lumpy reclaim for no swap
 space
Message-Id: <20090625183616.23b55b24.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevent to reclaim anon page in case of no swap space.
VM already prevent to reclaim anon page in various place.
But it doesnt't prevent it for lumpy reclaim.

It shuffles lru list unnecessary so that it is pointless.
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 026f452..fb401fe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -830,7 +830,13 @@ int __isolate_lru_page(struct page *page, int mode, int file)
 	 * When this function is being called for lumpy reclaim, we
 	 * initially look into all LRU pages, active, inactive and
 	 * unevictable; only give shrink_page_list evictable pages.
+
+	 * If we don't have enough swap space, reclaiming of anon page
+	 * is pointless.
 	 */
+	if (nr_swap_pages <= 0 && PageAnon(page))
+		return ret;
+
 	if (PageUnevictable(page))
 		return ret;
 
-- 
1.5.4.3




-- 
Kinds Regards
Minchan Kim
