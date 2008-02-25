Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYBYSBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYBYSBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYBYSBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:01:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37052 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbYBYSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:01:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 25 Feb 2008 19:00:46 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
Message-ID: <tkrat.5551e6e357b9dcd6@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
 <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
 <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following updates for the firewire and the ieee1394
> subsystems.
... 
>  Documentation/debugging-via-ohci1394.txt |   17 +-
>  drivers/firewire/fw-cdev.c               |   17 +-
>  drivers/firewire/fw-device.c             |   48 ++-
>  drivers/firewire/fw-device.h             |    2 +-
>  drivers/firewire/fw-sbp2.c               |  358 +++++++++++++++++-----
>  drivers/ieee1394/sbp2.c                  |   15 +
>  drivers/ieee1394/sbp2.h                  |    2 +
>  7 files changed, 350 insertions(+), 109 deletions(-)
> 
> Stefan Richter (19):
>       firewire: fw-sbp2: unsigned int vs. unsigned
>       firewire: fw-sbp2: fix logout before login retry
>       firewire: fix "kobject_add failed for fw* with -EEXIST"
>       firewire: fw-sbp2: don't retry login or reconnect after unplug
>       firewire: log GUID of new devices
>       firewire: fw-sbp2: add INQUIRY delay workaround
>       ieee1394: sbp2: add INQUIRY delay workaround
>       firewire: fw-sbp2: wait for completion of fetch agent reset
>       firewire: fw-sbp2: log bus_id at management request failures
>       firewire: fw-sbp2: don't add scsi_device twice
>       firewire: fw-sbp2: logout and login after failed reconnect
>       firewire: fw-sbp2: sort includes
>       firewire: fw-sbp2: enforce a retry of __scsi_add_device if bus generation changed
>       firewire: fw-sbp2: (try to) avoid I/O errors during reconnect
>       firewire: fw-sbp2: fix NULL pointer deref. in slave_alloc
>       firewire: fw-sbp2: fix NULL pointer deref. in scsi_remove_device
>       ieee1394: sbp2: fix rescan-scsi-bus
>       Documentation: correction to debugging-via-ohci1394
>       firewire: fix NULL pointer deref. and resource leak


commit fae603121428ba83b7343c88e68a7144525ab3eb
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Feb 20 21:10:06 2008 +0100

    firewire: fix NULL pointer deref. and resource leak
    
    By supplying ioctl()s in the wrong order, a userspace client was able to
    trigger NULL pointer dereferences.  Furthermore, by calling
    ioctl_create_iso_context more than once, new contexts could be created
    without ever freeing the previously created contexts.
    
    Thanks to Anders Blomdell for the report.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 44ccee2..46bc197 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -646,6 +646,10 @@ static int ioctl_create_iso_context(struct client *client, void *buffer)
 	struct fw_cdev_create_iso_context *request = buffer;
 	struct fw_iso_context *context;
 
+	/* We only support one context at this time. */
+	if (client->iso_context != NULL)
+		return -EBUSY;
+
 	if (request->channel > 63)
 		return -EINVAL;
 
