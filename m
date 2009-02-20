Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZBTQK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZBTQK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZBTQKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:10:12 -0500
Received: from www17.your-server.de ([213.133.104.17]:46626 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZBTQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:10:09 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Thomas Meyer <thomas@m3y3r.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       "jens.axboe" <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1235116151.4736.12.camel@laptop>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <1235111568.3363.3.camel@localhost.localdomain>
	 <1235116151.4736.12.camel@laptop>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 16:09:08 +0100
Message-Id: <1235142548.3588.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 20.02.2009, 08:49 +0100 schrieb Peter Zijlstra:
> On Fri, 2009-02-20 at 07:32 +0100, Thomas Meyer wrote:
> > Are you interested in these BUG reports?
> 
> Yes we are, thanks!
> 
> > Without CONFIG_HIGHPTE kernel boots and seems to work correct, but I'm
> > hitting these two BUGs:
> 
> They appear to be identical, so I'll consider them two instances of one
> bug :-)
> 
> > [   19.840100] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
> > [   19.840105] in_atomic(): 0, irqs_disabled(): 1, pid: 718, name: IRQ-14
> > [   19.840110] Pid: 718, comm: IRQ-14 Tainted: G        W  2.6.29-rc4-rt2-tip #55
> > [   19.840113] Call Trace:
> > [   19.840123]  [<c0444cbd>] __might_sleep+0xda/0xf0
> > [   19.840128]  [<c043ee31>] kmap+0x50/0x77
> > [   19.840133]  [<c0663e35>] sg_miter_next+0xc1/0xdf
> > [   19.840137]  [<c0663ee8>] sg_copy_buffer+0x95/0xc5
> > [   19.840141]  [<c0663f35>] sg_copy_to_buffer+0x1d/0x33
> > [   19.840149]  [<c0774ab1>] atapi_qc_complete+0x25a/0x2c5
> > [   19.840153]  [<c076dece>] __ata_qc_complete+0xb4/0xcd
> > [   19.840157]  [<c076f844>] ata_qc_complete+0x1be/0x1d7
> > [   19.840162]  [<c077c812>] ata_hsm_qc_complete+0xa9/0xd3
> > [   19.840166]  [<c077ceb7>] ata_sff_hsm_move+0x67b/0x6da
> > [   19.840171]  [<c077d19b>] ata_sff_interrupt+0x15d/0x205
> > [   19.840176]  [<c049440a>] handle_IRQ_event+0x4b/0xce
> > [   19.840180]  [<c0494ac7>] do_irqd+0x141/0x271
> > [   19.840184]  [<c0494986>] ? do_irqd+0x0/0x271
> > [   19.840189]  [<c0467022>] kthread+0x4a/0x82
> > [   19.840192]  [<c0466fd8>] ? kthread+0x0/0x82
> > [   19.840197]  [<c0420b67>] kernel_thread_helper+0x7/0x10
> 
> sg_copy_buffer() seems to disable IRQs, however since on -rt everything
> is a irq-thread and kmap is preemptible, we don't appear to have that
> need.
> 
> CC'd everybody who ever touched the file.
> 
> ---
>  lib/scatterlist.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index b7b449d..4c6510d 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -426,7 +426,7 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
>  
>  	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC);
>  
> -	local_irq_save(flags);
> +	local_irq_save_nort(flags);
>  
>  	while (sg_miter_next(&miter) && offset < buflen) {
>  		unsigned int len;
> @@ -445,7 +445,7 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
>  
>  	sg_miter_stop(&miter);
>  
> -	local_irq_restore(flags);
> +	local_irq_restore_nort(flags);
>  	return offset;
>  }
>  

With above patch I get a lot of warnings in 

lib/scatterlist.c:395 sg_miter_stop+0x5a/0xa4().

Like:
[   34.946650] ------------[ cut here ]------------
[   34.946653] WARNING: at lib/scatterlist.c:395 sg_miter_stop+0x5a/0xa4()
[   34.946655] Hardware name: MacBookPro1,1
[   34.946657] Modules linked in: ath5k mac80211 cfg80211 video [last unloaded: scsi_wait_scan]
[   34.946665] Pid: 8, comm: sirq-block/0 Tainted: G        W  2.6.29-rc4-rt2-tip #56
[   34.946690] Call Trace:
[   34.946694]  [<c0451e50>] warn_slowpath+0x8a/0xd3
[   34.946698]  [<c09ab0e4>] ? __spin_unlock+0x1e/0x43
[   34.946703]  [<c04476d6>] ? enqueue_task_fair+0x2df/0x331
[   34.946707]  [<c0442c7c>] ? enqueue_task+0x70/0x8e
[   34.946711]  [<c044cf91>] ? try_to_wake_up+0x2eb/0x306
[   34.946715]  [<c0663e0a>] sg_miter_stop+0x5a/0xa4
[   34.946719]  [<c0663fd6>] sg_copy_buffer+0xa3/0xbe
[   34.946723]  [<c0664041>] sg_copy_from_buffer+0x1d/0x33
[   34.946728]  [<c0774c3d>] ata_scsi_rbuf_fill+0x59/0x90
[   34.946731]  [<c07760ed>] ? ata_scsiop_inq_80+0x0/0x41
[   34.946735]  [<c0755b3e>] ? scsi_done+0x0/0x2d
[   34.946739]  [<c0755b3e>] ? scsi_done+0x0/0x2d
[   34.946743]  [<c0774e24>] ata_scsi_simulate+0x1b0/0x1f8
[   34.946747]  [<c0755b3e>] ? scsi_done+0x0/0x2d
[   34.946752]  [<c0775178>] ata_scsi_queuecmd+0x16d/0x1bc
[   34.946756]  [<c0755de0>] scsi_dispatch_cmd+0x18a/0x208
[   34.946760]  [<c075b378>] scsi_request_fn+0x349/0x487
[   34.946764]  [<c064bcb6>] blk_invoke_request_fn+0x75/0x146
[   34.946768]  [<c064c671>] __blk_run_queue+0x2d/0x42
[   34.946772]  [<c064c6ac>] blk_run_queue+0x26/0x46
[   34.946775]  [<c075a836>] scsi_run_queue+0x283/0x321
[   34.946780]  [<c075b6c9>] scsi_next_command+0x36/0x54
[   34.946783]  [<c075b8e2>] scsi_end_request+0x84/0xa1
[   34.946787]  [<c075beb9>] scsi_io_completion+0x1a4/0x3a6
[   34.946792]  [<c075c1be>] ? scsi_device_unbusy+0x8c/0xa3
[   34.946796]  [<c0755b25>] scsi_finish_command+0xd3/0xec
[   34.946800]  [<c075c3bc>] scsi_softirq_done+0x104/0x11d
[   34.946804]  [<c06505df>] blk_done_softirq+0x5f/0x7e
[   34.946808]  [<c04575e3>] ksoftirqd+0x12d/0x223
[   34.946813]  [<c04574b6>] ? ksoftirqd+0x0/0x223
[   34.946816]  [<c0467022>] kthread+0x4a/0x82
[   34.946820]  [<c0466fd8>] ? kthread+0x0/0x82
[   34.946824]  [<c0420b67>] kernel_thread_helper+0x7/0x10
[   34.946827] ---[ end trace a7919e7f17c0a754 ]---


