Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYCBMug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYCBMug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 07:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYCBMu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 07:50:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40035 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbYCBMu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 07:50:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 2 Mar 2008 13:49:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.948f418ebe464164@s5r6.in-berlin.de>
Message-ID: <tkrat.72eabec512517ca9@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
 <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
 <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
 <tkrat.948f418ebe464164@s5r6.in-berlin.de>
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
> to receive the following updates for the firewire subsystem.  They fix
> module unloading.  I will follow up with the combined full log and diff.
> Diffstat and shortlog:
> 
>  drivers/firewire/fw-card.c        |   61 ++++++++++++++++++++--------
>  drivers/firewire/fw-device.c      |   21 +++-------
>  drivers/firewire/fw-device.h      |   16 +++++++-
>  drivers/firewire/fw-sbp2.c        |   50 +++++++++++++++---------
>  drivers/firewire/fw-topology.c    |    1 +
>  drivers/firewire/fw-transaction.h |    2 +
>  6 files changed, 97 insertions(+), 54 deletions(-)
> 
> Stefan Richter (3):
>       firewire: fw-sbp2: better fix for NULL pointer dereference in scsi_remove_device
>       firewire: potentially invalid pointers used in fw_card_bm_work
>       firewire: fix crash in automatic module unloading


commit 855c603d61ede7e2810217f15f0d574b4f29c891
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Wed Feb 27 22:14:27 2008 +0100

    firewire: fix crash in automatic module unloading
    
    "modprobe firewire-ohci; sleep .1; modprobe -r firewire-ohci" used to
    result in crashes like this:
    
        BUG: unable to handle kernel paging request at ffffffff8807b455
        IP: [<ffffffff8807b455>]
        PGD 203067 PUD 207063 PMD 7c170067 PTE 0
        Oops: 0010 [1] PREEMPT SMP
        CPU 0
        Modules linked in: i915 drm cpufreq_ondemand acpi_cpufreq freq_table applesmc input_polldev led_class coretemp hwmon eeprom snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss button thermal processor sg snd_hda_intel snd_pcm snd_timer snd snd_page_alloc sky2 i2c_i801 rtc [last unloaded: crc_itu_t]
        Pid: 9, comm: events/0 Not tainted 2.6.25-rc2 #3
        RIP: 0010:[<ffffffff8807b455>]  [<ffffffff8807b455>]
        RSP: 0018:ffff81007dcdde88  EFLAGS: 00010246
        RAX: ffff81007dc95040 RBX: ffff81007dee5390 RCX: 0000000000005e13
        RDX: 0000000000008c8b RSI: 0000000000000001 RDI: ffff81007dee5388
        RBP: ffff81007dc5eb40 R08: 0000000000000002 R09: ffffffff8022d05c
        R10: ffffffff8023b34c R11: ffffffff8041a353 R12: ffff81007dee5388
        R13: ffffffff8807b455 R14: ffffffff80593bc0 R15: 0000000000000000
        FS:  0000000000000000(0000) GS:ffffffff8055a000(0000) knlGS:0000000000000000
        CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
        CR2: ffffffff8807b455 CR3: 0000000000201000 CR4: 00000000000006e0
        DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
        DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
        Process events/0 (pid: 9, threadinfo ffff81007dcdc000, task ffff81007dc95040)
        Stack:  ffffffff8023b396 ffffffff88082524 0000000000000000 ffffffff8807d9ae
        ffff81007dc5eb40 ffff81007dc9dce0 ffff81007dc5eb40 ffff81007dc5eb80
        ffff81007dc9dce0 ffffffffffffffff ffffffff8023be87 0000000000000000
        Call Trace:
        [<ffffffff8023b396>] ? run_workqueue+0xdf/0x1df
        [<ffffffff8023be87>] ? worker_thread+0xd8/0xe3
        [<ffffffff8023e917>] ? autoremove_wake_function+0x0/0x2e
        [<ffffffff8023bdaf>] ? worker_thread+0x0/0xe3
        [<ffffffff8023e813>] ? kthread+0x47/0x74
        [<ffffffff804198e0>] ? trace_hardirqs_on_thunk+0x35/0x3a
        [<ffffffff8020c008>] ? child_rip+0xa/0x12
        [<ffffffff8020b6e3>] ? restore_args+0x0/0x3d
        [<ffffffff8023e68a>] ? kthreadd+0x14c/0x171
        [<ffffffff8023e68a>] ? kthreadd+0x14c/0x171
        [<ffffffff8023e7cc>] ? kthread+0x0/0x74
        [<ffffffff8020bffe>] ? child_rip+0x0/0x12
    
        Code:  Bad RIP value.
        RIP  [<ffffffff8807b455>]
        RSP <ffff81007dcdde88>
        CR2: ffffffff8807b455
        ---[ end trace c7366c6657fe5bed ]---
    
    Note that this crash happened _after_ firewire-core was unloaded.  The
    shared workqueue tried to run firewire-core's device initialization jobs
    or similar jobs.
    
    The fix makes sure that firewire-ohci and hence firewire-core is not
    unloaded before all device shutdown jobs have been completed.  This is
    determined by the count of device initializations minus device releases.
    
    Also skip useless retries in the node initialization job if the node is
    to be shut down.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index e6395b2..a034627 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/crc-itu-t.h>
