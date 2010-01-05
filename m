Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667Ab0AEAiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0AEAiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636Ab0AEAhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:37:31 -0500
Received: from kroah.org ([198.145.64.141]:42528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0AEAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rik van Riel <riel@redhat.com>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik Theys <rik.theys@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 96/97] vmscan: do not evict inactive pages when skipping an active list scan
Date: Mon,  4 Jan 2010 16:33:49 -0800
Message-Id: <1262651630-7354-96-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

commit b39415b2731d7dec5e612d2d12595da82399eedf upstream.

In AIM7 runs, recent kernels start swapping out anonymous pages well
before they should.  This is due to shrink_list falling through to
shrink_inactive_list if !inactive_anon_is_low(zone, sc), when all we
really wanted to do is pre-age some anonymous pages to give them extra
time to be referenced while on the inactive list.

The obvious fix is to make sure that shrink_list does not fall through to
scanning/reclaiming inactive pages when we called it to scan one of the
active lists.

This change should be safe because the loop in shrink_zone ensures that we
will still shrink the anon and file inactive lists whenever we should.

[kosaki.motohiro@jp.fujitsu.com: inactive_file_is_low() should be inactive_anon_is_low()]
Reported-by: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik Theys <rik.theys@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/vmscan.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 777af57..692807f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1464,20 +1464,26 @@ static int inactive_file_is_low(struct zone *zone, struct scan_control *sc)
 	return low;
 }
 
+static int inactive_list_is_low(struct zone *zone, struct scan_control *sc,
+				int file)
+{
+	if (file)
+		return inactive_file_is_low(zone, sc);
+	else
+		return inactive_anon_is_low(zone, sc);
+}
+
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	struct zone *zone, struct scan_control *sc, int priority)
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_FILE && inactive_file_is_low(zone, sc)) {
-		shrink_active_list(nr_to_scan, zone, sc, priority, file);
+	if (is_active_lru(lru)) {
+		if (inactive_list_is_low(zone, sc, file))
+		    shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
 
-	if (lru == LRU_ACTIVE_ANON && inactive_anon_is_low(zone, sc)) {
-		shrink_active_list(nr_to_scan, zone, sc, priority, file);
-		return 0;
-	}
 	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
-- 
1.6.6

