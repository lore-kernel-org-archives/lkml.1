Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbYERQKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbYERQKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 12:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbYERQKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 12:10:06 -0400
Received: from stinky.trash.net ([213.144.137.162]:40458 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbYERQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 12:10:04 -0400
Message-ID: <483054DB.4030504@trash.net>
Date: Sun, 18 May 2008 18:10:03 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: asterisk hangs with RT priority
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing hanging asterisk processes on startup when using
RT priority with current -git. Unfortunately I'm not sure about
the last working version, but it was one of the final 2.6.25 rcs.
The hang stops when executing "schedtool -N $(pidof asterisk)".

The last thing seen in strace (tried multiple times, output is
identical each time) is:

...
connect(3, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 
ENOENT (No such file or directory)
close(3)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 3
fcntl64(3, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(3, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 
ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/group", O_RDONLY|0x80000 /* O_??? */) = 3
_llseek(3, 0, [0], SEEK_CUR)            = 0
fstat64(3, {st_mode=S_IFREG|0644, st_size=504, ...}) = 0
mmap2(NULL, 504, PROT_READ, MAP_SHARED, 3, 0) = 0xb7f2e000
_llseek(3, 504, [504], SEEK_SET)        = 0
fstat64(3, {st_mode=S_IFREG|0644, st_size=504, ...}) = 0
munmap(0xb7f2e000, 504)                 = 0
close(3)                                = 0
setgroups32(3, [103, 20, 29])           = 0
setuid32(102)                           = 0

when executing the schedtool command above at this point, it
continues with

capset(0x19980330, 0, {CAP_NET_ADMIN, CAP_NET_ADMIN, 0}) = 0
geteuid32()                             = 102
stat64("/etc/asterisk/extconfig.conf", {st_mode=S_IFREG|0640, 
st_size=1506, ...}) = 0
open("/etc/asterisk/extconfig.conf", O_RDONLY|O_LARGEFILE) = 3
...

sysrq-t shows:
...
[   32.032337]  =======================
[   32.032337] S21asterisk   S 00000000     0  1220   1148
[   32.032337]        c7d7cf00 00000282 c0103158 00000000 c10e1800 
c7cbbc00 c7cbbd6c ffffffea
[   32.032337]        00000004 c7cbbbf8 c7d7cf78 c012097f c7cbaa80 
070c0065 070c0065 c7d7cf3c
[   32.032337]        00000000 c7cbbd00 0000000c 00000000 00000003 
c7cbbc00 00000001 c7cbbc00
[   32.032337] Call Trace:
[   32.032337]  [<c0103158>] ? do_notify_resume+0x51/0x78e
[   32.032337]  [<c012097f>] do_wait+0x5b1/0xb8c
[   32.032337]  [<c0119ce2>] ? default_wake_function+0x0/0xd
[   32.032337]  [<c0120fbf>] sys_wait4+0x65/0xa2
[   32.032337]  [<c0121023>] sys_waitpid+0x27/0x29
[   32.032337]  [<c0103c4a>] syscall_call+0x7/0xb
[   32.032337]  [<c0320000>] ? serial_pci_guess_board+0x170/0x1ce
[   32.032337]  =======================
[   32.032337] asterisk      R running      0  1229   1220
[   32.032337]        c7d7afb0 00000286 00000000 00001000 00000000 
c7cbaa80 c7cbabf0 b7fa9ff4
[   32.032337]        b7faa668 b7f68b40 c7d7a000 c0103cee b7fa9ff4 
00000007 0000035f b7faa668
[   32.032337]        b7f68b40 bfca8b04 0804abc8 0000007b 0000007b 
c0100000 ffffffff b7f97ff6
[   32.032337] Call Trace:
[   32.032337]  [<c0103cee>] work_resched+0x5/0x28
[   32.032337]  =======================
...
[   32.032337] Sched Debug Version: v0.07, 2.6.26-rc1 #28
[   32.032337] now at 31553.299102 msecs
[   32.032337]   .sysctl_sched_latency                    : 20.000000
[   32.032337]   .sysctl_sched_min_granularity            : 4.000000
[   32.032337]   .sysctl_sched_wakeup_granularity         : 10.000000
[   32.032337]   .sysctl_sched_child_runs_first           : 0.000001
[   32.032337]   .sysctl_sched_features                   : 895
[   32.032337]
[   32.032337] cpu#0, 2667.480 MHz
[   32.032337]   .nr_running                    : 3
[   32.032337]   .load                          : 179570
[   32.032337]   .nr_switches                   : 7594
[   32.032337]   .nr_load_updates               : 6015
[   32.032337]   .nr_uninterruptible            : 0
[   32.032337]   .jiffies                       : 4294698635
[   32.032337]   .next_balance                  : 0.000000
[   32.032337]   .curr->pid                     : 1235
[   32.032337]   .clock                         : 31339.548336
[   32.032337]   .cpu_load[0]                   : 179570
[   32.032337]   .cpu_load[1]                   : 178546
[   32.032337]   .cpu_load[2]                   : 178043
[   32.032337]   .cpu_load[3]                   : 177875
[   32.032337]   .cpu_load[4]                   : 178008
[   32.032337]
[   32.032337] cfs_rq[0]:
[   32.032337]   .exec_clock                    : 0.000000
[   32.032337]   .MIN_vruntime                  : 0.000001
[   32.032337]   .min_vruntime                  : 6015.548989
[   32.032337]   .max_vruntime                  : 0.000001
[   32.032337]   .spread                        : 0.000000
[   32.032337]   .spread0                       : 0.000000
[   32.032337]   .nr_running                    : 0
[   32.032337]   .load                          : 0
[   32.032337]   .nr_spread_over                : 0
[   32.032337]
[   32.032337] cfs_rq[0]:
[   32.032337]   .exec_clock                    : 0.000000
[   32.032337]   .MIN_vruntime                  : 0.000001
[   32.032337]   .min_vruntime                  : 6015.548989
[   32.032337]   .max_vruntime                  : 0.000001
[   32.032337]   .spread                        : 0.000000
[   32.032337]   .spread0                       : 0.000000
[   32.032337]   .nr_running                    : 0
[   32.032337]   .load                          : 0
[   32.032337]   .nr_spread_over                : 0
[   32.032337]
[   32.032337] cfs_rq[0]:
[   32.032337]   .exec_clock                    : 0.000000
[   32.032337]   .MIN_vruntime                  : 0.000001
[   32.032337]   .min_vruntime                  : 6015.548989
[   32.032337]   .max_vruntime                  : 0.000001
[   32.032337]   .spread                        : 0.000000
[   32.032337]   .spread0                       : 0.000000
[   32.032337]   .nr_running                    : 0
[   32.032337]   .load                          : 0
[   32.032337]   .nr_spread_over                : 0
[   32.032337]
[   32.032337] cfs_rq[0]:
[   32.032337]   .exec_clock                    : 0.000000
[   32.032337]   .MIN_vruntime                  : 0.000001
[   32.032337]   .min_vruntime                  : 6015.548989
[   32.032337]   .max_vruntime                  : 0.000001
[   32.032337]   .spread                        : 0.000000
[   32.032337]   .spread0                       : 0.000000
[   32.032337]   .nr_running                    : 0
[   32.032337]   .load                          : 0
[   32.032337]   .nr_spread_over                : 0
[   32.032337]
[   32.032337] cfs_rq[0]:
[   32.032337]   .exec_clock                    : 0.000000
[   32.032337]   .MIN_vruntime                  : 26351.612585
[   32.032337]   .min_vruntime                  : 6015.548989
[   32.032337]   .max_vruntime                  : 26351.612585
[   32.032337]   .spread                        : 0.000000
[   32.032337]   .spread0                       : 0.000000
[   32.032337]   .nr_running                    : 2
[   32.032337]   .load                          : 2048
[   32.032337]   .nr_spread_over                : 0
[   32.032337]
[   32.032337] runnable tasks:
[   32.032337]             task   PID         tree-key  switches  prio 
    exec-runtime
  sum-exec        sum-sleep
[   32.032337] 
--------------------------------------------------------------------------------
--------------------------
[   32.032337]            klogd  1168     26351.612585        14   120 
              0
       0               0.000000               0.000000 
0.000000
[   32.032337]         asterisk  1229     25780.061231        22    89 
              0
       0               0.000000               0.000000 
0.000000
[   32.032337] R           bash  1235     26362.344107        89   120 
              0
       0               0.000000               0.000000 
0.000000
[   32.032337]


The above is from inside lguest, but the problem happens on
a real system as well. If more information is needed, please
ask.
