Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab0BTWWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 17:22:37 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:39407 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab0BTWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 17:22:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LdFC+zAInfPP6HRSBDsaixGpJYfsBCEo5LYZ93I5slnID3Ay8dtb5FmgBCuaq3FAgo
         wgQa1wl7QZGgAVX9NtO2Bt/V55N8E9RgQwLQGPE9Y7ZnJh3dBu0jeOSUpC93BJW2hU8S
         kbVPb+99Z0dKGg6+Kyg7mFzdGITu2VJDd7gjI=
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.1002161126340.1281-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1002161126340.1281-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Feb 2010 00:22:30 +0200
Message-ID: <1266704550.3748.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 11:27 -0500, Alan Stern wrote: 
> On Mon, 15 Feb 2010, Rafael J. Wysocki wrote:
> 
> > On Monday 15 February 2010, Maxim Levitsky wrote:
> > > On Sat, 2010-02-13 at 15:29 +0200, Maxim Levitsky wrote: 
> > > > I noticed that currently calling del_gendisk leads to sure deadlock if
> > > > attemped from .suspend or .resume functions.
> > 
> > Well, it shouldn't be called from there, then.
> 
> Even if drivers avoid calling it from within suspend methods, they have
> to be able to call it from within resume methods.  After all, the
> resume method may find that the disk's device has vanished.
> 
> > > > Something like that:
> > > > 
> > > > [<ffffffff8106620a>] ? prepare_to_wait+0x2a/0x90
> > > > [<ffffffff810790bd>] ? trace_hardirqs_on+0xd/0x10
> > > > [<ffffffff8140db12>] ? _raw_spin_unlock_irqrestore+0x42/0x80
> > > > [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
> > > > [<ffffffff8112a39e>] bdi_sched_wait+0xe/0x20
> > > > [<ffffffff8140af6f>] __wait_on_bit+0x5f/0x90
> > > > [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
> > > > [<ffffffff8140b018>] out_of_line_wait_on_bit+0x78/0x90
> > > > [<ffffffff81065fd0>] ? wake_bit_function+0x0/0x40
> > > > [<ffffffff8112a2d3>] ? bdi_queue_work+0xa3/0xe0
> > > > [<ffffffff8112a37f>] bdi_sync_writeback+0x6f/0x80
> > > > [<ffffffff8112a3d2>] sync_inodes_sb+0x22/0x120
> > > > [<ffffffff8112f1d2>] __sync_filesystem+0x82/0x90
> > > > [<ffffffff8112f3db>] sync_filesystem+0x4b/0x70
> > > > [<ffffffff811391de>] fsync_bdev+0x2e/0x60
> > > > [<ffffffff812226be>] invalidate_partition+0x2e/0x50
> > > > [<ffffffff8116b92f>] del_gendisk+0x3f/0x140
> > > > [<ffffffffa00c0233>] mmc_blk_remove+0x33/0x60 [mmc_block]
> > > > [<ffffffff81338977>] mmc_bus_remove+0x17/0x20
> > > > [<ffffffff812ce746>] __device_release_driver+0x66/0xc0
> > > > [<ffffffff812ce89d>] device_release_driver+0x2d/0x40
> > > > [<ffffffff812cd9b5>] bus_remove_device+0xb5/0x120
> > > > [<ffffffff812cb46f>] device_del+0x12f/0x1a0
> > > > [<ffffffff81338a5b>] mmc_remove_card+0x5b/0x90
> > > > [<ffffffff8133ac27>] mmc_sd_remove+0x27/0x50
> > > > [<ffffffff81337d8c>] mmc_resume_host+0x10c/0x140
> > > > [<ffffffffa00850e9>] sdhci_resume_host+0x69/0xa0 [sdhci]
> > > > [<ffffffffa0bdc39e>] sdhci_pci_resume+0x8e/0xb0 [sdhci_pci]
> > > > 
> > > > bdi_queue_work seems to be the problem.
> > > > 
> > > > Some device drivers need to remove their cards logically in .suspend,
> > > > because the card is removable, and can be changed while system is
> > > > suspended.
> > 
> > I don't know how to resolve this right now.
> 
> This is a matter for Jens.  Is the bdi writeback task freezable?  If it
> is, should it be made unfreezable?

Any update?

Best regards,
Maxim Levitsky



