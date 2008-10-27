Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYJ0Q0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYJ0Q0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYJ0Q0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:26:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45516 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYJ0QZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:25:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 Oct 2008 17:25:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.fdc0f1418123ab98@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following FireWire subsystem updates.  They fix long-
standing bugs, among them a quite visible panic.  It's very new stuff
but stress-tested.

Jay Fenlason (4):
      firewire: Survive more than 256 bus resets
      firewire: fix struct fw_node memory leak
      firewire: fw-ohci: don't leak dma memory on module removal
      firewire: fw-sbp2: fix races

Stefan Richter (2):
      firewire: fw-ohci: initialization failure path fixes
      firewire: fw-sbp2: delay first login to avoid retries

 drivers/firewire/fw-ohci.c        |   50 +++++++++++++++++++++++-----
 drivers/firewire/fw-sbp2.c        |   38 +++++++++++++++------
 drivers/firewire/fw-topology.c    |    6 ++-
 drivers/firewire/fw-transaction.h |    2 +-
 4 files changed, 73 insertions(+), 23 deletions(-)


commit cd1f70fdb4823c97328a1f151f328eb36fafd579
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Fri Oct 24 15:26:20 2008 -0400

    firewire: fw-sbp2: fix races
    
    1: There is a small race between queue_delayed_work() and its
       corresponding kref_get().  Do the kref_get first, and _put it again
       if the queue_delayed_work() failed, so there is no chance of the
       kref going to zero while the work is scheduled.
    2: An SBP2_LOGOUT_REQUEST could be sent out with a login_id full of
       garbage.  Initialize it to an invalid value so we can tell if we
       ever got a valid login_id.
    3: The node ID and generation may have changed but the new values may
       not yet have been recorded in lu and tgt when the final logout is
       attempted.  Use the latest values from the device in
       sbp2_release_target().
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 17bf0e1..d334cac 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -173,6 +173,9 @@ struct sbp2_target {
 	int blocked;	/* ditto */
 };
 
+/* Impossible login_id, to detect logout attempt before successful login */
+#define INVALID_LOGIN_ID 0x10000
+
 /*
  * Per section 7.4.8 of the SBP-2 spec, a mgt_ORB_timeout value can be
  * provided in the config rom. Most devices do provide a value, which
@@ -788,9 +791,20 @@ static void sbp2_release_target(struct kref *kref)
 			scsi_remove_device(sdev);
 			scsi_device_put(sdev);
 		}
-		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
-				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
-
+		if (lu->login_id != INVALID_LOGIN_ID) {
+			int generation, node_id;
+			/*
+			 * tgt->node_id may be obsolete here if we failed
+			 * during initial login or after a bus reset where
+			 * the topology changed.
+			 */
+			generation = device->generation;
+			smp_rmb(); /* node_id vs. generation */
+			node_id    = device->node_id;
+			sbp2_send_management_orb(lu, node_id, generation,
+						 SBP2_LOGOUT_REQUEST,
+						 lu->login_id, NULL);
+		}
 		fw_core_remove_address_handler(&lu->address_handler);
 		list_del(&lu->link);
 		kfree(lu);
@@ -805,19 +819,20 @@ static void sbp2_release_target(struct kref *kref)
 
 static struct workqueue_struct *sbp2_wq;
 
