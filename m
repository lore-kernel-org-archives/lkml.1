Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXEOSZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXEOSZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXEOSZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:25:00 -0400
Received: from brick.kernel.dk ([80.160.20.94]:27020 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbXEOSZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:25:00 -0400
Date: Tue, 15 May 2007 20:23:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Message-ID: <20070515182336.GJ23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk> <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com> <20070515172001.GB23798@kernel.dk> <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com> <20070515175025.GE23798@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515175025.GE23798@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15 2007, Jens Axboe wrote:
> On Tue, May 15 2007, Badari Pulavarty wrote:
> > On Tue, 2007-05-15 at 19:20 +0200, Jens Axboe wrote:
> > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > > > > Hi,
> > > > > 
> > > > > Updated version of the patch - this time I'll just attach the patch
> > > > > file...
> > > > 
> > > > Missing scatterlist.h inclusions..
> > > > 
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> > > > of function ???for_each_sg???
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> > > > token
> > > > drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> > > > make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> > > > 
> > > > 
> > > > drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> > > > drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> > > > function ???for_each_sg???
> > > > drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> > > > token
> > > 
> > > Thanks, will fix those. What arch? I tested it here.
> > 
> > I am playing with them on ppc64.
> 
> Ah ok, you need the updated patch series for ppc64 support. Builds fine
> here on ppc64. See the #sglist branch of the block repo:

A little teaser for those that haven't tried it yet. This is the
blktrace stats of doing a dd from a device and piping to md5sum. Just
meant to test that I got the same data back with chained sglists.

Snips from the blktrace data:

  8,16   2     1302    14.958707808     0  C   R 983040 + 10240 [0]
  8,16   2     1303    14.959619712     0  D   R 1005568 + 13312 [swapper]
  8,16   2     1304    15.066257952     0  C   R 993280 + 12288 [0]
  8,16   2     1305    15.067238272     0  D   R 1018880 + 13312 [swapper]

That's completion of a 5120kb request, dispatch of a 6656kb request,
completion of a 6144kb request, and finally dispatch of a 6656kb request
again. Average io size for reading half a gig of data:

 Read Dispatches:      110,  524,288KiB

or ~4766kb average IO size. 6656 are the largest requests in this test,
it's running into the hw sg limit at that point. Just doing a plain
O_DIRECT dd from the device makes basically all requests reach the max,
giving an average io size above 6mb/request.

-- 
Jens Axboe

