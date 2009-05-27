Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbZE0CIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbZE0CIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZE0CIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:08:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:46170 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbZE0CID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:08:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,256,1241420400"; 
   d="scan'208";a="147249055"
Date: Wed, 27 May 2009 10:07:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090527020730.GA17658@localhost>
References: <6.0.0.20.2.20090518183752.0581fdc0@172.19.0.2> <20090518175259.GL4140@kernel.dk> <20090520025123.GB8186@localhost> <6.0.0.20.2.20090521145005.06f81fe0@172.19.0.2> <20090522010538.GB6010@localhost> <6.0.0.20.2.20090522102551.0705aea0@172.19.0.2> <20090522023323.GA10864@localhost> <20090526164252.0741b392.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526164252.0741b392.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 07:42:52AM +0800, Andrew Morton wrote:
> On Fri, 22 May 2009 10:33:23 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > I tested above patch, and I got same performance number.
> > > I wonder why if (PageUptodate(page)) check is there...
> > 
> > Thanks!  This is an interesting micro timing behavior that
> > demands some research work.  The above check is to confirm if it's
> > the PageUptodate() case that makes the difference. So why that case
> > happens so frequently so as to impact the performance? Will it also
> > happen in NFS?
> > 
> > The problem is readahead IO pipeline is not running smoothly, which is
> > undesirable and not well understood for now.
> 
> The patch causes a remarkably large performance increase.  A 9%
> reduction in time for a linear read?  I'd be surprised if the workload
> even consumed 9% of a CPU, so where on earth has the kernel gone to?
> 
> Have you been able to reproduce this in your testing?

No I cannot reproduce it on raw partition and ext4fs.

The commands I run:

        # echo 1 > /proc/sys/vm/drop_caches
        # dd if=/dev/sda1 of=/dev/null bs=16384 count=100000 # sda1 is not mounted

The results are almost identical:

before:
        1638400000 bytes (1.6 GB) copied, 31.3073 s, 52.3 MB/s
        1638400000 bytes (1.6 GB) copied, 31.3393 s, 52.3 MB/s
after:
        1638400000 bytes (1.6 GB) copied, 31.3216 s, 52.3 MB/s
        1638400000 bytes (1.6 GB) copied, 31.3762 s, 52.2 MB/s

My kernel is
        Linux hp 2.6.30-rc6 #281 SMP Wed May 27 09:32:37 CST 2009 x86_64 GNU/Linux

The readahead size is the default one:
        # blockdev --getra  /dev/sda    
        256

I tried another ext4 directory with many ~100MB files(vmlinux-2.6.*) in it:

        # time tar cf - /hp/boot | cat > /dev/null

before:
        tar cf - /hp/boot  0.22s user 5.63s system 21% cpu 26.750 total
        tar cf - /hp/boot  0.26s user 5.53s system 21% cpu 26.620 total
after:
        tar cf - /hp/boot  0.18s user 5.57s system 21% cpu 26.719 total
        tar cf - /hp/boot  0.22s user 5.32s system 21% cpu 26.321 total

Another round with 1MB readahead size:

before:
        tar cf - /hp/boot  0.24s user 4.70s system 19% cpu 25.689 total
        tar cf - /hp/boot  0.22s user 4.99s system 20% cpu 25.634 total
after:
        tar cf - /hp/boot  0.18s user 4.89s system 19% cpu 25.599 total
        tar cf - /hp/boot  0.18s user 4.97s system 20% cpu 25.645 total

Thanks,
Fengguang
