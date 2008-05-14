Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbYENOu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbYENOu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYENOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:50:13 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:21714 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbYENOuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:50:10 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2008 10:50:09 EDT
Date: Wed, 14 May 2008 07:40:30 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm: bdi: export BDI attributes in sysfs
Message-ID: <20080514144030.GD6458@ajones-laptop.nbttech.com>
References: <20080513190435.GG23649@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080513190435.GG23649@ajones-laptop.nbttech.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,  Andrew Morton asked that I add some
details and a lkml cc: to this bug report.

This problem showed up in a test I have which
uses the ipmitool to repeatedly cycle power on
3 SATA disks connected to an AHCI controller:

00:1f.2 SATA controller: Intel Corporation: Unknown device 2922 (rev 02)
(prog-)
        Subsystem: Tyan Computer: Unknown device 6631
        Flags: bus master, 66Mhz, medium devsel, latency 0, IRQ 511
        I/O ports at fc00 [size=8]
        I/O ports at f880 [size=4]
        I/O ports at f800 [size=8]
        I/O ports at f480 [size=4]
        I/O ports at f400 [size=32]
        Memory at fdfff800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/4 Enabl+
        Capabilities: [70] Power Management version 3
        Capabilities: [a8] #12 [0010]
        Capabilities: [b0] #13 [0306]

About 1 in 4 times, when turning the power back
on for a drive, I get the BUG reported below.  The
drives are not mounted, just sitting there getting
power cycled (the test looks to make sure they are
being seen by the scsi subsystem and udev).

The ipmitool command which powers off disks 2 and 3 is:

ipmitool raw 0x06 0x52 0x07 0x36 0x00 0x01 0xfb
ipmitool raw 0x06 0x52 0x07 0x36 0x00 0x01 0xf7

The ipmitool command which powers on all disks is:

ipmitool raw 0x06 0x52 0x07 0x36 0x00 0x01 0xff

Though I expect these commands are not likely to
work anywhere but on the systems we have here...

Arthur

On Tue, May 13, 2008 at 12:04:35PM -0700, Arthur Jones wrote:
> Hi Peter,  When powering down then back up SATA drives
> on my box I found a BUG in the read_ahead_kb_show bdi
> device attribute code.  Somehow (I never tracked down
> why), the bdi is NULL occassionally in this code when
> running my test.  I'm not sure the right way to fix
> it, but the attached patch no longer causes the bug
> after many power cycles...
> 
> This code appeared in Linus' tree via:
> 
> commit cf0ca9fe5dd9e3693d935757a7b2fc50fc576554
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Wed Apr 30 00:54:32 2008 -0700
> 
>     mm: bdi: export BDI attributes in sysfs
>     
>     Provide a place in sysfs (/sys/class/bdi) for the backing_dev_info object.
>     This allows us to see and set the various BDI specific variables.
> 
>     [...]
> 
> The backtrace was:
> 
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000000
> IP: [<ffffffff802694e3>] read_ahead_kb_show+0x1b/0x2d
> PGD df92c067 PUD df92b067 PMD 0 
> Oops: 0000 [1] SMP 
> CPU 0 
> Modules linked in: iptable_mangle ip_tables x_tables ipmi_devintf
> ipmi_watchdoge
> Pid: 12752, comm: udev Tainted: GF         2.6.26-rc2SMP #5
> RIP: 0010:[<ffffffff802694e3>]  [<ffffffff802694e3>]
> read_ahead_kb_show+0x1b/0xd
> RSP: 0018:ffff8100778a1e98  EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffffffff8066a4e0 RCX: 0000000000000000
> RDX: ffffffff805eb4cf RSI: 0000000000000fff RDI: ffff810099cbf000
> RBP: fffffffffffffffb R08: ffff810099cbf000 R09: 000000000009b25f
> R10: 0000000000000000 R11: 0000000000000002 R12: ffff810099dd5870
> R13: ffffffff80682ec0 R14: ffff8100778a1f50 R15: 0000000000000000
> FS:  00007fed77fff6e0(0000) GS:ffffffff806ca000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 00000000df929000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process udev (pid: 12752, threadinfo ffff8100778a0000, task
> ffff81011e274800)
> Stack:  ffff81011fc02093 ffffffff803d88ea 0000000000000000
> ffff81011ddcc930
>  ffff81011e7c9780 ffffffff802cd2f9 0000000000000000 0000000000001000
>  000000000054bad0 ffff81009891a600 0000000000001000 000000000054bad0
> Call Trace:
>  [<ffffffff803d88ea>] ? dev_attr_show+0x1f/0x41
>  [<ffffffff802cd2f9>] ? sysfs_read_file+0xa5/0x128
>  [<ffffffff80286fca>] ? vfs_read+0xab/0x12e
>  [<ffffffff802872ce>] ? sys_read+0x45/0x6e
>  [<ffffffff8020b14b>] ? system_call_after_swapgs+0x7b/0x80
> 
> 
> Code: e5 48 89 45 00 5a 5b 5d 41 5c 4c 89 e8 41 5d c3 41 50 48 8b 87 e0
> 01 00 0 
> RIP  [<ffffffff802694e3>] read_ahead_kb_show+0x1b/0x2d
>  RSP <ffff8100778a1e98>
> CR2: 0000000000000000
> ---[ end trace 74e8b5443cce1870 ]---
> 
> Arthur

> mm: bdi: Check for NULL backing device
> 
> When powering down then powering up SATA drives,
> I found that the bdi would sometimes be NULL in
> the dev_get_drvdata(dev).  When showing device
> attributes, check for this condition to avoid
> a NULL pointer dereference.
> 
> Signed-off-by:  Arthur Jones <ajones@riverbed.com>
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 7c4f9e0..cc9393f 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -109,7 +109,10 @@ static ssize_t name##_show(struct device *dev,				\
>  {									\
>  	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
>  									\
> -	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
> +	if (!bdi)							\
> +		return snprintf(page, PAGE_SIZE - 1, "\n");		\
> +	else								\
> +		return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);\
>  }
>  
>  BDI_SHOW(read_ahead_kb, K(bdi->ra_pages))

