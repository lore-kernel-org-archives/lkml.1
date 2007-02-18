Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXBRXbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXBRXbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXBRXbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:31:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbXBRXbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:31:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2
Date: Mon, 19 Feb 2007 00:25:48 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702181344.54959.rjw@sisk.pl> <20070218114326.35d7645b.akpm@linux-foundation.org>
In-Reply-To: <20070218114326.35d7645b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702190025.49273.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 20:43, Andrew Morton wrote:
> On Sun, 18 Feb 2007 13:44:54 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> > > 
> > > Temporarily at
> > > 
> > >   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> > > 
> > > Will appear later at
> > > 
> > >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> > 
> > Two problems:
> > 
> > 1) A showstopper with the root partition on RAID1:
> > 
> > md: raid1 personality registered for level 1
> > [--snip--]
> > md: multipath personality registered for level -4
> > register_blkdev: failed to get major for mdp
> > [--snip--]
> > VFS: Cannot open root device "md1" or unknown-block(0,0)
> 
> Someone else reported that against mainline.  Can you please debug it a bit?

Sure, tomorrow I will.

> I'd suggested reverting the recent changes in there:
> 
> --- a/block/genhd.c~a
> +++ a/block/genhd.c
> @@ -61,14 +61,6 @@ int register_blkdev(unsigned int major, 
>  	/* temporary */
>  	if (major == 0) {
>  		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
> -			/*
> -			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
> -			 * majors
> -			 */
> -			if ((60 <= index && index <= 63) ||
> -					(120 <= index && index <= 127) ||
> -					(240 <= index && index <= 254))
> -				continue;
>  			if (major_names[index] == NULL)
>  				break;
>  		}
> _
> 
> but I don't see how they could cause this.
> 
> 
> > At the moment I have no serial console attached to the box, so I had to rewrite
> > the messages manually.
> 
> netconsole is good.

I know. :-)

In the meantime, I've got something worse on another x86_64 box:

Asus Laptop ACPI Extras version 0.30
  L5D model detected, supported
audit(1171831698.918:2): audit_pid=4281 old=0 by auid=4294967295
general protection fault: 0000 [2] PREEMPT
last sysfs file: /class/net/eth2/carrier
CPU 0
Modules linked in: af_packet ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device asus_acpi backlight button battery ac dm_mod pcmr
Pid: 178, comm: pdflush Not tainted 2.6.20-mm2 #1
RIP: 0010:[<ffffffff8034bce4>]  [<ffffffff8034bce4>] __make_request+0x134/0x370
RSP: 0000:ffff81005ed659a0  EFLAGS: 00010297
RAX: 00000000ffffffff RBX: 6b6b6b6b6b6b6b6b RCX: 000000000203396a
RDX: 0000000100000000 RSI: ffff810037b4dbb0 RDI: ffff81004683d8c0
RBP: ffff81005ed659f0 R08: ffff81004683d070 R09: ffff81003d333cc0
R10: 0000000000000000 R11: 0000000000000000 R12: ffff810037b4dbb0
R13: ffff81005daba3f0 R14: ffff810037daca90 R15: ffff81005daba3d0
FS:  00002ad4a29e6d00(0000) GS:ffffffff805db000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002b6a345aa000 CR3: 0000000056585000 CR4: 00000000000006e0
Process pdflush (pid: 178, threadinfo ffff81005ed64000, task ffff810037b060c0)
Stack:  ffff810002852540 0000000000000001 ffff810037b4dbb0 ffffffff8026be21
 ffff81005ed65a40 0000000000000008 ffff810037b4dbb0 0000000000000800
 0000000000000008 ffff8100021d94e0 ffff81005ed65a40 ffffffff80348e7c
