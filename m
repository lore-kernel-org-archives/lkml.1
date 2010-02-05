Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab0BEOT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:19:28 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53182 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009Ab0BEOTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:19:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WmyPvNbK8lKzuHna94DssWCDx/EUnZQgafUxYBLw9FlW2Vpshzd2vml76oO7w0fDTA
         IzYnGhTFz0MBVKfrjeDFQBg/9e1tRDspAU93CqhMyMYCPAcwqy8TsPUqyj1HJU300wgK
         08T7zh12qtqMeZMBcL38Ir2QgjsDJPLeJbl2c=
Subject: Re: [PATCH] MMC: fix hang if card was removed during suspend and
 unsafe resume was enabled
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100205061335.b664aa20.akpm@linux-foundation.org>
References: <1265219241.12549.8.camel@maxim-laptop>
	 <1265325495-4220-1-git-send-email-maximlevitsky@gmail.com>
	 <20100204160957.1c51cc1b.akpm@linux-foundation.org>
	 <1265358702.3424.8.camel@maxim-laptop>
	 <20100205061335.b664aa20.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 16:19:20 +0200
Message-ID: <1265379560.14522.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 06:13 -0800, Andrew Morton wrote: 
> On Fri, 05 Feb 2010 10:31:42 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > On Thu, 2010-02-04 at 16:09 -0800, Andrew Morton wrote: 
> > > On Fri,  5 Feb 2010 01:18:15 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > 
> > > > Currently removal of the card leads to del_disk called indirectly by mmc core.
> > > > This function expects userspace to be running, which isn't when .resume is called
> > > > 
> > > > Fix that by removing the code that did that in mmc_resume_host. It is possible
> > > > because card detection logic will kick it later and remove the card.
> > > 
> > > I don't really understand.  The above implies that to trigger this bug,
> > > one needs to physically remove the card during a resume operation.  ie:
> > > a human-vs-computer race.  Sounds unlikely?
> > > 
> > > So...  exactly what steps does the user need to take to trigger this
> > 
> > Sorry for describing this poorly.
> > The steps are:
> > 
> > -> Have a kernel with CONFIG_MMC_UNSAFE_RESUME
> > -> Insert MMC/SD card
> > -> Suspend/hibernate the system
> > -> While system is hibernated/suspended pull the card off
> > -> Resume the system
> > -> Hang
> > 
> > 
> > if CONFIG_MMC_UNSAFE_RESUME is set, mmc core allows the user to
> > suspend/resume the card normally assuming he won't change the card or
> > modify it in another system. The former case is actually handled quite
> > well.
> > 
> > if CONFIG_MMC_UNSAFE_RESUME isn't set, it removes the card during
> > suspend, and I now think (and will test) that this will still hang the
> > system this time on suspend.
> > 
> > Maybe we can make del_disk behave well if called with userspace frozen?
> > After all if user calls it, very likely that hardware is absent thus
> > there is no point in syncing (which I think triggers the hang)....
> > 
> 
> There is no del_disk in the kernel.  Let's be more specific (and
> accurate!) about the hang.  I assume it's
> mmc_remove_card->device_del->kobject_uevent?
Sorry!
I was referring to del_gendisk. 

<4>[15241.042047]  [<ffffffff8106620a>] ? prepare_to_wait+0x2a/0x90
<4>[15241.042159]  [<ffffffff810790bd>] ? trace_hardirqs_on+0xd/0x10
<4>[15241.042271]  [<ffffffff8140db12>] ? _raw_spin_unlock_irqrestore+0x42/0x80
<4>[15241.042386]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
<4>[15241.042496]  [<ffffffff8112a39e>] bdi_sched_wait+0xe/0x20
<4>[15241.042606]  [<ffffffff8140af6f>] __wait_on_bit+0x5f/0x90
<4>[15241.042714]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
<4>[15241.042824]  [<ffffffff8140b018>] out_of_line_wait_on_bit+0x78/0x90
<4>[15241.042935]  [<ffffffff81065fd0>] ? wake_bit_function+0x0/0x40
<4>[15241.043045]  [<ffffffff8112a2d3>] ? bdi_queue_work+0xa3/0xe0
<4>[15241.043155]  [<ffffffff8112a37f>] bdi_sync_writeback+0x6f/0x80
<4>[15241.043265]  [<ffffffff8112a3d2>] sync_inodes_sb+0x22/0x120
<4>[15241.043375]  [<ffffffff8112f1d2>] __sync_filesystem+0x82/0x90
<4>[15241.043485]  [<ffffffff8112f3db>] sync_filesystem+0x4b/0x70
<4>[15241.043594]  [<ffffffff811391de>] fsync_bdev+0x2e/0x60
<4>[15241.043704]  [<ffffffff812226be>] invalidate_partition+0x2e/0x50
<4>[15241.043816]  [<ffffffff8116b92f>] del_gendisk+0x3f/0x140
<4>[15241.043926]  [<ffffffffa00c0233>] mmc_blk_remove+0x33/0x60 [mmc_block]
<4>[15241.044043]  [<ffffffff81338977>] mmc_bus_remove+0x17/0x20
<4>[15241.044152]  [<ffffffff812ce746>] __device_release_driver+0x66/0xc0
<4>[15241.044264]  [<ffffffff812ce89d>] device_release_driver+0x2d/0x40
<4>[15241.044375]  [<ffffffff812cd9b5>] bus_remove_device+0xb5/0x120
<4>[15241.044486]  [<ffffffff812cb46f>] device_del+0x12f/0x1a0
<4>[15241.044593]  [<ffffffff81338a5b>] mmc_remove_card+0x5b/0x90
<4>[15241.044702]  [<ffffffff8133ac27>] mmc_sd_remove+0x27/0x50
<4>[15241.044811]  [<ffffffff81337d8c>] mmc_resume_host+0x10c/0x140
<4>[15241.044929]  [<ffffffffa00850e9>] sdhci_resume_host+0x69/0xa0 [sdhci]
<4>[15241.045044]  [<ffffffffa0bdc39e>] sdhci_pci_resume+0x8e/0xb0 [sdhci_pci]

> 
> Yes, I'd have thought that it would be a good idea for the
> kobject_uevent code (or lower, in call_usermodehelper) to take avoiding
> action if userspace is frozen.  However such action would probably
> involve doing a WARN_ON() too, so we'd still need MMC changes to avoid
> that.
> 
> 

Best regards,
Maxim Levitsky


