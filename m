Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZFADDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZFADDO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 23:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZFADC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 23:02:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:64139 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbZFADC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 23:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,281,1241420400"; 
   d="scan'208";a="149067095"
Date: Mon, 1 Jun 2009 11:02:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090601030249.GA10348@localhost>
References: <20090526164252.0741b392.akpm@linux-foundation.org> <6.0.0.20.2.20090527092105.076be238@172.19.0.2> <20090527020909.GB17658@localhost> <6.0.0.20.2.20090527110937.0770c420@172.19.0.2> <20090527023638.GA27079@localhost> <6.0.0.20.2.20090527114200.076aab00@172.19.0.2> <20090527025721.GA11153@localhost> <6.0.0.20.2.20090527120248.076abe38@172.19.0.2> <20090601023758.GA8795@localhost> <6.0.0.20.2.20090601115104.0739dac0@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090601115104.0739dac0@172.19.0.2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 10:51:56AM +0800, Hisashi Hifumi wrote:
> 
> At 11:37 09/06/01, Wu Fengguang wrote:
> >On Wed, May 27, 2009 at 11:06:37AM +0800, Hisashi Hifumi wrote:
> >> 
> >> At 11:57 09/05/27, Wu Fengguang wrote:
> >> >On Wed, May 27, 2009 at 10:47:47AM +0800, Hisashi Hifumi wrote:
> >> >> 
> >> >> At 11:36 09/05/27, Wu Fengguang wrote:
> >> >> >On Wed, May 27, 2009 at 10:21:53AM +0800, Hisashi Hifumi wrote:
> >> >> >>
> >> >> >> At 11:09 09/05/27, Wu Fengguang wrote:
> >> >> >> >On Wed, May 27, 2009 at 08:25:04AM +0800, Hisashi Hifumi wrote:
> >> >> >> >>
> >> >> >> >> At 08:42 09/05/27, Andrew Morton wrote:
> >> >> >> >> >On Fri, 22 May 2009 10:33:23 +0800
> >> >> >> >> >Wu Fengguang <fengguang.wu@intel.com> wrote:
> >> >> >> >> >
> >> >> >> >> >> > I tested above patch, and I got same performance number.
> >> >> >> >> >> > I wonder why if (PageUptodate(page)) check is there...
> >> >> >> >> >>
> >> >> >> >> >> Thanks!  This is an interesting micro timing behavior that
> >> >> >> >> >> demands some research work.  The above check is to confirm if it's
> >> >> >> >> >> the PageUptodate() case that makes the difference. So why that case
> >> >> >> >> >> happens so frequently so as to impact the performance? Will it also
> >> >> >> >> >> happen in NFS?
> >> >> >> >> >>
> >> >> >> >> >> The problem is readahead IO pipeline is not running smoothly, 
> >which is
> >> >> >> >> >> undesirable and not well understood for now.
> >> >> >> >> >
> >> >> >> >> >The patch causes a remarkably large performance increase.  A 9%
> >> >> >> >> >reduction in time for a linear read? I'd be surprised if the workload
> >> >> >> >>
> >> >> >> >> Hi Andrew.
> >> >> >> >> Yes, I tested this with dd.
> >> >> >> >>
> >> >> >> >> >even consumed 9% of a CPU, so where on earth has the kernel gone to?
> >> >> >> >> >
> >> >> >> >> >Have you been able to reproduce this in your testing?
> >> >> >> >>
> >> >> >> >> Yes, this test on my environment is reproducible.
> >> >> >> >
> >> >> >> >Hisashi, does your environment have some special configurations?
> >> >> >>
> >> >> >> Hi.
> >> >> >> My testing environment is as follows:
> >> >> >> Hardware: HP DL580
> >> >> >> CPU:Xeon 3.2GHz *4 HT enabled
> >> >> >> Memory:8GB
> >> >> >> Storage: Dothill SANNet2 FC (7Disks RAID-0 Array)
> >> >> >
> >> >> >This is a big hardware RAID. What's the readahead size?
> >> >> >
> >> >> >The numbers look too small for a 7 disk RAID:
> >> >> >
> >> >> >        > #dd if=testdir/testfile of=/dev/null bs=16384
> >> >> >        >
> >> >> >        > -2.6.30-rc6
> >> >> >        > 1048576+0 records in
> >> >> >        > 1048576+0 records out
> >> >> >        > 17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s
> >> >> >        >
> >> >> >        > -2.6.30-rc6-patched
> >> >> >        > 1048576+0 records in
> >> >> >        > 1048576+0 records out
> >> >> >        > 17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s
> >> >> >
> >> >> >I'd suggest you to configure the array properly before coming back to
> >> >> >measuring the impact of this patch.
> >> >> 
> >> >> 
> >> >> I created 16GB file to this disk array, and mounted to testdir, dd to 
> >> >this directory.
> >> >
> >> >I mean, you should get >300MB/s throughput with 7 disks, and you
> >> >should seek ways to achieve that before testing out this patch :-)
> >> 
> >> Throughput number of storage array is very from one product to another.
> >> On my hardware environment I think this number is valid and
> >> my patch is effective.
> >
> >What's your readahead size? Is it large enough to cover the stripe width?
> 
> Do you mean strage's readahead size?

What's strage? I mean if your RAID's block device file is /dev/sda, then

        blockdev --getra /dev/sda

will tell its readahead size in unit of 512 bytes.

Thanks,
Fengguang

