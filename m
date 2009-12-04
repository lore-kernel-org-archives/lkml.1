Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZLDWAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZLDWAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZLDWAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:00:10 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42263 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbZLDWAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:00:09 -0500
Date: Fri, 4 Dec 2009 16:55:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chunkeey@googlemail.com,
       reinette.chatre@intel.com
Subject: [PATCH] mac80211: fix reorder buffer release
Message-ID: <20091204215555.GC3595@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

My patch "mac80211: correctly place aMPDU RX reorder code"
uses an skb queue for MPDUs that were released from the
buffer. I intentially didn't initialise and use the skb
queue's spinlock, but in this place forgot that the code
variant that doesn't touch the spinlock is needed.

Thanks to Christian Lamparter for quickly spotting the
bug in the backtrace Reinette reported.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Bug-identified-by: Christian Lamparter <chunkeey@googlemail.com>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Dave,

I missed this in today's pull request -- please queue it directly in
your tree!

Thanks,

John

 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-12-03 20:18:21.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-12-03 20:42:50.000000000 +0100
@@ -570,7 +570,7 @@ static void ieee80211_release_reorder_fr
 		rate = &sband->bitrates[status->rate_idx];
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
-	skb_queue_tail(frames, skb);
+	__skb_queue_tail(frames, skb);
 
 no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);


-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
