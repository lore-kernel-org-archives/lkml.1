Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbXJNXOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbXJNXOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXJNXOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:14:34 -0400
Received: from srve.com ([208.69.183.6]:34998 "EHLO srve.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXJNXOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:14:32 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2007 19:14:32 EDT
Date: Mon, 15 Oct 2007 09:04:56 +1000
From: Chris Drake <christopher@pobox.com>
X-Priority: 3 (Normal)
Message-ID: <1972197991.20071015090456@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel memory subsystem incorrectly invokes OOM killer under certain situations
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linux-kernel,



[1.] One line summary of the problem:

kernel memory subsystem incorrectly invokes OOM killer under certain situations


[2.] Full description of the problem/report:

My guess is that whatever invokes the OOM killer is incorrectly
"deciding" that memory allocated for disk cache operations cannot be
"reclaimed", or, the oom killer code itself is incorrectly killing
processes when the cause of the memory exhaustion is the disk cache
subsystem (and not a runaway process).

Specifically - I have a RedHat AS4u5 2.6.9-55.0.6.ELsmp system with
4gigs RAM, running vmware 1.0.4, and another AS4 guest, which has 3
virtual SCSI drives.  The following guest command reliably causes the
host OOM killer to terminate my vmware process:

dd if=/dev/sdb of=/deb/sdc

(to clone the contents of a 16gb virtual disk).  The host has one 2TB
file system only.

While it's easiest to use vmware to demonstrate the problem, this does
not appear to be a problem with vmware itself.


[3.] Keywords (i.e., modules, networking, kernel):

/usr/src/redhat/BUILD/kernel-2.6.9/linux-2.6.9/mm/oom_kill.c

OOM killer


[4.] Kernel version (from /proc/version):

Linux version 2.6.9-55.0.6.ELsmp (brewbuilder@hs20-bc2-3.build.redhat.com) (gcc version 3.4.6 20060404 (Red Hat 3.4.6-8)) #1 SMP Thu Aug 23 11:11:20 EDT 2007


[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)

Here's the messages output showing the offending oom-kill.

Oct 14 21:05:14 dor kernel: oom-killer: gfp_mask=0xd0
Oct 14 21:05:14 dor kernel: Mem-info:
Oct 14 21:05:14 dor kernel: DMA per-cpu:
Oct 14 21:05:14 dor kernel: cpu 0 hot: low 2, high 6, batch 1
Oct 14 21:05:14 dor kernel: cpu 0 cold: low 0, high 2, batch 1
Oct 14 21:05:14 dor kernel: cpu 1 hot: low 2, high 6, batch 1
Oct 14 21:05:14 dor kernel: cpu 1 cold: low 0, high 2, batch 1
Oct 14 21:05:14 dor kernel: cpu 2 hot: low 2, high 6, batch 1
Oct 14 21:05:14 dor kernel: cpu 2 cold: low 0, high 2, batch 1
Oct 14 21:05:14 dor kernel: cpu 3 hot: low 2, high 6, batch 1
Oct 14 21:05:14 dor kernel: cpu 3 cold: low 0, high 2, batch 1
Oct 14 21:05:14 dor kernel: Normal per-cpu:
Oct 14 21:05:14 dor kernel: cpu 0 hot: low 32, high 96, batch 16
Oct 14 21:05:20 dor kernel: cpu 0 cold: low 0, high 32, batch 16
Oct 14 21:05:20 dor kernel: cpu 1 hot: low 32, high 96, batch 16
Oct 14 21:05:21 dor kernel: cpu 1 cold: low 0, high 32, batch 16
Oct 14 21:05:21 dor kernel: cpu 2 hot: low 32, high 96, batch 16
Oct 14 21:05:21 dor kernel: cpu 2 cold: low 0, high 32, batch 16
Oct 14 21:05:21 dor kernel: cpu 3 hot: low 32, high 96, batch 16
Oct 14 21:05:21 dor kernel: cpu 3 cold: low 0, high 32, batch 16
Oct 14 21:05:21 dor kernel: HighMem per-cpu:
Oct 14 21:05:21 dor kernel: cpu 0 hot: low 32, high 96, batch 16
Oct 14 21:05:21 dor kernel: cpu 0 cold: low 0, high 32, batch 16
Oct 14 21:05:21 dor kernel: cpu 1 hot: low 32, high 96, batch 16
Oct 14 21:05:21 dor kernel: cpu 1 cold: low 0, high 32, batch 16
Oct 14 21:05:21 dor kernel: cpu 2 hot: low 32, high 96, batch 16
Oct 14 21:05:21 dor kernel: cpu 2 cold: low 0, high 32, batch 16
Oct 14 21:05:21 dor kernel: cpu 3 hot: low 32, high 96, batch 16
Oct 14 21:05:21 dor kernel: cpu 3 cold: low 0, high 32, batch 16
Oct 14 21:05:21 dor kernel: 
Oct 14 21:05:21 dor kernel: Free pages:       26152kB (3584kB HighMem)
Oct 14 21:05:21 dor kernel: Active:599689 inactive:398895 dirty:429 writeback:15 unstable:0 free:6538 slab:13298 mapped:369678 pagetables:6087
Oct 14 21:05:21 dor kernel: DMA free:12544kB min:180kB low:360kB high:540kB active:0kB inactive:0kB present:16384kB pages_scanned:871 all_unreclaimable? yes
Oct 14 21:05:27 dor kernel: protections[]: 0 0 0
Oct 14 21:05:28 dor kernel: Normal free:10024kB min:10056kB low:20112kB high:30168kB active:928kB inactive:775024kB present:901120kB pages_scanned:5812455 all_unreclaimable? yes
Oct 14 21:05:28 dor kernel: protections[]: 0 0 0
Oct 14 21:05:28 dor kernel: HighMem free:3584kB min:512kB low:1024kB high:1536kB active:2397828kB inactive:820556kB present:3538944kB pages_scanned:0 all_unreclaimable? no
Oct 14 21:05:28 dor kernel: protections[]: 0 0 0
Oct 14 21:05:28 dor kernel: DMA: 4*4kB 4*8kB 3*16kB 3*32kB 3*64kB 3*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 2*4096kB = 12544kB
Oct 14 21:05:28 dor kernel: Normal: 0*4kB 1*8kB 0*16kB 1*32kB 0*64kB 10*128kB 6*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 10024kB
Oct 14 21:05:28 dor kernel: HighMem: 52*4kB 68*8kB 85*16kB 26*32kB 2*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 3584kB
Oct 14 21:05:28 dor kernel: Swap cache: add 678557, delete 673525, find 277514/347205, race 0+5
Oct 14 21:05:28 dor kernel: 0 bounce buffer pages
Oct 14 21:05:28 dor kernel: Free swap:       20303648kB
Oct 14 21:05:28 dor kernel: 1114112 pages of RAM
Oct 14 21:05:28 dor kernel: 819184 pages of HIGHMEM
Oct 14 21:05:28 dor kernel: 75731 reserved pages
Oct 14 21:05:28 dor kernel: 1013077 pages shared
Oct 14 21:05:28 dor kernel: 5040 pages swap cached
Oct 14 21:05:28 dor kernel: Out of Memory: Killed process 10422 (oracle).
Oct 14 21:05:28 dor kernel: oom-killer: gfp_mask=0xd0
Oct 14 21:05:28 dor kernel: Mem-info:
Oct 14 21:05:28 dor kernel: DMA per-cpu:
Oct 14 21:05:28 dor kernel: cpu 0 hot: low 2, high 6, batch 1
Oct 14 21:05:28 dor kernel: cpu 0 cold: low 0, high 2, batch 1
Oct 14 21:05:28 dor kernel: cpu 1 hot: low 2, high 6, batch 1
Oct 14 21:05:28 dor kernel: cpu 1 cold: low 0, high 2, batch 1
Oct 14 21:05:28 dor kernel: cpu 2 hot: low 2, high 6, batch 1
Oct 14 21:05:28 dor kernel: cpu 2 cold: low 0, high 2, batch 1
Oct 14 21:05:28 dor kernel: cpu 3 hot: low 2, high 6, batch 1
Oct 14 21:05:28 dor kernel: cpu 3 cold: low 0, high 2, batch 1
Oct 14 21:05:28 dor kernel: Normal per-cpu:
Oct 14 21:05:28 dor kernel: cpu 0 hot: low 32, high 96, batch 16
Oct 14 21:05:28 dor kernel: cpu 0 cold: low 0, high 32, batch 16
Oct 14 21:05:32 dor kernel: cpu 1 hot: low 32, high 96, batch 16
Oct 14 21:05:33 dor kernel: cpu 1 cold: low 0, high 32, batch 16
Oct 14 21:05:33 dor kernel: cpu 2 hot: low 32, high 96, batch 16
Oct 14 21:05:33 dor kernel: cpu 2 cold: low 0, high 32, batch 16
Oct 14 21:05:33 dor kernel: cpu 3 hot: low 32, high 96, batch 16
Oct 14 21:05:33 dor kernel: cpu 3 cold: low 0, high 32, batch 16
Oct 14 21:05:33 dor kernel: HighMem per-cpu:
Oct 14 21:05:33 dor kernel: cpu 0 hot: low 32, high 96, batch 16
Oct 14 21:05:33 dor kernel: cpu 0 cold: low 0, high 32, batch 16
Oct 14 21:05:33 dor kernel: cpu 1 hot: low 32, high 96, batch 16
Oct 14 21:05:33 dor kernel: cpu 1 cold: low 0, high 32, batch 16
Oct 14 21:05:33 dor kernel: cpu 2 hot: low 32, high 96, batch 16
Oct 14 21:05:33 dor kernel: cpu 2 cold: low 0, high 32, batch 16
Oct 14 21:05:33 dor kernel: cpu 3 hot: low 32, high 96, batch 16
Oct 14 21:05:33 dor kernel: cpu 3 cold: low 0, high 32, batch 16
Oct 14 21:05:33 dor kernel: 
Oct 14 21:05:33 dor kernel: Free pages:       24176kB (1600kB HighMem)
Oct 14 21:05:33 dor kernel: Active:599578 inactive:399690 dirty:0 writeback:0 unstable:0 free:6044 slab:13256 mapped:370227 pagetables:6025
Oct 14 21:05:33 dor kernel: DMA free:12544kB min:180kB low:360kB high:540kB active:0kB inactive:0kB present:16384kB pages_scanned:913 all_unreclaimable? yes
Oct 14 21:05:33 dor kernel: protections[]: 0 0 0
Oct 14 21:05:33 dor kernel: Normal free:10032kB min:10056kB low:20112kB high:30168kB active:0kB inactive:775944kB present:901120kB pages_scanned:6652899 all_unreclaimable? yes
Oct 14 21:05:33 dor kernel: protections[]: 0 0 0
Oct 14 21:05:33 dor kernel: HighMem free:1600kB min:512kB low:1024kB high:1536kB active:2398312kB inactive:822560kB present:3538944kB pages_scanned:0 all_unreclaimable? no
Oct 14 21:05:33 dor kernel: protections[]: 0 0 0
Oct 14 21:05:33 dor kernel: DMA: 4*4kB 4*8kB 3*16kB 3*32kB 3*64kB 3*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 2*4096kB = 12544kB
Oct 14 21:05:33 dor kernel: Normal: 0*4kB 2*8kB 0*16kB 1*32kB 0*64kB 10*128kB 6*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 10032kB
Oct 14 21:05:33 dor kernel: HighMem: 10*4kB 3*8kB 10*16kB 21*32kB 3*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1600kB
Oct 14 21:05:33 dor kernel: Swap cache: add 678557, delete 673525, find 277515/347206, race 0+5
Oct 14 21:05:33 dor kernel: 0 bounce buffer pages
Oct 14 21:05:33 dor kernel: Free swap:       20303648kB
Oct 14 21:05:33 dor kernel: 1114112 pages of RAM
Oct 14 21:05:33 dor kernel: 819184 pages of HIGHMEM
Oct 14 21:05:33 dor kernel: 75731 reserved pages
Oct 14 21:05:33 dor kernel: 1011055 pages shared
Oct 14 21:05:33 dor kernel: 5040 pages swap cached
Oct 14 21:05:33 dor kernel: Out of Memory: Killed process 10794 (oracle).
Oct 14 21:05:51 dor kernel: oom-killer: gfp_mask=0xd0
Oct 14 21:05:51 dor kernel: Mem-info:
Oct 14 21:05:51 dor kernel: DMA per-cpu:
Oct 14 21:05:51 dor kernel: cpu 0 hot: low 2, high 6, batch 1
Oct 14 21:05:51 dor kernel: cpu 0 cold: low 0, high 2, batch 1
Oct 14 21:05:51 dor kernel: cpu 1 hot: low 2, high 6, batch 1
Oct 14 21:05:51 dor kernel: cpu 1 cold: low 0, high 2, batch 1
Oct 14 21:05:51 dor kernel: cpu 2 hot: low 2, high 6, batch 1
Oct 14 21:05:51 dor kernel: cpu 2 cold: low 0, high 2, batch 1
Oct 14 21:05:51 dor kernel: cpu 3 hot: low 2, high 6, batch 1
Oct 14 21:05:51 dor kernel: cpu 3 cold: low 0, high 2, batch 1
Oct 14 21:05:51 dor kernel: Normal per-cpu:
Oct 14 21:05:51 dor kernel: cpu 0 hot: low 32, high 96, batch 16
Oct 14 21:05:53 dor kernel: cpu 0 cold: low 0, high 32, batch 16
Oct 14 21:05:54 dor kernel: cpu 1 hot: low 32, high 96, batch 16
Oct 14 21:05:54 dor kernel: cpu 1 cold: low 0, high 32, batch 16
Oct 14 21:05:54 dor kernel: cpu 2 hot: low 32, high 96, batch 16
Oct 14 21:05:54 dor kernel: cpu 2 cold: low 0, high 32, batch 16
Oct 14 21:05:54 dor kernel: cpu 3 hot: low 32, high 96, batch 16
Oct 14 21:05:54 dor kernel: cpu 3 cold: low 0, high 32, batch 16
Oct 14 21:05:54 dor kernel: HighMem per-cpu:
Oct 14 21:05:54 dor kernel: cpu 0 hot: low 32, high 96, batch 16
Oct 14 21:05:54 dor kernel: cpu 0 cold: low 0, high 32, batch 16
Oct 14 21:05:54 dor kernel: cpu 1 hot: low 32, high 96, batch 16
Oct 14 21:05:54 dor kernel: cpu 1 cold: low 0, high 32, batch 16
Oct 14 21:05:54 dor kernel: cpu 2 hot: low 32, high 96, batch 16
Oct 14 21:05:54 dor kernel: cpu 2 cold: low 0, high 32, batch 16
Oct 14 21:05:54 dor kernel: cpu 3 hot: low 32, high 96, batch 16
Oct 14 21:05:54 dor kernel: cpu 3 cold: low 0, high 32, batch 16
Oct 14 21:05:54 dor kernel: 
Oct 14 21:05:54 dor kernel: Free pages:       24176kB (1600kB HighMem)
Oct 14 21:05:54 dor kernel: Active:598000 inactive:401375 dirty:67 writeback:0 unstable:0 free:6044 slab:13215 mapped:376483 pagetables:5924
Oct 14 21:05:54 dor kernel: DMA free:12544kB min:180kB low:360kB high:540kB active:0kB inactive:0kB present:16384kB pages_scanned:987 all_unreclaimable? yes
Oct 14 21:05:54 dor kernel: protections[]: 0 0 0
Oct 14 21:05:54 dor kernel: Normal free:10032kB min:10056kB low:20112kB high:30168kB active:40kB inactive:776768kB present:901120kB pages_scanned:6367284 all_unreclaimable? yes
Oct 14 21:05:54 dor kernel: protections[]: 0 0 0
Oct 14 21:05:54 dor kernel: HighMem free:1600kB min:512kB low:1024kB high:1536kB active:2391960kB inactive:828732kB present:3538944kB pages_scanned:0 all_unreclaimable? no
Oct 14 21:05:54 dor kernel: protections[]: 0 0 0
Oct 14 21:05:54 dor kernel: DMA: 4*4kB 4*8kB 3*16kB 3*32kB 3*64kB 3*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 2*4096kB = 12544kB
Oct 14 21:05:54 dor kernel: Normal: 0*4kB 4*8kB 1*16kB 0*32kB 0*64kB 10*128kB 6*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 10032kB
Oct 14 21:05:54 dor kernel: HighMem: 32*4kB 6*8kB 41*16kB 8*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1600kB
Oct 14 21:05:54 dor kernel: Swap cache: add 679214, delete 673826, find 277673/347433, race 0+5
Oct 14 21:05:54 dor kernel: 0 bounce buffer pages
Oct 14 21:05:54 dor kernel: Free swap:       20305016kB
Oct 14 21:05:54 dor kernel: 1114112 pages of RAM
Oct 14 21:05:54 dor kernel: 819184 pages of HIGHMEM
Oct 14 21:05:54 dor kernel: 75731 reserved pages
Oct 14 21:05:54 dor kernel: 1017889 pages shared
Oct 14 21:05:54 dor kernel: 5396 pages swap cached
Oct 14 21:05:54 dor kernel: Out of Memory: Killed process 24044 (vmware-vmx).
Oct 14 21:05:54 dor kernel: device eth0 left promiscuous mode

     
[6.] A small shell script or example program which triggers the
     problem (if possible)

1. install RedHat AS4
2. install vmware 1.0.4  (same problem with 1.0.1, 1.0.2, and 1.0.3)
3. install AS4 again as a guest
4. configure 2 extra SCSI drives, and put at least 16gb of junk onto
   one.
5. issue the "dd" command to copy one disk to another
6. observe the host will OOM-kill the vmware-vmx without warrant :-)


