Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbXG0Sbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbXG0Sbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbXG0Sba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:31:30 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:63413 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880AbXG0Sb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ty7cEhxuYYIYmVcM6ryWBcIg/ydLA+BJpAIv+qjWTWhrADlA33LA7+il1ZORVfV/saKPSxVrkHPVoU8hhGC8cEHh9LqK2Kszhm8sMpqhRm4sfYsq+uBbkgeEoNodzJTyPpPnSGB9ZW2cbDnyU420gn3cyo1UeLIwBFkZf+Sd5pw=
Message-ID: <a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com>
Date: Sat, 28 Jul 2007 00:01:27 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Eric Sandeen" <sandeen@sandeen.net>, "Andrea Arcangeli" <andrea@suse.de>,
       "Matt Mackall" <mpm@selenic.com>, "Rene Herman" <rene.herman@gmail.com>,
       "Ray Lee" <ray-lk@madrabbit.org>, "Bodo Eggert" <7eggert@gmx.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20070727183807.2d7dbe7b@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BF104.1040703@gmail.com> <20070716232755.GD11115@waste.org>
	 <20070719001539.GC29728@v2.random>
	 <20070719013955.1bedc423@the-village.bc.nu>
	 <20070719013358.GD29728@v2.random> <20070719013725.GP11115@waste.org>
	 <20070719112436.GG29728@v2.random>
	 <20070719124419.48c3d610@the-village.bc.nu>
	 <46A9ECD5.3050801@sandeen.net>
	 <20070727183807.2d7dbe7b@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Maybe I should resurrect it & send it out...

Hmm, something that hooks in not only at do_IRQ time (as the present
in-mainline stackoverflow check thing)?

> > (FWIW I think I recall that the warning itself sometimes tipped the
> > scales enough on 4k stacks to bring the box down)
>
> You can always switch stack for the printk and it probably should panic
> at that point and give a trace then die as that is what we are trying to
> prove does not occur

Yes, only yesterday I saw exactly this happening DEBUG_STACKOVERFLOW
when doing a udf -> pktcdvd -> cdrom -> ide_cd thing. It's one of those
reproducible will-crash-4k-stacks tests, especially if you have debug stuff
enabled in your build that would make on-stack structures (where such
exist on the codepath) a bit heavier.

Admittedly, what seems to have happened is a bit pathological:

[  481.836378] cdrom: entering cdrom_count_tracks
[  481.844266] BUG: sleeping function called from invalid context at
include/asm/semaphore.h:98
[  481.844434] do_IRQ: stack overflow: 164
[  481.844540]  [<c0405cfe>] show_trace_log_lvl+0x19/0x2e
[  481.844707]  [<c0405dfe>] show_trace+0x12/0x14
[  481.844867]  [<c0405e14>] dump_stack+0x14/0x16
[  481.845027]  [<c0406ff6>] do_IRQ+0x7b/0xe1
[  481.845186]  [<c040583e>] common_interrupt+0x2e/0x34
[  481.845348]  [<c042b8e7>] printk+0x1b/0x1d
[  481.845507]  [<c0422c05>] __might_sleep+0x81/0xdc
[  481.845668]  [<c066d869>] __reacquire_kernel_lock+0x2d/0x4f
[  481.845833]  [<c066b09b>] schedule+0x78a/0x7a4
[  481.845996]  [<c066b538>] wait_for_completion+0x72/0x97
[  481.846160]  [<c05937a6>] ide_do_drive_cmd+0xeb/0x109
[  481.846324]  [<f89172a2>] cdrom_queue_packet_command+0x40/0xc5 [ide_cd]
[  481.846503]  [<f89175b7>] ide_cdrom_packet+0x86/0xa4 [ide_cd]
[  481.846669]  [<f8854dc1>] cdrom_get_disc_info+0x48/0x87 [cdrom]
[  481.846839]  [<f8854ec6>] cdrom_get_last_written+0x2a/0xfe [cdrom]
[  481.847009]  [<f891831b>] cdrom_read_toc+0x39d/0x3f3 [ide_cd]
[  481.847231]  [<f8918e7e>] ide_cdrom_audio_ioctl+0x130/0x1ce [ide_cd]
[  481.847414]  [<f8854123>] cdrom_count_tracks+0x5c/0x126 [cdrom]
[  481.847583]  [<f8855688>] cdrom_open+0x147/0x79c [cdrom]
[  481.847748]  [<f891799a>] idecd_open+0x75/0x8a [ide_cd]
[  481.847912]  [<c04aac0e>] do_open+0x1d1/0x284
[  481.848079]  [<c04aad89>] __blkdev_get+0x73/0x7e
[  481.848242]  [<c04aada9>] blkdev_get+0x15/0x17
[  481.848411]  [<f8b34b6b>] pkt_open+0x99/0xc6e [pktcdvd]
[  481.848583]  [<c04aaad3>] do_open+0x96/0x284
[  481.848745]  [<c04aad89>] __blkdev_get+0x73/0x7e
[  481.848910]  [<c04aada9>] blkdev_get+0x15/0x17

(... the trace cut off there, and then the box froze hard, no sysrq ...)

The mount(2) hit the wait_for_completion() in ide_do_drive_cmd(),
little stack was left at this point. But then I have no idea why the
__reacquire_kernel_lock() from schedule() gave a might_sleep() there,
the code in sched.c and kernel_lock.c looks obviously correct -- the
down(&kernel_sem) only happens with both irqs and preemption on.

Anyway, the second line of printk() in __might_sleep (the one that
tells us in_atomic() and irqs_disabled()) was about to be printed when
an interrupt decided to join the fun. do_IRQ() comes in, with debug
stackoverflows on, it notices that only 164 bytes worth of stack is left
and decides to dump_stack ... and while we were doing just that,
we died. (this was 2.6.23-rc1-mm1)
