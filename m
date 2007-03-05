Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbXCEKT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbXCEKT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbXCEKT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:19:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbXCEKTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:19:55 -0500
Date: Mon, 5 Mar 2007 11:11:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Auke Kok <auke-jan.h.kok@intel.com>
Subject: SATA resume slowness, e1000 MSI warning
Message-ID: <20070305101120.GA23032@elte.hu>
References: <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz> <20070305084257.GA4464@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305084257.GA4464@mellanox.co.il>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> > (Resume is very slow, because disks are not spinned up properly; and
> > there's something wrong with timers; console beeps take way too long).

> Pavel, I tried with your .config, and indeed the system came back to 
> life after 2-3 minutes after I press Fn/F4, indeed the issue seems to 
> be with the disk. It could be that the same takes place with my 
> original .config - maybe I just wasn't patient enough. I'll need to 
> re-test that.

the spin-up takes a few seconds here under suspend/resume simulation:

 | ata1: waiting for device to spin up (7 secs)
 | Restarting tasks ... done.

 [5-10 seconds pass]

 | ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 | ata1.00: configured for UDMA/100
 | SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
 | sda: Write Protect is off
 | sda: Mode Sense: 00 3a 00 00
 | SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

with real resume it takes even longer time - but i dont see where the 
delays come from in that case - i suspect it's SATA.

i'm also getting this WARN_ON() from e1000:

BUG: at drivers/pci/msi.c:611 pci_enable_msi()
 [<c01061bd>] show_trace_log_lvl+0x19/0x2e
 [<c01062b6>] show_trace+0x12/0x14
 [<c01062cc>] dump_stack+0x14/0x16
 [<c024fcc4>] pci_enable_msi+0x6d/0x203
 [<c02b709e>] e1000_request_irq+0x2e/0xe2
 [<c02bb742>] e1000_resume+0x7f/0xef
 [<c0249a68>] pci_device_resume+0x1a/0x44
 [<c02b39ec>] resume_device+0xf7/0x16f
 [<c02b3adb>] dpm_resume+0x77/0xcb
 [<c02b3b69>] device_resume+0x3a/0x51
 [<c014e669>] enter_state+0x193/0x1bb
 [<c014e712>] state_store+0x81/0x97
 [<c01b68bc>] subsys_attr_store+0x20/0x25
 [<c01b6feb>] sysfs_write_file+0xce/0xf6
 [<c017e16b>] vfs_write+0xb1/0x13a
 [<c017e899>] sys_write+0x3d/0x61
 [<c0105220>] syscall_call+0x7/0xb

seems harmless because it seems to work fine.

	Ingo
