Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXFMTf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXFMTf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXFMTft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:35:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:23158 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXFMTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Fp+qPLy2Dw0AwH2ewYwQoapNQpUJnvCf1vxMb5OasCvGepIC/S64sGnr4TlPIeqstXZ4MeUFTRU/oMomfS/5sp5X01gA0skgwcMc2tK09OKwsrv7ihZLMrC6/do3vaSoz+c04ZY7ynGJ10u9AYKdVL6GU3M9G618LqIz/xk+5CI=
Message-ID: <4354d3270706131235x6c879f7emc1869700af108b27@mail.gmail.com>
Date: Wed, 13 Jun 2007 22:35:47 +0300
From: "=?ISO-8859-1?Q?T=F6r=F6k_Edvin?=" <edwintorok@gmail.com>
To: mingo@redhat.com
Subject: CFS-v16: top shows incorrect CPU% for multi-threaded application
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I run a multithreaded application, consisting of a "main thread"
that is mostly idle, and
3 "worker threads" (using as much CPU as they can get), 'top' and 'ps'
show that
the application uses 0% CPU.
If I turn off thread details in top, and ps it correctly shows the CPU
usage of each thread.

This happens only on 2.6.22-rc4-cfs-v16, on 2.6.21-1 everything is ok
(top shows sum-of-all-threads-CPU-usage, i.e. ~98,99%).

Can I help debug/track down the cause of this issue? (how?)

uname -a: Linux lightspeed2 2.6.22-rc4-cfs-v16-g845a2fdc-dirty #2 SMP
Sun Jun 10 14:23:08 EEST 2007 x86_64 GNU/Linux

Running top with 'show threads off':
PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
5932 clamav    20   0  277m  53m 1608 S  0.0  2.7   0:00.81 clam

Running top with 'show threads on':
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 5953 clamav    20   0  277m  53m 1608 R 99.9  2.7   1:50.33 clamd
 5952 clamav    20   0  277m  53m 1608 R 99.9  2.7   1:49.18 clamd
 5956 clamav    20   0  277m  53m 1608 R 99.9  2.7   1:47.72 clamd
 5932 clamav    20   0  277m  53m 1608 S  0.0  2.7   0:00.81 clamd
 5951 clamav    20   0  277m  53m 1608 S  0.0  2.7   0:01.78 clamd

^First time, after second refresh the 99% is down to 30%

top - 22:25:06 up 16 min,  1 user,  load average: 3.51, 3.45, 2.23
Tasks: 161 total,   4 running, 157 sleeping,   0 stopped,   0 zombie
Cpu(s): 96.3%us,  2.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.7%si,  0.0%st
Mem:   2060820k total,  2041144k used,    19676k free,    33948k buffers
Swap:        0k total,        0k used,        0k free,  1502632k cached

Somewhat later:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 5953 clamav    20   0  279m  52m 1632 R 30.9  2.6   4:14.37 clamd
 5956 clamav    20   0  279m  52m 1632 R 30.9  2.6   4:11.67 clamd
 5952 clamav    20   0  279m  52m 1632 R 28.9  2.6   4:14.20 clamd
 5951 clamav    20   0  279m  52m 1632 S  0.3  2.6   0:04.55 clamd
 5932 clamav    20   0  279m  52m 1632 S  0.0  2.6   0:00.81 clamd

Also same results from ps:

edwin@lightspeed2:~$ ps -eLf|grep clamd
clamav    5932     1  5932  0    5 22:10 ?        00:00:00 clamd
clamav    5932     1  5951  0    5 22:11 ?        00:00:02 clamd
clamav    5932     1  5952 31    5 22:11 ?        00:02:27 clamd
clamav    5932     1  5953 31    5 22:11 ?        00:02:28 clamd
clamav    5932     1  5956 31    5 22:11 ?        00:02:26 clamd
edwin     5950  5731  5950  0    1 22:11 pts/3    00:00:00 clamdscan
--quiet -m .
edwin     6746  5729  6746  0    1 22:18 pts/1    00:00:00 grep clamd
edwin@lightspeed2:~$ ps -e|grep clamd
 5932 ?        00:00:00 clamd
 5950 pts/3    00:00:00 clamdscan

Output of /proc/sched_debug:
Sched Debug Version: v0.02
now at 449457590200 nsecs

cpu: 0
  .nr_running            : 5
  .raw_weighted_load     : 4206
  .nr_switches           : 716023
  .nr_load_updates       : 448815
  .nr_uninterruptible    : 0
  .jiffies               : 4295116153
  .next_balance          : 4295116155
  .curr->pid             : 6599
  .clock                 : 356291196511
  .prev_clock_raw        : 459148341095
  .clock_warps           : 0
  .clock_overflows       : 8686
  .clock_unstable_events : 0
  .clock_max_delta       : 1998116
  .fair_clock            : 192139480240
  .delta_fair_clock      : 200255631498
  .exec_clock            : 350544921775
  .delta_exec_clock      : 350544921775
  .wait_runtime          : -48647436
  .wait_runtime_overruns : 280656
  .wait_runtime_underruns: 4285
  .cpu_load[0]           : 4206
  .cpu_load[1]           : 4206
  .cpu_load[2]           : 4190
  .cpu_load[3]           : 4024
  .cpu_load[4]           : 3736
  .wait_runtime_rq_sum   : 3955762

runnable tasks:
            task   PID        tree-key         delta       waiting
switches  prio        sum-exec        sum-wait       sum-sleep
wait-overrun   wait-underrun
------------------------------------------------------------------------------------------------------------------------------------------------------------------
           clamd  5952    192137574072      -1906168        449816
98914   120    102684256359      2613992521      8984991859
1006             245
           clamd  5953    192139027677       -452563        448071
97449   120    103668648209      1738317592      5672775365
 542             323
           clamd  5956    192137649522      -1830718       1097630
97852   120    101209019733      2430217564      7866850540
 957             220
     munin-graph  6561    192137708550      -1771690       -275731
 3885   130      2792201054         -761359               0
   0               0
R            cat  6599    192137244264      -2235976       2235976
    2   120           61234         2235976           84374

If you need further info, please ask.

Best regards,
--Edwin
