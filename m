Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbZJNQJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbZJNQJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761952AbZJNQJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:09:47 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51429 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761930AbZJNQJq (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 14 Oct 2009 12:09:46 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [NET PATCH 5/9] venet: cache the ringlen values at init
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 14 Oct 2009 11:59:12 -0400
Message-ID: <20091014155912.18864.83106.stgit@dev.haskins.net>
In-Reply-To: <20091014154457.18864.28382.stgit@dev.haskins.net>
References: <20091014154457.18864.28382.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to prevent the condition where changes to the module-params
could affect the run-time validity of the ringstate

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/net/vbus-enet.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vbus-enet.c b/drivers/net/vbus-enet.c
index 63237f3..fe9eeca 100644
--- a/drivers/net/vbus-enet.c
+++ b/drivers/net/vbus-enet.c
@@ -50,6 +50,7 @@ module_param(sg_enabled, int, 0444);
 struct vbus_enet_queue {
 	struct ioq              *queue;
 	struct ioq_notifier      notifier;
+	unsigned long            count;
 };
 
 struct vbus_enet_priv {
@@ -94,6 +95,8 @@ queue_init(struct vbus_enet_priv *priv,
 		q->queue->notifier = &q->notifier;
 	}
 
+	q->count = ringsize;
+
 	return 0;
 }
 
@@ -222,7 +225,7 @@ tx_setup(struct vbus_enet_priv *priv)
 	/* pre-allocate our descriptor pool if pmtd is enabled */
 	if (priv->pmtd.enabled) {
 		struct vbus_device_proxy *dev = priv->vdev;
-		size_t poollen = len * tx_ringlen;
+		size_t poollen = len * priv->txq.count;
 		char *pool;
 		int shmid;
 
@@ -251,7 +254,7 @@ tx_setup(struct vbus_enet_priv *priv)
 	/*
 	 * Now populate each descriptor with an empty SG descriptor
 	 */
-	for (i = 0; i < tx_ringlen; i++) {
+	for (i = 0; i < priv->txq.count; i++) {
 		struct venet_sg *vsg;
 
 		if (priv->pmtd.enabled) {

