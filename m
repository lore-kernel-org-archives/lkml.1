Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbZKKAIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbZKKAIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbZKKAIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:08:10 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38829 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717AbZKKAIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:08:04 -0500
MIME-Version: 1.0
Date: Wed, 11 Nov 2009 01:08:07 +0100
Message-ID: <40e92d5b0911101608t4baf75bo83c5780f24761781@mail.gmail.com>
Subject: SATA NCQ - blessing for throughput, curse for latency?
From: =?UTF-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Native Command Queuing is in short about maximizing disk performance
and minimizing head movement by optimizing the order of commands
execution. So it's rather natural thinking that using it is better
than having it turned off. Does this apply to desktop users? I am not
sure. Recently after buying PCI-E controller based on JMB363 I had
first opportunity to test NCQ. (My KN9 motherboard has CK804 SATA
controller, sata_nv has disabled NCQ by default because it's unstable
on certain configurations and I didn't want to risk losing data by
enforcing using NCQ.) Two weeks before I bought WD3200BJKT and
installed Linux on it. When I have switched to JMB363 using AHCI I
noticed (not immediately) that under some kinds of heavy disk usage my
system slowed down, i.e. wasn't as responsive as it used to be. To be
sure that this is not only my feeling I wanted to create simple
test/tool that could measure it. So I wrote a script (that is pasted
at the end), which using zcav from bonnie++ (and unbuffer from expect
to work properly if output is redirected to a file) reads up to 64 GB
of the disk, but after a first few gigabytes (depending on how many GB
of memory you have) cats kernel sources with binary files up to the
second level of directory depth. What is measured? The real time of
the cat to /dev/null operation. Why not the kernel sources alone?
Because if we build kernel, especially with -jX (where X > 1), then
both inodes and contents of the corresponding files within these
directories generally won't be consecutive. Time for the results with
some background information. In my tests I have used 2.6.31.5 built
with debuginfo (using debian's make-kpkg).


*** NCQ turned on ***

kernel:     2.6.31.5+kp+di+tp+fts+pc+lt x86_64
model name: AMD Athlon(tm) 64 X2 Dual Core Processor 4600+
model name: AMD Athlon(tm) 64 X2 Dual Core Processor 4600+
mem total:  4057476 kB

dmesg:
[    3.853766] ahci 0000:04:00.0: version 3.0
[    3.853999] ahci 0000:04:00.0: PCI INT A -> Link[APC4] -> GSI 19
(level, low) -> IRQ 19
[    3.869033] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    3.869036] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum part
[    3.869041] ahci 0000:04:00.0: setting latency timer to 64
[    3.869402] scsi1 : ahci
[    4.821110] scsi 1:0:0:0: Direct-Access     ATA      WDC
WD3200BJKT-0 11.0 PQ: 0 ANSI: 5
[    4.821373] sd 1:0:0:0: [sda] 625142448 512-byte logical blocks:
(320 GB/298 GiB)
[    4.821413] sd 1:0:0:0: [sda] Write Protect is off
[    4.821415] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.821434] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.865318] sd 1:0:0:0: [sda] Attached SCSI disk

lspci:
04:00.0 SATA controller: JMicron Technologies, Inc. JMicron
20360/20363 AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at fd9fe000 (32-bit, non-prefetchable) [size=8K]
	[virtual] Expansion ROM at fd800000 [disabled] [size=64K]
	Capabilities: [68] Power Management version 2
	Capabilities: [50] Express Legacy Endpoint, MSI 01
	Kernel driver in use: ahci


/sys/block/sda/device:
device_blocked:0		rev:11.0
evt_media_change:0		scsi_level:6
iocounterbits:32		state:running
iodone_cnt:0x6b3		timeout:30
ioerr_cnt:0x1			type:0
iorequest_cnt:0x6b4		uevent:DEVTYPE=scsi_device
modalias:scsi:t-0x00		uevent:DRIVER=sd
model:WDC WD3200BJKT-0		uevent:MODALIAS=scsi:t-0x00
queue_depth:31			unload_heads:0
queue_type:simple		vendor:ATA

