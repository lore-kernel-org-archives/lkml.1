Return-Path: <linux-kernel-owner+w=401wt.eu-S936634AbXEVPf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936634AbXEVPf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936523AbXEVPe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:34:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49587 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936514AbXEVPe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:34:26 -0400
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: Badari Pulavarty <pbadari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
In-Reply-To: <20070521061445.GD14746@kernel.dk>
References: <20070511135108.GF4629@kernel.dk>
	 <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515172001.GB23798@kernel.dk>
	 <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515175025.GE23798@kernel.dk>
	 <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20070517062742.GW23798@kernel.dk>
	 <1179414911.23725.7.camel@dyn9047017100.beaverton.ibm.com>
	 <20070518073525.GD23798@kernel.dk>
	 <1179510664.29302.16.camel@dyn9047017100.beaverton.ibm.com>
	 <20070521061445.GD14746@kernel.dk>
Content-Type: text/plain
Date: Tue, 22 May 2007 08:35:10 -0700
Message-Id: <1179848110.29302.38.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 08:14 +0200, Jens Axboe wrote:
> On Fri, May 18 2007, Badari Pulavarty wrote:
> > On Fri, 2007-05-18 at 09:35 +0200, Jens Axboe wrote:
> > > On Thu, May 17 2007, Badari Pulavarty wrote:
> > > > On Thu, 2007-05-17 at 08:27 +0200, Jens Axboe wrote:
> > > > > On Wed, May 16 2007, Badari Pulavarty wrote:
> > > > > > On Tue, 2007-05-15 at 19:50 +0200, Jens Axboe wrote:
> > > > > > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > > > > > On Tue, 2007-05-15 at 19:20 +0200, Jens Axboe wrote:
> > > > > > > > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > > > > > > > On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > > > > > > > > > > Hi,
> > > > > > > > > > > 
> > > > > > > > > > > Updated version of the patch - this time I'll just attach the patch
> > > > > > > > > > > file...
> > > > > > > > > > 
> > > > > > > > > > Missing scatterlist.h inclusions..
> > > > > > > > > > 
> > > > > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> > > > > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> > > > > > > > > > of function ???for_each_sg???
> > > > > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> > > > > > > > > > token
> > > > > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> > > > > > > > > > make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> > > > > > > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> > > > > > > > > > function ???for_each_sg???
> > > > > > > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> > > > > > > > > > token
> > > > > > > > > 
> > > > > > > > > Thanks, will fix those. What arch? I tested it here.
> > > > > > > > 
> > > > > > > > I am playing with them on ppc64.
> > > > > > > 
> > > > > > > Ah ok, you need the updated patch series for ppc64 support. Builds fine
> > > > > > > here on ppc64. See the #sglist branch of the block repo:
> > > > > > > 
> > > > > > > git://git.kernel.dk/data/git/linux-2.6-block.git
> > > > > > > 
> > > > > > > I can mail you an updated patch, if you want.
> > > > > > 
> > > > > > 
> > > > > > Here is the whole panic stack..
> > > > > 
> > > > > Thanks will fix that up, the IDE part is totally untested. Can you try
> > > > > and backout this patch and see if it boots?
> > > > 
> > > > I increased max_segments to 1024 on my qla2200 attached disks and
> > > > simple "dd" (direct read) resulted in following:
> > > > 
> > > > elm3b29:/sys/block/sdd/queue # echo 1024 > max_segments
> > > > elm3b29:/sys/block/sdd/queue # cat max_hw_sectors_kb > max_sectors_kb
> > > > elm3b29:/mnt # dd iflag=direct if=./z of=/dev/null bs=512M
> > > > 
> > > > Unable to handle kernel paging request at 0000000000001008 RIP:
> > > >  [<ffffffff8025e7af>] __rmqueue+0x6f/0x120
> > > 
> > > Auch, that's a bug. I don't think the oom path has been tested yet,
> > > perhaps this is hitting it.
> > > 
> > > Can you try with this debug patch, plus enable the slab debugging
> > > helpers (like poisoning)?
> > > 
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 7456992..a479d1e 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -793,6 +793,7 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> > >  	return ret;
> > >  enomem:
> > >  	if (ret) {
> > > +		printk(KERN_ERR "scsi: failed to allocate sg table\n");
> > >  		/*
> > >  		 * Free entries chained off ret. Since we were trying to
> > >  		 * allocate another sglist, we know that all entries are of
> > > 
> > 
> > Not much help. I get all kinds of weird panics.. This time I got (with
> > the above debug).
> > 
> > general protection fault: 0000 [1] SMP
> > CPU 1
> > Modules linked in: jfs sg sd_mod qla2xxx firmware_class
> > scsi_transport_fc scsi_mod vfat fat ipv6 thermal processor fan button
> > battery ac dm_mod floppy parport_pc lp parport
> > Pid: 56, comm: kblockd/1 Not tainted 2.6.22-rc1-sg #8
> > RIP: 0010:[<ffffffff802816b6>]  [<ffffffff802816b6>] kmem_cache_alloc
> > +0x36/0x70
> > RSP: 0018:ffff81017abbfc10  EFLAGS: 00010002
> > RAX: 0000000000000000 RBX: 0000000000000082 RCX: 0600000000000064
> > RDX: ffff81019ff2b8a0 RSI: 0000000000011220 RDI: ffffffff8068d120
> > RBP: ffff81017abbfc20 R08: 00000000000039f8 R09: 0000000000000000
> > R10: ffff81019cbee700 R11: 0000000000000188 R12: ffff8101df2a64e0
> > R13: 0000000000011220 R14: ffff8101df2a6510 R15: ffff81017abbfc50
> > FS:  00002b505b027f20(0000) GS:ffff81018021f300(0000)
> > knlGS:00000000f7da26b0
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 00002b505b029008 CR3: 000000019af73000 CR4: 00000000000006e0
> > Process kblockd/1 (pid: 56, threadinfo ffff81017abbe000, task
> > ffff81017a571440)
> > Stack:  000000007abbfc30 0000000000000000 ffff81017abbfc30
> > ffffffff8025d001
> >  ffff81017abbfcb0 ffffffff8025d122 ffff81017abbfc60 ffffffff80219dc0
> >  ffffffff880e5da6 00000000000000ad ffff81017abbfcd0 ffffffff8021a366
> > Call Trace:
> >  [<ffffffff8025d001>] mempool_alloc_slab+0x11/0x20
> >  [<ffffffff8025d122>] mempool_alloc+0x42/0x110
> >  [<ffffffff80219dc0>] flush_gart+0x40/0x50
> >  [<ffffffff880e5da6>] :scsi_mod:__scsi_get_command+0x26/0x90
> >  [<ffffffff8021a366>] gart_map_sg+0x2d6/0x3e0
> 
> Smells like a bug in the gart modifications, I'll double check them.
> Does it work if you boot with iommu=off?
> 

Sorry for not getting back earlier. iommu=off on my machine generates
tons & tons of following messages and makes machine almost unusable..

nommu_map_sg: overflow 1da18f000+4096 of device mask ffffffff
nommu_map_sg: overflow 1d5322000+4096 of device mask ffffffff
nommu_map_sg: overflow 1d306f000+4096 of device mask ffffffff
nommu_map_sg: overflow 1dc233000+4096 of device mask ffffffff
nommu_map_sg: overflow 1d9d53000+4096 of device mask ffffffff
nommu_map_sg: overflow 1d5322000+4096 of device mask ffffffff
nommu_map_sg: overflow 1d306f000+4096 of device mask ffffffff
nommu_map_sg: overflow 1da189000+4096 of device mask ffffffff
nommu_map_sg: overflow 1d9d97000+4096 of device mask ffffffff
nommu_map_sg: overflow 1d5322000+4096 of device mask ffffffff
nommu_map_sg: overflow 1d306f000+4096 of device mask ffffffff

I will apply the suggested patch and re-run the test.

Thanks,
Badari