Call Trace:
 [<ffffffff8026be21>] mempool_alloc_slab+0x11/0x20
 [<ffffffff80348e7c>] generic_make_request+0x1ec/0x230
 [<ffffffff8034b7e6>] submit_bio+0xf6/0x110
 [<ffffffff802b60f0>] submit_bh+0x100/0x130
 [<ffffffff802b788a>] __block_write_full_page+0x1ca/0x2e0
 [<ffffffff802bc040>] blkdev_get_block+0x0/0x70
 [<ffffffff802bc040>] blkdev_get_block+0x0/0x70
 [<ffffffff802b7a93>] block_write_full_page+0xf3/0x110
 [<ffffffff802baeb3>] blkdev_writepage+0x13/0x20
 [<ffffffff8026eb85>] __writepage+0x15/0x40
 [<ffffffff8026f1e3>] write_cache_pages+0x1f3/0x360
 [<ffffffff8026eb70>] __writepage+0x0/0x40
 [<ffffffff8026f372>] generic_writepages+0x22/0x30
 [<ffffffff8026f3c6>] do_writepages+0x46/0x80
 [<ffffffff802b1f67>] __writeback_single_inode+0x1d7/0x370
 [<ffffffff802b2355>] generic_sync_sb_inodes+0x35/0x2b0
 [<ffffffff802b24f9>] generic_sync_sb_inodes+0x1d9/0x2b0
 [<ffffffff802b29f2>] writeback_inodes+0x82/0x100
 [<ffffffff802b25f5>] sync_sb_inodes+0x25/0x30
 [<ffffffff802b2a08>] writeback_inodes+0x98/0x100
 [<ffffffff8026fd40>] pdflush+0x0/0x1e0
 [<ffffffff8026f934>] wb_kupdate+0x94/0x110
 [<ffffffff8026fe68>] pdflush+0x128/0x1e0
 [<ffffffff8026f8a0>] wb_kupdate+0x0/0x110
 [<ffffffff8026fd40>] pdflush+0x0/0x1e0
 [<ffffffff80240863>] kthread+0xd3/0x110
 [<ffffffff80240700>] keventd_create_kthread+0x0/0x90
 [<ffffffff8020a3f8>] child_rip+0xa/0x12
 [<ffffffff80483e5b>] _spin_unlock_irq+0x2b/0x60
 [<ffffffff80209fb0>] restore_args+0x0/0x30
 [<ffffffff80240790>] kthread+0x0/0x110
 [<ffffffff8020a3ee>] child_rip+0x0/0x12


Code: 48 8b 43 08 0f 18 08 49 39 dd 75 a2 49 8b be 38 02 00 00 e8
RIP  [<ffffffff8034bce4>] __make_request+0x134/0x370
 RSP <ffff81005ed659a0>
PM: Adding info for No Bus:vcs10
PM: Adding info for No Bus:vcsa10

It looks _really_ bad to me. :-(


> > 2) On HPC nx6325 I get the following 100% of the time during the resume from
> > disk:
> > 
> > BUG: at drivers/pci/pci.c:823 pcim_enable_device()
> > 
> > Call Trace:
> >  [<ffffffff80325ff8>] pcim_enable_device+0x93/0xb3
> >  [<ffffffff803a974a>] ata_pci_device_do_resume+0x21/0x5e
> >  [<ffffffff803b5e6c>] sil_pci_device_resume+0x1c/0x51
> >  [<ffffffff8032800d>] pci_device_resume+0x22/0x53
> >  [<ffffffff8039ae58>] resume_device+0xca/0x131
> >  [<ffffffff8039af40>] dpm_resume+0x81/0xd3
> >  [<ffffffff8039afc2>] device_resume+0x30/0x45
> >  [<ffffffff802a0792>] snapshot_ioctl+0x245/0x63e
> >  [<ffffffff8023cfcc>] do_ioctl+0x5e/0x77
> >  [<ffffffff8022d2b3>] vfs_ioctl+0x25c/0x279
> >  [<ffffffff80246a80>] sys_ioctl+0x5f/0x82
> >  [<ffffffff80215586>] sys_write+0x47/0x70
> >  [<ffffffff8025711e>] system_call+0x7e/0x83
> > 
> > Nevertheless, the system seems to be fully functional after the resume.
> > 
> > [I've been observing it since 2.6.20-git10 and have reported it for a couple
> > of times, but apparently nobody cares. :-(]
> 
> This is a Tejun thing - apparently it's due to swsusp calling suspend once
> and resume twice (or is it vice versa).  He'll be looking into it soon.

OK