/sys/block/sda/queue:
hw_sector_size:512	minimum_io_size:512	read_ahead_kb:128
iostats:1		nomerges:0		rotational:1
logical_block_size:512	nr_requests:128		rq_affinity:0
max_hw_sectors_kb:32767	optimal_io_size:0	sched:cfq
max_sectors_kb:512	physical_block_size:512

Test will start in 3 seconds...
#loops: 1, version: 1.03d
#block offset (GiB), MiB/s, time
0.00 82.33 12.438
1.00 82.30 12.442
2.00 82.39 12.428
3.00 82.30 12.442
4.00 82.44 12.421
Concurrent read will start in 1 second...
5.00 80.90 12.658
6.00 80.73 12.685
7.00 81.41 12.578
8.00 80.52 12.718
9.00 80.94 12.652
10.00 81.01 12.641
11.00 81.00 12.641
12.00 81.09 12.628
13.00 80.84 12.667
14.00 80.80 12.673
15.00 80.82 12.671
16.00 80.83 12.669
17.00 81.03 12.637
18.00 81.19 12.613
19.00 79.67 12.853
20.00 76.96 13.305
21.00 73.04 14.019
22.00 65.26 15.692
23.00 66.19 15.470
24.00 79.64 12.857
25.00 79.08 12.949
26.00 79.12 12.943
27.00 79.25 12.921
28.00 79.41 12.895
29.00 79.49 12.882
30.00 79.39 12.898
31.00 79.46 12.887
32.00 79.51 12.879
33.00 57.12 17.927
34.00 68.89 14.864
35.00 74.66 13.715
36.00 76.25 13.430
37.00 74.95 13.662
38.00 79.58 12.867
39.00 78.25 13.087
40.00 57.34 17.859
41.00 67.58 15.153
42.00 77.62 13.192
43.00 77.97 13.134
44.00 77.90 13.145
45.00 77.46 13.220
46.00 77.93 13.141
47.00 77.78 13.166
48.00 77.68 13.182
49.00 68.44 14.962
50.00 71.85 14.251
51.00 53.44 19.163
52.00 76.67 13.356
53.00 77.24 13.257
54.00 77.48 13.216
55.00 77.23 13.259
56.00 76.45 13.394
57.00 76.42 13.400
58.00 76.57 13.373
59.00 75.82 13.506
60.00 67.59 15.149
real 752.30
user 0.20
sys 1.83
61.00 74.75 13.698


*** NCQ turned off *** (kernel booted with noncq parameter)

[cut]

/sys/block/sda/device:
device_blocked:0		rev:11.0
evt_media_change:0		scsi_level:6
iocounterbits:32		state:running
iodone_cnt:0x6a9		timeout:30
ioerr_cnt:0x1			type:0
iorequest_cnt:0x6aa		uevent:DEVTYPE=scsi_device
modalias:scsi:t-0x00		uevent:DRIVER=sd
model:WDC WD3200BJKT-0		uevent:MODALIAS=scsi:t-0x00
queue_depth:1			unload_heads:0
queue_type:none			vendor:ATA

/sys/block/sda/queue:
hw_sector_size:512	minimum_io_size:512	read_ahead_kb:128
iostats:1		nomerges:0		rotational:1
logical_block_size:512	nr_requests:128		rq_affinity:0
max_hw_sectors_kb:32767	optimal_io_size:0	sched:cfq
max_sectors_kb:512	physical_block_size:512

Test will start in 3 seconds...
#loops: 1, version: 1.03d
#block offset (GiB), MiB/s, time
0.00 82.32 12.439
1.00 82.30 12.442
2.00 82.39 12.429
3.00 82.25 12.450
4.00 82.44 12.421
Concurrent read will start in 1 second...
5.00 38.53 26.579
6.00 38.38 26.680
real 62.30
user 0.27
sys 1.59
7.00 57.12 17.928


