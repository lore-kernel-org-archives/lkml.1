Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXJUMoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXJUMoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXJUMoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:44:32 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13179 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbXJUMob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:44:31 -0400
Date: Sun, 21 Oct 2007 14:44:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [bug] block subsystem related crash on Legacy iSeries  viodasd.c
Message-ID: <20071021124426.GS10674@kernel.dk>
References: <1192829614.11003.30.camel@farscape.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192829614.11003.30.camel@farscape.rchland.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19 2007, Will Schmidt wrote:
> Hi Jens, Stephen, and Everyone else.
> 
>    I am seeing this crash on a legacy iSeries box.   Bisect points at
> 70eb8040dc81212c884a464b75e37dca8014f3ad  (Add chained sg support to
> linux/scatterlist.h).
> 
> I see there were some related troubles discussed a couple days back.
> I've refreshed my tree, so believe I should have pulled in all the
> changes that fixed those issues by now, so this is an additional problem
> (viodasd funkyness), or I've screwed something up in my pulls, or fixes
> are still pending in another tree. 
> 
> >From the register dump, looks like sg passed into memset was a -2.  
> 
> (from blk_rq_map_sg())	if (!sg)
> 				sg = sglist;
> 			else
> 				sg = sg_next(sg);
> 
> 			memset(sg, 0, sizeof(*sg));  <--
> 
> 
> linux-2.6.git tree at 
> 	commit 4fa4d23fa20de67df919030c1216295664866ad7
> 	Merge: a9e82d3... 4f1e5ba...
> 	Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> 	Date:   Thu Oct 18 19:31:54 2007 -0700
>     Merge branch 'upstream-linus' of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6
> 
> > git log drivers/scsi/scsi_lib.c
> commit a3bec5c5aea0da263111c4d8f8eabc1f8560d7bf
> Author: Jens Axboe <axboe@carl.home.kernel.dk>
> Date:   Wed Oct 17 19:33:05 2007 +0200
> 
>     Revert "[SCSI] Remove full sg table memset()"
> 
> > > git log block/ll_rw_blk.c
> commit ba951841ceb7fa5b06ad48caa5270cc2ae17941e
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Wed Oct 17 19:34:11 2007 +0200
> 
>     [BLOCK] blk_rq_map_sg() next_sg fixup
> 
> --  The panic is:
> Freeing unused kernel memory: 224k freed
> Unable to handle kernel paging request for data at address 0xfffffffffffffffe
> Faulting instruction address: 0xc0000000000282f0
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=32 iSeries
> Modules linked in:
> NIP: c0000000000282f0 LR: c0000000001c772c CTR: 0000000000000000
> REGS: c000000002026b00 TRAP: 0300   Not tainted  (2.6.23)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 44000022  XER: 00000008
> DAR: fffffffffffffffe, DSISR: 0000000042000000
> TASK = c000000002022000[1] 'swapper' THREAD: c000000002024000 CPU: 1
> GPR00: 0000000000000002 c000000002026d80 c0000000005168c8 fffffffffffffffe
> GPR04: 0000000000000000 000000000000001e fffffffffffffffe 0000000000000000
> GPR08: 0000000000000000 0000000000000001 6db6db6db6db6db7 0000000001491000
> GPR12: c00000000058d000 c000000000464f80 0000000000000000 c000000002027780
> GPR16: c00000000300a0c8 0000000000000001 c0000000004d4dd0 c00000000297e868
> GPR20: c000000002720000 c000000002026ec0 0000000000000001 0000000000000003
> GPR24: 0000000000000000 c000000002720000 0000000000001000 0000000000000003
> GPR28: fffffffffffffffe c000000002a61000 c0000000004c2510 c0000000027f64b0
> NIP [c0000000000282f0] .memset+0x3c/0xfc
> LR [c0000000001c772c] .blk_rq_map_sg+0x154/0x1e8
> Call Trace:
> [c000000002026d80] [c0000000004d4ed8] 0xc0000000004d4ed8 (unreliable)
> [c000000002026e50] [c0000000002283d8] .do_viodasd_request+0xb4/0x448
> [c0000000020270a0] [c0000000001c8ddc] .__generic_unplug_device+0x54/0x6c
> [c000000002027120] [c0000000001ca438] .generic_unplug_device+0x30/0x78
> [c0000000020271b0] [c0000000001c5888] .blk_backing_dev_unplug+0x34/0x48
> [c000000002027230] [c0000000000cf75c] .block_sync_page+0x78/0x90
> [c0000000020272b0] [c000000000074d50] .sync_page+0x74/0x98
> [c000000002027330] [c000000000344538] .__wait_on_bit_lock+0x8c/0x110
> [c0000000020273d0] [c000000000074c94] .__lock_page+0x70/0x90
> [c0000000020274a0] [c0000000000758b4] .do_generic_mapping_read+0x248/0x47c
> [c0000000020275a0] [c000000000077644] .generic_file_aio_read+0x144/0x1d4
> [c000000002027680] [c0000000000a3ad8] .do_sync_read+0xc4/0x124
> [c000000002027820] [c0000000000a4350] .vfs_read+0xd8/0x1a4
> [c0000000020278c0] [c0000000000a965c] .kernel_read+0x38/0x5c
> [c000000002027960] [c0000000000aad18] .do_execve+0xe8/0x208
> [c000000002027a10] [c00000000000e0b4] .sys_execve+0x6c/0xf0
> [c000000002027ab0] [c000000000007540] syscall_exit+0x0/0x40
> --- Exception: c01 at .kernel_execve+0x8/0x14
>     LR = .run_init_process+0x28/0x40
> [c000000002027da0] [c0000000000b35ec] .sys_dup+0x2c/0x44 (unreliable)
> [c000000002027e20] [c000000000007fb4] .init_post+0xc4/0xe8
> [c000000002027ea0] [c000000000407978] .kernel_init+0x384/0x3b8
> [c000000002027f90] [c000000000020000] .kernel_thread+0x4c/0x68
> Instruction dump:
> 5084801e 7c850040 7884000e 7c001120 7c661b78 418400ac 41a2002c 7ca02850
> 409f000c 98860000 38c60001 409e000c <b0860000> 38c60002 409d000c 90860000
> Kernel panic - not syncing: Attempted to kill init!
> Rebooting in 180 seconds..                                       

You need this, will remember to fix that up for the new branch as well.

diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index e824b67..2ce3622 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -270,6 +270,7 @@ static int send_request(struct request *req)
         d = req->rq_disk->private_data;
 
 	/* Now build the scatter-gather list */
+	memset(sg, 0, sizeof(sg));
 	nsg = blk_rq_map_sg(req->q, req, sg);
 	nsg = dma_map_sg(d->dev, sg, nsg, direction);
 

-- 
Jens Axboe