Here's an example of the guest (from the "top" command) before an
unwarranted oom-kill:-

25749 devnull    5 -10 1845m 1.1g 1.0g S   62 26.7   8:24.60 /usr/lib/vmware/bin/vmware-vmx -C /home/devnull/vmware/rnprod-cup-devnull/rnprod.vmx -@ ""

[root@dor bin]# cat /proc/25749/status
Name:   vmware-vmx
State:  S (sleeping)
SleepAVG:       92%
Tgid:   25749
Pid:    25749
PPid:   1
TracerPid:      0
Uid:    513     513     0       513
Gid:    513     513     513     513
FDSize: 256
Groups: 501 502 513 
VmSize:  1890956 kB
VmLck:         0 kB
VmRSS:    994708 kB
VmData:   194564 kB
VmStk:       552 kB
VmExe:      3463 kB
VmLib:    169189 kB
StaBrk: 084da000 kB
Brk:    08e60000 kB
StaStk: bffffe70 kB
ExecLim:        c0000000
Threads:        17
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: 0000000000301000
SigCgt: 0000000193c8eeef
CapInh: 0000000000000000
CapPrm: 00000000fffffeff
CapEff: 0000000000000000
[root@dor bin]# cat /proc/25749/statm
472774 249204 244690 865 0 48779 0
[root@dor bin]# cat /proc/25749/stat
25749 (vmware-vmx) S 1 25749 25749 0 -1 256 792342 65 18981 0 3199 50666 0 0 5 -10 17 0 102764987 1936482304 244937 4294967295 134512640 138058888 3221225072 3221223464 11691938 0 0 3149824 331935471 4294967295 0 0 17 3 0 0
[root@dor bin]# cat /proc/25749/maps
001a8000-001b0000 r-xp 00000000 08:03 81583764   /usr/X11R6/lib/libXcursor.so.1.0.2
001b0000-001b1000 rwxp 00007000 08:03 81583764   /usr/X11R6/lib/libXcursor.so.1.0.2
00a22000-00a6f000 r-xp 00000000 08:03 81585424   /usr/X11R6/lib/libXt.so.6.0
00a6f000-00a73000 rwxp 0004c000 08:03 81585424   /usr/X11R6/lib/libXt.so.6.0
00b26000-00b3c000 r-xp 00000000 08:03 103055407  /lib/ld-2.3.4.so
00b3c000-00b3d000 r-xp 00015000 08:03 103055407  /lib/ld-2.3.4.so
00b3d000-00b3e000 rwxp 00016000 08:03 103055407  /lib/ld-2.3.4.so
00b44000-00c6a000 r-xp 00000000 08:03 103055410  /lib/tls/libc-2.3.4.so
00c6a000-00c6c000 r-xp 00125000 08:03 103055410  /lib/tls/libc-2.3.4.so
00c6c000-00c6e000 rwxp 00127000 08:03 103055410  /lib/tls/libc-2.3.4.so
00c6e000-00c70000 rwxp 00c6e000 00:00 0 
00c72000-00c93000 r-xp 00000000 08:03 103055499  /lib/tls/libm-2.3.4.so
00c93000-00c94000 r-xp 00020000 08:03 103055499  /lib/tls/libm-2.3.4.so
00c94000-00c95000 rwxp 00021000 08:03 103055499  /lib/tls/libm-2.3.4.so
00c97000-00c99000 r-xp 00000000 08:03 103055502  /lib/libdl-2.3.4.so
00c99000-00c9a000 r-xp 00001000 08:03 103055502  /lib/libdl-2.3.4.so
00c9a000-00c9b000 rwxp 00002000 08:03 103055502  /lib/libdl-2.3.4.so
00c9d000-00cac000 r-xp 00000000 08:03 81581962   /usr/lib/libz.so.1.2.1.2
00cac000-00cad000 rwxp 0000e000 08:03 81581962   /usr/lib/libz.so.1.2.1.2
00caf000-00d8a000 r-xp 00000000 08:03 81581269   /usr/X11R6/lib/libX11.so.6.2
00d8a000-00d8e000 rwxp 000db000 08:03 81581269   /usr/X11R6/lib/libX11.so.6.2
00d90000-00d9e000 r-xp 00000000 08:03 103055501  /lib/tls/libpthread-2.3.4.so
00d9e000-00d9f000 r-xp 0000d000 08:03 103055501  /lib/tls/libpthread-2.3.4.so
00d9f000-00da0000 rwxp 0000e000 08:03 103055501  /lib/tls/libpthread-2.3.4.so
00da0000-00da2000 rwxp 00da0000 00:00 0 
00da4000-00db1000 r-xp 00000000 08:03 81581436   /usr/X11R6/lib/libXext.so.6.4
00db1000-00db2000 rwxp 0000c000 08:03 81581436   /usr/X11R6/lib/libXext.so.6.4
00db4000-00dbc000 r-xp 00000000 08:03 81584546   /usr/X11R6/lib/libSM.so.6.0
00dbc000-00dbd000 rwxp 00007000 08:03 81584546   /usr/X11R6/lib/libSM.so.6.0
00dbf000-00dd4000 r-xp 00000000 08:03 81584142   /usr/X11R6/lib/libICE.so.6.3
00dd4000-00dd5000 rwxp 00014000 08:03 81584142   /usr/X11R6/lib/libICE.so.6.3
00dd5000-00dd7000 rwxp 00dd5000 00:00 0 
00dd9000-00de8000 r-xp 00000000 08:03 103055517  /lib/libresolv-2.3.4.so
00de8000-00de9000 r-xp 0000f000 08:03 103055517  /lib/libresolv-2.3.4.so
00de9000-00dea000 rwxp 00010000 08:03 103055517  /lib/libresolv-2.3.4.so
00dea000-00dec000 rwxp 00dea000 00:00 0 
00dee000-00df5000 r-xp 00000000 08:03 81581742   /usr/X11R6/lib/libXrender.so.1.2.2
00df5000-00df6000 rwxp 00006000 08:03 81581742   /usr/X11R6/lib/libXrender.so.1.2.2
03d3e000-03d42000 r-xp 00000000 08:03 81588637   /usr/X11R6/lib/libXtst.so.6.1
03d42000-03d43000 rwxp 00003000 08:03 81588637   /usr/X11R6/lib/libXtst.so.6.1
08048000-083aa000 r-xp 00000000 08:03 81724358   /usr/lib/vmware/bin/vmware-vmx
083aa000-083bf000 rwxp 00361000 08:03 81724358   /usr/lib/vmware/bin/vmware-vmx
083bf000-08e60000 rwxp 083bf000 00:00 0 
44c00000-44c25000 rwxp 44c00000 00:00 0 
44c25000-44d00000 --xp 44c25000 00:00 0 
44e00000-44efa000 rwxp 44e00000 00:00 0 
44efa000-44f00000 --xp 44efa000 00:00 0 
45000000-45028000 rwxp 45000000 00:00 0 
45028000-45100000 --xp 45028000 00:00 0 
45200000-45221000 rwxp 45200000 00:00 0 
45221000-45300000 --xp 45221000 00:00 0 
45300000-453af000 rwxp 45300000 00:00 0 
453af000-45400000 --xp 453af000 00:00 0 
45500000-455ff000 rwxp 45500000 00:00 0 
455ff000-45600000 --xp 455ff000 00:00 0 
45600000-456ff000 rwxp 45600000 00:00 0 
456ff000-45700000 --xp 456ff000 00:00 0 
45700000-45729000 rwxp 45700000 00:00 0 
45729000-45800000 --xp 45729000 00:00 0 
458fb000-459fb000 rwxs 05a00000 08:03 73236569   /home/devnull/vmware/rnprod-cup-devnull/564d6162-3e22-137b-de77-caa72f04a155.vmem
45a48000-45b48000 rwxs 04bf0000 08:03 73236569   /home/devnull/vmware/rnprod-cup-devnull/564d6162-3e22-137b-de77-caa72f04a155.vmem
[snip]
b579a000-b579b000 --xp b579a000 00:00 0
b579b000-b619b000 rwxp b579b000 00:00 0 
b619c000-b7dbc000 rwxs 000b7000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7dbc000-b7e4c000 r-xs 00027000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e4c000-b7e4d000 rwxs 00026000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e4d000-b7e4e000 rwxs 00025000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e4e000-b7e50000 r-xs 00000000 00:0d 7420       /dev/vmmon
b7e50000-b7e63000 r-xs 00012000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e63000-b7e67000 r-xp 00000000 08:03 103055406  /lib/libnss_dns-2.3.4.so
b7e67000-b7e68000 r-xp 00003000 08:03 103055406  /lib/libnss_dns-2.3.4.so
b7e68000-b7e69000 rwxp 00004000 08:03 103055406  /lib/libnss_dns-2.3.4.so
b7e78000-b7e79000 rwxs 00011000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e79000-b7e7a000 rwxs 00010000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e7a000-b7e7b000 rwxs 0000f000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e7b000-b7e7c000 rwxs 0000e000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e7c000-b7e8a000 rwxs 00000000 08:03 40386589   /tmp/vmware-devnull/ram0 (deleted)
b7e8a000-b7e93000 r-xp 00000000 08:03 103055409  /lib/libnss_files-2.3.4.so
b7e93000-b7e94000 r-xp 00008000 08:03 103055409  /lib/libnss_files-2.3.4.so
b7e94000-b7e95000 rwxp 00009000 08:03 103055409  /lib/libnss_files-2.3.4.so
b7eb6000-b7ee2000 r-xp 00000000 08:03 81724340   /usr/lib/vmware/lib/libssl.so.0.9.7/libssl.so.0.9.7
b7ee2000-b7ee5000 rwxp 0002b000 08:03 81724340   /usr/lib/vmware/lib/libssl.so.0.9.7/libssl.so.0.9.7
b7ee5000-b7fc6000 r-xp 00000000 08:03 81724227   /usr/lib/vmware/lib/libcrypto.so.0.9.7/libcrypto.so.0.9.7
b7fc6000-b7fd8000 rwxp 000e0000 08:03 81724227   /usr/lib/vmware/lib/libcrypto.so.0.9.7/libcrypto.so.0.9.7
b7fd8000-b7fdf000 rwxp b7fd8000 00:00 0 
b7ffa000-b8000000 r-xs 00000000 08:03 81609502   /usr/lib/gconv/gconv-modules.cache
bff76000-c0000000 rwxp bff76000 00:00 0 
ffffe000-fffff000 ---p 00000000 00:00 0 
[root@dor bin]# free
             total       used       free     shared    buffers     cached
