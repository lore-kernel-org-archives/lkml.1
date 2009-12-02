Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZLBCzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZLBCzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 21:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZLBCzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 21:55:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37983 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZLBCzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 21:55:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH] Clear reference bit although page isn't mapped.
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20091201102645.5C0A.A69D9226@jp.fujitsu.com>
References: <1259618429.2345.3.camel@dhcp-100-19-198.bos.redhat.com> <20091201102645.5C0A.A69D9226@jp.fujitsu.com>
Message-Id: <20091202115358.5C4F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Dec 2009 11:55:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> btw, current shrink_active_list() have unnecessary page_mapping_inuse() call.
> it prevent to drop page reference bit from unmapped cache page. it mean
> we protect unmapped cache page than mapped page. it is strange.

How about this?

---------------------------------
SplitLRU VM replacement algorithm assume shrink_active_list() clear
the page's reference bit. but unnecessary page_mapping_inuse() test
prevent it.

This patch remove it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 00156f2..3e942b5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1347,8 +1347,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 		}
 
 		/* page_referenced clears PageReferenced */
-		if (page_mapping_inuse(page) &&
-		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
+		if (page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			nr_rotated++;
 			/*
 			 * Identify referenced, file-backed active pages and
-- 
1.6.5.2



