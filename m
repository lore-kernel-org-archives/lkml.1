Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbXCLSXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbXCLSXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXCLSXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:23:55 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1580 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXCLSXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:23:54 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/3] lumpy: back out removal of active check in isolate_lru_pages
References: <exportbomb.1173723760@pinky>
InReply-To: <exportbomb.1173723760@pinky>
Message-ID: <6619d81fbc4236897250d4b1ee9b4081@pinky>
Date: Mon, 12 Mar 2007 18:23:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As pointed out by Christop Lameter it should not be possible for a
page to change its active/inactive state without taking the lru_lock.
Reinstate this safety net.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bda63a0..d7a0860 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -691,10 +691,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			nr_taken++;
 			break;
 
-		default:
-			/* page is being freed, or is a missmatch */
+		case -EBUSY:
+			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
 			continue;
+
+		default:
+			BUG();
 		}
 
 		if (!order)
