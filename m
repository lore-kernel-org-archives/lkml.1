Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbZAIWbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbZAIWbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbZAIW3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:29:43 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44840 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbZAIW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:29:39 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 9 Jan 2009 23:28:38 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux1394-devel@lists.sourceforge.net,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>, Greg KH <gregkh@suse.de>
In-Reply-To: <20090109215423.GA7869@suse.de>
Message-ID: <tkrat.8b4396bb1aafd7a5@s5r6.in-berlin.de>
References: <496798FE.8030900@s5r6.in-berlin.de>
 <tkrat.34f28fe71f678057@s5r6.in-berlin.de>
 <20090109211718.48a7a4a6@lxorguk.ukuu.org.uk>
 <20090109215423.GA7869@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  9 Jan, Greg KH wrote:
> On Fri, Jan 09, 2009 at 09:17:18PM +0000, Alan Cox wrote:
>> On Fri, 9 Jan 2009 20:49:37 +0100 (CET)
>> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> 
>> > Due to commit 2831fe6f9cc4e16c103504ee09a47a084297c0f3, "driver core:
>> > create a private portion of struct device", device_initialize() can no
>> > longer be called from atomic contexts.
>> 
>> I don't see why this is neccessary or appropriate - the original commit
>> needs to be pulled and the private area allocation rethought.
> 
> Ugh, I think you're right.  I'll revert this (and all of the patches in
> the series that were needed to get this working properly), and redo the
> patch set, first making device_initialize() able to fail, and auditing
> all callers to make sure it's not being called in atomic context.
> 
> At first glance, I think it's only firewire that is doing this in atomic
> context, so Stefan, I wouldn't mind seeing your patch go in as-is just
> to make things simpler overall.
> 
> I'll go make up the patchset and send them to Linus...

Linus,

please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following change --- as a hotfix for now, and to expand
Greg's options when he sorts device_initialize() out later.

Stefan Richter (1):
      firewire: core: fix sleep in atomic context due to driver core change

 drivers/firewire/fw-card.c   |   13 +++++++------
 drivers/firewire/fw-device.c |   23 +++++++++++++----------
 2 files changed, 20 insertions(+), 16 deletions(-)


commit 6230582320b721e6cf2581d048cb688dca97f504
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Jan 9 20:49:37 2009 +0100

    firewire: core: fix sleep in atomic context due to driver core change
    
    Due to commit 2831fe6f9cc4e16c103504ee09a47a084297c0f3, "driver core:
    create a private portion of struct device", device_initialize() can no
    longer be called from atomic contexts.
    
    We now defer it until after config ROM probing.  This requires changes
    to the bus manager code because this may use a device before it was
    probed.
    
    Reported-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index 799f944..6bd91a1 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -209,6 +209,8 @@ fw_card_bm_work(struct work_struct *work)
 	unsigned long flags;
 	int root_id, new_root_id, irm_id, gap_count, generation, grace, rcode;
 	bool do_reset = false;
+	bool root_device_is_running;
+	bool root_device_is_cmc;
 	__be32 lock_data[2];
 
 	spin_lock_irqsave(&card->lock, flags);
@@ -224,8 +226,9 @@ fw_card_bm_work(struct work_struct *work)
 
 	generation = card->generation;
 	root_device = root_node->data;
-	if (root_device)
-		fw_device_get(root_device);
+	root_device_is_running = root_device &&
+			atomic_read(&root_device->state) == FW_DEVICE_RUNNING;
+	root_device_is_cmc = root_device && root_device->cmc;
 	root_id = root_node->node_id;
 	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 10));
 
@@ -308,14 +311,14 @@ fw_card_bm_work(struct work_struct *work)
 		 * config rom.  In either case, pick another root.
 		 */
 		new_root_id = local_node->node_id;
-	} else if (atomic_read(&root_device->state) != FW_DEVICE_RUNNING) {
+	} else if (!root_device_is_running) {
 		/*
 		 * If we haven't probed this device yet, bail out now
 		 * and let's try again once that's done.
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
 		goto out;
-	} else if (root_device->cmc) {
+	} else if (root_device_is_cmc) {
 		/*
 		 * FIXME: I suppose we should set the cmstr bit in the
 		 * STATE_CLEAR register of this node, as described in
@@ -362,8 +365,6 @@ fw_card_bm_work(struct work_struct *work)
 		fw_core_initiate_bus_reset(card, 1);
 	}
  out:
-	if (root_device)
-		fw_device_put(root_device);
 	fw_node_put(root_node);
 	fw_node_put(local_node);
  out_put_card:
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index c173be3..2af5a8d 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -159,7 +159,8 @@ static void fw_device_release(struct device *dev)
 
 	/*
 	 * Take the card lock so we don't set this to NULL while a
-	 * FW_NODE_UPDATED callback is being handled.
+	 * FW_NODE_UPDATED callback is being handled or while the
+	 * bus manager work looks at this node.
 	 */
 	spin_lock_irqsave(&card->lock, flags);
 	device->node->data = NULL;
@@ -695,12 +696,13 @@ static void fw_device_init(struct work_struct *work)
 		return;
 	}
 
-	err = -ENOMEM;
+	device_initialize(&device->device);
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	if (idr_pre_get(&fw_device_idr, GFP_KERNEL))
-		err = idr_get_new(&fw_device_idr, device, &minor);
+	err = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
+	      idr_get_new(&fw_device_idr, device, &minor) :
+	      -ENOMEM;
 	up_write(&fw_device_rwsem);
 
 	if (err < 0)
@@ -911,13 +913,14 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 
 		/*
 		 * Do minimal intialization of the device here, the
-		 * rest will happen in fw_device_init().  We need the
-		 * card and node so we can read the config rom and we
-		 * need to do device_initialize() now so
-		 * device_for_each_child() in FW_NODE_UPDATED is
-		 * doesn't freak out.
+		 * rest will happen in fw_device_init().
+		 *
+		 * Attention:  A lot of things, even fw_device_get(),
+		 * cannot be done before fw_device_init() finished!
+		 * You can basically just check device->state and
+		 * schedule work until then, but only while holding
+		 * card->lock.
 		 */
-		device_initialize(&device->device);
 		atomic_set(&device->state, FW_DEVICE_INITIALIZING);
 		device->card = fw_card_get(card);
 		device->node = fw_node_get(node);



Thanks,
-- 
Stefan Richter
-=====-==--= ---= -=--=
http://arcgraph.de/sr/

