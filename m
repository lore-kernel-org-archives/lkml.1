Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858Ab0BET7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:59:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:50165 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844Ab0BET7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:59:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pPFsf1yS4nEQq/QG2IxH8MWHJX54s9MuG+JOWgkrGi+BXXwWMGdH/G4LVvK1fg9kaz
         VNZzS58oUUD/FTlSz85UifVjDmGrUu3YQvV/VIOcaDFBSz6Bc2ktViT0gNLE+vRJZsdt
         kxLKOAjUwwn0d1kxwNm4j3BffERMS3kEjXdUs=
Subject: Re: [PATCH] MMC: fix hang if card was removed during suspend and
 unsafe resume was enabled
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100205102630.361f0c88.akpm@linux-foundation.org>
References: <1265219241.12549.8.camel@maxim-laptop>
	 <1265325495-4220-1-git-send-email-maximlevitsky@gmail.com>
	 <20100204160957.1c51cc1b.akpm@linux-foundation.org>
	 <1265358702.3424.8.camel@maxim-laptop>
	 <20100205061335.b664aa20.akpm@linux-foundation.org>
	 <1265379560.14522.2.camel@maxim-laptop>
	 <20100205063911.05eca1c6.akpm@linux-foundation.org>
	 <1265385120.16817.6.camel@maxim-laptop>
	 <20100205102630.361f0c88.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 21:58:59 +0200
Message-ID: <1265399939.23033.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 10:26 -0800, Andrew Morton wrote: 
> On Fri, 05 Feb 2010 17:52:00 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > > > <4>[15241.042047]  [<ffffffff8106620a>] ? prepare_to_wait+0x2a/0x90
> > > > <4>[15241.042159]  [<ffffffff810790bd>] ? trace_hardirqs_on+0xd/0x10
> > > > <4>[15241.042271]  [<ffffffff8140db12>] ? _raw_spin_unlock_irqrestore+0x42/0x80
> > > > <4>[15241.042386]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
> > > > <4>[15241.042496]  [<ffffffff8112a39e>] bdi_sched_wait+0xe/0x20
> > > > <4>[15241.042606]  [<ffffffff8140af6f>] __wait_on_bit+0x5f/0x90
> > > > <4>[15241.042714]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
> > > > <4>[15241.042824]  [<ffffffff8140b018>] out_of_line_wait_on_bit+0x78/0x90
> > > > <4>[15241.042935]  [<ffffffff81065fd0>] ? wake_bit_function+0x0/0x40
> > > > <4>[15241.043045]  [<ffffffff8112a2d3>] ? bdi_queue_work+0xa3/0xe0
> > > > <4>[15241.043155]  [<ffffffff8112a37f>] bdi_sync_writeback+0x6f/0x80
> > > > <4>[15241.043265]  [<ffffffff8112a3d2>] sync_inodes_sb+0x22/0x120
> > > > <4>[15241.043375]  [<ffffffff8112f1d2>] __sync_filesystem+0x82/0x90
> > > > <4>[15241.043485]  [<ffffffff8112f3db>] sync_filesystem+0x4b/0x70
> > > > <4>[15241.043594]  [<ffffffff811391de>] fsync_bdev+0x2e/0x60
> > > > <4>[15241.043704]  [<ffffffff812226be>] invalidate_partition+0x2e/0x50
> > > > <4>[15241.043816]  [<ffffffff8116b92f>] del_gendisk+0x3f/0x140
> > > > <4>[15241.043926]  [<ffffffffa00c0233>] mmc_blk_remove+0x33/0x60 [mmc_block]
> > > > <4>[15241.044043]  [<ffffffff81338977>] mmc_bus_remove+0x17/0x20
> > > > <4>[15241.044152]  [<ffffffff812ce746>] __device_release_driver+0x66/0xc0
> > > > <4>[15241.044264]  [<ffffffff812ce89d>] device_release_driver+0x2d/0x40
> > > > <4>[15241.044375]  [<ffffffff812cd9b5>] bus_remove_device+0xb5/0x120
> > > > <4>[15241.044486]  [<ffffffff812cb46f>] device_del+0x12f/0x1a0
> > > > <4>[15241.044593]  [<ffffffff81338a5b>] mmc_remove_card+0x5b/0x90
> > > > <4>[15241.044702]  [<ffffffff8133ac27>] mmc_sd_remove+0x27/0x50
> > > > <4>[15241.044811]  [<ffffffff81337d8c>] mmc_resume_host+0x10c/0x140
> > > > <4>[15241.044929]  [<ffffffffa00850e9>] sdhci_resume_host+0x69/0xa0 [sdhci]
> > > > <4>[15241.045044]  [<ffffffffa0bdc39e>] sdhci_pci_resume+0x8e/0xb0 [sdhci_pci]
> > > 
> > > So what's the hang?  del_gendisk is doing IO?  I'd assumed that it was
> > > because it was calling kobject_uevent, but userspace is frozen.
> > 
> > This is a backtrace of a hang.
> 
> But why did it hang?  Because the BDI worker threads are trying to
> perform IO through a suspended device?
> 
Something like that I guess.
Also this is 100% reproducible, and I can reproduce this with my own
driver too (by making the card detection workqueue be non freezable)


Best regards,
Maxim Levitsky

