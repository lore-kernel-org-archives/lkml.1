Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZLNMdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZLNMdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZLNMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:33:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44908 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZLNMdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:33:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH 8/8] mm: Give up allocation if the task have fatal signal
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
Message-Id: <20091214213224.BBC6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 21:32:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In OOM case, almost processes may be in vmscan. There isn't any reason
the killed process continue allocation. process exiting free lots pages
rather than greedy vmscan.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ca9cae1..8a9cbaa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1878,6 +1878,14 @@ rebalance:
 		goto got_pg;
 
 	/*
+	 * If the allocation is for userland page and we have fatal signal,
+	 * there isn't any reason to continue allocation. instead, the task
+	 * should exit soon.
+	 */
+	if (fatal_signal_pending(current) && (gfp_mask & __GFP_HIGHMEM))
+		goto nopage;
+
+	/*
 	 * If we failed to make any progress reclaiming, then we are
 	 * running out of options and have to consider going OOM
 	 */
-- 
1.6.5.2



