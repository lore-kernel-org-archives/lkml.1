Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXITHP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXITHP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbXITHPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:15:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:57759 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750795AbXITHPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:15:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+9T0JHKqG9w3lg8PGUhYFhgHHlqmJidFHm7BhEhE
	pmbzbn/ZTMSQzg
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1190264114.6411.4.camel@Homer.simpson.net>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 09:15:07 +0200
Message-Id: <1190272507.27867.20.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 06:55 +0200, Mike Galbraith wrote:
> On Wed, 2007-09-19 at 10:06 -0700, Tong Li wrote:
> 
> > Were the experiments run on a 2-CPU system?
> 
> Yes.
> 
> >  When Xorg experiences large 
> > wait time, is it on the same CPU that has the two pinned tasks? If this is 
> > the case, then the problem could be X somehow advanced faster and got a 
> > larger vruntime then the two pinned tasks, so it had to wait for the 
> > pinned ones to catch up before it got a chance to be scheduled.
> 
> Good question.  I've not yet been able to capture any event where
> vruntimes are that far apart in sched_debug.

But, I did just manage to trigger some horrid behavior, and log it.  I
modified the kernel to print task's actual tree key instead of their
current vruntime, and was watching that while make -j2 was running (and
not seeing anything very interesting), when on a lark, I restarted
SuSE's system updater thingy.  That beast chews 100% CPU for so long at
startup that I long ago got annoyed, and changed it to run at nice 19.
Anyway, when it started, interactivity went to hell in the proverbial
hand-basket, and the sched_debug log shows some interesting results..
like spread0 hitting -13659412644, and cc1 being keyed at -3867063305.

cpu#0, 2992.608 MHz
  .nr_running                    : 4
  .load                          : 4096
  .nr_switches                   : 1105882
  .nr_load_updates               : 735146
  .nr_uninterruptible            : 4294966399
  .jiffies                       : 1936201
  .next_balance                  : 1936276
  .curr->pid                     : 27004
  .clock                         : 735034802877
  .idle_clock                    : 0
  .prev_clock_raw                : 2259213083886
  .clock_warps                   : 0
  .clock_overflows               : 677631
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 999848
  .cpu_load[0]                   : 4096
  .cpu_load[1]                   : 3960
  .cpu_load[2]                   : 3814
  .cpu_load[3]                   : 3539
  .cpu_load[4]                   : 3153

cfs_rq
  .exec_clock                    : 623175870707
  .MIN_vruntime                  : 3791173262297
  .min_vruntime                  : 3791173259723
  .max_vruntime                  : 3791173264579
  .spread                        : 2282
  .spread0                       : 0
  .nr_sync_min_vruntime          : 296756

runnable tasks:
            task   PID        tree-key  switches  prio    exec-runtime        sum-exec       sum-sleep
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            bash  6338            3212           554   120   3791173262935       104271360    645224098563
R            cc1 27004        -7509103             6   120   3791165750620        15396029        13300466
            make 27006            4856             6   120   3791173264579         9540879         6458208
            make 27010            2574             3   120   3791173262297         8897680               0

cpu#1, 2992.608 MHz
  .nr_running                    : 5
  .load                          : 6208
  .nr_switches                   : 1012995
  .nr_load_updates               : 747540
  .nr_uninterruptible            : 897
  .jiffies                       : 1936201
  .next_balance                  : 1936303
  .curr->pid                     : 27012
  .clock                         : 747426624818
  .idle_clock                    : 0
  .prev_clock_raw                : 2259213140042
  .clock_warps                   : 0
  .clock_overflows               : 582091
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 999848
  .cpu_load[0]                   : 6208
  .cpu_load[1]                   : 4545
  .cpu_load[2]                   : 3810
  .cpu_load[3]                   : 3065
  .cpu_load[4]                   : 2397

cfs_rq
  .exec_clock                    : 581940255731
  .MIN_vruntime                  : 3791835890838
  .min_vruntime                  : 3791854778322
  .max_vruntime                  : 3791902652145
  .spread                        : 66761307
  .spread0                       : 681518599
  .nr_sync_min_vruntime          : 256743

runnable tasks:
            task   PID        tree-key  switches  prio    exec-runtime        sum-exec       sum-sleep
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            Xorg  5740       -18887484        157025   115   3791835890838        46597617    638567698716
   update-status 26093        48184396          1537   139   3791902652145      5709334592      2622161813
              sh 27011        -6808461             2   120   3791847969861         4162855         1457101
R            cat 27012       -19965525             3   120   3791836175385         1756456         1974618
            bash 27013            1498             2   120   3791854779820          394907               0

Sched Debug Version: v0.05-v20, 2.6.23-rc6-smp-d #43
now at 2237384024289 nsecs

