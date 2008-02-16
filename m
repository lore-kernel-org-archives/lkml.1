Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYBPPi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYBPPi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbYBPPis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:38:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36184 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbYBPPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:38:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Feb 2008 16:37:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 9/9] firewire: fw-sbp2: fix I/O errors during reconnect
To: Jarod Wilson <jwilson@redhat.com>, Kristian Hoegsberg <krh@bitplanet.net>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <47B0AE54.8090602@s5r6.in-berlin.de>
Message-ID: <tkrat.40f086463eb9e187@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
 <tkrat.8110272bacc3f714@s5r6.in-berlin.de> <47B08F6B.2020502@redhat.com>
 <47B0AE54.8090602@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Jarod Wilson wrote:
>> Stefan Richter wrote:
>>> +static void sbp2_conditionally_block(struct sbp2_logical_unit *lu)
>>> +{
>>> +    struct fw_card *card =
>>> fw_device(lu->tgt->unit->device.parent)->card;
>>> +
>>> +    if (!atomic_read(&lu->tgt->dont_block) &&
>>> +        lu->generation != card->generation &&
>>> +        atomic_cmpxchg(&lu->blocked, 0, 1) == 0) {
>> 
>> Just to be absolutely sure, we don't need any barriers here to ensure we
>> get the right generations, do we?
> 
> I didn't think so.  But I will carefully look at it again later this
> week.  The function definitely must not block the device when the
> generation is current.  We look at two data fields here which makes this
> even more problematic.  Could be that we need locks after all.

My lockless juggling with six variables was indeed broken.  Who would
have expected that.  So here is an update, also with a more realistic
patch title.

Without the patch, _all_ ongoing I/O during bus resets will _always_
fail.  With the patch, a lot but sadly not all I/O will survive.  But at
least this stuff is enough of an improvement while not too invasive to
be considered for upstream inclusion in a later 2.6.25-rc.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: fw-sbp2: (try to) avoid I/O errors during reconnect

While fw-sbp2 takes the necessary time to reconnect to a logical unit
after bus reset, the SCSI core keeps sending new commands.  They are all
immediately completed with host busy status, and application clients or
filesystems will break quickly.  The SCSI device might even be taken
offline:  http://bugzilla.kernel.org/show_bug.cgi?id=9734

The only remedy seems to be to block the SCSI device until reconnect.
Alas the SCSI core has no useful API to block only one logical unit i.e.
the scsi_device, therefore we block the entire Scsi_Host.  This
currently corresponds to an SBP-2 target.  In case of targets with
multiple logical units, we need to satisfy the dependencies between
logical units by carefully tracking the blocking state of the target and
its units.  We block all logical units of a target as soon as one of
them needs to be blocked, and keep them blocked until all of them are
ready to be unblocked.

Furthermore, as the history of the old sbp2 driver has shown, the
scsi_block_requests() API is a minefield with high potential of
deadlocks.  We therefore take extra measures to keep logical units
unblocked during __scsi_add_device() and during shutdown.

This avoids I/O errors during reconnect in many but alas not in all
cases.  There may still be errors after a re-login had to be performed.
Also, some bridges have been seen to cease fetching management ORBs if
I/O went on up until a bus reset.  In these cases, all management ORBs
time out after mgt_orb_timeout.  The old sbp2 driver is less vulnerable
or maybe not vulnerable to this, for as yet unknown reasons.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:
  - included patch "firewire: fw-sbp2: preemptively block sdev"
  - converted from lockless to spinlock protected accesses due to too
    many interdependencies
  - updated patch description WRT how well the fix works.

 drivers/firewire/fw-sbp2.c |  126 +++++++++++++++++++++++++++++++++++--
 1 file changed, 122 insertions(+), 4 deletions(-)

Index: linux-2.6.25-rc1/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.25-rc1.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.25-rc1/drivers/firewire/fw-sbp2.c
@@ -139,6 +139,7 @@ struct sbp2_logical_unit {
 	int generation;
 	int retries;
 	struct delayed_work work;
+	bool blocked;
 };
 
 /*
@@ -157,6 +158,9 @@ struct sbp2_target {
 	int address_high;
 	unsigned int workarounds;
 	unsigned int mgt_orb_timeout;
+
+	int dont_block;	/* counter for each logical unit */
+	int blocked;	/* ditto */
 };
 
 /*
@@ -646,6 +650,107 @@ static void sbp2_agent_reset_no_wait(str
 			&z, sizeof(z), complete_agent_reset_write_no_wait, t);
 }
 
+static void sbp2_set_generation(struct sbp2_logical_unit *lu, int generation)
+{
+	struct fw_card *card = fw_device(lu->tgt->unit->device.parent)->card;
+	unsigned long flags;
+
+	/* serialize with comparisons of lu->generation and card->generation */
+	spin_lock_irqsave(&card->lock, flags);
+	lu->generation = generation;
+	spin_unlock_irqrestore(&card->lock, flags);
+}
+
+static inline void sbp2_allow_block(struct sbp2_logical_unit *lu)
+{
+	/*
+	 * We may access dont_block without taking card->lock here:
+	 * All callers of sbp2_allow_block() and all callers of sbp2_unblock()
+	 * are currently serialized against each other.
+	 * And a wrong result in sbp2_conditionally_block()'s access of
+	 * dont_block is rather harmless, it simply misses its first chance.
+	 */
+	--lu->tgt->dont_block;
+}
+
+/*
+ * Blocks lu->tgt if all of the following conditions are met:
+ *   - Login, INQUIRY, and high-level SCSI setup of all of the target's
+ *     logical units have been finished (indicated by dont_block == 0).
+ *   - lu->generation is stale.
+ *
+ * Note, scsi_block_requests() must be called while holding card->lock,
+ * otherwise it might foil sbp2_[conditionally_]unblock()'s attempt to
+ * unblock the target.
+ */
+static void sbp2_conditionally_block(struct sbp2_logical_unit *lu)
+{
+	struct sbp2_target *tgt = lu->tgt;
+	struct fw_card *card = fw_device(tgt->unit->device.parent)->card;
+	struct Scsi_Host *shost =
+		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+	unsigned long flags;
+
+	spin_lock_irqsave(&card->lock, flags);
+	if (!tgt->dont_block && !lu->blocked &&
+	    lu->generation != card->generation) {
+		lu->blocked = true;
+		if (++tgt->blocked == 1) {
+			scsi_block_requests(shost);
+			fw_notify("blocked %s\n", lu->tgt->bus_id);
+		}
+	}
+	spin_unlock_irqrestore(&card->lock, flags);
+}
+
+/*
+ * Unblocks lu->tgt as soon as all its logical units can be unblocked.
+ * Note, it is harmless to run scsi_unblock_requests() outside the
+ * card->lock protected section.  On the other hand, running it inside
+ * the section might clash with shost->host_lock.
+ */
+static void sbp2_conditionally_unblock(struct sbp2_logical_unit *lu)
+{
+	struct sbp2_target *tgt = lu->tgt;
+	struct fw_card *card = fw_device(tgt->unit->device.parent)->card;
+	struct Scsi_Host *shost =
+		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+	unsigned long flags;
+	bool unblock = false;
+
+	spin_lock_irqsave(&card->lock, flags);
+	if (lu->blocked && lu->generation == card->generation) {
+		lu->blocked = false;
+		unblock = --tgt->blocked == 0;
+	}
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	if (unblock) {
+		scsi_unblock_requests(shost);
+		fw_notify("unblocked %s\n", lu->tgt->bus_id);
+	}
+}
+
+/*
+ * Prevents future blocking of tgt and unblocks it.
+ * Note, it is harmless to run scsi_unblock_requests() outside the
+ * card->lock protected section.  On the other hand, running it inside
+ * the section might clash with shost->host_lock.
+ */
+static void sbp2_unblock(struct sbp2_target *tgt)
+{
+	struct fw_card *card = fw_device(tgt->unit->device.parent)->card;
+	struct Scsi_Host *shost =
+		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+	unsigned long flags;
+
+	spin_lock_irqsave(&card->lock, flags);
+	++tgt->dont_block;
+	spin_unlock_irqrestore(&card->lock, flags);
+
+	scsi_unblock_requests(shost);
+}
+
 static void sbp2_release_target(struct kref *kref)
 {
 	struct sbp2_target *tgt = container_of(kref, struct sbp2_target, kref);
@@ -653,6 +758,9 @@ static void sbp2_release_target(struct k
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 
+	/* prevent deadlocks */
+	sbp2_unblock(tgt);
+
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
 		if (lu->sdev)
 			scsi_remove_device(lu->sdev);
@@ -717,17 +825,20 @@ static void sbp2_login(struct work_struc
 
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
-		if (lu->retries++ < 5)
+		if (lu->retries++ < 5) {
 			sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
-		else
+		} else {
 			fw_error("%s: failed to login to LUN %04x\n",
 				 tgt->bus_id, lu->lun);
+			/* Let any waiting I/O fail from now on. */
+			sbp2_unblock(lu->tgt);
+		}
 		goto out;
 	}
 
-	lu->generation    = generation;
 	tgt->node_id	  = node_id;
 	tgt->address_high = local_node_id << 16;
+	sbp2_set_generation(lu, generation);
 
 	/* Get command block agent offset and login id. */
 	lu->command_block_agent_address =
@@ -749,6 +860,7 @@ static void sbp2_login(struct work_struc
 	/* This was a re-login. */
 	if (lu->sdev) {
 		sbp2_cancel_orbs(lu);
+		sbp2_conditionally_unblock(lu);
 		goto out;
 	}
 
@@ -785,6 +897,7 @@ static void sbp2_login(struct work_struc
 
 	/* No error during __scsi_add_device() */
 	lu->sdev = sdev;
+	sbp2_allow_block(lu);
 	goto out;
 
  out_logout_login:
@@ -825,6 +938,8 @@ static int sbp2_add_logical_unit(struct 
 	lu->sdev = NULL;
 	lu->lun  = lun_entry & 0xffff;
 	lu->retries = 0;
+	lu->blocked = false;
+	++tgt->dont_block;
 	INIT_LIST_HEAD(&lu->orb_list);
 	INIT_DELAYED_WORK(&lu->work, sbp2_login);
 
@@ -1041,15 +1156,16 @@ static void sbp2_reconnect(struct work_s
 		goto out;
 	}
 
-	lu->generation    = generation;
 	tgt->node_id      = node_id;
 	tgt->address_high = local_node_id << 16;
+	sbp2_set_generation(lu, generation);
 
 	fw_notify("%s: reconnected to LUN %04x (%d retries)\n",
 		  tgt->bus_id, lu->lun, lu->retries);
 
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
+	sbp2_conditionally_unblock(lu);
  out:
 	sbp2_target_put(tgt);
 }
@@ -1066,6 +1182,7 @@ static void sbp2_update(struct fw_unit *
 	 * Iteration over tgt->lu_list is therefore safe here.
 	 */
 	list_for_each_entry(lu, &tgt->lu_list, link) {
+		sbp2_conditionally_block(lu);
 		lu->retries = 0;
 		sbp2_queue_work(lu, 0);
 	}
@@ -1169,6 +1286,7 @@ complete_command_orb(struct sbp2_orb *ba
 		 * or when sending the write (less likely).
 		 */
 		result = DID_BUS_BUSY << 16;
+		sbp2_conditionally_block(orb->lu);
 	}
 
 	dma_unmap_single(device->card->device, orb->base.request_bus,

-- 
Stefan Richter
-=====-==--- --=- =----
http://arcgraph.de/sr/

