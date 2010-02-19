Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0BSRQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:16:22 -0500
Received: from swm.pp.se ([212.247.200.143]:40239 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab0BSRQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:16:18 -0500
Date: Fri, 19 Feb 2010 18:16:16 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-kernel@vger.kernel.org
Subject: disk/crypto performance regression 2.6.31 -> 2.6.32 (mmap
 problem?)
Message-ID: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a system with 8 gigs of ram, c2d 2.4GHz and md 
raid6->crypto->lvm/lv->xfs that I've had for quite a while. It used to be 
raid5, but with 2.6.32 I was able to restripe it into a raid6.

When under 2.6.32 (Linux ub 2.6.32-12-generic #16-Ubuntu SMP Thu Jan 28 
07:47:05 UTC 2010 x86_64 GNU/Linux) I'm seeing this in latency-top 
(sometimes worse, several seconds) when running rtorrent (which uses mmap)

Cause                                                Maximum     Percentage
Page fault                                        1580.4 msec         84.7 %
Writing a page to disk                            869.7 msec          2.2 %
[xfs_ilock]                                       232.9 msec          2.3 %
Truncating file                                   110.1 msec          0.3 %
Waiting for TTY data                               18.2 msec          0.0 %
Reading EXT3 indirect blocks                       10.0 msec          0.1 %
Executing a program                                 9.8 msec          0.0 %
Walking directory tree                              8.7 msec          0.0 %
Waiting for event (select)                          5.0 msec          1.8 %

swmike@ub:~$ free
              total       used       free     shared    buffers     cached
Mem:       8194328    6455004    1739324          0       2012    4343532
-/+ buffers/cache:    2109460    6084868
Swap:            0          0          0

iostat -x 5 gives this:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.61    0.00    4.36   63.29    0.00   31.74

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb              35.80    59.00   20.80   21.00   457.60   646.40    26.41     0.13    3.21   2.06   8.60
sdc              33.20    74.40   21.60   26.40   491.20   814.40    27.20     0.23    4.88   3.29  15.80
sdd              24.20    96.60   21.00   32.80   457.60  1040.00    27.84     0.31    5.84   4.16  22.40
sde              25.60    94.80   18.80   33.60   420.80  1033.60    27.76     0.28    5.42   3.82  20.00
md0               0.00     0.00    5.00   97.20   393.60  2390.40    27.24     0.00    0.00   0.00   0.00
sdf              29.80    87.20   18.60   28.80   460.80   937.60    29.50     0.16    3.38   2.70  12.80
sdg              35.80    61.80   20.60   19.60   476.80   657.60    28.22     0.26    5.92   3.38  13.60
sdh              32.20    71.20   21.00   22.20   465.60   752.00    28.19     0.23    5.23   3.24  14.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    5.00  132.40   393.60  2390.40    20.26     3.32   22.39   7.26  99.80
dm-3              0.00     0.00    5.20   77.80   444.80  1841.60    27.55     3.32   37.08  12.05 100.00

swmike@ub:/dev/mapper$ ls -l
total 0
crw-rw---- 1 root root  10, 59 2010-02-05 17:57 control
brw-rw---- 1 root disk 252,  2 2010-02-15 13:55 md0_crypt
brw-rw---- 1 root disk 252,  0 2010-02-15 13:55 sdb1_crypt
brw-rw---- 1 root disk 252,  1 2010-02-15 13:55 ub-root
brw-rw---- 1 root disk 252,  3 2010-02-15 13:55 vg01-home

So from what I can gather, even though it's moving very little traffic 
thru the crypt layer, this is still the bottleneck (when just copying a 
single file I can easily get 50+ megabyte/s thru the crypto layer). Top 
indicates low cpu usage but still high load of course, since rtorrent is 
"blocking" most of the time (unresponsive to interactive input).

top - 17:34:54 up 14 days, 37 min,  6 users,  load average: 3.60, 3.90, 3.89
Tasks: 237 total,   2 running, 235 sleeping,   0 stopped,   0 zombie
Cpu0  :  1.7%us,  8.6%sy,  0.0%ni, 55.1%id, 30.9%wa,  2.3%hi,  1.3%si,  0.0%st
Cpu1  :  1.4%us, 11.1%sy,  0.0%ni,  2.8%id, 81.9%wa,  0.0%hi,  2.8%si,  0.0%st
Mem:   8194328k total,  8143856k used,    50472k free,     2136k buffers
Swap:        0k total,        0k used,        0k free,  5625364k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  9950 root      20   0     0    0    0 S    5  0.0   1012:29 md0_raid5
25684 root      20   0     0    0    0 R    9  0.0 342:58.88 kcryptd
22007 swmike    20   0  325m 170m 140m D    5  2.1  87:09.82 rtorrent
15543 swmike    20   0  124m  24m 3296 S    1  0.3  78:25.01 rtorrent
31346 swmike     9 -11  327m 5940 4200 S    0  0.1  43:12.09 pulseaudio

When I was running 2.6.31 (ubuntu 9.10) kernel I didn't see this problem 
at all, though things have changed in that I'm now running raid6 instead 
of raid5, but from the iostat it looks like the disk+md layer is not 
causing this behaviour (before in 2.6.31 that was the bottleneck but not 
anymore).

Here is an example of when I dd a large file instead, note the dm-2 
behaviour:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           29.10    0.00   70.90    0.00    0.00    0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    3.00    0.00    54.40     0.00    18.13     0.01    4.00   1.33   0.40
sdb              42.80  1990.20    3.40   75.40   369.60 16537.60   214.56     0.20    2.51   0.79   6.20
sdc              38.60  1993.40    3.20   75.20   334.40 16563.20   215.53     0.10    1.22   0.56   4.40
sdd              31.80  1990.40    2.20   75.00   272.00 16537.60   217.74     0.12    1.53   0.65   5.00
sde              31.80  1986.80    2.20   75.40   272.00 16512.00   216.29     0.25    3.20   1.11   8.60
md0               0.00     0.00    0.00  777.20     0.00 99225.60   127.67     0.00    0.00   0.00   0.00
sdf              28.80  1993.40    2.00   75.40   246.40 16563.20   217.18     0.06    0.80   0.52   4.00
sdg              36.80  1999.20    3.00   75.80   318.40 16612.80   214.86     0.56    7.13   1.73  13.60
sdh              17.60  1993.20    1.80   75.60   155.20 16563.20   216.00     0.02    0.26   0.21   1.60
dm-0              0.00     0.00    3.00    0.00    54.40     0.00    18.13     0.01    4.00   1.33   0.40
dm-1              0.00     0.00    3.00    0.00    54.40     0.00    18.13     0.01    4.00   1.33   0.40
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     0.00 14696.19    0.00   0.00 100.00
dm-3              0.00     0.00    0.00 9051.80     0.00 963836.80   106.48 14696.19  468.84   0.11 100.00
sdj              24.80  1999.00    2.20   76.00   216.00 16612.80   215.20     0.10    1.25   0.72   5.60

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           24.82    0.00   73.27    1.91    0.00    0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    1.20    0.00    24.00     0.00    20.00     0.00    3.33   3.33   0.40
sdb               3.00  3288.00    0.20   83.40    25.60 26972.80   322.95     0.16    1.91   1.89  15.80
sdc               6.00  3287.80    0.80   83.60    54.40 26972.80   320.23     0.19    2.25   2.13  18.00
sdd               7.20  3283.40    1.00   83.00    65.60 26932.80   321.41     0.29    3.40   2.45  20.60
sde               7.20  3283.80    1.00   82.60    65.60 26932.80   322.95     0.25    3.01   2.39  20.00
md0               0.00     0.00    0.00 3665.20     0.00 161574.40    44.08     0.00    0.00   0.00   0.00
sdf               1.20  3283.80    0.60   82.60    14.40 26932.80   323.88     0.21    2.50   2.33  19.40
sdg               3.00  3285.00    0.20   83.20    25.60 26947.20   323.41     0.29    3.43   2.45  20.40
sdh               1.20  3283.80    0.60   82.60    14.40 26932.80   323.88     0.20    2.43   2.28  19.00
dm-0              0.00     0.00    1.20    0.00    24.00     0.00    20.00     0.00    3.33   3.33   0.40
dm-1              0.00     0.00    1.20    0.00    24.00     0.00    20.00     0.00    3.33   3.33   0.40
dm-2              0.00     0.00    0.00 3872.40     0.00 334886.40    86.48  9989.29 6114.24   0.26 100.00
dm-3              0.00     0.00    0.00 2731.80     0.00 178907.60    65.49  9989.30 8667.10   0.37 100.00
sdj               4.20  3283.80    0.80   82.60    40.00 26932.80   323.41     0.18    2.16   2.13  17.80

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           30.89    0.00   65.09    4.02    0.00    0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sdb              12.00  3141.00    0.80   78.20   102.40 25680.00   326.36     0.15    1.85   1.77  14.00
sdc               9.00  3141.20    0.60   78.20    76.80 25756.80   327.84     0.14    1.83   1.75  13.80
sdd               9.00  3140.80    0.60   78.60    76.80 25755.20   326.16     0.32    4.04   2.30  18.20
sde               9.00  3140.60    0.60   78.80    76.80 25755.20   325.34     0.27    3.38   2.14  17.00
md0               0.00     0.00    0.00 1685.80     0.00 154444.80    91.62     0.00    0.00   0.00   0.00
sdf               6.00  3141.00    0.40   78.40    51.20 25755.20   327.49     0.16    2.03   1.93  15.20
sdg               9.00  3142.60    0.60   78.40    76.80 25769.60   327.17     0.48    6.08   3.32  26.20
sdh               6.00  3141.20    0.40   77.80    51.20 25678.40   329.02     0.14    1.74   1.71  13.40
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     0.00  9797.52    0.00   0.00 100.00
dm-3              0.00     0.00    0.20 2035.60     1.60 135518.80    66.57  9797.52 3423.06   0.49 100.00
sdj               9.00  3142.40    0.60   78.60    76.80 25769.60   326.34     0.18    2.25   1.97  15.60

Any ideas? What more information can I collect to help look into this 
issue? Currently I'm running with:

swmike@ub:~$ cat /etc/sysctl.conf | grep vm
vm.dirty_background_ratio = 1
vm.dirty_ratio = 60

Setting this to 10/30 or something alike doesn't really change the 
behaviour with rtorrent. I've also mucked around with io scheduler, 
running deadline right now, doesn't see much difference between them under 
2.6.32 and this problem.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
