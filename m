Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbXERHhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbXERHhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbXERHhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:37:16 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20794 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854AbXERHhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:37:14 -0400
Date: Fri, 18 May 2007 09:35:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Message-ID: <20070518073525.GD23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk> <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com> <20070515172001.GB23798@kernel.dk> <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com> <20070515175025.GE23798@kernel.dk> <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com> <20070517062742.GW23798@kernel.dk> <1179414911.23725.7.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179414911.23725.7.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17 2007, Badari Pulavarty wrote:
> On Thu, 2007-05-17 at 08:27 +0200, Jens Axboe wrote:
> > On Wed, May 16 2007, Badari Pulavarty wrote:
> > > On Tue, 2007-05-15 at 19:50 +0200, Jens Axboe wrote:
> > > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > > On Tue, 2007-05-15 at 19:20 +0200, Jens Axboe wrote:
> > > > > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > > > > On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > Updated version of the patch - this time I'll just attach the patch
> > > > > > > > file...
> > > > > > > 
> > > > > > > Missing scatterlist.h inclusions..
> > > > > > > 
> > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> > > > > > > of function ???for_each_sg???
> > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> > > > > > > token
> > > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> > > > > > > make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> > > > > > > 
> > > > > > > 
> > > > > > > drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> > > > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> > > > > > > function ???for_each_sg???
> > > > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> > > > > > > token
> > > > > > 
> > > > > > Thanks, will fix those. What arch? I tested it here.
> > > > > 
> > > > > I am playing with them on ppc64.
> > > > 
> > > > Ah ok, you need the updated patch series for ppc64 support. Builds fine
> > > > here on ppc64. See the #sglist branch of the block repo:
> > > > 
> > > > git://git.kernel.dk/data/git/linux-2.6-block.git
> > > > 
> > > > I can mail you an updated patch, if you want.
> > > 
> > > 
> > > Here is the whole panic stack..
> > 
> > Thanks will fix that up, the IDE part is totally untested. Can you try
> > and backout this patch and see if it boots?
> 
> I increased max_segments to 1024 on my qla2200 attached disks and
> simple "dd" (direct read) resulted in following:
> 
> elm3b29:/sys/block/sdd/queue # echo 1024 > max_segments
> elm3b29:/sys/block/sdd/queue # cat max_hw_sectors_kb > max_sectors_kb
> elm3b29:/mnt # dd iflag=direct if=./z of=/dev/null bs=512M
> 
> Unable to handle kernel paging request at 0000000000001008 RIP:
>  [<ffffffff8025e7af>] __rmqueue+0x6f/0x120

Auch, that's a bug. I don't think the oom path has been tested yet,
perhaps this is hitting it.

Can you try with this debug patch, plus enable the slab debugging
helpers (like poisoning)?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7456992..a479d1e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -793,6 +793,7 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	return ret;
 enomem:
 	if (ret) {
+		printk(KERN_ERR "scsi: failed to allocate sg table\n");
 		/*
 		 * Free entries chained off ret. Since we were trying to
 		 * allocate another sglist, we know that all entries are of

-- 
Jens Axboe

