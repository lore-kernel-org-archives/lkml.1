Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZJBIGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZJBIGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZJBIGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:06:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59925 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZJBIGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:06:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] congestion_wait() don't use WRITE
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20091002170343.5F67.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  2 Oct 2009 17:06:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 8aa7e847d (Fix congestion_wait() sync/async vs read/write confusion)
replace WRITE with BLK_RW_ASYNC.
Unfortunately, concurrent mm development made the unchanged place
accidentally.

This patch fixes it too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4a7b0d5..e4a915b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1088,7 +1088,7 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
 	int lumpy_reclaim = 0;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
-		congestion_wait(WRITE, HZ/10);
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
-- 
1.6.0.GIT



