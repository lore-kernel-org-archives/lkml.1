Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYBDMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYBDMnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYBDMnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:43:10 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8313 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYBDMnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:43:09 -0500
Date: Mon, 4 Feb 2008 13:43:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dragon kumar <disaster2008@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: soft lock failure on FC8
Message-ID: <20080204124305.GH15220@kernel.dk>
References: <216e58580802040422u27c1efa0vf1d02b194514888e@mail.gmail.com> <20080204043347.a66b0226.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204043347.a66b0226.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04 2008, Andrew Morton wrote:
> On Mon, 4 Feb 2008 17:52:16 +0530 "Dragon kumar" <disaster2008@gmail.com> wrote:
> 
> > Hi Andrew,
> > 
> > I am not able to boot 2.6.24-mm1 kernel on x86_64 machine with FC8. I
> > am attaching config file and call trace also with this mail.
> > 
> > 
> > [  921.273592] BUG: soft lockup - CPU#0 stuck for 61s! [scsi_scan_0:473]
> > [  921.273601] CPU 0:
> > [  921.273601] Modules linked in: scsi_wait_scan tg3 shpchp
> > pci_hotplug aacraid sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd
> > ssb ehci_hcd usbcore
> > [  921.273601] Pid: 473, comm: scsi_scan_0 Not tainted 2.6.24-mm1-autokern1 #1
> > [  921.273601] RIP: 0010:[<ffffffff8031fa1b>]  [<ffffffff8031fa1b>]
> > radix_tree_gang_lookup+0xe1/0x139
> > [  921.273601] RSP: 0018:ffff81007d99bda8  EFLAGS: 00000293
> > [  921.273601] RAX: 0000000000000000 RBX: ffff81007d99bde0 RCX: 0000000000000000
> > [  921.273601] RDX: 0000000000000000 RSI: ffff81007d8f2690 RDI: 000000000000000c
> > [  921.273601] RBP: 0000000000000001 R08: ffff81007d8dce0c R09: 0000000000000001
> > [  921.273601] R10: ffff81007d90caf0 R11: 000000000000000d R12: ffff81000106ac00
> > [  921.273601] R13: ffff8100808ed000 R14: ffff81007d99a000 R15: ffffffff8077eef0
> > [  921.273601] FS:  0000000000000000(0000) GS:ffffffff8057e000(0000)
> > knlGS:0000000000000000
> > [  921.273601] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [  921.273601] CR2: 00000000006167d0 CR3: 0000000000201000 CR4: 00000000000006e0
> > [  921.273601] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  921.273601] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [  921.273601]
> > [  921.273601] Call Trace:
> > [  921.273601]  [<ffffffff8031870d>] ? call_for_each_cic+0x72/0x104
> > [  921.273601]  [<ffffffff80318e84>] ? cfq_exit_single_io_context+0x0/0x4e
> > [  921.273601]  [<ffffffff803187b7>] ? cfq_exit_io_context+0x18/0x1a
> > [  921.273601]  [<ffffffff80311844>] ? exit_io_context+0x101/0x111
> > [  921.273601]  [<ffffffff80239e53>] ? do_exit+0x794/0x7c1
> > [  921.273601]  [<ffffffff8020d03f>] ? child_rip+0x11/0x12
> > [  921.273601]  [<ffffffff8020c703>] ? restore_args+0x0/0x30
> > [  921.273601]  [<ffffffff80249c5d>] ? kthreadd+0x17d/0x1a2
> > [  921.273601]  [<ffffffff80249da9>] ? kthread+0x0/0x77
> > [  921.273601]  [<ffffffff8020d02e>] ? child_rip+0x0/0x12
> > [  921.273601]
> > 
> 
> At a guess I'd say that call_for_each_cic() is failing to advance across
> the radix-tree and got stuck.

I'd say that's a good guess, I don't see how else it could get stuck
looping forever.

> 
> Could you please apply this debug patch and retest?
> 
> Thanks.
> 
> diff -puN block/cfq-iosched.c~a block/cfq-iosched.c
> --- a/block/cfq-iosched.c~a
> +++ a/block/cfq-iosched.c
> @@ -1159,6 +1159,7 @@ call_for_each_cic(struct io_context *ioc
>  
>  	do {
>  		int i;
> +		unsigned long next_index;
>  
>  		/*
>  		 * Perhaps there's a better way - this just gang lookups from
> @@ -1171,8 +1172,13 @@ call_for_each_cic(struct io_context *ioc
>  			break;
>  
>  		called += nr;
> -		index = 1 + (unsigned long) cics[nr - 1]->key;
> -
> +		next_index = 1 + (unsigned long) cics[nr - 1]->key;
> +		if (next_index <= index) {
> +			printk("next_index=%lu, index=%lu\n",
> +				next_index, index);
> +			dump_stack();
> +		}
> +		index = next_index;
>  		for (i = 0; i < nr; i++)
>  			func(ioc, cics[i]);
>  	} while (nr == CIC_GANG_NR);
> _
> 

-- 
Jens Axboe

