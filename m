Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYKCVDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYKCVDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYKCVDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:03:07 -0500
Received: from mail.vyatta.com ([76.74.103.46]:40396 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbYKCVDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:03:06 -0500
Date: Mon, 3 Nov 2008 13:03:03 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: increase receive packet quantum
Message-ID: <20081103130303.29dd4e21@extreme>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets about 1.25% back on tbench regression.

My change to NAPI for multiqueue support changed the time limit on
network receive processing.  Under sustained loads like tbench, this
can cause the receiver to reschedule prematurely. 

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/net/core/dev.c	2008-11-03 11:11:44.000000000 -0800
+++ b/net/core/dev.c	2008-11-03 11:16:07.000000000 -0800
@@ -2373,7 +2373,7 @@ EXPORT_SYMBOL(__napi_schedule);
 static void net_rx_action(struct softirq_action *h)
 {
 	struct list_head *list = &__get_cpu_var(softnet_data).poll_list;
-	unsigned long start_time = jiffies;
+	unsigned long time_limit = jiffies + 2;
 	int budget = netdev_budget;
 	void *have;
 
@@ -2384,13 +2384,10 @@ static void net_rx_action(struct softirq
 		int work, weight;
 
 		/* If softirq window is exhuasted then punt.
-		 *
-		 * Note that this is a slight policy change from the
-		 * previous NAPI code, which would allow up to 2
-		 * jiffies to pass before breaking out.  The test
-		 * used to be "jiffies - start_time > 1".
+		 * Allow this to run for 2 jiffies since which will allow
+		 * an average latency of 1.5/HZ.
 		 */
-		if (unlikely(budget <= 0 || jiffies != start_time))
+		if (unlikely(budget <= 0 || time_after(jiffies, time_limit)))
 			goto softnet_break;
 
 		local_irq_enable();
