Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbXH1Kk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbXH1Kk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXH1KkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:40:13 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:48882 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXH1KkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:40:11 -0400
Message-ID: <46D3FB7F.6060805@free.fr>
Date: Tue, 28 Aug 2007 12:39:59 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: pdflush preemption
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been using the latency tracing tool in -rt.
Linux version 2.6.22.1-rt9 (gcc version 3.4.4) #1 PREEMPT RT

     prctl(0, 1); /* start tracing */
     TsOut.Write(buf, packet_size);
     prctl(0, 0); /* stop tracing */

Write() calls the driver through an ioctl, which schedules a DMA to copy 
the buffer to a hardware device, and sleeps until the device acks the data.

The user space process has RT prio 30.
The device's IRQ line is IRQ-5.
I lowered softirq-timer's prio because at least two pieces of code 
sometimes insisted on running even when an interrupt was pending 
(eepro100 talking to the EEPROM and net route flush).

What's the difference between the softirq-* gizmos and the IRQ threads?
(ksoftirqd vs irqd)

# ps -eo pid,class,rtprio,ni,pri,stat,wchan:14,comm
   PID CLS RTPRIO  NI PRI STAT WCHAN          COMMAND
     1 TS       -   0  19 Ss   select         init
     2 TS       -  -5  24 S<   kthreadd       kthreadd
     3 FF      99   - 139 S<   posix_cpu_time posix_cpu_timer
     4 FF      50   -  90 S<   ksoftirqd      softirq-high/0
     5 FF      10   -  50 S<   ksoftirqd      softirq-timer/0
     6 FF      50   -  90 S<   ksoftirqd      softirq-net-tx/
     7 FF      50   -  90 S<   ksoftirqd      softirq-net-rx/
     8 FF      50   -  90 S<   ksoftirqd      softirq-block/0
     9 FF      50   -  90 S<   ksoftirqd      softirq-tasklet
    10 FF      50   -  90 S<   ksoftirqd      softirq-sched/0
    11 FF      50   -  90 S<   ksoftirqd      softirq-hrtimer
    12 FF      50   -  90 S<   ksoftirqd      softirq-rcu/0
    13 TS       - -10  29 S<   desched_thread desched/0
    14 FF       1   -  41 S<   worker_thread  events/0
    15 TS       -  -5  24 S<   worker_thread  khelper
    31 TS       -  -5  24 S<   worker_thread  kblockd/0
    32 TS       -  -5  24 S<   worker_thread  kacpid
    33 TS       -  -5  24 S<   worker_thread  kacpi_notify
    34 FF      50   -  90 S<   irqd           IRQ-9
    96 TS       -  -5  24 S<   serio_thread   kseriod
   113 TS       -   0  19 S    pdflush        pdflush
   114 TS       -   0  19 S    pdflush        pdflush
   115 TS       -  -5  24 S<   kswapd         kswapd0
   116 TS       -  -5  24 S<   worker_thread  flush_filesd/0
   117 TS       -  -5  24 S<   worker_thread  aio/0
   720 FF      50   -  90 S<   irqd           IRQ-14
   732 FF      50   -  90 S<   irqd           IRQ-12
   733 FF      50   -  90 S<   irqd           IRQ-1
   806 TS       -  -4  23 S<s  select         udevd
   826 TS       -   0  19 Ss   select         syslogd
   828 TS       -   0  19 Ss   syslog         klogd
   867 FF      50   -  90 S<   irqd           IRQ-10
   899 FF      50   -  90 S<   irqd           IRQ-11
   937 TS       -   0  19 Ss   select         sshd
   943 TS       -   0  19 Ss   poll           acpid
   946 TS       -   0  19 Ss+  read_chan      agetty
   949 TS       -   0  19 Ss+  read_chan      agetty
   982 TS       -   0  19 Rs   -              sshd
   984 TS       -   0  19 Ss   wait           bash
  1005 FF      60   - 100 S<   irqd           IRQ-5
  2443 TS       -   0  19 R+   -              ps

Why does pdflush kick in to ruin my party? :-)
The expected latency is ~600 µs.
http://linux.kernel.free.fr/latency/pdflush.trace
Does ide_inb mean I'm reading from the disk?

Why are there two pdflush threads?

# cat /proc/meminfo
MemTotal:       250560 kB
MemFree:        230236 kB
Buffers:           412 kB
Cached:          12300 kB
SwapCached:          0 kB
Active:           8044 kB
Inactive:         6036 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:               0 kB
Writeback:           0 kB
AnonPages:        1384 kB
Mapped:           2276 kB
Slab:             4384 kB
SReclaimable:     1796 kB
SUnreclaim:       2588 kB
PageTables:        136 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    125280 kB
Committed_AS:    10640 kB
VmallocTotal:   778196 kB
VmallocUsed:       168 kB
VmallocChunk:   777988 kB

Does pdflush stand for page disk flush?
http://www.westnet.com/~gsmith/content/linux-pdflush.htm

# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext2 rw,noatime 0 0
none /proc proc rw 0 0
sysfs /sys sysfs rw 0 0
tmpfs /dev tmpfs rw 0 0
tmpfs /var tmpfs rw 0 0
/dev/hda2 /mnt/vidip ext2 rw,noatime 0 0

(hda is an IDE-compatible flash device.)

Is pdflush in a non-preemptible section in my trace?
(AFAICT the DOM does not support DMA.)

/var and /tmp are tmpfs, so writes to these directories don't go to hda.

There shouldn't be any writes to hda...

Regards.
