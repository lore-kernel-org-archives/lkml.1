Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbYAVRyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbYAVRyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYAVRyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:54:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:14810 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYAVRym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:54:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Ckdu1YTYZYD6y3zA5TS+Jy2qEkDPMI5QOVlHhRTv9Ra1ZxI0Fl+cwtyHsYiWSXI3ZLMJ5G+uMkViRDbITktGi/mXm+fqgW4qrICF1RclYqbMdKwnozdn7JKXTjZXixq7DJskSdr/gwqo98VDaLkz7WtVh5JBqrIbeVKZe5veCFQ=
Message-ID: <47962DD1.9050800@gmail.com>
Date: Tue, 22 Jan 2008 19:54:25 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Strange interaction between latencytop and the scheduler
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan, Ingo,

I am using latest latencytop from git (commit
92b6ca9d40998697866689f64b95647eca3200cb), and I'm seeing some strange
things:
[for minor latencytop userspace specific issues see at end of mail]

* if I compile with CONFIG_SCHED_DEBUG I see a 30-40msec latency from
the scheduler, always (Scheduler: waiting for cpu).
There is also a constant ~5% user, ~2% sys CPU usage on an idle system,
regardless  if latencytop sysctl is on or off.
Is this normal? (is overhead really 40msec?)
I was also seeing an unusually high number of context switches (as shown
by vmstat), I usually have 400-800 with non-patched kernels (while
running mplayer too), but I was getting steadily over 1100 with the
patch (on idle system).

CPU usage with latencytop on:
Cpu(s):  7.3%us,  7.0%sy,  0.3%ni, 85.3%id,  0.0%wa,  0.0%hi,  0.0%si, 
0.0%st

CPU usage with latencytop sysctl off:
Cpu(s):  5.0%us,  1.7%sy,  0.0%ni, 93.3%id,  0.0%wa,  0.0%hi,  0.0%si, 
0.0%st

However top won't tell me who's using 5% CPU!
PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
    1 root      20   0 10388  648  548 S  0.0  0.0   0:01.70 init
    2 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthreadd
    3 root      15  -5     0    0    0 S  0.0  0.0   0:00.13 ksoftirqd/0
    4 root      RT  -5     0    0    0 S  0.0  0.0   0:00.00 watchdog/0

High number of context switches (>1100):
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 2  0    520  60828  92276 832212    0    0   281    55  330 1215 16  3
73  8
 0  0    520  60828  92276 832212    0    0     0     2  242 1158  5  1
94  0
 0  0    520  60828  92288 832212    0    0     0     3  290 1261  8  1
91  0
 0  0    520  60836  92288 832216    0    0     1     0  227 1407 10  2
89  0

Scheduler latency:
Cause                                                Maximum     Percentage
put_device elv_insert blk_plug_device default_wake152.4 msec          4.3 %
Creating block layer request                       68.1 msec          2.5 %
Scheduler: waiting for cpu                         26.6 msec          6.5 %
Writing a page to disk                             15.5 msec          1.8 %
Checking for media change                          10.3 msec          7.8 %
SCSI cdrom ioctl                                    9.4 msec          1.3 %
Checking CDROM media present                        7.1 msec          0.3 %
Waiting for event (poll)                            5.0 msec         59.4 %
Application requested delay                         4.9 msec         11.6 %

Process hddtemp (3772)
put_device elv_insert blk_plug_device default_wake152.4 msec        
61.5 %blk_rq_bio_prep blk_rq_append_bio blk_rq_map_user sg_io scsi_
Creating block layer request                       68.1 msec         36.3 %
Scheduler: waiting for cpu                          6.5 msec          2.2 %


* I compile without CONFIG_SCHED_DEBUG, I no longer get *any* latency
from the scheduler, even if I run multi-threaded programs, etc. Is this
to be expected? (i.e. is this feature available only when enabling
CONFIG_SCHED_DEBUG?)


I was trying to trigger some scheduler latencies artifically, so I wrote
a program that creates 10 threads, each doing an usleep(1) in an infloop.
Still I get no scheduler latency (I was getting scheduler latency with
version 0.1).
If latencytop sysctl is on, when running this test, after a short while
X becomes unusable, and almost freezes; yet I still can't see latencies.
Before it freezes I captured top outputs (see below), notice how
otherwise idle programs get a high CPU usage!
If latencytop sysctl is off no freeze occurs, and CPU usage% is as
normal (a.out getting 99%)

Top output when latencytop sysctl is on:

