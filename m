Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbZKYSie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbZKYSie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZKYSid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:38:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZKYSic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:38:32 -0500
Date: Wed, 25 Nov 2009 13:37:52 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, lwoodman@redhat.com, kosaki.motohiro@fujitsu.co.jp,
       Tomasz Chmielewski <mangoo@wpkg.org>, akpm@linux-foundation.org
Subject: [PATCH] vmscan: do not evict inactive pages when skipping an active
 list scan
Message-ID: <20091125133752.2683c3e4@bree.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In AIM7 runs, recent kernels start swapping out anonymous pages
well before they should.  This is due to shrink_list falling
through to shrink_inactive_list if !inactive_anon_is_low(zone, sc),
when all we really wanted to do is pre-age some anonymous pages to
give them extra time to be referenced while on the inactive list.

The obvious fix is to make sure that shrink_list does not fall
through to scanning/reclaiming inactive pages when we called it
to scan one of the active lists.

This change should be safe because the loop in shrink_zone ensures
that we will still shrink the anon and file inactive lists whenever
we should.


Reported-by: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 777af57..ec4dfda 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1469,13 +1469,15 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
-		shrink_active_list(nr_to_scan, zone, sc, priority, file);
+	if (lru == LRU_ACTIVE_FILE) {
+		if (inactive_file_is_low(zone, sc))
+		      shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
 
-	if (lru == LRU_ACTIVE_ANON && inactive_anon_is_low(zone, sc)) {
-		shrink_active_list(nr_to_scan, zone, sc, priority, file);
+	if (lru == LRU_ACTIVE_ANON) {
+		if (inactive_file_is_low(zone, sc))
+		      shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
 	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);

