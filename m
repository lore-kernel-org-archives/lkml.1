Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYGDI6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYGDI6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYGDI6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:58:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52081 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYGDI6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:58:21 -0400
Date: Fri, 4 Jul 2008 18:02:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "riel@redhat.com" <riel@redhat.com>
Subject: memcg: lru scan fix (Was: 2.6.26-rc8-mm1
Message-Id: <20080704180226.46436432.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since rc5-mm3, memcg easily goes into OOM when limit was low.
This is a fix to split-lru to fix OOM.

==
Under memcg, active anon tend not to go to inactive anon.
This will cause OOM in memcg easily when tons of anon was used at once.
This check was lacked in split-lru.

Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: test-2.6.26-rc8-mm1/mm/vmscan.c
===================================================================
--- test-2.6.26-rc8-mm1.orig/mm/vmscan.c
+++ test-2.6.26-rc8-mm1/mm/vmscan.c
@@ -1501,6 +1501,8 @@ static unsigned long shrink_zone(int pri
 	 */
 	if (scan_global_lru(sc) && inactive_anon_is_low(zone))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
+	else if (!scan_global_lru(sc))
+		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
 	return nr_reclaimed;