+static void sbp2_target_put(struct sbp2_target *tgt)
+{
+	kref_put(&tgt->kref, sbp2_release_target);
+}
+
 /*
  * Always get the target's kref when scheduling work on one its units.
  * Each workqueue job is responsible to call sbp2_target_put() upon return.
  */
 static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
 {
-	if (queue_delayed_work(sbp2_wq, &lu->work, delay))
-		kref_get(&lu->tgt->kref);
-}
-
-static void sbp2_target_put(struct sbp2_target *tgt)
-{
-	kref_put(&tgt->kref, sbp2_release_target);
+	kref_get(&lu->tgt->kref);
+	if (!queue_delayed_work(sbp2_wq, &lu->work, delay))
+		sbp2_target_put(lu->tgt);
 }
 
 /*
@@ -978,6 +993,7 @@ static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 
 	lu->tgt      = tgt;
 	lu->lun      = lun_entry & 0xffff;
+	lu->login_id = INVALID_LOGIN_ID;
 	lu->retries  = 0;
 	lu->has_sdev = false;
 	lu->blocked  = false;

commit 0dcfeb7e3c8695c5aa3677dda8efb9bef2e7e64d
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Oct 22 00:28:36 2008 +0200

    firewire: fw-sbp2: delay first login to avoid retries
    
    This optimizes firewire-sbp2's device probe for the case that the local
    node and the SBP-2 node were discovered at the same time.  In this case,
    fw-core's bus management work and fw-sbp2's login and SCSI probe work
    are scheduled in parallel (in the globally shared workqueue and in
    fw-sbp2's workqueue, respectively).  The bus reset from fw-core may then
    disturb and extremely delay the login and SCSI probe because the latter
    fails with several command timeouts and retries and has to be retried
    from scratch.
    
    We avoid this particular situation of sbp2_login() and fw_card_bm_work()
    running in parallel by delaying the first sbp2_login() a little bit.
    
    This is meant to be a short-term fix for
    https://bugzilla.redhat.com/show_bug.cgi?id=466679.  In the long run,
    the SCSI probe, i.e. fw-sbp2's call of __scsi_add_device(), should be
    parallelized with sbp2_reconnect().
    
    Problem reported and fix tested and confirmed by Alex Kanavin.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index ef0b9b4..17bf0e1 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1147,7 +1147,7 @@ static int sbp2_probe(struct device *dev)
 
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
-		sbp2_queue_work(lu, 0);
+		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 	return 0;
 
  fail_tgt_put:

commit 7007a0765e33bf89182e069e35ec6009fa54f610
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Oct 26 09:50:31 2008 +0100

    firewire: fw-ohci: initialization failure path fixes
    
    Fix leaks when pci_probe fails.  Simplify error log strings.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 5a5685f..8e16bfb 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -2365,8 +2365,8 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
 	if (ohci == NULL) {
-		fw_error("Could not malloc fw_ohci data.\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto fail;
 	}
 
 	fw_card_initialize(&ohci->card, &ohci_driver, &dev->dev);
@@ -2375,7 +2375,7 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 
 	err = pci_enable_device(dev);
 	if (err) {
-		fw_error("Failed to enable OHCI hardware.\n");
+		fw_error("Failed to enable OHCI hardware\n");
 		goto fail_free;
 	}
 
@@ -2443,9 +2443,8 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 	ohci->ir_context_list = kzalloc(size, GFP_KERNEL);
 
 	if (ohci->it_context_list == NULL || ohci->ir_context_list == NULL) {
-		fw_error("Out of memory for it/ir contexts.\n");
 		err = -ENOMEM;
-		goto fail_registers;
+		goto fail_contexts;
 	}
 
 	/* self-id dma buffer allocation */
@@ -2454,9 +2453,8 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 					       &ohci->self_id_bus,
 					       GFP_KERNEL);
 	if (ohci->self_id_cpu == NULL) {
-		fw_error("Out of memory for self ID buffer.\n");
 		err = -ENOMEM;
-		goto fail_registers;
+		goto fail_contexts;
 	}
 
 	bus_options = reg_read(ohci, OHCI1394_BusOptions);
@@ -2476,9 +2474,13 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
  fail_self_id:
 	dma_free_coherent(ohci->card.device, SELF_ID_BUF_SIZE,
 			  ohci->self_id_cpu, ohci->self_id_bus);
- fail_registers:
-	kfree(ohci->it_context_list);
+ fail_contexts:
 	kfree(ohci->ir_context_list);
+	kfree(ohci->it_context_list);
+	context_release(&ohci->at_response_ctx);
+	context_release(&ohci->at_request_ctx);
+	ar_context_release(&ohci->ar_response_ctx);
+	ar_context_release(&ohci->ar_request_ctx);
 	pci_iounmap(dev, ohci->registers);
  fail_iomem:
 	pci_release_region(dev, 0);
@@ -2487,6 +2489,9 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
  fail_free:
 	kfree(&ohci->card);
 	ohci_pmac_off(dev);
+ fail:
+	if (err == -ENOMEM)
+		fw_error("Out of memory\n");
 
 	return err;
 }

