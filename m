Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZKKL3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZKKL3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 06:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZKKL3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 06:29:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZKKL3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 06:29:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, jens.axboe@oracle.com
Subject: Re: [PATCH 1/1]: Thaws refrigerated bdi flusher threads before invoking kthread_stop on them
Date: Wed, 11 Nov 2009 12:30:58 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Romit Dasgupta <romit@ti.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1257928216.15415.57.camel@boson> <20091111103444.GD26423@elf.ucw.cz>
In-Reply-To: <20091111103444.GD26423@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911111230.58479.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009, Pavel Machek wrote:
> On Wed 2009-11-11 14:00:16, Romit Dasgupta wrote:
> > Kicks out frozen bdi flusher task out of the refrigerator when the flusher task
> > needs to exit.
> 
> 
> > Signed-off-by: Romit Dasgupta <romit@ti.com>
> 
> Ok, its slightly "interesting", but better than modifying common
> code. Looks ok to me.
> 
> ACK.

Agreed.

Jens, any objections?

> > ---
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index 5a37e20..c757b05 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -606,8 +606,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
> >  	 * Finally, kill the kernel threads. We don't need to be RCU
> >  	 * safe anymore, since the bdi is gone from visibility.
> >  	 */
> > -	list_for_each_entry(wb, &bdi->wb_list, list)
> > +	list_for_each_entry(wb, &bdi->wb_list, list) {
> > +		if (unlikely(frozen(wb->task)))
> > +			wb->task->flags &= ~PF_FROZEN;
> >  		kthread_stop(wb->task);
> > +	}
> >  }
> >  
> >  void bdi_unregister(struct backing_dev_info *bdi)
> > 

For completness, below is the information from the Romit's introductory message
(Romit, I really think that should go into the chagelog):

"Few days back I started facing problems during system suspend with
MMC, SD card installed. I will restate how to reproduce the problem:

1) Mount a file system from MMC/SD card.
2) Unmount the file system. This creates a flusher task.
3) Attempt suspend to RAM. System is unresponsive.

This is because the bdi flusher thread is already in the refrigerator
and will remain so until it is thawed. The MMC driver suspend routine
ultimately will issue a 'kthread_stop' on the bdi flusher thread and
will block until the flusher thread is exited. Since the bdi flusher
thread is in the refrigerator it never cleans up until thawed.

Enabling khungtaskd gave the following dump: (the dump wraps beyond 80
cols).

INFO: task sh:387 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sh            D c027e86c     0   387      1 0x00000000
[<c027e86c>] (schedule+0x2e0/0x36c) from [<c027ee78>] (schedule_timeout+0x18/0x1ec)
[<c027ee78>] (schedule_timeout+0x18/0x1ec) from [<c027ed10>] (wait_for_common+0xe0/0x198)
[<c027ed10>] (wait_for_common+0xe0/0x198) from [<c0063dd4>] (kthread_stop+0x44/0x78)
[<c0063dd4>] (kthread_stop+0x44/0x78) from [<c0090938>] (bdi_unregister+0x64/0xa4)
[<c0090938>] (bdi_unregister+0x64/0xa4) from [<c0173958>] (unlink_gendisk+0x20/0x3c)
[<c0173958>] (unlink_gendisk+0x20/0x3c) from [<c00f2338>] (del_gendisk+0x84/0xb4)
[<c00f2338>] (del_gendisk+0x84/0xb4) from [<c01e6840>] (mmc_blk_remove+0x24/0x44)
[<c01e6840>] (mmc_blk_remove+0x24/0x44) from [<c01e14f0>] (mmc_bus_remove+0x18/0x20)
[<c01e14f0>] (mmc_bus_remove+0x18/0x20) from [<c01af6ac>] (__device_release_driver+0x64/0xa4)
[<c01af6ac>] (__device_release_driver+0x64/0xa4) from [<c01af7e4>] (device_release_driver+0x1c/0x28)
[<c01af7e4>] (device_release_driver+0x1c/0x28) from [<c01aed5c>] (bus_remove_device+0x7c/0x90)
[<c01aed5c>] (bus_remove_device+0x7c/0x90) from [<c01ad538>] (device_del+0x110/0x160)
[<c01ad538>] (device_del+0x110/0x160) from [<c01e15a8>] (mmc_remove_card+0x50/0x64)
[<c01e15a8>] (mmc_remove_card+0x50/0x64) from [<c01e2ea4>] (mmc_sd_remove+0x24/0x30)
[<c01e2ea4>] (mmc_sd_remove+0x24/0x30) from [<c01e0dcc>] (mmc_suspend_host+0x110/0x1a8)
[<c01e0dcc>] (mmc_suspend_host+0x110/0x1a8) from [<c01e7d04>] (omap_hsmmc_suspend+0x74/0x104)
[<c01e7d04>] (omap_hsmmc_suspend+0x74/0x104) from [<c01b08e8>] (platform_pm_suspend+0x50/0x5c)
[<c01b08e8>] (platform_pm_suspend+0x50/0x5c) from [<c01b27f0>] (pm_op+0x30/0x74)
[<c01b27f0>] (pm_op+0x30/0x74) from [<c01b2ec8>] (dpm_suspend_start+0x3b4/0x518)
[<c01b2ec8>] (dpm_suspend_start+0x3b4/0x518) from [<c0078b20>] (suspend_devices_and_enter+0x3c/0x1c4)
[<c0078b20>] (suspend_devices_and_enter+0x3c/0x1c4) from [<c0078d88>] (enter_state+0xe0/0x138)
[<c0078d88>] (enter_state+0xe0/0x138) from [<c0078444>] (state_store+0x94/0xbc)
[<c0078444>] (state_store+0x94/0xbc) from [<c017e124>] (kobj_attr_store+0x18/0x1c)
[<c017e124>] (kobj_attr_store+0x18/0x1c) from [<c00f3a08>] (sysfs_write_file+0x108/0x13c)
[<c00f3a08>] (sysfs_write_file+0x108/0x13c) from [<c00a76b8>] (vfs_write+0xac/0x154)
[<c00a76b8>] (vfs_write+0xac/0x154) from [<c00a780c>] (sys_write+0x3c/0x68)
[<c00a780c>] (sys_write+0x3c/0x68) from [<c0025e60>] (ret_fast_syscall+0x0/0x2c)

Earlier I had sent a patch to thaw any refrigerated kernel thread when
some active thread has invoked 'kthread_stop' on it. This was done with
the assumption that all such kernel threads should invoke
'kthread_should_stop' after 'try_to_freeze' and exit if necessary. It
looks there are some kernel threads which do not follow this. With that
in mind I am sending a different patch to fix the above issue (in the
next mail)."

Rafael
