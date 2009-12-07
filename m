Return-Path: <linux-kernel-owner+w=401wt.eu-S964886AbZLGSDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886AbZLGSDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964858AbZLGSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:03:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964832AbZLGSDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:03:08 -0500
Date: Mon, 7 Dec 2009 13:03:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was
	delayed
Message-ID: <20091207180311.GF16900@redhat.com>
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com> <4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com> <4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com> <20091206104950.GN8742@kernel.dk> <x49iqciyis3.fsf@segfault.boston.devel.redhat.com> <20091207144149.GZ8742@kernel.dk> <x493a3mg2bs.fsf@segfault.boston.devel.redhat.com> <20091207172747.GE16900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207172747.GE16900@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 12:27:47PM -0500, Vivek Goyal wrote:

[..]
> > next-2.6.33 won't boot for me:
> > 
> > general protection fault: 0000 [#1] SMP
> > async/0 used greatest stack depth: 4256 bytes left
> > 
> > last sysfs file: /sys/class/firmware/timeout
> > CPU 1
> > Modules linked in: ata_piix pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uh
> > ci_hcd ohci_hcd ehci_hcd
> > Pid: 729, comm: async/1 Not tainted 2.6.32 #1 ProLiant DL320 G5p
> > RIP: 0010:[<ffffffff81199cee>]  [<ffffffff81199cee>] cfq_put_cfqg+0x0/0x91
> > RSP: 0018:ffff8801251b1d48  EFLAGS: 00010002
> > RAX: ffff880126dcdd28 RBX: ffff8801251fa158 RCX: 0000000000170001
> > RDX: ffff880125556700 RSI: ffff8801251fa158 RDI: 6b6b6b6b6b6b6b6b
> > RBP: ffff8801251b1d70 R08: ffff8801255a0448 R09: 000000000000005a
> > R10: ffff8801255a0448 R11: ffffffff818d6210 R12: ffff880126dcdb18
> > R13: ffff880126dcdb50 R14: 0000000000000286 R15: ffff880125556760
> > FS:  0000000000000000(0000) GS:ffff88002f200000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 0000000000000000 CR3: 00000001256a5000 CR4: 00000000000006a0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process async/1 (pid: 729, threadinfo ffff8801251b0000, task ffff880125556770)
> > Stack:
> >  ffffffff8119a856 0000000000000002 ffff880126dcdb18 ffff8801251fa158
> > <0> ffff880125210000 ffff8801251b1d90 ffffffff8119a9e5 ffff8801251f80d0
> > <0> ffff880126dcdb18 ffff8801251b1db0 ffffffff8119aa62 ffff880126dcdb18
> > Call Trace:
> >  [<ffffffff8119a856>] ? cfq_put_queue+0xfa/0x102
> >  [<ffffffff8119a9e5>] cfq_exit_cfqq+0x99/0x9e
> >  [<ffffffff8119aa62>] __cfq_exit_single_io_context+0x78/0x85
> >  [<ffffffff8119aaa9>] cfq_exit_single_io_context+0x3a/0x52
> >  [<ffffffff8119aa6f>] ? cfq_exit_single_io_context+0x0/0x52
> >  [<ffffffff8119b27b>] call_for_each_cic+0x56/0x7c
> >  [<ffffffff8119b225>] ? call_for_each_cic+0x0/0x7c
> >  [<ffffffff8119b2b1>] cfq_exit_io_context+0x10/0x12
> >  [<ffffffff81192d3b>] exit_io_context+0x93/0xbc
> >  [<ffffffff81192d03>] ? exit_io_context+0x5b/0xbc
> >  [<ffffffff810474e5>] do_exit+0x71a/0x747
> >  [<ffffffff810628f1>] ? async_thread+0x0/0x1fa
> >  [<ffffffff8105cd9e>] kthread_stop+0x0/0xb3
> >  [<ffffffff81033fa6>] ? complete+0x1c/0x4b
> >  [<ffffffff8100cafa>] child_rip+0xa/0x20
> >  [<ffffffff8103d667>] ? finish_task_switch+0x0/0xe3
> >  [<ffffffff8100c4bc>] ? restore_args+0x0/0x30
> >  [<ffffffff8105ccf8>] ? kthreadd+0xdf/0x100
> >  [<ffffffff8105cd19>] ? kthread+0x0/0x85
> >  [<ffffffff8100caf0>] ? child_rip+0x0/0x20
> > Code: 48 c7 43 38 00 00 00 00 48 c7 43 40 00 00 00 00 48 89 3e 48 8b 73 48 e8 fd 9e 00 00 eb 08 48 c7 43 48 00 00 00 00 5b 41 5c c9 c3 <8b> 87 d8 01 00 00 55 48 89 e5 85 c0 7f 04 0f 0b eb fe 48 8d 87
> > RIP  [<ffffffff81199cee>] cfq_put_cfqg+0x0/0x91
> >  RSP <ffff8801251b1d48>
> 
> Hm.., I seem to be accessing cfqq->orig_cfqg, after I have freed cfqq.
> Following patch should fix it. Testing it now.
> 

I tested this patch and it is working. Now system boots fine. Thanks for
loaning the system to me Jeff.

Vivek

> Thanks
> Vivek
> 
> Index: linux-2.6-block/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6-block.orig/block/cfq-iosched.c
> +++ linux-2.6-block/block/cfq-iosched.c
> @@ -2368,7 +2368,7 @@ static int cfq_dispatch_requests(struct 
>  static void cfq_put_queue(struct cfq_queue *cfqq)
>  {
>  	struct cfq_data *cfqd = cfqq->cfqd;
> -	struct cfq_group *cfqg;
> +	struct cfq_group *cfqg, *orig_cfqg;
>  
>  	BUG_ON(atomic_read(&cfqq->ref) <= 0);
>  
> @@ -2379,6 +2379,7 @@ static void cfq_put_queue(struct cfq_que
>  	BUG_ON(rb_first(&cfqq->sort_list));
>  	BUG_ON(cfqq->allocated[READ] + cfqq->allocated[WRITE]);
>  	cfqg = cfqq->cfqg;
> +	orig_cfqg = cfqq->orig_cfqg;
>  
>  	if (unlikely(cfqd->active_queue == cfqq)) {
>  		__cfq_slice_expired(cfqd, cfqq, 0);
> @@ -2388,8 +2389,8 @@ static void cfq_put_queue(struct cfq_que
>  	BUG_ON(cfq_cfqq_on_rr(cfqq));
>  	kmem_cache_free(cfq_pool, cfqq);
>  	cfq_put_cfqg(cfqg);
> -	if (cfqq->orig_cfqg)
> -		cfq_put_cfqg(cfqq->orig_cfqg);
> +	if (orig_cfqg)
> +		cfq_put_cfqg(orig_cfqg);
>  }
>  
>  /*