@@ -792,8 +796,9 @@ static int ioctl_start_iso(struct client *client, void *buffer)
 {
 	struct fw_cdev_start_iso *request = buffer;
 
-	if (request->handle != 0)
+	if (client->iso_context == NULL || request->handle != 0)
 		return -EINVAL;
+
 	if (client->iso_context->type == FW_ISO_CONTEXT_RECEIVE) {
 		if (request->tags == 0 || request->tags > 15)
 			return -EINVAL;
@@ -810,7 +815,7 @@ static int ioctl_stop_iso(struct client *client, void *buffer)
 {
 	struct fw_cdev_stop_iso *request = buffer;
 
-	if (request->handle != 0)
+	if (client->iso_context == NULL || request->handle != 0)
 		return -EINVAL;
 
 	return fw_iso_context_stop(client->iso_context);

commit 09d7328e62e3b4cefe4bf3eeeeacb54f62a7ae5c
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Feb 18 21:38:35 2008 +0100

    Documentation: correction to debugging-via-ohci1394
    
    Rectify a factoid about firewire-ohci.
    
    Acked-by: Ingo Molnar <mingo@elte.hu>
    
    Also fix a typo spotted by Bernhard Kaindl.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/Documentation/debugging-via-ohci1394.txt b/Documentation/debugging-via-ohci1394.txt
index de4804e..c360d4e 100644
--- a/Documentation/debugging-via-ohci1394.txt
+++ b/Documentation/debugging-via-ohci1394.txt
@@ -36,14 +36,15 @@ available (notebooks) or too slow for extensive debug information (like ACPI).
 Drivers
 -------
 
-The OHCI-1394 drivers in drivers/firewire and drivers/ieee1394 initialize
-the OHCI-1394 controllers to a working state and can be used to enable
-physical DMA. By default you only have to load the driver, and physical
-DMA access will be granted to all remote nodes, but it can be turned off
-when using the ohci1394 driver.
-
-Because these drivers depend on the PCI enumeration to be completed, an
-initialization routine which can runs pretty early (long before console_init(),
+The ohci1394 driver in drivers/ieee1394 initializes the OHCI-1394 controllers
+to a working state and enables physical DMA by default for all remote nodes.
+This can be turned off by ohci1394's module parameter phys_dma=0.
+
+The alternative firewire-ohci driver in drivers/firewire uses filtered physical
+DMA, hence is not yet suitable for remote debugging.
+
+Because ohci1394 depends on the PCI enumeration to be completed, an
+initialization routine which runs pretty early (long before console_init()
 which makes the printk buffer appear on the console can be called) was written.
 
 To activate it, enable CONFIG_PROVIDE_OHCI1394_DMA_INIT (Kernel hacking menu:

commit ef774c16a744f130f27c654bf9c4806e767fc773
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 17 14:57:10 2008 +0100

    ieee1394: sbp2: fix rescan-scsi-bus
    
    rescan-scsi-bus used to add SBP-2 targets which weren't there.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index accb2ad..9e2b196 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1974,6 +1974,9 @@ static int sbp2scsi_slave_alloc(struct scsi_device *sdev)
 {
 	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
 
+	if (sdev->lun != 0 || sdev->id != lu->ud->id || sdev->channel != 0)
+		return -ENODEV;
+
 	lu->sdev = sdev;
 	sdev->allow_restart = 1;
 

commit 33f1c6c3529f5f279e2e98e5cca0c5bac152153b
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Feb 19 09:05:49 2008 +0100

    firewire: fw-sbp2: fix NULL pointer deref. in scsi_remove_device
    
    Fix a kernel bug when unplugging an SBP-2 device after having its
    scsi_device already removed via the "delete" sysfs attribute.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 60ebcb5..5259491 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -762,9 +762,10 @@ static void sbp2_release_target(struct kref *kref)
 	sbp2_unblock(tgt);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
-		if (lu->sdev)
+		if (lu->sdev) {
 			scsi_remove_device(lu->sdev);
-
+			scsi_device_put(lu->sdev);
+		}
 		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 
@@ -886,12 +887,11 @@ static void sbp2_login(struct work_struct *work)
 	if (IS_ERR(sdev))
 		goto out_logout_login;
 
-	scsi_device_put(sdev);
-
 	/* Unreported error during __scsi_add_device() */
 	smp_rmb(); /* get current card generation */
 	if (generation != device->card->generation) {
 		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
 		goto out_logout_login;
 	}
 

commit 5513c5f6f9bd8c8ad3727130910fa288c62526a7
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 17 14:56:19 2008 +0100

    firewire: fw-sbp2: fix NULL pointer deref. in slave_alloc
    
    Fix a kernel bug when running rescan-scsi-bus while a FireWire disk is
    connected:  http://bugzilla.kernel.org/show_bug.cgi?id=10008
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index ea4811c..60ebcb5 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1473,6 +1473,10 @@ static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 {
 	struct sbp2_logical_unit *lu = sdev->hostdata;
 
+	/* (Re-)Adding logical units via the SCSI stack is not supported. */
+	if (!lu)
+		return -ENOSYS;
+
 	sdev->allow_restart = 1;
 
 	/*

commit 2e2705bdcb959372d54bf7f79dd9a555ec2adfb4
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Feb 16 16:37:28 2008 +0100

    firewire: fw-sbp2: (try to) avoid I/O errors during reconnect
    
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

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 6d10934..ea4811c 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
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
@@ -646,6 +650,107 @@ static void sbp2_agent_reset_no_wait(struct sbp2_logical_unit *lu)
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
@@ -653,6 +758,9 @@ static void sbp2_release_target(struct kref *kref)
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 
+	/* prevent deadlocks */
+	sbp2_unblock(tgt);
+
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
 		if (lu->sdev)
 			scsi_remove_device(lu->sdev);
@@ -717,17 +825,20 @@ static void sbp2_login(struct work_struct *work)
 
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
@@ -749,6 +860,7 @@ static void sbp2_login(struct work_struct *work)
 	/* This was a re-login. */
 	if (lu->sdev) {
 		sbp2_cancel_orbs(lu);
+		sbp2_conditionally_unblock(lu);
 		goto out;
 	}
 
@@ -785,6 +897,7 @@ static void sbp2_login(struct work_struct *work)
 
 	/* No error during __scsi_add_device() */
 	lu->sdev = sdev;
+	sbp2_allow_block(lu);
 	goto out;
 
  out_logout_login:
@@ -825,6 +938,8 @@ static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 	lu->sdev = NULL;
 	lu->lun  = lun_entry & 0xffff;
 	lu->retries = 0;
+	lu->blocked = false;
+	++tgt->dont_block;
 	INIT_LIST_HEAD(&lu->orb_list);
 	INIT_DELAYED_WORK(&lu->work, sbp2_login);
 
@@ -1041,15 +1156,16 @@ static void sbp2_reconnect(struct work_struct *work)
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
@@ -1066,6 +1182,7 @@ static void sbp2_update(struct fw_unit *unit)
 	 * Iteration over tgt->lu_list is therefore safe here.
 	 */
 	list_for_each_entry(lu, &tgt->lu_list, link) {
+		sbp2_conditionally_block(lu);
 		lu->retries = 0;
 		sbp2_queue_work(lu, 0);
 	}
@@ -1169,6 +1286,7 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 		 * or when sending the write (less likely).
 		 */
 		result = DID_BUS_BUSY << 16;
+		sbp2_conditionally_block(orb->lu);
 	}
 
 	dma_unmap_single(device->card->device, orb->base.request_bus,

commit e80de3704ac30ddb7f9a12447a2ecee32ccd7880
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Feb 15 21:29:02 2008 +0100

    firewire: fw-sbp2: enforce a retry of __scsi_add_device if bus generation changed
    
    fw-sbp2 is unable to reconnect while performing __scsi_add_device
    because there is only a single workqueue thread context available for
    both at the moment.  This should be fixed eventually.
    
    An actual failure of __scsi_add_device is easy to handle, but an
    incomplete execution of __scsi_add_device with an sdev returned would
    remain undetected and leave the SBP-2 target unusable.
    
    Therefore we use a workaround:  If there was a bus reset during
    __scsi_add_device (i.e. during the SCSI probe), we remove the new sdev
    immediately, log out, and attempt login and SCSI probe again.
    
    Tested-by: Jarod Wilson <jwilson@redhat.com> (earlier version)
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 323b03b..6d10934 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -762,22 +762,43 @@ static void sbp2_login(struct work_struct *work)
 
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
-	if (IS_ERR(sdev)) {
-		smp_rmb(); /* generation may have changed */
-		generation = device->generation;
-		smp_rmb(); /* node_id must not be older than generation */
+	/*
+	 * FIXME:  We are unable to perform reconnects while in sbp2_login().
+	 * Therefore __scsi_add_device() will get into trouble if a bus reset
+	 * happens in parallel.  It will either fail or leave us with an
+	 * unusable sdev.  As a workaround we check for this and retry the
+	 * whole login and SCSI probing.
+	 */
 
-		sbp2_send_management_orb(lu, device->node_id, generation,
-				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
-		/*
-		 * Set this back to sbp2_login so we fall back and
-		 * retry login on bus reset.
-		 */
-		PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
-	} else {
-		lu->sdev = sdev;
-		scsi_device_put(sdev);
+	/* Reported error during __scsi_add_device() */
+	if (IS_ERR(sdev))
+		goto out_logout_login;
+
+	scsi_device_put(sdev);
+
+	/* Unreported error during __scsi_add_device() */
+	smp_rmb(); /* get current card generation */
+	if (generation != device->card->generation) {
+		scsi_remove_device(sdev);
+		goto out_logout_login;
 	}
+
+	/* No error during __scsi_add_device() */
+	lu->sdev = sdev;
+	goto out;
+
+ out_logout_login:
+	smp_rmb(); /* generation may have changed */
+	generation = device->generation;
+	smp_rmb(); /* node_id must not be older than generation */
+
+	sbp2_send_management_orb(lu, device->node_id, generation,
+				 SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+	/*
+	 * If a bus reset happened, sbp2_update will have requeued
+	 * lu->work already.  Reset the work from reconnect to login.
+	 */
+	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
  out:
 	sbp2_target_put(tgt);
 }

commit 7bb6bf7c8ba0b4ccfecaa00d6faea51b0bd42c8c
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 3 23:12:17 2008 +0100

    firewire: fw-sbp2: sort includes
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 80ab651..323b03b 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -28,15 +28,15 @@
  * and many others.
  */
 
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/mod_devicetable.h>
-#include <linux/delay.h>
-#include <linux/device.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-mapping.h>
-#include <linux/blkdev.h>
 #include <linux/string.h>
 #include <linux/stringify.h>
 #include <linux/timer.h>
@@ -48,9 +48,9 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
-#include "fw-transaction.h"
-#include "fw-topology.h"
 #include "fw-device.h"
+#include "fw-topology.h"
+#include "fw-transaction.h"
 
 /*
  * So far only bridges from Oxford Semiconductor are known to support

commit ce896d95cc7886ae05859c5b409a7b2f3b606ec1
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 3 23:11:39 2008 +0100

    firewire: fw-sbp2: logout and login after failed reconnect
    
    If fw-sbp2 was too late with requesting the reconnect, the target would
    reject this.  In this case, log out before attempting the reconnect.
    Else several firmwares will deny the re-login because they somehow
    didn't invalidate the old login.
    
    Also, don't retry reconnects in this situation.  The retries won't
    succeed either.
    
    These changes improve chances for successful re-login and shorten the
    period during which the logical unit is inaccessible.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 914170b..80ab651 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -710,6 +710,11 @@ static void sbp2_login(struct work_struct *work)
 	node_id       = device->node_id;
 	local_node_id = device->card->node_id;
 
+	/* If this is a re-login attempt, log out, or we might be rejected. */
+	if (lu->sdev)
+		sbp2_send_management_orb(lu, device->node_id, generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				SBP2_LOGIN_REQUEST, lu->lun, &response) < 0) {
 		if (lu->retries++ < 5)
@@ -997,9 +1002,17 @@ static void sbp2_reconnect(struct work_struct *work)
 	if (sbp2_send_management_orb(lu, node_id, generation,
 				     SBP2_RECONNECT_REQUEST,
 				     lu->login_id, NULL) < 0) {
-		if (lu->retries++ >= 5) {
+		/*
+		 * If reconnect was impossible even though we are in the
+		 * current generation, fall back and try to log in again.
+		 *
+		 * We could check for "Function rejected" status, but
+		 * looking at the bus generation as simpler and more general.
+		 */
+		smp_rmb(); /* get current card generation */
+		if (generation == device->card->generation ||
+		    lu->retries++ >= 5) {
 			fw_error("%s: failed to reconnect\n", tgt->bus_id);
-			/* Fall back and try to log in again. */
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}

commit 0fa6dfdb0a2768541e998a5dab10b368de56c60a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 3 23:10:47 2008 +0100

    firewire: fw-sbp2: don't add scsi_device twice
    
    When a reconnect failed but re-login succeeded, __scsi_add_device was
    called again.
    
    In those cases, __scsi_add_device succeeded and returned the pointer to
    the existing scsi_device.  fw-sbp2 then continued orderly, except that
    it missed to call sbp2_cancel_orbs.  SCSI core would call fw-sbp2's
    eh_abort_handler eventually if there had been an outstanding command.
    
    This patch avoids the needless lookups and temporary allocations in SCSI
    core and I/O stall and timeout until eh_abort_handler hits.
    
    Also, __scsi_add_device tolerating calls for devices which already exist
    is undocumented behavior on which we shouldn't rely.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 077f1c0..914170b 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -741,6 +741,12 @@ static void sbp2_login(struct work_struct *work)
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
 	sbp2_agent_reset(lu);
 
+	/* This was a re-login. */
+	if (lu->sdev) {
+		sbp2_cancel_orbs(lu);
+		goto out;
+	}
+
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
 		ssleep(SBP2_INQUIRY_DELAY);
 

commit 48f18c761c001a66ef1928b42799c717368b1d64
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 3 23:09:50 2008 +0100

    firewire: fw-sbp2: log bus_id at management request failures
    
    for easier readable logs if more than one SBP-2 device is present.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 32b50f1..077f1c0 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -148,6 +148,7 @@ struct sbp2_logical_unit {
 struct sbp2_target {
 	struct kref kref;
 	struct fw_unit *unit;
+	const char *bus_id;
 	struct list_head lu_list;
 
 	u64 management_agent_address;
@@ -566,20 +567,20 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 
 	retval = -EIO;
 	if (sbp2_cancel_orbs(lu) == 0) {
-		fw_error("orb reply timed out, rcode=0x%02x\n",
-			 orb->base.rcode);
+		fw_error("%s: orb reply timed out, rcode=0x%02x\n",
+			 lu->tgt->bus_id, orb->base.rcode);
 		goto out;
 	}
 
 	if (orb->base.rcode != RCODE_COMPLETE) {
-		fw_error("management write failed, rcode 0x%02x\n",
-			 orb->base.rcode);
+		fw_error("%s: management write failed, rcode 0x%02x\n",
+			 lu->tgt->bus_id, orb->base.rcode);
 		goto out;
 	}
 
 	if (STATUS_GET_RESPONSE(orb->status) != 0 ||
 	    STATUS_GET_SBP_STATUS(orb->status) != 0) {
-		fw_error("error status: %d:%d\n",
+		fw_error("%s: error status: %d:%d\n", lu->tgt->bus_id,
 			 STATUS_GET_RESPONSE(orb->status),
 			 STATUS_GET_SBP_STATUS(orb->status));
 		goto out;
@@ -664,7 +665,7 @@ static void sbp2_release_target(struct kref *kref)
 		kfree(lu);
 	}
 	scsi_remove_host(shost);
-	fw_notify("released %s\n", tgt->unit->device.bus_id);
+	fw_notify("released %s\n", tgt->bus_id);
 
 	put_device(&tgt->unit->device);
 	scsi_host_put(shost);
@@ -693,12 +694,11 @@ static void sbp2_login(struct work_struct *work)
 {
 	struct sbp2_logical_unit *lu =
 		container_of(work, struct sbp2_logical_unit, work.work);
-	struct Scsi_Host *shost =
-		container_of((void *)lu->tgt, struct Scsi_Host, hostdata[0]);
+	struct sbp2_target *tgt = lu->tgt;
+	struct fw_device *device = fw_device(tgt->unit->device.parent);
+	struct Scsi_Host *shost;
 	struct scsi_device *sdev;
 	struct scsi_lun eight_bytes_lun;
-	struct fw_unit *unit = lu->tgt->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
@@ -715,14 +715,14 @@ static void sbp2_login(struct work_struct *work)
 		if (lu->retries++ < 5)
 			sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 		else
-			fw_error("failed to login to %s LUN %04x\n",
-				 unit->device.bus_id, lu->lun);
+			fw_error("%s: failed to login to LUN %04x\n",
+				 tgt->bus_id, lu->lun);
 		goto out;
 	}
 
-	lu->generation        = generation;
-	lu->tgt->node_id      = node_id;
-	lu->tgt->address_high = local_node_id << 16;
+	lu->generation    = generation;
+	tgt->node_id	  = node_id;
+	tgt->address_high = local_node_id << 16;
 
 	/* Get command block agent offset and login id. */
 	lu->command_block_agent_address =
@@ -730,8 +730,8 @@ static void sbp2_login(struct work_struct *work)
 		response.command_block_agent.low;
 	lu->login_id = LOGIN_RESPONSE_GET_LOGIN_ID(response);
 
-	fw_notify("logged in to %s LUN %04x (%d retries)\n",
-		  unit->device.bus_id, lu->lun, lu->retries);
+	fw_notify("%s: logged in to LUN %04x (%d retries)\n",
+		  tgt->bus_id, lu->lun, lu->retries);
 
 #if 0
 	/* FIXME: The linux1394 sbp2 does this last step. */
@@ -747,6 +747,7 @@ static void sbp2_login(struct work_struct *work)
 	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
 	eight_bytes_lun.scsi_lun[0] = (lu->lun >> 8) & 0xff;
 	eight_bytes_lun.scsi_lun[1] = lu->lun & 0xff;
+	shost = container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
@@ -767,7 +768,7 @@ static void sbp2_login(struct work_struct *work)
 		scsi_device_put(sdev);
 	}
  out:
-	sbp2_target_put(lu->tgt);
+	sbp2_target_put(tgt);
 }
 
 static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
@@ -850,7 +851,7 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
 			if (timeout > tgt->mgt_orb_timeout)
 				fw_notify("%s: config rom contains %ds "
 					  "management ORB timeout, limiting "
-					  "to %ds\n", tgt->unit->device.bus_id,
+					  "to %ds\n", tgt->bus_id,
 					  timeout / 1000,
 					  tgt->mgt_orb_timeout / 1000);
 			break;
@@ -878,7 +879,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 	if (w)
 		fw_notify("Please notify linux1394-devel@lists.sourceforge.net "
 			  "if you need the workarounds parameter for %s\n",
-			  tgt->unit->device.bus_id);
+			  tgt->bus_id);
 
 	if (w & SBP2_WORKAROUND_OVERRIDE)
 		goto out;
@@ -900,8 +901,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 	if (w)
 		fw_notify("Workarounds for %s: 0x%x "
 			  "(firmware_revision 0x%06x, model_id 0x%06x)\n",
-			  tgt->unit->device.bus_id,
-			  w, firmware_revision, model);
+			  tgt->bus_id, w, firmware_revision, model);
 	tgt->workarounds = w;
 }
 
@@ -925,6 +925,7 @@ static int sbp2_probe(struct device *dev)
 	tgt->unit = unit;
 	kref_init(&tgt->kref);
 	INIT_LIST_HEAD(&tgt->lu_list);
+	tgt->bus_id = unit->device.bus_id;
 
 	if (fw_device_enable_phys_dma(device) < 0)
 		goto fail_shost_put;
@@ -975,8 +976,8 @@ static void sbp2_reconnect(struct work_struct *work)
 {
 	struct sbp2_logical_unit *lu =
 		container_of(work, struct sbp2_logical_unit, work.work);
-	struct fw_unit *unit = lu->tgt->unit;
-	struct fw_device *device = fw_device(unit->device.parent);
+	struct sbp2_target *tgt = lu->tgt;
+	struct fw_device *device = fw_device(tgt->unit->device.parent);
 	int generation, node_id, local_node_id;
 
 	if (fw_device_is_shutdown(device))
@@ -991,8 +992,7 @@ static void sbp2_reconnect(struct work_struct *work)
 				     SBP2_RECONNECT_REQUEST,
 				     lu->login_id, NULL) < 0) {
 		if (lu->retries++ >= 5) {
-			fw_error("failed to reconnect to %s\n",
-				 unit->device.bus_id);
+			fw_error("%s: failed to reconnect\n", tgt->bus_id);
 			/* Fall back and try to log in again. */
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
@@ -1001,17 +1001,17 @@ static void sbp2_reconnect(struct work_struct *work)
 		goto out;
 	}
 
-	lu->generation        = generation;
-	lu->tgt->node_id      = node_id;
-	lu->tgt->address_high = local_node_id << 16;
+	lu->generation    = generation;
+	tgt->node_id      = node_id;
+	tgt->address_high = local_node_id << 16;
 
-	fw_notify("reconnected to %s LUN %04x (%d retries)\n",
-		  unit->device.bus_id, lu->lun, lu->retries);
+	fw_notify("%s: reconnected to LUN %04x (%d retries)\n",
+		  tgt->bus_id, lu->lun, lu->retries);
 
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
  out:
-	sbp2_target_put(lu->tgt);
+	sbp2_target_put(tgt);
 }
 
 static void sbp2_update(struct fw_unit *unit)
@@ -1359,7 +1359,7 @@ static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
 {
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 
-	fw_notify("sbp2_scsi_abort\n");
+	fw_notify("%s: sbp2_scsi_abort\n", lu->tgt->bus_id);
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
 

commit e0e60215552d4d40caf581a8d3247203fe948fe7
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 3 23:08:58 2008 +0100

    firewire: fw-sbp2: wait for completion of fetch agent reset
    
    Like the old sbp2 driver, wait for the write transaction to the
    AGENT_RESET to complete before proceeding (after login, after reconnect,
    or in SCSI error handling).
    
    There is one occasion where AGENT_RESET is written to from atomic
    context when getting DEAD status for a command ORB.  There we still
    continue without waiting for the transaction to complete because this
    is more difficult to fix...
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 4a118fb..32b50f1 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -603,29 +603,46 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 
 static void
 complete_agent_reset_write(struct fw_card *card, int rcode,
-			   void *payload, size_t length, void *data)
+			   void *payload, size_t length, void *done)
 {
-	struct fw_transaction *t = data;
+	complete(done);
+}
+
+static void sbp2_agent_reset(struct sbp2_logical_unit *lu)
+{
+	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct fw_transaction t;
+	static u32 z;
 
-	kfree(t);
+	fw_send_request(device->card, &t, TCODE_WRITE_QUADLET_REQUEST,
+			lu->tgt->node_id, lu->generation, device->max_speed,
+			lu->command_block_agent_address + SBP2_AGENT_RESET,
+			&z, sizeof(z), complete_agent_reset_write, &done);
+	wait_for_completion(&done);
 }
 
-static int sbp2_agent_reset(struct sbp2_logical_unit *lu)
+static void
+complete_agent_reset_write_no_wait(struct fw_card *card, int rcode,
+				   void *payload, size_t length, void *data)
+{
+	kfree(data);
+}
+
+static void sbp2_agent_reset_no_wait(struct sbp2_logical_unit *lu)
 {
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct fw_transaction *t;
-	static u32 zero;
+	static u32 z;
 
-	t = kzalloc(sizeof(*t), GFP_ATOMIC);
+	t = kmalloc(sizeof(*t), GFP_ATOMIC);
 	if (t == NULL)
-		return -ENOMEM;
+		return;
 
 	fw_send_request(device->card, t, TCODE_WRITE_QUADLET_REQUEST,
 			lu->tgt->node_id, lu->generation, device->max_speed,
 			lu->command_block_agent_address + SBP2_AGENT_RESET,
-			&zero, sizeof(zero), complete_agent_reset_write, t);
-
-	return 0;
+			&z, sizeof(z), complete_agent_reset_write_no_wait, t);
 }
 
 static void sbp2_release_target(struct kref *kref)
@@ -1086,7 +1103,7 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 
 	if (status != NULL) {
 		if (STATUS_GET_DEAD(*status))
-			sbp2_agent_reset(orb->lu);
+			sbp2_agent_reset_no_wait(orb->lu);
 
 		switch (STATUS_GET_RESPONSE(*status)) {
 		case SBP2_STATUS_REQUEST_COMPLETE:

commit d94a983526cb868658c958ab689410dc1c6a31f3
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 3 23:07:44 2008 +0100

    ieee1394: sbp2: add INQUIRY delay workaround
    
    Add the same workaround as found in fw-sbp2 for feature parity and
    compatibility of the workarounds module parameter.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 28e155a..accb2ad 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -183,6 +183,9 @@ MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
  *   Avoids access beyond actual disk limits on devices with an off-by-one bug.
  *   Don't use this with devices which don't have this bug.
  *
+ * - delay inquiry
+ *   Wait extra SBP2_INQUIRY_DELAY seconds after login before SCSI inquiry.
+ *
  * - override internal blacklist
  *   Instead of adding to the built-in blacklist, use only the workarounds
  *   specified in the module load parameter.
@@ -195,6 +198,7 @@ MODULE_PARM_DESC(workarounds, "Work around device bugs (default = 0"
 	", 36 byte inquiry = "    __stringify(SBP2_WORKAROUND_INQUIRY_36)
 	", skip mode page 8 = "   __stringify(SBP2_WORKAROUND_MODE_SENSE_8)
 	", fix capacity = "       __stringify(SBP2_WORKAROUND_FIX_CAPACITY)
+	", delay inquiry = "      __stringify(SBP2_WORKAROUND_DELAY_INQUIRY)
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
@@ -357,6 +361,11 @@ static const struct {
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36 |
 					  SBP2_WORKAROUND_MODE_SENSE_8,
 	},
+	/* DViCO Momobay FX-3A with TSB42AA9A bridge */ {
+		.firmware_revision	= 0x002800,
+		.model_id		= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY,
+	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
 		.model_id		= SBP2_ROM_VALUE_WILDCARD,
@@ -914,6 +923,9 @@ static int sbp2_start_device(struct sbp2_lu *lu)
 	sbp2_agent_reset(lu, 1);
 	sbp2_max_speed_and_size(lu);
 
+	if (lu->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
+		ssleep(SBP2_INQUIRY_DELAY);
+
 	error = scsi_add_device(lu->shost, 0, lu->ud->id, 0);
 	if (error) {
 		SBP2_ERR("scsi_add_device failed");
diff --git a/drivers/ieee1394/sbp2.h b/drivers/ieee1394/sbp2.h
index d2ecb0d..80d8e09 100644
--- a/drivers/ieee1394/sbp2.h
+++ b/drivers/ieee1394/sbp2.h
@@ -343,6 +343,8 @@ enum sbp2lu_state_types {
 #define SBP2_WORKAROUND_INQUIRY_36	0x2
 #define SBP2_WORKAROUND_MODE_SENSE_8	0x4
 #define SBP2_WORKAROUND_FIX_CAPACITY	0x8
+#define SBP2_WORKAROUND_DELAY_INQUIRY	0x10
+#define SBP2_INQUIRY_DELAY		12
 #define SBP2_WORKAROUND_OVERRIDE	0x100
 
 #endif /* SBP2_H */

commit 9220f1946209a5b3335ea2d28f8462695885791b
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 3 23:04:38 2008 +0100

    firewire: fw-sbp2: add INQUIRY delay workaround
    
    Several different SBP-2 bridges accept a login early while the IDE
    device is still powering up.  They are therefore unable to respond to
    SCSI INQUIRY immediately, and the SCSI core has to retry the INQUIRY.
    One of these retries is typically successful, and all is well.
    
    But in case of Momobay FX-3A, the INQUIRY retries tend to fail entirely.
    This can usually be avoided by waiting a little while after login before
    letting the SCSI core send the INQUIRY.  The old sbp2 driver handles
    this more gracefully for as yet unknown reasons (perhaps because it
    waits for fetch agent resets to complete, unlike fw-sbp2 which quickly
    proceeds after requesting the agent reset).  Therefore the workaround is
    not as much necessary for sbp2.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 72fddf5..4a118fb 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
@@ -82,6 +83,9 @@ MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
  *   Avoids access beyond actual disk limits on devices with an off-by-one bug.
  *   Don't use this with devices which don't have this bug.
  *
+ * - delay inquiry
+ *   Wait extra SBP2_INQUIRY_DELAY seconds after login before SCSI inquiry.
+ *
  * - override internal blacklist
  *   Instead of adding to the built-in blacklist, use only the workarounds
  *   specified in the module load parameter.
@@ -91,6 +95,8 @@ MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
 #define SBP2_WORKAROUND_INQUIRY_36	0x2
 #define SBP2_WORKAROUND_MODE_SENSE_8	0x4
 #define SBP2_WORKAROUND_FIX_CAPACITY	0x8
+#define SBP2_WORKAROUND_DELAY_INQUIRY	0x10
+#define SBP2_INQUIRY_DELAY		12
 #define SBP2_WORKAROUND_OVERRIDE	0x100
 
 static int sbp2_param_workarounds;
@@ -100,6 +106,7 @@ MODULE_PARM_DESC(workarounds, "Work around device bugs (default = 0"
 	", 36 byte inquiry = "    __stringify(SBP2_WORKAROUND_INQUIRY_36)
 	", skip mode page 8 = "   __stringify(SBP2_WORKAROUND_MODE_SENSE_8)
 	", fix capacity = "       __stringify(SBP2_WORKAROUND_FIX_CAPACITY)
+	", delay inquiry = "      __stringify(SBP2_WORKAROUND_DELAY_INQUIRY)
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
@@ -303,6 +310,11 @@ static const struct {
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36 |
 					  SBP2_WORKAROUND_MODE_SENSE_8,
 	},
+	/* DViCO Momobay FX-3A with TSB42AA9A bridge */ {
+		.firmware_revision	= 0x002800,
+		.model			= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY,
+	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
 		.model			= ~0,
@@ -712,6 +724,9 @@ static void sbp2_login(struct work_struct *work)
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
 	sbp2_agent_reset(lu);
 
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
+		ssleep(SBP2_INQUIRY_DELAY);
+
 	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
 	eight_bytes_lun.scsi_lun[0] = (lu->lun >> 8) & 0xff;
 	eight_bytes_lun.scsi_lun[1] = lu->lun & 0xff;

commit fa6e697b85d705d37b3b03829095c22bcbe95ab6
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 3 23:03:00 2008 +0100

    firewire: log GUID of new devices
    
    This should help to interpret user reports.  E.g. one can look up the
    vendor OUI (first three bytes of the GUID) and thus tell what is what.
    
    Also simplifies the math in the GUID sysfs attribute.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index c04c288..2ab13e0 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -358,12 +358,9 @@ static ssize_t
 guid_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct fw_device *device = fw_device(dev);
-	u64 guid;
 
-	guid = ((u64)device->config_rom[3] << 32) | device->config_rom[4];
-
-	return snprintf(buf, PAGE_SIZE, "0x%016llx\n",
-			(unsigned long long)guid);
+	return snprintf(buf, PAGE_SIZE, "0x%08x%08x\n",
+			device->config_rom[3], device->config_rom[4]);
 }
 
 static struct device_attribute fw_device_attributes[] = {
@@ -723,13 +720,22 @@ static void fw_device_init(struct work_struct *work)
 	 */
 	if (atomic_cmpxchg(&device->state,
 		    FW_DEVICE_INITIALIZING,
-		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN)
+		    FW_DEVICE_RUNNING) == FW_DEVICE_SHUTDOWN) {
 		fw_device_shutdown(&device->work.work);
-	else
-		fw_notify("created new fw device %s "
-			  "(%d config rom retries, S%d00)\n",
-			  device->device.bus_id, device->config_rom_retries,
-			  1 << device->max_speed);
+	} else {
+		if (device->config_rom_retries)
+			fw_notify("created device %s: GUID %08x%08x, S%d00, "
+				  "%d config ROM retries\n",
+				  device->device.bus_id,
+				  device->config_rom[3], device->config_rom[4],
+				  1 << device->max_speed,
+				  device->config_rom_retries);
+		else
+			fw_notify("created device %s: GUID %08x%08x, S%d00\n",
+				  device->device.bus_id,
+				  device->config_rom[3], device->config_rom[4],
+				  1 << device->max_speed);
+	}
 
 	/*
 	 * Reschedule the IRM work if we just finished reading the

commit be6f48b0174584c9c415012ca14803c7e941e27e
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jan 27 19:14:44 2008 +0100

    firewire: fw-sbp2: don't retry login or reconnect after unplug
    
    If a device is being unplugged while fw-sbp2 had a login or reconnect on
    schedule, it would take about half a minute to shut the fw_unit down:
    
        Jan 27 18:34:54 stein firewire_sbp2: logged in to fw2.0 LUN 0000 (0 retries)
        <unplug>
        Jan 27 18:34:59 stein firewire_sbp2: sbp2_scsi_abort
        Jan 27 18:34:59 stein scsi 25:0:0:0: Device offlined - not ready after error recovery
        Jan 27 18:35:01 stein firewire_sbp2: orb reply timed out, rcode=0x11
        Jan 27 18:35:06 stein firewire_sbp2: orb reply timed out, rcode=0x11
        Jan 27 18:35:12 stein firewire_sbp2: orb reply timed out, rcode=0x11
        Jan 27 18:35:17 stein firewire_sbp2: orb reply timed out, rcode=0x11
        Jan 27 18:35:22 stein firewire_sbp2: orb reply timed out, rcode=0x11
        Jan 27 18:35:27 stein firewire_sbp2: orb reply timed out, rcode=0x11
        Jan 27 18:35:32 stein firewire_sbp2: orb reply timed out, rcode=0x11
        Jan 27 18:35:32 stein firewire_sbp2: failed to login to fw2.0 LUN 0000
        Jan 27 18:35:32 stein firewire_sbp2: released fw2.0
    
    After this patch, typically only a few seconds spent in __scsi_add_device
    remain:
    
        Jan 27 19:05:50 stein firewire_sbp2: logged in to fw2.0 LUN 0000 (0 retries)
        <unplug>
        Jan 27 19:05:56 stein firewire_sbp2: sbp2_scsi_abort
        Jan 27 19:05:56 stein scsi 33:0:0:0: Device offlined - not ready after error recovery
        Jan 27 19:05:56 stein firewire_sbp2: released fw2.0
    
    The benefit of this is less noise in the syslog.  It furthermore avoids
    a few wasted CPU cycles and needlessly prolonged lifetime of a few
    driver objects.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index a15e3c7..72fddf5 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -499,6 +499,9 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 	unsigned int timeout;
 	int retval = -ENOMEM;
 
+	if (function == SBP2_LOGOUT_REQUEST && fw_device_is_shutdown(device))
+		return 0;
+
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb == NULL)
 		return -ENOMEM;
@@ -619,16 +622,13 @@ static void sbp2_release_target(struct kref *kref)
 	struct sbp2_logical_unit *lu, *next;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
-	struct fw_device *device = fw_device(tgt->unit->device.parent);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
 		if (lu->sdev)
 			scsi_remove_device(lu->sdev);
 
-		if (!fw_device_is_shutdown(device))
-			sbp2_send_management_orb(lu, tgt->node_id,
-					lu->generation, SBP2_LOGOUT_REQUEST,
-					lu->login_id, NULL);
+		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 
 		fw_core_remove_address_handler(&lu->address_handler);
 		list_del(&lu->link);
@@ -673,6 +673,9 @@ static void sbp2_login(struct work_struct *work)
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
+	if (fw_device_is_shutdown(device))
+		goto out;
+
 	generation    = device->generation;
 	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;
@@ -944,6 +947,9 @@ static void sbp2_reconnect(struct work_struct *work)
 	struct fw_device *device = fw_device(unit->device.parent);
 	int generation, node_id, local_node_id;
 
+	if (fw_device_is_shutdown(device))
+		goto out;
+
 	generation    = device->generation;
 	smp_rmb();    /* node_id must not be older than generation */
 	node_id       = device->node_id;

commit 96b19062e741b715cf399312c30e0672d8889569
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Feb 2 15:01:09 2008 +0100

    firewire: fix "kobject_add failed for fw* with -EEXIST"
    
    There is a race between shutdown and creation of devices:  fw-core may
    attempt to add a device with the same name of an already existing
    device.  http://bugzilla.kernel.org/show_bug.cgi?id=9828
    
    Impact of the bug:  Happens rarely (when shutdown of a device coincides
    with creation of another), forces the user to unplug and replug the new
    device to get it working.
    
    The fix is obvious:  Free the minor number *after* instead of *before*
    device_unregister().  This requires to take an additional reference of
    the fw_device as long as the IDR tree points to it.
    
    And while we are at it, we fix an additional race condition:
    fw_device_op_open() took its reference of the fw_device a little bit too
    late, hence was in danger to access an already invalid fw_device.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 7e73cba..44ccee2 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -109,15 +109,17 @@ static int fw_device_op_open(struct inode *inode, struct file *file)
 	struct client *client;
 	unsigned long flags;
 
-	device = fw_device_from_devt(inode->i_rdev);
+	device = fw_device_get_by_devt(inode->i_rdev);
 	if (device == NULL)
 		return -ENODEV;
 
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
-	if (client == NULL)
+	if (client == NULL) {
+		fw_device_put(device);
 		return -ENOMEM;
+	}
 
-	client->device = fw_device_get(device);
+	client->device = device;
 	INIT_LIST_HEAD(&client->event_list);
 	INIT_LIST_HEAD(&client->resource_list);
 	spin_lock_init(&client->lock);
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index de9066e..c04c288 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -610,12 +610,14 @@ static DECLARE_RWSEM(idr_rwsem);
 static DEFINE_IDR(fw_device_idr);
 int fw_cdev_major;
 
-struct fw_device *fw_device_from_devt(dev_t devt)
+struct fw_device *fw_device_get_by_devt(dev_t devt)
 {
 	struct fw_device *device;
 
 	down_read(&idr_rwsem);
 	device = idr_find(&fw_device_idr, MINOR(devt));
+	if (device)
+		fw_device_get(device);
 	up_read(&idr_rwsem);
 
 	return device;
@@ -627,13 +629,14 @@ static void fw_device_shutdown(struct work_struct *work)
 		container_of(work, struct fw_device, work.work);
 	int minor = MINOR(device->device.devt);
 
-	down_write(&idr_rwsem);
-	idr_remove(&fw_device_idr, minor);
-	up_write(&idr_rwsem);
-
 	fw_device_cdev_remove(device);
 	device_for_each_child(&device->device, NULL, shutdown_unit);
 	device_unregister(&device->device);
+
+	down_write(&idr_rwsem);
+	idr_remove(&fw_device_idr, minor);
+	up_write(&idr_rwsem);
+	fw_device_put(device);
 }
 
 static struct device_type fw_device_type = {
@@ -682,10 +685,13 @@ static void fw_device_init(struct work_struct *work)
 	}
 
 	err = -ENOMEM;
+
+	fw_device_get(device);
 	down_write(&idr_rwsem);
 	if (idr_pre_get(&fw_device_idr, GFP_KERNEL))
 		err = idr_get_new(&fw_device_idr, device, &minor);
 	up_write(&idr_rwsem);
+
 	if (err < 0)
 		goto error;
 
@@ -741,7 +747,9 @@ static void fw_device_init(struct work_struct *work)
 	idr_remove(&fw_device_idr, minor);
 	up_write(&idr_rwsem);
  error:
-	put_device(&device->device);
+	fw_device_put(device);		/* fw_device_idr's reference */
+
+	put_device(&device->device);	/* our reference */
 }
 
 static int update_unit(struct device *dev, void *data)
diff --git a/drivers/firewire/fw-device.h b/drivers/firewire/fw-device.h
index 0854fe2..43808c0 100644
--- a/drivers/firewire/fw-device.h
+++ b/drivers/firewire/fw-device.h
@@ -77,13 +77,13 @@ fw_device_is_shutdown(struct fw_device *device)
 }
 
 struct fw_device *fw_device_get(struct fw_device *device);
+struct fw_device *fw_device_get_by_devt(dev_t devt);
 void fw_device_put(struct fw_device *device);
 int fw_device_enable_phys_dma(struct fw_device *device);
 
 void fw_device_cdev_update(struct fw_device *device);
 void fw_device_cdev_remove(struct fw_device *device);
 
-struct fw_device *fw_device_from_devt(dev_t devt);
 extern int fw_cdev_major;
 
 struct fw_unit {

commit 1b9c12ba2fdf802a23630f70eddb0e821296634e
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jan 26 17:43:23 2008 +0100

    firewire: fw-sbp2: fix logout before login retry
    
    This fixes a "can't recognize device" kind of bug.
    
    If the SCSI INQUIRY failed and hence __scsi_add_device failed due to a
    bus reset, we tried a logout and then waited for the already scheduled
    login work to happen.  So far so good, but the generation used for the
    logout was outdated, hence the logout never reached the target.  The
    target might therefore deny the subsequent relogin attempt, which would
    also leave the target inaccessible.
    
    Therefore fetch a fresh device->generation for the logout.  Use memory
    barriers to prevent our plan being foiled by compiler or hardware
    optimizations.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index f2a9a33..a15e3c7 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -716,7 +716,11 @@ static void sbp2_login(struct work_struct *work)
 	sdev = __scsi_add_device(shost, 0, 0,
 				 scsilun_to_int(&eight_bytes_lun), lu);
 	if (IS_ERR(sdev)) {
-		sbp2_send_management_orb(lu, node_id, generation,
+		smp_rmb(); /* generation may have changed */
+		generation = device->generation;
+		smp_rmb(); /* node_id must not be older than generation */
+
+		sbp2_send_management_orb(lu, device->node_id, generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 		/*
 		 * Set this back to sbp2_login so we fall back and

commit 05cca7381429e12d66c5b5c8b5c5848055b88bf7
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Jan 26 17:42:45 2008 +0100

    firewire: fw-sbp2: unsigned int vs. unsigned
    
    Standardize on "unsigned int" style.
    Sort some struct members thematically.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 19ece9b..f2a9a33 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -141,15 +141,13 @@ struct sbp2_logical_unit {
 struct sbp2_target {
 	struct kref kref;
 	struct fw_unit *unit;
+	struct list_head lu_list;
 
 	u64 management_agent_address;
 	int directory_id;
 	int node_id;
 	int address_high;
-
-	unsigned workarounds;
-	struct list_head lu_list;
-
+	unsigned int workarounds;
 	unsigned int mgt_orb_timeout;
 };
 
@@ -160,7 +158,7 @@ struct sbp2_target {
  */
 #define SBP2_MIN_LOGIN_ORB_TIMEOUT	5000U	/* Timeout in ms */
 #define SBP2_MAX_LOGIN_ORB_TIMEOUT	40000U	/* Timeout in ms */
-#define SBP2_ORB_TIMEOUT		2000	/* Timeout in ms */
+#define SBP2_ORB_TIMEOUT		2000U	/* Timeout in ms */
 #define SBP2_ORB_NULL			0x80000000
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
 
@@ -297,7 +295,7 @@ struct sbp2_command_orb {
 static const struct {
 	u32 firmware_revision;
 	u32 model;
-	unsigned workarounds;
+	unsigned int workarounds;
 } sbp2_workarounds_table[] = {
 	/* DViCO Momobay CX-1 with TSB42AA9 bridge */ {
 		.firmware_revision	= 0x002800,
@@ -836,7 +834,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 				  u32 firmware_revision)
 {
 	int i;
-	unsigned w = sbp2_param_workarounds;
+	unsigned int w = sbp2_param_workarounds;
 
 	if (w)
 		fw_notify("Please notify linux1394-devel@lists.sourceforge.net "
@@ -1197,7 +1195,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_command_orb *orb;
-	unsigned max_payload;
+	unsigned int max_payload;
 	int retval = SCSI_MLQUEUE_HOST_BUSY;
 
 	/*

-- 
Stefan Richter
-=====-==--- --=- ==--=
http://arcgraph.de/sr/