Mem:       4153524    4119172      34352          0       2624    3308040
-/+ buffers/cache:     808508    3345016
Swap:     20514988     205632   20309356


[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)





# /usr/src/redhat/BUILD/kernel-2.6.9/linux-2.6.9/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux ****** 2.6.9-55.0.6.ELsmp #1 SMP Thu Aug 23 11:11:20 EDT 2007 i686 i686 i386 GNU/Linux
 
Gnu C                  3.4.6
Gnu make               3.80
binutils               2.15.92.0.2
util-linux             2.12a
mount                  2.12a
module-init-tools      3.1-pre5
e2fsprogs              1.35
reiserfsprogs          line
reiser4progs           line
pcmcia-cs              3.2.7
quota-tools            3.12.
PPP                    2.4.2
isdn4k-utils           3.3
nfs-utils              1.0.6
Linux C Library        2.3.4
Dynamic linker (ldd)   2.3.4
Procps                 3.2.3
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
Modules Loaded         smbfs nls_utf8 loop md5 ipv6 ppdev autofs4 i2c_dev i2c_core vmnet parport_pc parport vmmon sunrpc ipt_REJECT ipt_state ip_conntrack iptable_filter ip_tables dm_mirror dm_multipath dm_mod button battery ac uhci_hcd hw_random e1000 floppy ata_piix libata sg st ext3 jbd 3w_9xxx aic79xx sd_mod scsi_mod