commit a55709ba9d27053471f9fca8ee76b41ecefc14cd
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Wed Oct 22 15:59:42 2008 -0400

    firewire: fw-ohci: don't leak dma memory on module removal
    
    The transmit and receive context dma memory was not being freed on
    module removal.  Neither was the config rom memory.  Fix that.
    
    The ab->next assignment is pure paranoia.
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 251416f..5a5685f 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -476,6 +476,7 @@ static int ar_context_add_page(struct ar_context *ctx)
 	if (ab == NULL)
 		return -ENOMEM;
 
+	ab->next = NULL;
 	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
 	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
 						    DESCRIPTOR_STATUS |
@@ -496,6 +497,21 @@ static int ar_context_add_page(struct ar_context *ctx)
 	return 0;
 }
 
+static void ar_context_release(struct ar_context *ctx)
+{
+	struct ar_buffer *ab, *ab_next;
+	size_t offset;
+	dma_addr_t ab_bus;
+
+	for (ab = ctx->current_buffer; ab; ab = ab_next) {
+		ab_next = ab->next;
+		offset = offsetof(struct ar_buffer, data);
+		ab_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
+		dma_free_coherent(ctx->ohci->card.device, PAGE_SIZE,
+				  ab, ab_bus);
+	}
+}
+
 #if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
 #define cond_le32_to_cpu(v) \
 	(ohci->old_uninorth ? (__force __u32)(v) : le32_to_cpu(v))
@@ -2491,8 +2507,19 @@ static void pci_remove(struct pci_dev *dev)
 
 	software_reset(ohci);
 	free_irq(dev->irq, ohci);
+
+	if (ohci->next_config_rom && ohci->next_config_rom != ohci->config_rom)
+		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+				  ohci->next_config_rom, ohci->next_config_rom_bus);
+	if (ohci->config_rom)
+		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
+				  ohci->config_rom, ohci->config_rom_bus);
 	dma_free_coherent(ohci->card.device, SELF_ID_BUF_SIZE,
 			  ohci->self_id_cpu, ohci->self_id_bus);
+	ar_context_release(&ohci->ar_request_ctx);
+	ar_context_release(&ohci->ar_response_ctx);
+	context_release(&ohci->at_request_ctx);
+	context_release(&ohci->at_response_ctx);
 	kfree(ohci->it_context_list);
 	kfree(ohci->ir_context_list);
 	pci_iounmap(dev, ohci->registers);

commit 77e557191701afa55ae7320d42ad6458a2ad292e
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Thu Oct 16 18:00:15 2008 -0400

    firewire: fix struct fw_node memory leak
    
    With the bus_resets patch applied, it is easy to see this memory leak
    by repeatedly resetting the firewire bus while running slabtop in
    another window.  Just watch kmalloc-32 grow and grow...
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/fw-topology.c
index c1b8107..5e20471 100644
--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -413,7 +413,7 @@ static void
 update_tree(struct fw_card *card, struct fw_node *root)
 {
 	struct list_head list0, list1;
-	struct fw_node *node0, *node1;
+	struct fw_node *node0, *node1, *next1;
 	int i, event;
 
 	INIT_LIST_HEAD(&list0);
@@ -485,7 +485,9 @@ update_tree(struct fw_card *card, struct fw_node *root)
 		}
 
 		node0 = fw_node(node0->link.next);
-		node1 = fw_node(node1->link.next);
+		next1 = fw_node(node1->link.next);
+		fw_node_put(node1);
+		node1 = next1;
 	}
 }
 

commit 4f9740d4f5a17fa6a1b097fa3ccdfb7246660307
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Thu Oct 16 15:51:59 2008 -0400

    firewire: Survive more than 256 bus resets
    
    The "color" is used during the topology building after a bus reset,
    hovever in "struct fw_node"s it is stored in a u8, but in struct fw_card
    it is stored in an int.  When the value wraps in one struct, but not
    the other, disaster strikes.
    
    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    
    Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10922.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-transaction.h b/drivers/firewire/fw-transaction.h
index 027f58c..aed7dbb 100644
--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -248,7 +248,7 @@ struct fw_card {
 	struct fw_node *local_node;
 	struct fw_node *root_node;
 	struct fw_node *irm_node;
-	int color;
+	u8 color; /* must be u8 to match the definition in struct fw_node */
 	int gap_count;
 	bool beta_repeaters_present;
 


Thanks,
-- 
Stefan Richter
-=====-==--- =-=- ==-==
http://arcgraph.de/sr/

