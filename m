Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbZF2MzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbZF2MzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZF2MzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:55:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:59396 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZF2MzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="159575278"
Date: Mon, 29 Jun 2009 20:54:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Ronald Moesbergen <intercommit@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090629125434.GA8416@localhost>
References: <6.0.0.20.2.20090601095926.06ee98d8@172.19.0.2> <4A2936A7.9070309@gmail.com> <20090606233056.7B9F.A69D9226@jp.fujitsu.com> <20090606224538.GA6173@localhost> <20090618120436.ad3196e3.akpm@linux-foundation.org> <20090620035504.GA19516@localhost> <4A3CD62B.1020407@vlnb.net> <20090629093423.GB1315@localhost> <a0272b440906290326rcd63849j2513f6ee9b9bf93e@mail.gmail.com> <4A489DAC.7000007@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A489DAC.7000007@vlnb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 06:55:40PM +0800, Vladislav Bolkhovitin wrote:
> Ronald Moesbergen, on 06/29/2009 02:26 PM wrote:
> > 2009/6/29 Wu Fengguang <fengguang.wu@intel.com>:
> >> On Sat, Jun 20, 2009 at 08:29:31PM +0800, Vladislav Bolkhovitin wrote:
> >>> Wu Fengguang, on 06/20/2009 07:55 AM wrote:
> >>>> On Fri, Jun 19, 2009 at 03:04:36AM +0800, Andrew Morton wrote:
> >>>>> On Sun, 7 Jun 2009 06:45:38 +0800
> >>>>> Wu Fengguang <fengguang.wu@intel.com> wrote:
> >>>>>
> >>>>>>>> Do you have a place where the raw blktrace data can be retrieved for
> >>>>>>>> more in-depth analysis?
> >>>>>>> I think your comment is really adequate. In another thread, Wu Fengguang pointed
> >>>>>>> out the same issue.
> >>>>>>> I and Wu also wait his analysis.
> >>>>>> And do it with a large readahead size :)
> >>>>>>
> >>>>>> Alan, this was my analysis:
> >>>>>>
> >>>>>> : Hifumi, can you help retest with some large readahead size?
> >>>>>> :
> >>>>>> : Your readahead size (128K) is smaller than your max_sectors_kb (256K),
> >>>>>> : so two readahead IO requests get merged into one real IO, that means
> >>>>>> : half of the readahead requests are delayed.
> >>>>>>
> >>>>>> ie. two readahead requests get merged and complete together, thus the effective
> >>>>>> IO size is doubled but at the same time it becomes completely synchronous IO.
> >>>>>>
> >>>>>> :
> >>>>>> : The IO completion size goes down from 512 to 256 sectors:
> >>>>>> :
> >>>>>> : before patch:
> >>>>>> :   8,0    3   177955    50.050313976     0  C   R 8724991 + 512 [0]
> >>>>>> :   8,0    3   177966    50.053380250     0  C   R 8725503 + 512 [0]
> >>>>>> :   8,0    3   177977    50.056970395     0  C   R 8726015 + 512 [0]
> >>>>>> :   8,0    3   177988    50.060326743     0  C   R 8726527 + 512 [0]
> >>>>>> :   8,0    3   177999    50.063922341     0  C   R 8727039 + 512 [0]
> >>>>>> :
> >>>>>> : after patch:
> >>>>>> :   8,0    3   257297    50.000760847     0  C   R 9480703 + 256 [0]
> >>>>>> :   8,0    3   257306    50.003034240     0  C   R 9480959 + 256 [0]
> >>>>>> :   8,0    3   257307    50.003076338     0  C   R 9481215 + 256 [0]
> >>>>>> :   8,0    3   257323    50.004774693     0  C   R 9481471 + 256 [0]
> >>>>>> :   8,0    3   257332    50.006865854     0  C   R 9481727 + 256 [0]
> >>>>>>
> >>>>> I haven't sent readahead-add-blk_run_backing_dev.patch in to Linus yet
> >>>>> and it's looking like 2.6.32 material, if ever.
> >>>>>
> >>>>> If it turns out to be wonderful, we could always ask the -stable
> >>>>> maintainers to put it in 2.6.x.y I guess.
> >>>> Agreed. The expected (and interesting) test on a properly configured
> >>>> HW RAID has not happened yet, hence the theory remains unsupported.
> >>> Hmm, do you see anything improper in the Ronald's setup (see
> >>> http://sourceforge.net/mailarchive/forum.php?thread_name=a0272b440906030714g67eabc5k8f847fb1e538cc62%40mail.gmail.com&forum_name=scst-devel)?
> >>> It is HW RAID based.
> >> No. Ronald's HW RAID performance is reasonably good.  I meant Hifumi's
> >> RAID performance is too bad and may be improved by increasing the
> >> readahead size, hehe.
> >>
> >>> As I already wrote, we can ask Ronald to perform any needed tests.
> >> Thanks!  Ronald's test results are:
> >>
> >> 231   MB/s   HW RAID
> >>  69.6 MB/s   HW RAID + SCST
> >>  89.7 MB/s   HW RAID + SCST + this patch
> >>
> >> So this patch seem to help SCST, but again it would be better to
> >> improve the SCST throughput first - it is now quite sub-optimal.
> >> (Sorry for the long delay: currently I have not got an idea on
> >>  how to measure such timing issues.)
> >>
> >> And if Ronald could provide the HW RAID performance with this patch,
> >> then we can confirm if this patch really makes a difference for RAID.
> > 
> > I just tested raw HW RAID throughput with the patch applied, same
> > readahead setting (512KB), and it doesn't look promising:
> > 
> > ./blockdev-perftest -d -r /dev/cciss/c0d0
> > blocksize        W        W        W        R        R        R
> >  67108864       -1       -1       -1  5.59686   5.4098  5.45396
> >  33554432       -1       -1       -1  6.18616  6.13232  5.96124
> >  16777216       -1       -1       -1   7.6757  7.32139   7.4966
> >   8388608       -1       -1       -1  8.82793  9.02057  9.01055
> >   4194304       -1       -1       -1  12.2289  12.6804    12.19
> >   2097152       -1       -1       -1  13.3012   13.706  14.7542
> >   1048576       -1       -1       -1  11.7577  12.3609  11.9507
> >    524288       -1       -1       -1  12.4112  12.2383  11.9105
> >    262144       -1       -1       -1  7.30687   7.4417  7.38246
> >    131072       -1       -1       -1  7.95752  7.95053  8.60796
> >     65536       -1       -1       -1  10.1282  10.1286  10.1956
> >     32768       -1       -1       -1  9.91857  9.98597  10.8421
> >     16384       -1       -1       -1  10.8267  10.8899  10.8718
> >      8192       -1       -1       -1  12.0345  12.5275   12.005
> >      4096       -1       -1       -1  15.1537  15.0771  15.1753
> >      2048       -1       -1       -1   25.432  24.8985  25.4303
> >      1024       -1       -1       -1  45.2674  45.2707  45.3504
> >       512       -1       -1       -1  87.9405  88.5047  87.4726
> > 
> > It dropped down to 189 MB/s. :(
> 
> Ronald,
> 
> Can you, please, rerun this test locally on the target with the latest 
> version of blockdev-perftest, which produces much more readable results, 

Is blockdev-perftest public available? It's not obvious from google search.

> for the following 6 cases:
> 
> 1. Default vanilla 2.6.29 kernel, default parameters, including read-ahead

Why not 2.6.30? :)

> 2. Default vanilla 2.6.29 kernel, 512 KB read-ahead, the rest is default

How about 2MB RAID readahead size? That transforms into about 512KB
per-disk readahead size.

> 3. Default vanilla 2.6.29 kernel, 512 KB read-ahead, 64 KB 
> max_sectors_kb, the rest is default
> 
> 4. Patched by the Fengguang's patch http://lkml.org/lkml/2009/5/21/319 
> vanilla 2.6.29 kernel, default parameters, including read-ahead
> 
> 5. Patched by the Fengguang's patch vanilla 2.6.29 kernel, 512 KB 
> read-ahead, the rest is default
> 
> 6. Patched by the Fengguang's patch vanilla 2.6.29 kernel, 512 KB 
> read-ahead, 64 KB max_sectors_kb, the rest is default

Thanks,
Fengguang

