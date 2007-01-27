Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbXA0JfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbXA0JfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 04:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXA0JfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 04:35:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34303 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXA0JfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 04:35:17 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 27 Jan 2007 10:34:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: In-tree version of new FireWire drivers available
To: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
       Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <20070126233911.7ebf96ac.akpm@osdl.org>
Message-ID: <tkrat.7c1b8fcba7cb70ac@s5r6.in-berlin.de>
References: <59ad55d30701231948u5f1e02d8x3d06553cb373e5be@mail.gmail.com>
 <20070126233911.7ebf96ac.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 Jan, Andrew Morton wrote:
> arm:
> 
> drivers/firewire/fw-device.c: In function `fw_device_init':
> drivers/firewire/fw-device.c:495: warning: implicit declaration of function `cmpxchg'                                                                           
> 
> We can't use cmpxchg in generic code.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: use atomic type for fw_device.state

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c   |    2 +-
 drivers/firewire/fw-device.c |    6 +++---
 drivers/firewire/fw-device.h |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.20-rc5/drivers/firewire/fw-device.h
===================================================================
--- linux-2.6.20-rc5.orig/drivers/firewire/fw-device.h
+++ linux-2.6.20-rc5/drivers/firewire/fw-device.h
@@ -24,6 +24,7 @@
 
 #include <linux/fs.h>
 #include <linux/cdev.h>
+#include <asm/atomic.h>
 
 enum fw_device_state {
 	FW_DEVICE_INITIALIZING,
@@ -32,7 +33,7 @@ enum fw_device_state {
 };
 
 struct fw_device {
-	int state;
+	atomic_t state;
 	struct fw_node *node;
 	int node_id;
 	int generation;
Index: linux-2.6.20-rc5/drivers/firewire/fw-device.c
===================================================================
--- linux-2.6.20-rc5.orig/drivers/firewire/fw-device.c
+++ linux-2.6.20-rc5/drivers/firewire/fw-device.c
@@ -494,7 +494,7 @@ static void fw_device_init(struct work_s
 	 * necessary.  We have to use the atomic cmpxchg here to avoid
 	 * racing with the FW_NODE_DESTROYED case in
 	 * fw_node_event(). */
-	if (cmpxchg(&device->state,
+	if (atomic_cmpxchg(&device->state,
 		    FW_DEVICE_INITIALIZING,
 		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
 		fw_device_shutdown(&device->work.work);
@@ -551,7 +551,7 @@ void fw_node_event(struct fw_card *card,
 		 * device_for_each_child() in FW_NODE_UPDATED is
 		 * doesn't freak out. */
 		device_initialize(&device->device);
-		device->state = FW_DEVICE_INITIALIZING;
+		atomic_set(&device->state, FW_DEVICE_INITIALIZING);
 		device->card = fw_card_get(card);
 		device->node = fw_node_get(node);
 		device->node_id = node->node_id;
@@ -596,7 +596,7 @@ void fw_node_event(struct fw_card *card,
 		 * the device in shutdown state to have that code fail
 		 * to create the device. */
 		device = node->data;
-		if (xchg(&device->state,
+		if (atomic_xchg(&device->state,
 			 FW_DEVICE_SHUTDOWN) == FW_DEVICE_RUNNING) {
 			INIT_DELAYED_WORK(&device->work, fw_device_shutdown);
 			schedule_delayed_work(&device->work, 0);
Index: linux-2.6.20-rc5/drivers/firewire/fw-card.c
===================================================================
--- linux-2.6.20-rc5.orig/drivers/firewire/fw-card.c
+++ linux-2.6.20-rc5/drivers/firewire/fw-card.c
@@ -302,7 +302,7 @@ fw_card_bm_work(struct work_struct *work
 		/* Either link_on is false, or we failed to read the
 		 * config rom.  In either case, pick another root. */
 		new_root_id = card->local_node->node_id;
-	} else if (root->state != FW_DEVICE_RUNNING) {
+	} else if (atomic_read(&root->state) != FW_DEVICE_RUNNING) {
 		/* If we haven't probed this device yet, bail out now
 		 * and let's try again once that's done. */
 		spin_unlock_irqrestore(&card->lock, flags);


-- 
Stefan Richter
-=====-=-=== ---= ==-==
http://arcgraph.de/sr/