@@ -398,6 +399,7 @@ fw_card_initialize(struct fw_card *card, const struct fw_card_driver *driver,
 	static atomic_t index = ATOMIC_INIT(-1);
 
 	kref_init(&card->kref);
+	atomic_set(&card->device_count, 0);
 	card->index = atomic_inc_return(&index);
 	card->driver = driver;
 	card->device = device;
@@ -528,8 +530,14 @@ fw_core_remove_card(struct fw_card *card)
 	card->driver = &dummy_driver;
 
 	fw_destroy_nodes(card);
-	flush_scheduled_work();
+	/*
+	 * Wait for all device workqueue jobs to finish.  Otherwise the
+	 * firewire-core module could be unloaded before the jobs ran.
+	 */
+	while (atomic_read(&card->device_count) > 0)
+		msleep(100);
 
+	cancel_delayed_work_sync(&card->work);
 	fw_flush_transactions(card);
 	del_timer_sync(&card->flush_timer);
 
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index 2ab13e0..870125a 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -150,21 +150,10 @@ struct bus_type fw_bus_type = {
 };
 EXPORT_SYMBOL(fw_bus_type);
 
-struct fw_device *fw_device_get(struct fw_device *device)
-{
-	get_device(&device->device);
-
-	return device;
-}
-
-void fw_device_put(struct fw_device *device)
-{
-	put_device(&device->device);
-}
-
 static void fw_device_release(struct device *dev)
 {
 	struct fw_device *device = fw_device(dev);
+	struct fw_card *card = device->card;
 	unsigned long flags;
 
 	/*
@@ -176,9 +165,9 @@ static void fw_device_release(struct device *dev)
 	spin_unlock_irqrestore(&device->card->lock, flags);
 
 	fw_node_put(device->node);
-	fw_card_put(device->card);
 	kfree(device->config_rom);
 	kfree(device);
+	atomic_dec(&card->device_count);
 }
 
 int fw_device_enable_phys_dma(struct fw_device *device)
@@ -668,7 +657,8 @@ static void fw_device_init(struct work_struct *work)
 	 */
 
 	if (read_bus_info_block(device, device->generation) < 0) {
-		if (device->config_rom_retries < MAX_RETRIES) {
+		if (device->config_rom_retries < MAX_RETRIES &&
+		    atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
 			device->config_rom_retries++;
 			schedule_delayed_work(&device->work, RETRY_DELAY);
 		} else {
@@ -805,7 +795,8 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		 */
 		device_initialize(&device->device);
 		atomic_set(&device->state, FW_DEVICE_INITIALIZING);
-		device->card = fw_card_get(card);
+		atomic_inc(&card->device_count);
+		device->card = card;
 		device->node = fw_node_get(node);
 		device->node_id = node->node_id;
 		device->generation = card->generation;
diff --git a/drivers/firewire/fw-device.h b/drivers/firewire/fw-device.h
index 43808c0..78ecd39 100644
--- a/drivers/firewire/fw-device.h
+++ b/drivers/firewire/fw-device.h
@@ -76,9 +76,21 @@ fw_device_is_shutdown(struct fw_device *device)
 	return atomic_read(&device->state) == FW_DEVICE_SHUTDOWN;
 }
 
-struct fw_device *fw_device_get(struct fw_device *device);
+static inline struct fw_device *
+fw_device_get(struct fw_device *device)
+{
+	get_device(&device->device);
+
+	return device;
+}
+
+static inline void
+fw_device_put(struct fw_device *device)
+{
+	put_device(&device->device);
+}
+
 struct fw_device *fw_device_get_by_devt(dev_t devt);
-void fw_device_put(struct fw_device *device);
 int fw_device_enable_phys_dma(struct fw_device *device);
 
 void fw_device_cdev_update(struct fw_device *device);
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index a093ac3..03069a4 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -769,6 +769,7 @@ static void sbp2_release_target(struct kref *kref)
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	struct scsi_device *sdev;
+	struct fw_device *device = fw_device(tgt->unit->device.parent);
 
 	/* prevent deadlocks */
 	sbp2_unblock(tgt);
@@ -791,6 +792,7 @@ static void sbp2_release_target(struct kref *kref)
 
 	put_device(&tgt->unit->device);
 	scsi_host_put(shost);
+	fw_device_put(device);
 }
 
 static struct workqueue_struct *sbp2_wq;
@@ -1088,6 +1090,8 @@ static int sbp2_probe(struct device *dev)
 	if (scsi_add_host(shost, &unit->device) < 0)
 		goto fail_shost_put;
 
+	fw_device_get(device);
+
 	/* Initialize to values that won't match anything in our table. */
 	firmware_revision = 0xff000000;
 	model = 0xff000000;
diff --git a/drivers/firewire/fw-transaction.h b/drivers/firewire/fw-transaction.h
index fa7967b..09cb728 100644
--- a/drivers/firewire/fw-transaction.h
+++ b/drivers/firewire/fw-transaction.h
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/dma-mapping.h>
 #include <linux/firewire-constants.h>
+#include <asm/atomic.h>
 
 #define TCODE_IS_READ_REQUEST(tcode)	(((tcode) & ~1) == 4)
 #define TCODE_IS_BLOCK_PACKET(tcode)	(((tcode) &  1) != 0)
@@ -219,6 +220,7 @@ extern struct bus_type fw_bus_type;
 struct fw_card {
 	const struct fw_card_driver *driver;
 	struct device *device;
+	atomic_t device_count;
 	struct kref kref;
 
 	int node_id;

commit 15803478fdea964e5f76079851fcd13068208d5d
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Feb 24 18:57:23 2008 +0100

    firewire: potentially invalid pointers used in fw_card_bm_work
    
    The bus management workqueue job was in danger to dereference NULL
    pointers.  Also, after having temporarily lifted card->lock, a few node
    pointers and a device pointer may have become invalid.
    
    Add NULL pointer checks and get the necessary references.  Also, move
    card->local_node out of fw_card_bm_work's sight during shutdown of the
    card.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index 3e97199..e6395b2 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -214,17 +214,29 @@ static void
 fw_card_bm_work(struct work_struct *work)
 {
 	struct fw_card *card = container_of(work, struct fw_card, work.work);
-	struct fw_device *root;
+	struct fw_device *root_device;
+	struct fw_node *root_node, *local_node;
 	struct bm_data bmd;
 	unsigned long flags;
 	int root_id, new_root_id, irm_id, gap_count, generation, grace;
 	int do_reset = 0;
 
 	spin_lock_irqsave(&card->lock, flags);
+	local_node = card->local_node;
+	root_node  = card->root_node;
+
+	if (local_node == NULL) {
+		spin_unlock_irqrestore(&card->lock, flags);
+		return;
+	}
+	fw_node_get(local_node);
+	fw_node_get(root_node);
 
 	generation = card->generation;
-	root = card->root_node->data;
-	root_id = card->root_node->node_id;
+	root_device = root_node->data;
+	if (root_device)
+		fw_device_get(root_device);
+	root_id = root_node->node_id;
 	grace = time_after(jiffies, card->reset_jiffies + DIV_ROUND_UP(HZ, 10));
 
 	if (card->bm_generation + 1 == generation ||
@@ -243,14 +255,14 @@ fw_card_bm_work(struct work_struct *work)
 
 		irm_id = card->irm_node->node_id;
 		if (!card->irm_node->link_on) {
-			new_root_id = card->local_node->node_id;
+			new_root_id = local_node->node_id;
 			fw_notify("IRM has link off, making local node (%02x) root.\n",
 				  new_root_id);
 			goto pick_me;
 		}
 
 		bmd.lock.arg = cpu_to_be32(0x3f);
-		bmd.lock.data = cpu_to_be32(card->local_node->node_id);
+		bmd.lock.data = cpu_to_be32(local_node->node_id);
 
 		spin_unlock_irqrestore(&card->lock, flags);
 
@@ -267,12 +279,12 @@ fw_card_bm_work(struct work_struct *work)
 			 * Another bus reset happened. Just return,
 			 * the BM work has been rescheduled.
 			 */
-			return;
+			goto out;
 		}
 
 		if (bmd.rcode == RCODE_COMPLETE && bmd.old != 0x3f)
 			/* Somebody else is BM, let them do the work. */
-			return;
+			goto out;
 
 		spin_lock_irqsave(&card->lock, flags);
 		if (bmd.rcode != RCODE_COMPLETE) {
@@ -282,7 +294,7 @@ fw_card_bm_work(struct work_struct *work)
 			 * do a bus reset and pick the local node as
 			 * root, and thus, IRM.
 			 */
-			new_root_id = card->local_node->node_id;
+			new_root_id = local_node->node_id;
 			fw_notify("BM lock failed, making local node (%02x) root.\n",
 				  new_root_id);
 			goto pick_me;
@@ -295,7 +307,7 @@ fw_card_bm_work(struct work_struct *work)
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
 		schedule_delayed_work(&card->work, DIV_ROUND_UP(HZ, 10));
-		return;
+		goto out;
 	}
 
 	/*
@@ -305,20 +317,20 @@ fw_card_bm_work(struct work_struct *work)
 	 */
 	card->bm_generation = generation;
 
-	if (root == NULL) {
+	if (root_device == NULL) {
 		/*
 		 * Either link_on is false, or we failed to read the
 		 * config rom.  In either case, pick another root.
 		 */
-		new_root_id = card->local_node->node_id;
-	} else if (atomic_read(&root->state) != FW_DEVICE_RUNNING) {
+		new_root_id = local_node->node_id;
+	} else if (atomic_read(&root_device->state) != FW_DEVICE_RUNNING) {
 		/*
 		 * If we haven't probed this device yet, bail out now
 		 * and let's try again once that's done.
 		 */
 		spin_unlock_irqrestore(&card->lock, flags);
-		return;
-	} else if (root->config_rom[2] & BIB_CMC) {
+		goto out;
+	} else if (root_device->config_rom[2] & BIB_CMC) {
 		/*
 		 * FIXME: I suppose we should set the cmstr bit in the
 		 * STATE_CLEAR register of this node, as described in
@@ -332,7 +344,7 @@ fw_card_bm_work(struct work_struct *work)
 		 * successfully read the config rom, but it's not
 		 * cycle master capable.
 		 */
-		new_root_id = card->local_node->node_id;
+		new_root_id = local_node->node_id;
 	}
 
  pick_me:
@@ -341,8 +353,8 @@ fw_card_bm_work(struct work_struct *work)
 	 * the typically much larger 1394b beta repeater delays though.
 	 */
 	if (!card->beta_repeaters_present &&
-	    card->root_node->max_hops < ARRAY_SIZE(gap_count_table))
-		gap_count = gap_count_table[card->root_node->max_hops];
+	    root_node->max_hops < ARRAY_SIZE(gap_count_table))
+		gap_count = gap_count_table[root_node->max_hops];
 	else
 		gap_count = 63;
 
@@ -364,6 +376,11 @@ fw_card_bm_work(struct work_struct *work)
 		fw_send_phy_config(card, new_root_id, generation, gap_count);
 		fw_core_initiate_bus_reset(card, 1);
 	}
+ out:
+	if (root_device)
+		fw_device_put(root_device);
+	fw_node_put(root_node);
+	fw_node_put(local_node);
 }
 
 static void
diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/fw-topology.c
index 172c186..e47bb04 100644
--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -383,6 +383,7 @@ void fw_destroy_nodes(struct fw_card *card)
 	card->color++;
 	if (card->local_node != NULL)
 		for_each_fw_node(card, card->local_node, report_lost_node);
+	card->local_node = NULL;
 	spin_unlock_irqrestore(&card->lock, flags);
 }
 

commit f8436158b1d76e6842856048f287799468b56eb2
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Feb 26 23:30:02 2008 +0100

    firewire: fw-sbp2: better fix for NULL pointer dereference in scsi_remove_device
    
    Patch "firewire: fw-sbp2: fix NULL pointer deref. in scsi_remove_device"
    had the unintended effect that firewire-sbp2 could not be unloaded
    anymore until all SBP-2 devices were unplugged.
    
    We now fix the NULL pointer bug by reacquiring a reference to the sdev
    instead of holding a reference to the sdev (and to the module) all the
    time.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Tested-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 5259491..a093ac3 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -122,7 +122,6 @@ static const char sbp2_driver_name[] = "sbp2";
 struct sbp2_logical_unit {
 	struct sbp2_target *tgt;
 	struct list_head link;
-	struct scsi_device *sdev;
 	struct fw_address_handler address_handler;
 	struct list_head orb_list;
 
@@ -139,6 +138,7 @@ struct sbp2_logical_unit {
 	int generation;
 	int retries;
 	struct delayed_work work;
+	bool has_sdev;
 	bool blocked;
 };
 
@@ -751,20 +751,33 @@ static void sbp2_unblock(struct sbp2_target *tgt)
 	scsi_unblock_requests(shost);
 }
 
+static int sbp2_lun2int(u16 lun)
+{
+	struct scsi_lun eight_bytes_lun;
+
+	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
+	eight_bytes_lun.scsi_lun[0] = (lun >> 8) & 0xff;
+	eight_bytes_lun.scsi_lun[1] = lun & 0xff;
+
+	return scsilun_to_int(&eight_bytes_lun);
+}
+
 static void sbp2_release_target(struct kref *kref)
 {
 	struct sbp2_target *tgt = container_of(kref, struct sbp2_target, kref);
 	struct sbp2_logical_unit *lu, *next;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+	struct scsi_device *sdev;
 
 	/* prevent deadlocks */
 	sbp2_unblock(tgt);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
-		if (lu->sdev) {
-			scsi_remove_device(lu->sdev);
-			scsi_device_put(lu->sdev);
+		sdev = scsi_device_lookup(shost, 0, 0, sbp2_lun2int(lu->lun));
+		if (sdev) {
+			scsi_remove_device(sdev);
+			scsi_device_put(sdev);
 		}
 		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
@@ -807,7 +820,6 @@ static void sbp2_login(struct work_struct *work)
 	struct fw_device *device = fw_device(tgt->unit->device.parent);
 	struct Scsi_Host *shost;
 	struct scsi_device *sdev;
-	struct scsi_lun eight_bytes_lun;
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
@@ -820,7 +832,7 @@ static void sbp2_login(struct work_struct *work)
 	local_node_id = device->card->node_id;
 
 	/* If this is a re-login attempt, log out, or we might be rejected. */
-	if (lu->sdev)
+	if (lu->has_sdev)
 		sbp2_send_management_orb(lu, device->node_id, generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 
@@ -859,7 +871,7 @@ static void sbp2_login(struct work_struct *work)
 	sbp2_agent_reset(lu);
 
 	/* This was a re-login. */
-	if (lu->sdev) {
+	if (lu->has_sdev) {
 		sbp2_cancel_orbs(lu);
 		sbp2_conditionally_unblock(lu);
 		goto out;
@@ -868,13 +880,8 @@ static void sbp2_login(struct work_struct *work)
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
 		ssleep(SBP2_INQUIRY_DELAY);
 
-	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
-	eight_bytes_lun.scsi_lun[0] = (lu->lun >> 8) & 0xff;
-	eight_bytes_lun.scsi_lun[1] = lu->lun & 0xff;
 	shost = container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
-
-	sdev = __scsi_add_device(shost, 0, 0,
-				 scsilun_to_int(&eight_bytes_lun), lu);
+	sdev = __scsi_add_device(shost, 0, 0, sbp2_lun2int(lu->lun), lu);
 	/*
 	 * FIXME:  We are unable to perform reconnects while in sbp2_login().
 	 * Therefore __scsi_add_device() will get into trouble if a bus reset
@@ -896,7 +903,8 @@ static void sbp2_login(struct work_struct *work)
 	}
 
 	/* No error during __scsi_add_device() */
-	lu->sdev = sdev;
+	lu->has_sdev = true;
+	scsi_device_put(sdev);
 	sbp2_allow_block(lu);
 	goto out;
 
@@ -934,11 +942,11 @@ static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 		return -ENOMEM;
 	}
 
-	lu->tgt  = tgt;
-	lu->sdev = NULL;
-	lu->lun  = lun_entry & 0xffff;
-	lu->retries = 0;
-	lu->blocked = false;
+	lu->tgt      = tgt;
+	lu->lun      = lun_entry & 0xffff;
+	lu->retries  = 0;
+	lu->has_sdev = false;
+	lu->blocked  = false;
 	++tgt->dont_block;
 	INIT_LIST_HEAD(&lu->orb_list);
 	INIT_DELAYED_WORK(&lu->work, sbp2_login);

-- 
Stefan Richter
-=====-==--- --== ---=-
http://arcgraph.de/sr/

