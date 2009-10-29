Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZJ2IiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZJ2IiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbZJ2IiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:38:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45771 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZJ2IiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:38:16 -0400
Date: Thu, 29 Oct 2009 09:38:20 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32-rc5: surprise removal of USB mass storage, and whole
	system goes to hell
Message-ID: <20091029083820.GZ10727@kernel.dk>
References: <20091027211951.GA21967@elf.ucw.cz> <alpine.LRH.2.00.0910280212510.25075@twin.jikos.cz> <20091028095537.GD10727@kernel.dk> <20091028140731.GP10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028140731.GP10727@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28 2009, Jens Axboe wrote:
> On Wed, Oct 28 2009, Jens Axboe wrote:
> > On Wed, Oct 28 2009, Jiri Kosina wrote:
> > > On Tue, 27 Oct 2009, Pavel Machek wrote:
> > > 
> > > > I did remove one harddrive w/o unmounting, and now the whole system
> > > > becomes unusable :-(: (whole dmesg attached).
> > > > 
> > > > Stuff like "sync" hangs, and I'll probably have to reboot soon.
> > > 
> > > From the traces it seems that it might be related to the new per-bdi 
> > > writeback stuff ... adding Jens to CC.
> > 
> > It looks like the IO isn't being errored on the device side, or perhaps
> > it just got stuck. Pavel, if you can reproduce, please try with this
> > tracing patch. Apply it, and then do something ala:
> > 
> > # cd /sys/kernel/debug/tracing
> > # echo 0 events/enable
> > # echo 1 events/writeback/enable
> > # echo 0 > trace
> > 
> > then start the act of reproducing, and finally
> > 
> > # cat trace > /tmp/foo
> > 
> > and send the output of foo here. Thanks!
> 
> I can reproduce this. The writeback work gets queued, we notice the task
> isn't there and wake up the default task. And then nothing happens, I
> wonder if the bdi is gone.
> 
> I'll fiddle around with this.

Problem is, we cannot control if the bdi disappears all of a sudden.
This happens when the device is yanked. This bug got introduced with the
addition of the sb s_bdi cache pointer, it would now point to a bdi that
was gone (and memory had been freed).

Pavel, can you try this?

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 4f53a6d..756c31b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -614,6 +616,18 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 		kthread_stop(wb->task);
 }
 
+static void bdi_prune_sb(struct backing_dev_info *bdi)
+{
+	struct super_block *sb;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (sb->s_bdi == bdi)
+			sb->s_bdi = NULL;
+	}
+	spin_unlock(&sb_lock);
+}
+
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	if (bdi->dev) {
@@ -624,6 +638,8 @@ void bdi_unregister(struct backing_dev_info *bdi)
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
 	}
+
+	bdi_prune_sb(bdi);
 }
 EXPORT_SYMBOL(bdi_unregister);
 

-- 
Jens Axboe