[7.2.] Processor information (from /proc/cpuinfo):

[root@dor bin]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 5
cpu MHz         : 3190.124
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 6383.65

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 5
cpu MHz         : 3190.124
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 6378.64

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 5
cpu MHz         : 3190.124
cache size      : 1024 KB
physical id     : 3
siblings        : 2
core id         : 3
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 6378.64

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 3.20GHz
stepping        : 5
cpu MHz         : 3190.124
cache size      : 1024 KB
physical id     : 3
siblings        : 2
core id         : 3
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 6378.67

[root@dor bin]#


[7.3.] Module information (from /proc/modules):

[root@dor bin]# cat /proc/modules
smbfs 63417 2 - Live 0xf9482000
nls_utf8 6209 0 - Live 0xf9460000
loop 20681 0 - Live 0xf9468000
md5 8129 1 - Live 0xf93c3000
ipv6 243425 18 - Live 0xf94a8000
ppdev 13637 0 - Live 0xf944f000
autofs4 25285 0 - Live 0xf9458000
i2c_dev 14529 0 - Live 0xf93be000
i2c_core 26049 1 i2c_dev, Live 0xf9404000
vmnet 41116 18 - Live 0xf93f8000
parport_pc 28033 0 - Live 0xf93f0000
parport 38025 2 ppdev,parport_pc, Live 0xf93e5000
vmmon 113316 6 - Live 0xf9432000
sunrpc 143909 1 - Live 0xf940d000
ipt_REJECT 10689 1 - Live 0xf8932000
ipt_state 5953 130 - Live 0xf892f000
ip_conntrack 46085 1 ipt_state, Live 0xf93c7000
iptable_filter 6977 1 - Live 0xf8871000
ip_tables 22721 3 ipt_REJECT,ipt_state,iptable_filter, Live 0xf8937000
dm_mirror 31429 0 - Live 0xf88e4000
dm_multipath 22985 0 - Live 0xf8928000
dm_mod 65001 2 dm_mirror,dm_multipath, Live 0xf896b000
button 10705 0 - Live 0xf8869000
battery 12997 0 - Live 0xf88df000
ac 8901 0 - Live 0xf886d000
uhci_hcd 33241 0 - Live 0xf888f000
hw_random 9685 0 - Live 0xf8865000
e1000 119633 0 - Live 0xf894c000
floppy 58193 0 - Live 0xf88ca000
ata_piix 19141 0 - Live 0xf881c000
libata 106141 1 ata_piix, Live 0xf890d000
sg 38369 0 - Live 0xf8884000
st 40669 0 - Live 0xf8829000
ext3 119113 2 - Live 0xf88ee000
jbd 59609 1 ext3, Live 0xf8874000
3w_9xxx 36421 4 - Live 0xf8835000
aic79xx 187613 0 - Live 0xf889b000
sd_mod 20545 5 - Live 0xf8822000
scsi_mod 119757 6 libata,sg,st,3w_9xxx,aic79xx,sd_mod, Live 0xf8841000
[root@dor bin]# 

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

