Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbXERVHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbXERVHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbXERVHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:07:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:31803 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbXERVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=prS0sb4jkN/7pjT+7Hp+AokhdOPhayi7MMkZA4FTGUT+oFqlaQtEaAa6KTNZnp57Hp1rDG4hCi0eFYSRM+UssrfId6C+PYJ1sYACENZF0XFTFDsULrM0qNNNpWWnZI8CgShm4EUFsPreOoM7Jj6cJiyu7NdOORobeZAQ7eLobvA=
Message-ID: <4354d3270705181407t6e2d6der396ea3d0fd06f790@mail.gmail.com>
Date: Sat, 19 May 2007 00:07:28 +0300
From: "=?ISO-8859-1?Q?T=F6r=F6k_Edvin?=" <edwintorok@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: CFS Scheduler and real-time tasks
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070517201338.GA1713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4354d3270705171214v25bc4834t5e28a08649761e91@mail.gmail.com>
	 <20070517192343.GA24249@elte.hu>
	 <4354d3270705171310x1d7770b2mb086f1fde7cffabd@mail.gmail.com>
	 <20070517201338.GA1713@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/17/07, Ingo Molnar <mingo@elte.hu> wrote:
> hey, cool! Also try -v13 - it should be even more tighter.

I tried -v13. However the scheduling "error" is now 10% (vs 2% with -v12).

I also noticed strange behaviour with CPU hotplug. I offlined cpu1
(echo 0 >/sys/devices/system/cpu/cpu1/online), and the typing speed on
my terminal decreased noticably. I could hardly type something there.
The system was otherwise idle (running in Xorg, and gnome-terminal).
As soon as I started massive_intr.c workload, the keyboard typing
speed became normal again.  If I have a workload running, while I
offline a CPU the keyboard is fine after cpu1 is offlined.
Also the entire system froze once, when I offlined cpu1. I couldn't
reproduce this.

I don't know how -v12 behaved wrt to CPU hotplug.

> > ./massiv_new 9 300
> > 020860  00017782
> > 020858  00017774
> >
> > RT JOB:020865   00003785
> >
> > 020859  00017048
> > 020862  00017387
> > 020855  00017494
> > 020861  00017245
> > 020863  00017492
> > 020864  00017122

Results with -v13:

edwin@localhost ~ $ ./mo 9 300
006203  00006071
006198  00005712
006201  00006088
006196  00006208
006200  00006166
006195  00006306
006199  00006403
006197  00006288
006202  00006237

./massiv_new 9 300
013803  00010073
013801  00009889
013804  00010303
013806  00009953
013800  00010010
013802  00010171
013807  00009956
013805  00010037

RT JOB:013808   00002230

Interesting, massiv_new has better precision than massiv_orig.

Just in case it helps, here's me /proc/sched_debug (when system is
idle, and later, when running the test):

Sched Debug Version: v0.02
now at 1187357967816 nsecs

cpu: 0
  .nr_running            : 0
  .raw_weighted_load     : 0
  .nr_switches           : 555712
  .nr_load_updates       : 221754
  .nr_uninterruptible    : 4294967190
  .jiffies               : 221839
  .next_balance          : 221835
  .curr->pid             : 0
  .clock                 : 755701854416
  .prev_clock_raw        : 871997978419
  .clock_warps           : 0
  .clock_unstable_events : 97254
  .clock_max_delta       : 4749235
  .fair_clock            : 184031607224
  .prev_fair_clock       : 0
  .exec_clock            : 749010316890
  .prev_exec_clock       : 0
  .wait_runtime          : 59753136705
  .wait_runtime_overruns : 2689
  .wait_runtime_underruns: 1141
  .cpu_load[0]           : 0
  .cpu_load[1]           : 0
  .cpu_load[2]           : 0
  .cpu_load[3]           : 0
  .cpu_load[4]           : 0
  .wait_runtime_rq_sum   : 0

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------

