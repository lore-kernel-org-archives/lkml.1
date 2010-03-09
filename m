Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0CIN1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 08:27:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:57040 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751900Ab0CIN1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 08:27:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+buqNEp7qb5iHkwT77p/8Sl5EWgNO9ughOSwvoa+
	9HcyjA3FgvYdN5
Subject: Re: [patch 2/2] sched: fix select_idle_sibling() logic in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1268114749.6349.20.camel@marge.simson.net>
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
	 <20100305184213.922106492@sbs-t61.sc.intel.com>
	 <1267820755.6384.85.camel@marge.simson.net>
	 <1268087062.2830.285.camel@sbs-t61.sc.intel.com>
	 <1268114749.6349.20.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 09 Mar 2010 14:27:00 +0100
Message-Id: <1268141220.28032.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 07:05 +0100, Mike Galbraith wrote:
> On Mon, 2010-03-08 at 14:24 -0800, Suresh Siddha wrote:

> > Ok. I dropped that part in v2 patches that I just posted.
> 
> Yeah, I see mails (ramble ramble) crossed in the night.  I'll take them
> out for a spin, see if your box can get fixed up without busting mine :)

Ok, done, pretty darn boring testing.  My worries wrt ramp didn't
materialize, and without the sync+1=idle bit, box no longer hates your
patch ;)  It adds a tad of overhead though.

I tested it in my tinkered tree due to some things in virgin tip that I
think would have upset results.

tip = v2.6.33-6681-g91259c4
tip-x = tip + my patches
tip-xx = tip-x + your patches

netperf TCP_RR
unpinned
tip           64942.13    52203.28    92852.34   avg  69999.25   1.000
tip-x        107387.04   107334.34   107495.54   avg 107405.64   1.534   1.000
tip-xx       104602.54   104183.84   104095.35   avg 104293.91   1.489    .971

pinned
tip          101044.77    99478.75   100091.53   avg 100205.01   1.000
tip-x        103767.53   103138.71   103459.92   avg 103455.38   1.032   1.000
tip-xx       103465.68   103306.90   103189.46   avg 103320.68   1.031    .998

tbench 8
tip          1181.10   1173.81   1179.42   avg 1178.11   1.000
tip-x        1212.81   1214.73   1212.99   avg 1213.51   1.030   1.000
tip-xx       1212.56   1208.96   1207.57   avg 1209.69   1.026    .996

mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          10364.73   19210.43   37055.69   36724.26   35797.53   34806.00   32533.02   27463.10   21331.35
              8499.12   19438.84   36873.36   36574.78   35712.63   34763.84   32086.15   27325.47   20845.97
              9707.81   19431.68   36940.02   36495.55   35590.46   34612.24   32125.14   27124.94   21228.64
tip avg       9523.88   19360.31   36956.35   36598.19   35700.20   34727.36   32248.10   27304.50   21135.32

tip-x        11143.63   20398.50   36954.97   36515.57   35877.48   35101.78   32974.35   28018.32   22172.95
             11134.06   20615.39   36873.60   36541.21   35957.70   34954.68   32613.53   27737.31   21792.48
             11156.34   20481.79   36773.47   36473.38   35778.64   34867.88   32485.94   27705.44   22024.18
tip-x avg    11144.67   20498.56   36867.34   36510.05   35871.27   34974.78   32691.27   27820.35   21996.53
vs tip          1.170      1.058       .997       .997      1.004      1.007      1.013      1.018      1.040

tip-xx       11208.50   20952.28   36842.91   36495.95   35642.27   35049.26   32566.01   27096.20   22058.94
             11176.96   21123.91   37334.72   36849.41   36298.53   35269.21   32625.55   27248.00   21448.19
             11112.04   21042.49   37317.42   36835.94   36147.29   35144.11   32695.83   27393.21   21881.37
tip-xx avg   11165.83   21039.56   37165.01   36727.10   36029.36   35154.19   32629.13   27245.80   21796.16
vs tip          1.172      1.086      1.005      1.003      1.009      1.012      1.011       .997      1.031
vs tip-x        1.001      1.026      1.008      1.005      1.004      1.005       .998       .979       .990

pgsql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          15408.13   30181.76   53244.49   52684.00   52306.08   51115.08   50156.59   48907.81   45657.03
             15658.69   30379.33   53308.72   52879.11   52169.98   51080.25   50023.30   48758.86   46009.55
             15534.79   30343.67   53030.92   52437.59   52063.99   50897.84   50073.97   48720.65   45990.12
tip avg      15533.87   30301.58   53194.71   52666.90   52180.01   51031.05   50084.62   48795.77   45885.56

