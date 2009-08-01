Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbZHATug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbZHATug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 15:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZHATuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 15:50:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54103 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZHATud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 15:50:33 -0400
Date: Sat, 1 Aug 2009 21:50:31 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/net/wireless: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908012149570.25693@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/strip.c        |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/strip.c b/drivers/net/wireless/strip.c
index 73300c2..8eabb56 100644
--- a/drivers/net/wireless/strip.c
+++ b/drivers/net/wireless/strip.c
@@ -1550,9 +1550,12 @@ static int strip_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (time_after(jiffies, strip_info->pps_timer + HZ)) {
 		unsigned long t = jiffies - strip_info->pps_timer;
-		unsigned long rx_pps_count = (strip_info->rx_pps_count * HZ * 8 + t / 2) / t;
-		unsigned long tx_pps_count = (strip_info->tx_pps_count * HZ * 8 + t / 2) / t;
-		unsigned long sx_pps_count = (strip_info->sx_pps_count * HZ * 8 + t / 2) / t;
+		unsigned long rx_pps_count =
+			DIV_ROUND_CLOSEST(strip_info->rx_pps_count*HZ*8, t);
+		unsigned long tx_pps_count =
+			DIV_ROUND_CLOSEST(strip_info->tx_pps_count*HZ*8, t);
+		unsigned long sx_pps_count =
+			DIV_ROUND_CLOSEST(strip_info->sx_pps_count*HZ*8, t);
 
 		strip_info->pps_timer = jiffies;
 		strip_info->rx_pps_count = 0;