The difference is substantial. After seeing this I replaced my main hd
in notebook to test the same disk with other NCQ-compliant controller:
82801HBM/HEM (ICH8M/ICH8M-E). Results are almost the same so I omitted
including them here, because it would be superfluous and make this
mail even less clear. One more note. Before my script took the current
shape I found out that in similar workload anticipatory scheduler
behaves better than cfq if NCQ is used, but still worse than without
NCQ.

Can anyone confirm analogous NCQ-dependant behavior with other
disk/controller variants? Any suggestions for improvements other than
turning off NCQ or switching to anticipatory (in typical cases cfq is
better, so it's not the best option)?

Thanks.

PS. Please CC to me.

-- 
Przemysław Pawełczyk


#!/bin/bash

# Copyright (C) 2009 Przemyslaw Pawelczyk <przemyslaw@pawelczyk.it>

# Concurrent read tester
#
# Usage:
# concread.sh <path/to/kernel/source> [sdX]

KDIR="$1"
if [ -z "$KDIR" ]; then
	KDIR="/lib/modules/`uname -r`/source"
	KDIR="`stat -c '%N' "$KDIR" 2>/dev/null | sed 's/.*-> \`//;s/.$//'`"
fi
if ! [ -f "$KDIR/vmlinux.o" ]; then
	echo "incorrect path to kernel source"
	exit 1
fi
DISK="$2"
if [ -z "$DISK" ]; then
	DISK="`df -P "$KDIR" 2>/dev/null | awk 'NR==2{print $1}'`";
fi
DISK="${DISK##/dev/}"
DISK="${DISK%%[0-9]*}"
if ! [ -b "/dev/$DISK" ]; then
	echo "incorrect block filename"
	exit 1
fi

MEM_TOTAL=`cat /proc/meminfo | awk '{print $2; exit}'`
GB=$(( ( (MEM_TOTAL / 1024) + 1023) / 1024 ))
ERE='^('$(( GB ))'.00|'$(( GB * 1024 ))')'
ID=`dmesg | sed "/\[$DISK\]/!d;/\<sd\>/!d;s/^.* sd //;s/:.*//;q"`
DRV=`dmesg | sed "/^\[[0-9\. ]*\] scsi$ID : /!d;s///;q"`
HW="`dmesg | sed "/^\[[0-9\. ]*\] $DRV [0-9]\{4\}:/!d;s///;s/: .*//" | uniq`"
FILES='`find '"$KDIR"' -maxdepth 2 -type f`'
CMD="cat $FILES &>/dev/null"
SLP=20

echo "kernel:     `uname -r -m`"
cat /proc/cpuinfo | awk -F': ' '/model name/{print "model name:", $2}'
cat /proc/meminfo | awk 'NR==1{print "mem total: ",$2,$3}'
echo -e "\ndmesg:"
if [ -n "$DRV" ]; then dmesg | egrep " $DRV [0-9]{4}"; fi
if [ -n "$ID" ]; then dmesg | egrep " (scsi|sd) ?$ID"; fi
echo -e "\nlspci:"
for I in $HW; do lspci -v -s $I; done
for I in /sys/block/$DISK/device /sys/block/$DISK/queue; do
	echo -e "\n$I:"
	( cd $I && grep . * 2>/dev/null ) | \
	sed '/^scheduler:/s/uler:[^[]*\[/:/;s/\].*//' | COLUMNS=80 column
done
echo -e "\nTest will start in 3 seconds..."
sleep 3
unbuffer zcav -b 1024 -n 65536 /dev/$DISK | gawk "{print;fflush()}\
/$ERE/{print \"Concurrent read will start in 1 second...\";fflush();\
system(\"( sleep 1;time -p ( $CMD );sleep $SLP;kill -TERM -$$ ) 2>&1 & \");}"