tip-x        15897.83   31418.82   54116.88   53712.74   52628.43   51310.64   50624.15   49291.35   46430.55
             15848.06   30702.00   53166.82   52935.46   51859.48   51024.90   50123.57   48739.02   46033.40
             16043.14   30919.32   53576.71   53400.79   52525.99   51635.50   50515.64   49095.82   46374.42
tip-x avg    15929.67   31013.38   53620.13   53349.66   52337.96   51323.68   50421.12   49042.06   46279.45
vs tip          1.025      1.023      1.007      1.012      1.003      1.005      1.006      1.005      1.008 

tip-xx       16071.66   31145.83   53953.67   53280.52   52476.55   51472.32   50219.63   49016.45   46280.48
             15899.41   30769.93   53051.25   53006.46   52000.32   51151.68   50062.48   48539.12   45634.23
             16019.03   31035.88   53850.74   53086.54   52136.27   51246.17   50432.08   48544.87   45693.85
tip-xx avg   15996.70   30983.88   53618.55   53124.50   52204.38   51290.05   50238.06   48700.14   45869.52
vs tip          1.075      1.012       .879      1.001      1.006      1.022      1.010      1.013      1.074
vs tip-x        1.004       .999       .999       .995       .997       .999       .996       .993       .991


Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
marge    2.6.34-tip-smp 1.3400 1.4400 1.4000 2.1200 1.6400 2.26000 1.68000
marge    2.6.34-tip-smp 1.3600 1.3700 1.2700 2.1000 1.5600 2.26000 1.61000
marge    2.6.34-tip-smp 1.3800 1.3400 1.4000 2.1000 1.6400 2.29000 1.83000
marge   2.6.34-tip-smpx 1.0600 1.0900 1.0800 1.8200 1.3000 1.82000 1.33000
marge   2.6.34-tip-smpx 1.0700 1.1000 1.1200 1.8000 1.3100 1.83000 1.37000
marge   2.6.34-tip-smpx 1.0600 1.0900 1.1100 1.7800 1.2600 1.83000 1.38000
marge  2.6.34-tip-smpxx 1.1000 1.0900 1.1100 1.8000 1.3100 1.86000 1.37000
marge  2.6.34-tip-smpxx 1.1000 1.1000 1.1000 1.8000 1.3100 1.84000 1.35000
marge  2.6.34-tip-smpxx 1.1000 1.0800 1.1100 1.8100 1.3000 1.85000 1.36000

*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                        ctxsw       UNIX         UDP         TCP conn
--------- ------------- ----- ----- ---- ----- ----- ----- ----- ----
marge    2.6.34-tip-smp 1.340 4.179 4.42 8.959  12.1  27.4  14.9  18.
marge    2.6.34-tip-smp 1.360 4.369 4.61 8.868  12.0  26.9  14.9  18.
marge    2.6.34-tip-smp 1.380 4.364 4.70 8.931  11.9  25.6  14.9  18.
marge   2.6.34-tip-smpx 1.060 3.486 6.16 7.635  10.9 9.422  13.7  18.
marge   2.6.34-tip-smpx 1.070 3.456 5.93 7.677  11.0 9.412  13.7  18.
marge   2.6.34-tip-smpx 1.060 3.474 6.12 7.544  10.9 9.495  13.7  18.
marge  2.6.34-tip-smpxx 1.100 3.556 6.30 7.911  11.3 9.756  14.0  18.
marge  2.6.34-tip-smpxx 1.100 3.563 6.12 7.879  11.4 9.806  14.2  18.
marge  2.6.34-tip-smpxx 1.100 3.553 6.17 7.908  11.3 9.779  14.0  18.

*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
marge    2.6.34-tip-smp 1756 5168 754. 2818.3 4815.3 1243.7 1233.1 4342 1686.
marge    2.6.34-tip-smp 1778 5193 1152 2809.7 4748.9 1242.3 1236.1 4454 1679.
marge    2.6.34-tip-smp 1763 5161 1141 2801.5 4731.5 1246.6 1233.7 4493 1683.
marge   2.6.34-tip-smpx 2790 5230 2979 2838.2 4833.4 1322.5 1310.3 4488 1749.
marge   2.6.34-tip-smpx 2726 5222 2980 2825.6 4770.3 1336.4 1320.7 4447 1741.
marge   2.6.34-tip-smpx 2800 5214 2973 2817.3 4768.1 1383.3 1359.4 4447 1746.
marge  2.6.34-tip-smpxx 2549 5228 2931 2830.9 4795.9 1236.3 1229.3 4384 1686.
marge  2.6.34-tip-smpxx 2568 5212 740. 2833.0 4782.2 1239.2 1235.3 4462 1683.
marge  2.6.34-tip-smpxx 2608 5219 2949 2845.9 4806.4 1243.5 1232.7 4474 1683.