top - 19:33:31 up  1:28,  2 users,  load average: 3.45, 1.21, 1.05
Tasks: 120 total,   9 running, 110 sleeping,   1 stopped,   0 zombie
Cpu(s):  3.9%us, 95.5%sy,  0.6%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 
0.0%st
Mem:   2060592k total,  1979756k used,    80836k free,    69028k buffers
Swap:  3903724k total,        0k used,  3903724k free,  1473896k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7008 edwin     20   0 38764  472  356 R 58.4  0.0   0:05.94 a.out
 5613 edwin     20   0  179m  10m 7452 R 17.3  0.5   1:45.19 gkrellm
 5920 edwin     20   0  565m  90m  25m R 17.3  4.5   1:41.82 icedove-bin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is an idle program!
 5610 edwin     20   0  152m  21m  13m R  1.9  1.1   1:28.88 konsole
 6749 edwin     20   0  254m 7800 5496 S  1.9  0.4   0:00.87 mplayer
 5209 root      20   0  110m  35m 9016 S  1.3  1.8   1:36.31 Xorg
  908 root      15  -5     0    0    0 S  0.6  0.0   0:01.60 scsi_eh_0
 5132 postgres  20   0 77216 1284  736 S  0.6  0.1   0:00.35 postgres
 5151 root      35  15 41068  29m  648 S  0.6  1.5   0:27.96 preload
 7005 edwin     20   0 18976 1184  880 R  0.6  0.1   0:00.02 top
    1 root      20   0 10388  712  588 S  0.0  0.0   0:01.68 init

with latencytop sysctl off:

top - 19:37:03 up  1:32,  2 users,  load average: 0.76, 0.95, 0.98
Tasks: 120 total,   6 running, 113 sleeping,   1 stopped,   0 zombie
Cpu(s): 10.6%us, 89.4%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si, 
0.0%st
Mem:   2060592k total,  1984368k used,    76224k free,    69476k buffers
Swap:  3903724k total,        0k used,  3903724k free,  1474340k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7107 edwin     20   0 87940  504  368 S 94.1  0.0   0:05.52 a.out
 5610 edwin     20   0  152m  21m  13m R  3.0  1.1   1:31.26 konsole
 5209 root      20   0  110m  35m 9016 S  1.5  1.8   1:41.19 Xorg
 5613 edwin     20   0  179m  10m 7452 S  1.5  0.5   1:48.59 gkrellm
 6749 edwin     20   0  254m 7808 5496 S  1.5  0.4   0:02.31 mplayer
 7111 edwin     20   0 18976 1180  880 R  1.5  0.1   0:00.01 top
    1 root      20   0 10388  712  588 S  0.0  0.0   0:01.68 init
    2 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthreadd

Some minor latencytop userspace issues:
* percentages: new feature (nice!), but the values seem all wrong
(global perc. are always wrong, per app perc. are usually ok, but see
second example below)
* I miss the Average latency column. If it is too costly to keep account
of an overall average, can we have last N second average?
Or just cumulative latency so far (unless it overflows)
This is especially useful for lock contention latencies: if I see max
latency a few miliseconds I don't worry, if I see average latency a few
miliseconds I'm starting to worry.
* unknown reasons show a backtrace, but backtrace doesn't have enough
room on screen
* on startup there are lots of latencies with process_timeout as first
in backtrace
* /proc/latency_stats still says it is v0.1

Example output to illustrate some of the issues:

   LatencyTOP version 0.3       (C) 2008 Intel Corporation

Cause                                                Maximum     Percentage
put_device elv_insert blk_plug_device default_wake 29.3 msec          0.2 %
Creating block layer request                       20.5 msec          0.2 %
Waiting for event (poll)                            5.0 msec         43.1 %
Application requested delay                         5.0 msec         36.5 %
Waiting for TTY data                                5.0 msec         14.2 %
Page fault                                          4.9 msec          3.0 %
Waiting for data on unix socket                     4.0 msec          0.1 %
Reading from a pipe                                 3.4 msec          0.0 %
Userspace lock contention                           1.6 msec          0.0 %

Process hddtemp (3760)
put_device elv_insert blk_plug_device default_wake 29.3 msec        
51.1 %blk_rq_bio_prep blk_rq_append_bio blk_rq_map_user sg_io scs
Creating block layer request                       20.5 msec         48.9 %

 reiserfs/0  udevd  kpsmoused  kgameportd  mdadm  dhclient3  mdadm 
dirmngr  lighttpd  syslogd  acpid  cupsd  dbus-daemon  hddtemp


   LatencyTOP version 0.3       (C) 2008 Intel Corporation

Cause                                                Maximum     Percentage
Waiting for TTY data                                5.0 msec         13.5 %
Waiting for event (poll)                            5.0 msec         44.2 %
Application requested delay                         5.0 msec         36.7 %
synchronous write                                   5.0 msec          1.9 %
Waiting for data on unix socket                     4.9 msec          0.1 %
Page fault                                          4.9 msec          2.4 %
Writing buffer to disk (synchronous)                4.8 msec          0.0 %
Reading from a pipe                                 3.7 msec          0.1 %
Closing a file                                      1.9 msec          0.1 %

Process hald-addon-stor (4645)
SCSI cdrom ioctl                                    1.1 msec         17.7 %
Checking for media change                           0.6 msec         77.9 %
Executing raw SCSI command                          0.2 msec          4.3 %


Best regards,
--Edwin
