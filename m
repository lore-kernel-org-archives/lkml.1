Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYGNH7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYGNH7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbYGNH7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:59:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43150 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYGNH7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:59:04 -0400
Date: Mon, 14 Jul 2008 17:03:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "riel@redhat.com" <riel@redhat.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [-mm][PATCH][resend] split-lru-memcg page reclaim active anon fix
 v2
Message-Id: <20080714170359.31198aef.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under memcg, active anon tend not to go to inactive anon under split-lru vmscan.
Because this check was lacked in split-lru.
Without this, we see OOM under memcg too often.

This patch is a fix agaisnt
vmscan-second-chance-replacement-for-anonymous-pages.patch


Changelog: v1 -> v2:
 - clean up and avoid adding "else".

Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc8-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/mm/vmscan.c
+++ linux-2.6.26-rc8-mm1/mm/vmscan.c
@@ -1499,7 +1499,7 @@ static unsigned long shrink_zone(int pri
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (scan_global_lru(sc) && inactive_anon_is_low(zone))
+	if (!scan_global_lru(sc) || inactive_anon_is_low(zone))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);

