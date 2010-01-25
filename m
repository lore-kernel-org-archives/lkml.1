Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397Ab0AYNWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0AYNWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 08:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786Ab0AYNWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 08:22:40 -0500
Received: from borg.medozas.de ([188.40.89.202]:40417 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab0AYNWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:22:40 -0500
Date: Mon, 25 Jan 2010 14:22:39 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd continuously active
In-Reply-To: <20100125130627.GO13771@kernel.dk>
Message-ID: <alpine.LSU.2.01.1001251416340.8189@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1001230037350.20442@obet.zrqbmnf.qr> <20100125130627.GO13771@kernel.dk>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-01-25 14:06, Jens Axboe wrote:
>> 
>> with 2.6.32.2 on sparc64 I am seeing that there is a sync(1) process 
>> busy in D state, with the following trace:
>> 
>> sync          D 000000000079299c  7552  4851      1 0x208061101000004
>> Call Trace:
>>  [000000000053ca58] bdi_sched_wait+0xc/0x1c
>>  [000000000079299c] __wait_on_bit+0x58/0xb8
>>  [0000000000792a5c] out_of_line_wait_on_bit+0x60/0x74
>>  [000000000053ca3c] bdi_sync_writeback+0x6c/0x7c
>>  [000000000053ca78] sync_inodes_sb+0x10/0xfc
>>  [0000000000540dd0] __sync_filesystem+0x50/0x88
>>  [0000000000540ec8] sync_filesystems+0xc0/0x124
>>  [0000000000540f80] sys_sync+0x1c/0x48
>>  [0000000000406294] linux_sparc_syscall+0x34/0x44
>> 
>> kswapd is also active all the time, writing something to disk - LED is 
>> blinking, and that's been going on for over half an hour despite the box 
>> being not busy. How do I see what kswapd is still flushing to disk? Even 
>> if all RAM (8 GB) was filled with dirty data, syncing it out would not 
>> take that long - that is to say, the sync process should have long 
>> exited.
>
>That doesn't sound good. What does /proc/meminfo say? What file systems
>are you using?

Eventually that day, the sync finished; not sure what triggered that.
Usually, meminfo looks like when the box is doing something:

14:08 ares:~ > cat /proc/meminfo 
MemTotal:        8166752 kB
MemFree:         3243552 kB
Buffers:          207968 kB
Cached:          2728216 kB
SwapCached:            0 kB
Active:          2203136 kB
Inactive:        2152544 kB
Active(anon):    1167256 kB
Inactive(anon):   252952 kB
Active(file):    1035880 kB
Inactive(file):  1899592 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:            141624 kB
Writeback:             0 kB
AnonPages:       1421448 kB
Mapped:            49904 kB
Shmem:               680 kB
Slab:             429784 kB
SReclaimable:     315760 kB
SUnreclaim:       114024 kB
KernelStack:        9248 kB
PageTables:         6120 kB
Quicklists:        10560 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4083376 kB
Committed_AS:    1626280 kB
VmallocTotal:   1069547520 kB
VmallocUsed:       28816 kB
VmallocChunk:   1069518664 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
14:16 ares:~ > w
 14:17:13 up  6:26,  2 users,  load average: 21.09, 24.41, 22.49

This is used as a compile box, and there are lots of files created
and deleted when there is work - a new chroot for every package
basically, with a total of about 300K such "floating" files.
Filesystem is ext4.

/dev/sda4 / ext4 rw,relatime,barrier=1,data=ordered 0 0

Now that I see barrier=1, maybe I should turn that off in the future
like I did with XFS around 2.6.17[1].

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0605.2/1110.html
