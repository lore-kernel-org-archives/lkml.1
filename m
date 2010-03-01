Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab0CATpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:45:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0CATpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:45:13 -0500
Date: Mon, 1 Mar 2010 14:45:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC, PATCH 0/2] Reworking seeky detection for 2.6.34
Message-ID: <20100301194504.GD3109@redhat.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com> <20100301163552.GA3109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301163552.GA3109@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 11:35:52AM -0500, Vivek Goyal wrote:
> On Sat, Feb 27, 2010 at 07:45:38PM +0100, Corrado Zoccolo wrote:
> > 
> > Hi, I'm resending the rework seeky detection patch, together with 
> > the companion patch for SSDs, in order to get some testing on more
> > hardware.
> > 
> > The first patch in the series fixes a regression introduced in 2.6.33
> > for random mmap reads of more than one page, when multiple processes
> > are competing for the disk.
> > There is at least one HW RAID controller where it reduces performance,
> > though (but this controller generally performs worse with CFQ than
> > with NOOP, probably because it is performing non-work-conserving 
> > I/O scheduling inside), so more testing on RAIDs is appreciated.
> > 
> 
> Hi Corrado,
> 
> This time I don't have the machine where I had previously reported
> regressions. But somebody has exported me two Lun from an storage box
> over SAN and I have done my testing on that. With this seek patch applied, 
> I still see the regressions.
> 
> iosched=cfq     Filesz=1G   bs=64K
> 
>                         2.6.33              2.6.33-seek
> workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
> --------  --- --  ----------  ----------  ----------  ----------   ---- ----
> brrmmap   3   1   7113        0           7044        0              0% 0%
> brrmmap   3   2   6977        0           6774        0             -2% 0%
> brrmmap   3   4   7410        0           6181        0            -16% 0%
> brrmmap   3   8   9405        0           6020        0            -35% 0%
> brrmmap   3   16  11445       0           5792        0            -49% 0%
> 
>                         2.6.33              2.6.33-seek
> workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
> --------  --- --  ----------  ----------  ----------  ----------   ---- ----
> drrmmap   3   1   7195        0           7337        0              1% 0%
> drrmmap   3   2   7016        0           6855        0             -2% 0%
> drrmmap   3   4   7438        0           6103        0            -17% 0%
> drrmmap   3   8   9298        0           6020        0            -35% 0%
> drrmmap   3   16  11576       0           5827        0            -49% 0%
> 
> 
> I have run buffered random reads on mmaped files (brrmmap) and direct
> random reads on mmaped files (drrmmap) using fio. I have run these for
> increasing number of threads and did this for 3 times and took average of
> three sets for reporting.
> 
> I have used filesize 1G and bz=64K and ran each test sample for 30
> seconds.
> 
> Because with new seek logic, we will mark above type of cfqq as non seeky
> and will idle on these, I take a significant hit in performance on storage
> boxes which have more than 1 spindle.
> 
> So basically, the regression is not only on that particular RAID card but
> on other kind of devices which can support more than one spindle.
> 
> I will run some test on single SATA disk also where this patch should
> benefit.
> 

Ok, some more results on a single SATA disk.

iosched=cfq     Filesz=1G   bs=64K  

                        2.6.33              2.6.33-seek
workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
--------  --- --  ----------  ----------  ----------  ----------   ---- ----
brrmmap   3   1   4200        0           4200        0              0% 0%
brrmmap   3   2   4214        0           4246        0              0% 0%
brrmmap   3   4   3296        0           3868        0             17% 0%
brrmmap   3   8   2442        0           3117        0             27% 0%
brrmmap   3   16  1895        0           2510        0             32% 0%

                        2.6.33              2.6.33-seek
workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
--------  --- --  ----------  ----------  ----------  ----------   ---- ----
drrmmap   3   1   5476        0           5494        0              0% 0%
drrmmap   3   2   5065        0           5070        0              0% 0%
drrmmap   3   4   3607        0           4213        0             16% 0%
drrmmap   3   8   2474        0           3198        0             29% 0%
drrmmap   3   16  1912        0           2418        0             26% 0%

So we see improvements on single SATA disk as expected. But we lose more
on higher end storage/hardware RAID setups.

Also ran same test with bs=32K on SATA disk.

iosched=cfq     Filesz=1G   bs=32K  

                        2.6.33              2.6.33-seek
workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
--------  --- --  ----------  ----------  ----------  ----------   ---- ----
brrmmap   3   1   2408        0           2374        0             -1% 0%
brrmmap   3   2   2045        0           2304        0             12% 0%
brrmmap   3   4   1687        0           1753        0              3% 0%
brrmmap   3   8   1697        0           1562        0             -7% 0%
brrmmap   3   16  1604        0           1573        0             -1% 0%

                        2.6.33              2.6.33-seek
workload  Set NR  RDBW(KB/s)  WRBW(KB/s)  RDBW(KB/s)  WRBW(KB/s)    %Rd %Wr
--------  --- --  ----------  ----------  ----------  ----------   ---- ----
drrmmap   3   1   3171        0           3145        0              0% 0%
drrmmap   3   2   2634        0           2838        0              7% 0%
drrmmap   3   4   1844        0           1935        0              4% 0%
drrmmap   3   8   1761        0           1609        0             -8% 0%
drrmmap   3   16  1602        0           1573        0             -1% 0%

I think in this case cfqq is not being marked as sync-idle and continues
to be sync-noidle.

So in summary, yes we gain on single SATA disks for this test case but
lose on multi spindle setups. IMHO, we should enhance this patch with
some kind of single spindle detection and enable this functionality only
with those disks so that higher end storage does not incur the penalty.

Thanks
Vivek


 


> Based on testing results so far, I am not a big fan of marking these mmap
> queues as sync-idle. I guess if this patch really benefits, then we need
> to first put in place some kind of logic to detect whether if it is single
> spindle SATA disk and then on these disks, mark mmap queues as sync.
> 
> Apart from synthetic workloads, in practice, where this patch is helping you?
> 
> Thanks
> Vivek
> 
> 
> > The second patch changes the seeky detection logic to be meaningful
> > also for SSDs. A seeky request is one that doesn't utilize the full
> > bandwidth for the device. For SSDs, this happens for small requests,
> > regardless of their location.
> > With this change, the grouping of "seeky" requests done by CFQ can
> > result in a fairer distribution of disk service time among processes.
