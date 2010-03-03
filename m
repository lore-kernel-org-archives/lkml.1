Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0CCXLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:11:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab0CCXLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:11:48 -0500
Date: Wed, 3 Mar 2010 18:11:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC, PATCH 0/2] Reworking seeky detection for 2.6.34
Message-ID: <20100303231138.GC5230@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com> <20100301163552.GA3109@redhat.com> <4e5e476b1003011501h7b4ed638w3a620fa26ffec522@mail.gmail.com> <4e5e476b1003031439y5d92c7ch5d0d529d261f8945@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1003031439y5d92c7ch5d0d529d261f8945@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 11:39:05PM +0100, Corrado Zoccolo wrote:
> On Tue, Mar 2, 2010 at 12:01 AM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> > Hi Vivek,
> > On Mon, Mar 1, 2010 at 5:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> On Sat, Feb 27, 2010 at 07:45:38PM +0100, Corrado Zoccolo wrote:
> >>>
> >>> Hi, I'm resending the rework seeky detection patch, together with
> >>> the companion patch for SSDs, in order to get some testing on more
> >>> hardware.
> >>>
> >>> The first patch in the series fixes a regression introduced in 2.6.33
> >>> for random mmap reads of more than one page, when multiple processes
> >>> are competing for the disk.
> >>> There is at least one HW RAID controller where it reduces performance,
> >>> though (but this controller generally performs worse with CFQ than
> >>> with NOOP, probably because it is performing non-work-conserving
> >>> I/O scheduling inside), so more testing on RAIDs is appreciated.
> >>>
> >>
> >> Hi Corrado,
> >>
> >> This time I don't have the machine where I had previously reported
> >> regressions. But somebody has exported me two Lun from an storage box
> >> over SAN and I have done my testing on that. With this seek patch applied,
> >> I still see the regressions.
> >>
> >> iosched=cfq     Filesz=1G   bs=64K
> >>
> >>                        2.6.33              2.6.33-seek
> >> workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
> >> --------  --- --  ----------  ----------  ----------  ----------   ---- ----
> >> brrmmap   3   1   7113        0           7044        0              0% 0%
> >> brrmmap   3   2   6977        0           6774        0             -2% 0%
> >> brrmmap   3   4   7410        0           6181        0            -16% 0%
> >> brrmmap   3   8   9405        0           6020        0            -35% 0%
> >> brrmmap   3   16  11445       0           5792        0            -49% 0%
> >>
> >>                        2.6.33              2.6.33-seek
> >> workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
> >> --------  --- --  ----------  ----------  ----------  ----------   ---- ----
> >> drrmmap   3   1   7195        0           7337        0              1% 0%
> >> drrmmap   3   2   7016        0           6855        0             -2% 0%
> >> drrmmap   3   4   7438        0           6103        0            -17% 0%
> >> drrmmap   3   8   9298        0           6020        0            -35% 0%
> >> drrmmap   3   16  11576       0           5827        0            -49% 0%
> >>
> >>
> >> I have run buffered random reads on mmaped files (brrmmap) and direct
> >> random reads on mmaped files (drrmmap) using fio. I have run these for
> >> increasing number of threads and did this for 3 times and took average of
> >> three sets for reporting.
> 
> BTW, I think O_DIRECT doesn't affect mmap operation.

Yes, just for the sake of curiosity I tested O_DIRECT case also.

> 
> >>
> >> I have used filesize 1G and bz=64K and ran each test sample for 30
> >> seconds.
> >>
> >> Because with new seek logic, we will mark above type of cfqq as non seeky
> >> and will idle on these, I take a significant hit in performance on storage
> >> boxes which have more than 1 spindle.
> Thinking about this, can you check if your disks have a non-zero
> /sys/block/sda/queue/optimal_io_size ?
> >From the comment in blk-settings.c, I see this should be non-zero for
> RAIDs, so it may help discriminating the cases we want to optimize
> for.
> It could also help in identifying the correct threshold.