[root@dor bin]# cat /proc/ioports /proc/iomem
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
02f8-02ff : serial
0378-037a : parport0
03a0-03af : 0000:00:1f.1
  03a0-03a7 : ide0
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial
0400-047f : 0000:00:1f.0
  0400-0403 : PM1a_EVT_BLK
  0404-0405 : PM1a_CNT_BLK
  0408-040b : PM_TMR
  0410-0415 : ACPI CPU throttle
  0428-042b : GPE0_BLK
0480-04bf : 0000:00:1f.0
0540-0543 : PM1b_EVT_BLK
0544-0545 : PM1b_CNT_BLK
0548-054f : GPE1_BLK
0580-059f : 0000:00:1f.3
0cf8-0cff : PCI conf1
1000-10ff : 0000:01:0c.0
2000-3fff : PCI Bus #02
  2000-2fff : PCI Bus #03
    2000-20ff : 0000:03:04.1
      2000-20ff : aic79xx
    2400-24ff : 0000:03:04.1
      2400-24ff : aic79xx
    2800-28ff : 0000:03:04.0
      2800-28ff : aic79xx
    2c00-2cff : 0000:03:04.0
      2c00-2cff : aic79xx
  3000-3fff : PCI Bus #04
    3000-30ff : 0000:04:02.0
      3000-30ff : 3w-9xxx
    3400-343f : 0000:04:05.1
      3400-343f : e1000
    3440-347f : 0000:04:05.0
      3440-347f : e1000
