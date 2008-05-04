Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYEDSi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYEDSi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYEDSis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:38:48 -0400
Received: from brick.kernel.dk ([87.55.233.238]:16497 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbYEDSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:38:48 -0400
Date: Sun, 4 May 2008 20:38:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Prakash Punnoor <prakash@punnoor.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, neilb@suse.de
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
Message-ID: <20080504183839.GN12774@kernel.dk>
References: <200805031151.44287.prakash@punnoor.de> <481DB3F3.5080102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481DB3F3.5080102@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04 2008, Jacek Luczak wrote:
> Hi,
> 
> I've CC:-ed few guys which may help.
> 
> Prakash Punnoor pisze:
> > Hi, I got this on boot:
> >
> > usb 2-1.3: new full speed USB device using ehci_hcd and address 3
> > usb 2-1.3: configuration #1 chosen from 1 choice
> > Clocksource tsc unstable (delta = -117343945 ns)
> > ------------[ cut here ]------------
> > WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x7d/0x90()
> > Modules linked in: kvm_amd kvm powernow_k8 ehci_hcd ohci_hcd usbcore forcedeth
> > Pid: 1681, comm: fsck.ext3 Not tainted 2.6.25-07422-gb66e1f1-dirty #74
> > 
> > Call Trace:
> >  [<ffffffff80236354>] warn_on_slowpath+0x64/0xa0
> >  [<ffffffff803b6a04>] generic_make_request+0x194/0x250
> >  [<ffffffff803b82e7>] submit_bio+0x97/0x140
> >  [<ffffffff803b756d>] blk_remove_plug+0x7d/0x90
> >  [<ffffffff8049d4d4>] raid5_unplug_device+0x44/0x110
> >  [<ffffffff802666ce>] sync_page+0x2e/0x50
> >  [<ffffffff805a0985>] __wait_on_bit+0x65/0x90
> >  [<ffffffff802669c8>] wait_on_page_bit+0x78/0x80
> >  [<ffffffff8024bb70>] wake_bit_function+0x0/0x40
> >  [<ffffffff8026f1ba>] pagevec_lookup_tag+0x1a/0x30
> >  [<ffffffff80266fbd>] wait_on_page_writeback_range+0xbd/0x130
> >  [<ffffffff8026d5e0>] do_writepages+0x20/0x40
> >  [<ffffffff802670a2>] __filemap_fdatawrite_range+0x52/0x60
> >  [<ffffffff80267334>] filemap_write_and_wait+0x44/0x50
> >  [<ffffffff802bd968>] __blkdev_put+0x148/0x1b0
> >  [<ffffffff80293441>] __fput+0xb1/0x1c0
> >  [<ffffffff80290178>] filp_close+0x48/0x80
> >  [<ffffffff80291a1f>] sys_close+0x9f/0x110
> >  [<ffffffff8020c42b>] system_call_after_swapgs+0x7b/0x80
> > 
> > ---[ end trace 94c0787a2e4d19eb ]---
> > EXT3 FS on md1, internal journal
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on md2, internal journal
> > EXT3-fs: mounted filesystem with writeback data mode.
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on md3, internal journal
> > EXT3-fs: mounted filesystem with writeback data mode.
> > eth0: no link during initialization.
> > r8169: eth1: link up
> > r8169: eth1: link up
> > NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> > NFSD: starting 90-second grace period
> 
> Is this problem reproducible?
> 
> Trace is printed by last change from Jens on Apr-29 (commit:
> 7663c1e2792a9662b23dec6e19bfcd3d55360b8f, Improve queue_is_locked()), but it
> looks like raid5_unplug_device() is called during EXT3 check on md0 [why?].

Looks like it caught a real bug there - unfortunately we have to check
for ->queue_lock here as well, if this is another stacked devices and
not the bottom device. Does this make the warning go away for you?

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 087eee0..958f26b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3264,6 +3264,8 @@ static void raid5_unplug_device(struct request_queue *q)
 	unsigned long flags;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
+	if (q->queue_lock)
+		spin_lock(q->queue_lock);
 
 	if (blk_remove_plug(q)) {
 		conf->seq_flush++;
@@ -3271,6 +3273,8 @@ static void raid5_unplug_device(struct request_queue *q)
 	}
 	md_wakeup_thread(mddev->thread);
 
+	if (q->queue_lock)
+		spin_unlock(q->queue_lock);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	unplug_slaves(mddev);

-- 
Jens Axboe