cpu#0, 2992.608 MHz
  .nr_running                    : 2
  .load                          : 1039
  .nr_switches                   : 1106019
  .nr_load_updates               : 736329
  .nr_uninterruptible            : 4294966399
  .jiffies                       : 1937383
  .next_balance                  : 1937428
  .curr->pid                     : 27087
  .clock                         : 736217427466
  .idle_clock                    : 0
  .prev_clock_raw                : 2260395464994
  .clock_warps                   : 0
  .clock_overflows               : 678147
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 999848
  .cpu_load[0]                   : 1039
  .cpu_load[1]                   : 1039
  .cpu_load[2]                   : 1039
  .cpu_load[3]                   : 1039
  .cpu_load[4]                   : 1039

cfs_rq
  .exec_clock                    : 624358414291
  .MIN_vruntime                  : 3806531640151
  .min_vruntime                  : 3806501788119
  .max_vruntime                  : 3806531640151
  .spread                        : 0
  .spread0                       : 0
  .nr_sync_min_vruntime          : 296782

runnable tasks:
            task   PID        tree-key  switches  prio    exec-runtime        sum-exec       sum-sleep
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   update-status 26093        56810274          1572   139   3806531640151      5929003154      2622161813
R            cc1 27087               0            13   120   3806501788119       403581890        15024992

cpu#1, 2992.608 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 1013933
  .nr_load_updates               : 748722
  .nr_uninterruptible            : 898
  .jiffies                       : 1937383
  .next_balance                  : 1937455
  .curr->pid                     : 27089
  .clock                         : 748608445154
  .idle_clock                    : 0
  .prev_clock_raw                : 2260394709751
  .clock_warps                   : 0
  .clock_overflows               : 582583
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 999848
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 5016
  .cpu_load[2]                   : 6366
  .cpu_load[3]                   : 7081
  .cpu_load[4]                   : 6895

cfs_rq
  .exec_clock                    : 583122024084
  .MIN_vruntime                  : 3806331397540
  .min_vruntime                  : 3806350696772
  .max_vruntime                  : 3806331397540
  .spread                        : 0
  .spread0                       : -151091347
  .nr_sync_min_vruntime          : 256756

runnable tasks:
            task   PID        tree-key  switches  prio    exec-runtime        sum-exec       sum-sleep
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
         konsole  6330       -19299232        124476   120   3806331397540     17086991675    615801753460
R            cat 27089       -19513636             2   120   3806331713718         1163204         7839421

Sched Debug Version: v0.05-v20, 2.6.23-rc6-smp-d #43
now at 2238396055118 nsecs

cpu#0, 2992.608 MHz
  .nr_running                    : 4
  .load                          : 3087
  .nr_switches                   : 1106671
  .nr_load_updates               : 737341
  .nr_uninterruptible            : 4294966395
  .jiffies                       : 1938395
  .next_balance                  : 1938412
  .curr->pid                     : 27115
  .clock                         : 737229273643
  .idle_clock                    : 0
  .prev_clock_raw                : 2261407091960
  .clock_warps                   : 0
  .clock_overflows               : 678565
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 999848
  .cpu_load[0]                   : 3087
  .cpu_load[1]                   : 3055
  .cpu_load[2]                   : 2723
  .cpu_load[3]                   : 2169
  .cpu_load[4]                   : 1698

cfs_rq
  .exec_clock                    : 625370185925
  .MIN_vruntime                  : 3833041200497
  .min_vruntime                  : 3833041199517
  .max_vruntime                  : 3833103226422
  .spread                        : 62025925
  .spread0                       : 0
  .nr_sync_min_vruntime          : 296798

runnable tasks:
            task   PID        tree-key  switches  prio    exec-runtime        sum-exec       sum-sleep
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            bash  6334             980          4556   120   3833041200497       565634278    646894253582
   update-status 26093        66364651          1667   139   3833103226422      6318237803      2622161813
             cc1 27112         1387807            22   120   3833042327482       242204855        12705113
R            cat 27115       -19905217             2   120   3833023008660         1844735         3670718

cpu#1, 2992.608 MHz
  .nr_running                    : 2
  .load                          : 4145
  .nr_switches                   : 1014099
  .nr_load_updates               : 749734
  .nr_uninterruptible            : 901
  .jiffies                       : 1938395
  .next_balance                  : 1938479
  .curr->pid                     : 27084
  .clock                         : 749620291330
  .idle_clock                    : 0
  .prev_clock_raw                : 2261406342542
  .clock_warps                   : 0
  .clock_overflows               : 582991
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 999848
  .cpu_load[0]                   : 4145
  .cpu_load[1]                   : 4145
  .cpu_load[2]                   : 4136
  .cpu_load[3]                   : 3934
  .cpu_load[4]                   : 3342

cfs_rq
  .exec_clock                    : 584133842523
  .MIN_vruntime                  : 3819361786873
  .min_vruntime                  : 3819381786873
  .max_vruntime                  : 3819361786873
  .spread                        : 0
  .spread0                       : -13659412644
  .nr_sync_min_vruntime          : 256768

runnable tasks:
            task   PID        tree-key  switches  prio    exec-runtime        sum-exec       sum-sleep
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          kacpid    73       -20000000          1073   115   3819361786873       489384092    743825068255
R            cc1 27084     -3867063305           138   120   3815518715812      1205052524        24535558