I have got multipath device setup. But I see optimal_io_size=0 both on 
higher level multipath device as well as underlying component devices.

> >
> > Thanks for testing on a different setup.
> > I wonder if the wrong part for multi-spindle is the 64kb threshold.
> > Can you run with larger bs, and see if there is a value for which
> > idling is better?
> > For example on a 2 disk raid 0 I would expect  that a bs larger than
> > the stripe will still benefit by idling.
> >
> >>
> >> So basically, the regression is not only on that particular RAID card but
> >> on other kind of devices which can support more than one spindle.
> Ok makes sense. If the number of sequential pages read before jumping
> to a random address is smaller than the raid stripe, we are wasting
> potential parallelism.

Actually even if we are doing IO size bigger than stripe size, we will
probably keep only request_size/stripe_size spindles busy by one request.
We are still not exploiting parallelism of rest of the spindles.

Secondly in this particular case, becuse you are issuing 4K pages reads
at a time, you are for sure going to keep one spindle busy.

Increasing the block size to 128K or 256K does bring down the % of regression,
but I think that primarly comes from the fact that now we have made
workload less random and more sequential (One seek after 256/4=64
sequential reads as opposed to one seek after 64K/4=16 sequentila reads).

With bs=128K
===========
                        2.6.33              2.6.33-seek
workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
--------  --- --  ----------  ----------  ----------  ----------   ---- ----
brrmmap   3   1   8338        0           8532        0              2% 0%
brrmmap   3   2   8724        0           8553        0             -1% 0%
brrmmap   3   4   9577        0           8002        0            -16% 0%
brrmmap   3   8   11806       0           7990        0            -32% 0%
brrmmap   3   16  13329       0           8101        0            -39% 0%


With bs=256K
===========
                        2.6.33              2.6.33-seek
workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
--------  --- --  ----------  ----------  ----------  ----------   ---- ----
brrmmap   3   1   9778        0           9572        0             -2% 0%
brrmmap   3   2   10321       0           10029       0             -2% 0%
brrmmap   3   4   11132       0           9675        0            -13% 0%
brrmmap   3   8   13111       0           10057       0            -23% 0%
brrmmap   3   16  13910       0           10366       0            -25% 0%

So if we can detect there are multiple spindles underlying, we can probably
make the non-seeky definition stricter and that is instead of looking
for 4 seeky requests per 32 samples, we could say 2 seeky requests per
64 samples etc. That could help a bit on storages with multiple spindles
behind single Lun.

Thanks
Vivek
 

> >>
> >> I will run some test on single SATA disk also where this patch should
> >> benefit.
> >>
> >> Based on testing results so far, I am not a big fan of marking these mmap
> >> queues as sync-idle. I guess if this patch really benefits, then we need
> >> to first put in place some kind of logic to detect whether if it is single
> >> spindle SATA disk and then on these disks, mark mmap queues as sync.
> >>
> >> Apart from synthetic workloads, in practice, where this patch is helping you?
> >
> > The synthetic workload mimics the page fault patterns that can be seen
> > on program startup, and that is the target of my optimization. In
> > 2.6.32, we went the direction of enabling idling also for seeky
> > queues, while 2.6.33 tried to be more friendly with parallel storage
> > by usually allowing more parallel requests. Unfortunately, this
> > impacted this peculiar access pattern, so we need to fix it somehow.
> >
> > Thanks,
> > Corrado
> >
> >>
> >> Thanks
> >> Vivek
> >>
> >>
> >>> The second patch changes the seeky detection logic to be meaningful
> >>> also for SSDs. A seeky request is one that doesn't utilize the full
> >>> bandwidth for the device. For SSDs, this happens for small requests,
> >>> regardless of their location.
> >>> With this change, the grouping of "seeky" requests done by CFQ can
> >>> result in a fairer distribution of disk service time among processes.
> >>
> >