4000-401f : 0000:00:1d.2
  4000-401f : uhci_hcd
4020-403f : 0000:00:1d.1
  4020-403f : uhci_hcd
4040-405f : 0000:00:1d.0
  4040-405f : uhci_hcd
00000000-0009efff : System RAM
0009f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c9800-000ca7ff : Adapter ROM
000ca800-000cb7ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-effeffff : System RAM
  00100000-002d71d3 : Kernel code
  002d71d4-0039537f : Kernel data
efff0000-efffefff : ACPI Tables
effff000-efffffff : ACPI Non-volatile Storage
f1000000-f10003ff : 0000:00:1f.1
fae00000-fbdfffff : PCI Bus #02
  fae00000-fbdfffff : PCI Bus #04
    fb000000-fb7fffff : 0000:04:02.0
      fb000000-fb7fffff : 3w-9xxx
fd000000-fdffffff : 0000:01:0c.0
fe000000-fe3fffff : 0000:01:09.0
fe6f0000-fe6f0fff : 0000:01:0c.0
fe700000-febfffff : PCI Bus #02
  fe700000-fe9fffff : PCI Bus #03
    fe9e0000-fe9e1fff : 0000:03:04.0
    fe9f0000-fe9f1fff : 0000:03:04.1
  fea00000-feafffff : PCI Bus #04
    feaa0000-feabffff : 0000:04:05.0
      feaa0000-feabffff : e1000
    feac0000-feadffff : 0000:04:05.1
      feac0000-feadffff : e1000
    feaf0000-feaf00ff : 0000:04:02.0
      feaf0000-feaf00ff : 3w-9xxx
  febe0000-febe0fff : 0000:02:1c.0
  febf0000-febf0fff : 0000:02:1e.0
