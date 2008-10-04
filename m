Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYJDXSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYJDXSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 19:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbYJDXRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 19:17:51 -0400
Received: from nebensachen.de ([195.34.83.29]:44888 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbYJDXRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 19:17:50 -0400
X-Hashcash: 1:20:081004:bzolnier@gmail.com::0ewqGbf9YqOhYkBC:00000000000000000000000000000000000000000005dvS
X-Hashcash: 1:20:081004:linux-ide@vger.kernel.org::G1MXF2EaPYjptIuD:0000000000000000000000000000000000005u55
X-Hashcash: 1:20:081004:linux-kernel@vger.kernel.org::rDnbc+2raVVAG/0u:0000000000000000000000000000000001Mm+
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 v2] ide: Implement disk shock protection support
References: <87d4j2n3dn.fsf@denkblock.local>
	<20080917163144.9870.59732.stgit@denkblock.local>
	<200809181624.54248.bzolnier@gmail.com>
	<87fxnczocc.fsf@denkblock.local> <87d4igqxlm.fsf@denkblock.local>
Date: Sun, 05 Oct 2008 01:16:16 +0200
In-Reply-To: <87d4igqxlm.fsf@denkblock.local> (Elias Oltmanns's message of
	"Sat, 04 Oct 2008 15:49:25 +0200")
Message-ID: <873ajcar3z.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> Elias Oltmanns <eo@nebensachen.de> wrote:
>> Hi Bart,
>>
>> may I ask you to apply yet another inter-diff? This is in order to
>> address three issues:
>>
>> 1. Make sure that no negative value is being passed to
>>    jiffies_to_msecs() in ide_park_show().
>> 2. Drop the superfluous variable hwif in ide_special_rq().
>> 3. Skip initialisation of task and tf in ide_special_rq() if we are not
>>    handling a (un)park request.
>
> Well, #3 should have been done differently because we donn't want to
> check for REQ_(UN)?PARK_HEADS more often than is necessary.

While preparing the backport to 2.6.27, it has just occurred to me that
we need to clear the IDE_DFLAG_PARKED flag in ide_disk_pre_reset()
because this flag must not be set after *any* sort of access to the
device.

So, here is yet another revised version of the inter-diff. Just don't
hurry to apply in case I have an enlightening dream tonight and want to
change something more ;-).

Regards,

Elias

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 ide-io.c   |   47 +++++++++++++++++++++++++----------------------
 ide-iops.c |    1 +
 ide-park.c |    6 ++++--
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 09d10a5..77c6eae 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -672,25 +672,32 @@ EXPORT_SYMBOL_GPL(ide_devset_execute);
 
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t task;
-	struct ide_taskfile *tf = &task.tf;
+	u8 cmd = rq->cmd[0];
+
+	if (cmd == REQ_PARK_HEADS || cmd == REQ_UNPARK_HEADS) {
+		ide_task_t task;
+		struct ide_taskfile *tf = &task.tf;
+
+		memset(&task, 0, sizeof(task));
+		if (cmd == REQ_PARK_HEADS) {
+			drive->sleep = *(unsigned long *)rq->special;
+			drive->dev_flags |= IDE_DFLAG_SLEEPING;
+			tf->command = ATA_CMD_IDLEIMMEDIATE;
+			tf->feature = 0x44;
+			tf->lbal = 0x4c;
+			tf->lbam = 0x4e;
+			tf->lbah = 0x55;
+			task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+		} else		/* cmd == REQ_UNPARK_HEADS */
+			tf->command = ATA_CMD_CHK_POWER;
+
+		task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+		task.rq = rq;
+		drive->hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
+		return do_rw_taskfile(drive, &task);
+	}
 
-	memset(&task, 0, sizeof(task));
-	switch (rq->cmd[0]) {
-	case REQ_PARK_HEADS:
-		drive->sleep = *(unsigned long *)rq->special;
-		drive->dev_flags |= IDE_DFLAG_SLEEPING;
-		tf->command = ATA_CMD_IDLEIMMEDIATE;
-		tf->feature = 0x44;
-		tf->lbal = 0x4c;
-		tf->lbam = 0x4e;
-		tf->lbah = 0x55;
-		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
-		break;
-	case REQ_UNPARK_HEADS:
-		tf->command = ATA_CMD_CHK_POWER;
-		break;
+	switch (cmd) {
 	case REQ_DEVSET_EXEC:
 	{
 		int err, (*setfunc)(ide_drive_t *, int) = rq->special;
@@ -710,10 +717,6 @@ static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 		ide_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
-	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	task.rq = rq;
-	hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
-	return do_rw_taskfile(drive, &task);
 }
 
 static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 0eb6284..b762deb 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1020,6 +1020,7 @@ static void ide_disk_pre_reset(ide_drive_t *drive)
 	drive->special.b.recalibrate  = legacy;
 
 	drive->mult_count = 0;
+	drive->dev_flags &= ~IDE_DFLAG_PARKED;
 
 	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
 	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 35fc3ee..02d7e35 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -61,15 +61,17 @@ ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
+	unsigned long now;
 	unsigned int msecs;
 
 	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
 		return -EOPNOTSUPP;
 
 	spin_lock_irq(&ide_lock);
+	now = jiffies;
 	if (drive->dev_flags & IDE_DFLAG_PARKED &&
-	    time_after(drive->sleep, jiffies))
-		msecs = jiffies_to_msecs(drive->sleep - jiffies);
+	    time_after(drive->sleep, now))
+		msecs = jiffies_to_msecs(drive->sleep - now);
 	else
 		msecs = 0;
 	spin_unlock_irq(&ide_lock);
