Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbYCYCXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbYCYCXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbYCYCUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:20:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48410 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753537AbYCYCT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:19:58 -0400
Message-Id: <20080325021956.212787000@polaris-admin.engr.sgi.com>
References: <20080325021954.979158000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 24 Mar 2008 19:20:02 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>
Subject: [PATCH 08/10] net: remove NR_CPUS arrays in net/core/dev.c
Content-Disposition: inline; filename=nr_cpus-in-net_core_dev
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the fixed size channels[NR_CPUS] array in
net/core/dev.c and dynamically allocate array based on
nr_cpu_ids.

Based on linux-2.6.25-rc5-mm1

Cc: David S. Miller <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 net/core/dev.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- linux-2.6.25-rc5.orig/net/core/dev.c
+++ linux-2.6.25-rc5/net/core/dev.c
@@ -162,7 +162,7 @@ struct net_dma {
 	struct dma_client client;
 	spinlock_t lock;
 	cpumask_t channel_mask;
-	struct dma_chan *channels[NR_CPUS];
+	struct dma_chan **channels;
 };
 
 static enum dma_state_client
@@ -2448,7 +2448,7 @@ static struct netif_rx_stats *softnet_ge
 {
 	struct netif_rx_stats *rc = NULL;
 
-	while (*pos < NR_CPUS)
+	while (*pos < nr_cpu_ids)
 		if (cpu_online(*pos)) {
 			rc = &per_cpu(netdev_rx_stat, *pos);
 			break;
@@ -4320,7 +4320,7 @@ netdev_dma_event(struct dma_client *clie
 	spin_lock(&net_dma->lock);
 	switch (state) {
 	case DMA_RESOURCE_AVAILABLE:
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < nr_cpu_ids; i++)
 			if (net_dma->channels[i] == chan) {
 				found = 1;
 				break;
@@ -4335,7 +4335,7 @@ netdev_dma_event(struct dma_client *clie
 		}
 		break;
 	case DMA_RESOURCE_REMOVED:
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < nr_cpu_ids; i++)
 			if (net_dma->channels[i] == chan) {
 				found = 1;
 				pos = i;
@@ -4362,6 +4362,13 @@ netdev_dma_event(struct dma_client *clie
  */
 static int __init netdev_dma_register(void)
 {
+	net_dma.channels = kzalloc(nr_cpu_ids * sizeof(struct net_dma),
+								GFP_KERNEL);
+	if (unlikely(net_dma.channels)) {
+		printk(KERN_NOTICE
+				"netdev_dma: no memory for net_dma.channels\n");
+		return -ENOMEM;
+	}
 	spin_lock_init(&net_dma.lock);
 	dma_cap_set(DMA_MEMCPY, net_dma.client.cap_mask);
 	dma_async_client_register(&net_dma.client);

-- 