fec00000-fecfffff : reserved
fee00000-fee00fff : reserved
fff00000-ffffffff : reserved
[root@dor bin]# 

[7.5.] PCI information ('lspci -vvv' as root)

[root@dor bin]# lspci -vvv
00:00.0 Host bridge: Intel Corporation E7501 Memory Controller Hub (rev 01)
        Subsystem: Intel Corporation SE7501HG2 Mainboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [40] Vendor Specific Information

00:00.1 Class ff00: Intel Corporation E7500/E7501 Host RASUM Controller (rev 01)
        Subsystem: Intel Corporation SE7501HG2 Mainboard
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:03.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface C PCI-to-PCI Bridge (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Bus: primary=00, secondary=02, subordinate=04, sec-latency=0
        I/O behind bridge: 00002000-00003fff
        Memory behind bridge: fe700000-febfffff
        Prefetchable memory behind bridge: fae00000-fbdfffff
        Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:03.1 Class ff00: Intel Corporation E7500/E7501 Hub Interface C RASUM Controller (rev 01)
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:1d.0 USB Controller: Intel Corporation 82801CA/CAM USB Controller #1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation SE7501HG2 Mainboard
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 169
        Region 4: I/O ports at 4040 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801CA/CAM USB Controller #2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 177
        Region 4: I/O ports at 4020 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801CA/CAM USB Controller #3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 185
        Region 4: I/O ports at 4000 [size=32]

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 42) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: fbe00000-fe6fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801CA LPC Interface Controller (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801CA Ultra ATA Storage Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 169
        Region 0: I/O ports at <unassigned>
        Region 1: I/O ports at <unassigned>
        Region 2: I/O ports at <unassigned>
        Region 3: I/O ports at <unassigned>
        Region 4: I/O ports at 03a0 [size=16]
        Region 5: Memory at f1000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (rev 02)
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 193
        Region 4: I/O ports at 0580 [size=32]

01:09.0 Communication controller: Intel Corporation 536EP Data Fax Modem
        Subsystem: Intel Corporation: Unknown device 1000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size 08
        Interrupt: pin A routed to IRQ 193
        Region 0: Memory at fe000000 (32-bit, non-prefetchable) [size=4M]
        Capabilities: [e0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=375mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) (prog-if 00 [VGA])
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min), Cache Line Size 08
        Interrupt: pin A routed to IRQ 50
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: I/O ports at 1000 [size=256]
        Region 2: Memory at fe6f0000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at fe6c0000 [disabled] [size=128K]
        Capabilities: [5c] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 20 [IO(X)-APIC])
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at febe0000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [50] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=0
                Status: Bus=2 Dev=28 Func=0 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

02:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 04) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size 08
        Bus: primary=02, secondary=04, subordinate=04, sec-latency=48
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: fea00000-feafffff
        Prefetchable memory behind bridge: 00000000fae00000-00000000fbd00000
        Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] PCI-X bridge device.
                Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=conv
                Status: Bus=2 Dev=29 Func=0 64bit+ 133MHz+ SCD- USC-, SCO-, SRD-
                : Upstream: Capacity=65535, Commitment Limit=65535
                : Downstream: Capacity=65535, Commitment Limit=65535

02:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 20 [IO(X)-APIC])
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at febf0000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [50] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=0
                Status: Bus=2 Dev=30 Func=0 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

02:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 04) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size 08
        Bus: primary=02, secondary=03, subordinate=03, sec-latency=64
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: fe700000-fe9fffff
        Prefetchable memory behind bridge: fffffffffff00000-0000000000000000
        Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] PCI-X bridge device.
                Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=100MHz
                Status: Bus=2 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, SCO-, SRD-
                : Upstream: Capacity=65535, Commitment Limit=65535
                : Downstream: Capacity=65535, Commitment Limit=65535

03:04.0 SCSI storage controller: Adaptec AIC-7902 U320 (rev 03)
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (10000ns min, 6250ns max), Cache Line Size 08
        Interrupt: pin A routed to IRQ 225
        Region 0: I/O ports at 2800 [size=256]
        Region 1: Memory at fe9e0000 (64-bit, non-prefetchable) [disabled] [size=8K]
        Region 3: I/O ports at 2c00 [size=256]
        Expansion ROM at fe880000 [disabled] [size=512K]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [94] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=4
                Status: Bus=3 Dev=4 Func=0 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=0, DMOST=4, DMCRS=1, RSCEM-

03:04.1 SCSI storage controller: Adaptec AIC-7902 U320 (rev 03)
        Subsystem: Intel Corporation: Unknown device 3424
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (10000ns min, 6250ns max), Cache Line Size 08
        Interrupt: pin B routed to IRQ 233
        Region 0: I/O ports at 2000 [size=256]
        Region 1: Memory at fe9f0000 (64-bit, non-prefetchable) [disabled] [size=8K]
        Region 3: I/O ports at 2400 [size=256]
        Expansion ROM at fe900000 [disabled] [size=512K]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [94] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=4
                Status: Bus=3 Dev=4 Func=1 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=0, DMOST=4, DMCRS=1, RSCEM-

04:02.0 RAID bus controller: 3ware Inc 9xxx-series SATA-RAID
        Subsystem: 3ware Inc 9xxx-series SATA-RAID
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2250ns min), Cache Line Size 08
        Interrupt: pin A routed to IRQ 201
        Region 0: I/O ports at 3000 [size=256]
        Region 1: Memory at feaf0000 (64-bit, non-prefetchable) [size=256]
        Region 3: Memory at fb000000 (64-bit, prefetchable) [size=8M]
        Expansion ROM at feae0000 [disabled] [size=64K]
        Capabilities: [40] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=0
                Status: Bus=255 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:05.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev 01)
        Subsystem: Intel Corporation SE7501HG2 Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (63750ns min), Cache Line Size 08
        Interrupt: pin A routed to IRQ 209
        Region 0: Memory at feaa0000 (64-bit, non-prefetchable) [size=128K]
        Region 4: I/O ports at 3440 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk+ DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [e4] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=0
                Status: Bus=0 Dev=0 Func=0 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=2, DMOST=0, DMCRS=1, RSCEM-
        Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000

04:05.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev 01)
        Subsystem: Intel Corporation SE7501HG2 Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (63750ns min), Cache Line Size 08
        Interrupt: pin B routed to IRQ 217
        Region 0: Memory at feac0000 (64-bit, non-prefetchable) [size=128K]
        Region 4: I/O ports at 3400 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk+ DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [e4] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=0
                Status: Bus=0 Dev=0 Func=1 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=2, DMOST=0, DMCRS=1, RSCEM-
        Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000

[root@dor bin]#

[7.6.] SCSI information (from /proc/scsi/scsi)

[root@dor bin]# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SONY     Model: SDT-11000        Rev: 0200
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: AMCC     Model: 9500S-8MI  DISK  Rev: 2.08
  Type:   Direct-Access                    ANSI SCSI revision: 03
[root@dor bin]#


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

[X.] Other notes, patches, fixes, workarounds:

This seems to fix the problem with no side effects:
echo 0 > /proc/sys/vm/oom-kill

Obviously - it's a better idea to hunt down the reason for the
unwarranted call rather than simply making the call do nothing...

At least one Internet posting I found through google suggested this
bug can be used by unprivileged users to kill random privileged
processes on a local machine, so there may be security implications if
this can be verified.



Kind Regards,
Chris Drake