cpu: 1
  .nr_running            : 1
  .raw_weighted_load     : 1024
  .nr_switches           : 378755
  .nr_load_updates       : 202398
  .nr_uninterruptible    : 106
  .jiffies               : 221839
  .next_balance          : 221830
  .curr->pid             : 20421
  .clock                 : 794219468967
  .prev_clock_raw        : 874002443396
  .clock_warps           : 0
  .clock_unstable_events : 116368
  .clock_max_delta       : 4531475
  .fair_clock            : 175306014212
  .prev_fair_clock       : 0
  .exec_clock            : 718501418488
  .prev_exec_clock       : 0
  .wait_runtime          : -59753140134
  .wait_runtime_overruns : 1245
  .wait_runtime_underruns: 1604
  .cpu_load[0]           : 0
  .cpu_load[1]           : 0
  .cpu_load[2]           : 0
  .cpu_load[3]           : 0
  .cpu_load[4]           : 0
  .wait_runtime_rq_sum   : -34602

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
R            cat 20421    175306048814         34602        -34602
    2   120           69205          -34602             853
   0               0


And sched_debug output while running the test:

Sched Debug Version: v0.02
now at 1261993795754 nsecs

cpu: 0
  .nr_running            : 5
  .raw_weighted_load     : 5120
  .nr_switches           : 588021
  .nr_load_updates       : 232164
  .nr_uninterruptible    : 4294967190
  .jiffies               : 240498
  .next_balance          : 240508
  .curr->pid             : 21096
  .clock                 : 770190363479
  .prev_clock_raw        : 895084968848
  .clock_warps           : 0
  .clock_unstable_events : 125214
  .clock_max_delta       : 0
  .fair_clock            : 190695995910
  .prev_fair_clock       : 0
  .exec_clock            : 763286081256
  .prev_exec_clock       : 0
  .wait_runtime          : 68703429598
  .wait_runtime_overruns : 2978
  .wait_runtime_underruns: 1273
  .cpu_load[0]           : 5120
  .cpu_load[1]           : 5119
  .cpu_load[2]           : 5110
  .cpu_load[3]           : 5077
  .cpu_load[4]           : 5037
  .wait_runtime_rq_sum   : -54771343

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
R             mo 21096    190703231293       7235383      -7235383
  445   120      1813432308        -8250501       211806979
   0               1
              mo 21093    190704201003       8205093      -8472612
  450   120      1818737228       -12394371       206140729
   0               6
              mo 21094    190704732208       8736298      -9665761
  464   120      1816895620       -12925451       204333757
   0               4
              mo 21092    190704971831       8975921     -15574122
  456   120      1817099155       -16680247       208648471
   0               2
              mo 21091    190705631487       9635577     -13823465
  457   120      1816983212       -16160000       204693203
   0               4

cpu: 1
  .nr_running            : 5
  .raw_weighted_load     : 5120
  .nr_switches           : 415103
  .nr_load_updates       : 211674
  .nr_uninterruptible    : 106
  .jiffies               : 240498
  .next_balance          : 240516
  .curr->pid             : 21291
  .clock                 : 806335506481
  .prev_clock_raw        : 897090740058
  .clock_warps           : 0
  .clock_unstable_events : 150133
  .clock_max_delta       : 0
  .fair_clock            : 179777580248
  .prev_fair_clock       : 0
  .exec_clock            : 730473748729
  .prev_exec_clock       : 0
  .wait_runtime          : -68769955037
  .wait_runtime_overruns : 1250
  .wait_runtime_underruns: 1885
  .cpu_load[0]           : 4096
  .cpu_load[1]           : 4293
  .cpu_load[2]           : 5044
  .cpu_load[3]           : 7236
  .cpu_load[4]           : 8445
  .wait_runtime_rq_sum   : -11785269

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
R            cat 21291    179777631414         51166        -51166
    2   120           66773          -51166           53218
   0               0
              mo 21095    179778195659        615411       -799325
  737   120      2088825958         -799325       201402067
   0               0
              mo 21090    179778267640        687392       -711781
  760   120      2094378519         -711781       208607795
   0               0
              mo 21097    179781627293       4047045      -5262328
  789   120      2090034861        -5262328       202105919
   0               0
              mo 21089    179782321359       4741111      -4960669
  757   120      2094677840        -4960669       202830299
   0               0
