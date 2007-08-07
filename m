Return-Path: <linux-kernel-owner+w=401wt.eu-S936679AbXHGWYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936679AbXHGWYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934679AbXHGWXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:23:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56118 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760342AbXHGWXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:23:17 -0400
Date: Tue, 7 Aug 2007 15:23:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Rafa=5F=5F?= Bilski <rafalbilski@interia.pl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove bdput from do_open() in fs/block_dev.c
Message-Id: <20070807152306.d4ef89a3.akpm@linux-foundation.org>
In-Reply-To: <46B4F432.4020408@interia.pl>
References: <46B4F432.4020408@interia.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Aug 2007 23:48:34 +0200
Rafa__ Bilski <rafalbilski@interia.pl> wrote:

> I mistyped
> # echo /dev/hdc1 >/sys/module/block2mtd/parameters/block2mt
> instead of sdc1. There is no /dev/hdc1. I have DVD-ROM as /dev/hdc.
> # dmesg
> block2mtd: version $Revision: 1.30 $
> block2mtd: error: cannot open device /dev/hdc1
> Looks right, but tray is locked. And it doesn't want to get out.
> # eject
> hdc: irq timeout: status=0xd0 { Busy }
> ide: failed opcode was: unknown
> WARNING: at kernel/irq/resend.c:70 check_irq_resend()
>  [<c013444b>] check_irq_resend+0xab/0xc0
>  [<c0133e2a>] enable_irq+0x4a/0xa0
>  [<c02c26e7>] ide_error+0x47/0xa0
>  [<c02d1e60>] cdrom_newpc_intr+0x0/0x300
>  [<c02c2bc0>] ide_timer_expiry+0x1e0/0x2d0
>  [<c02c29e0>] ide_timer_expiry+0x0/0x2d0
>  [<c011b986>] run_timer_softirq+0x116/0x160
>  [<c0127e75>] hrtimer_interrupt+0x165/0x1a0
>  [<c0118772>] __do_softirq+0x42/0x90
>  [<c01187e6>] do_softirq+0x26/0x30
>  [<c0118aaa>] irq_exit+0x5a/0x60
>  [<c0104817>] do_IRQ+0x47/0x80
>  [<c0102c23>] common_interrupt+0x23/0x30
>  [<c0281a46>] acpi_processor_idle+0x162/0x380
>  [<c0100d0e>] cpu_idle+0x4e/0x70
>  [<c0524ac5>] start_kernel+0x1f5/0x240
>  [<c05243a0>] unknown_bootoption+0x0/0x1e0
>  =======================
> 
> Removing bdput from do_open() in fs/block_dev.c seems 
> to be a cure for irq timeout.
> 
> Signed-off-by: Rafa__ Bilski <rafalbilski@interia.pl>
> --- 
> diff --git a/fs/block_dev.c b/fs/block_dev.c 
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1120,7 +1120,6 @@ static int do_open(struct block_device *
>  	disk = get_gendisk(bdev->bd_dev, &part);
>  	if (!disk) {
>  		unlock_kernel();
> -		bdput(bdev);
>  		return ret;
>  	}
>  	owner = disk->fops->owner;
> 

>From my reading, this patch will fix the blkdev_get() error path, but will
break the blkdev_open() path.

It could be that we also need to add a bdput() into blkdev_open() if
do_open() failed (to balance blkdev_open()'s bd_acquire()).

It's pretty damn ugly that do_open() attempts to fix up the caller's
refcounting.

