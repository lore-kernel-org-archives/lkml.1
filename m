Return-Path: <linux-kernel-owner+w=401wt.eu-S936584AbYGCHOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936584AbYGCHOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYGCG6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64686 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbYGCGhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 02:37:47 -0400
Message-ID: <486C7349.9010707@cn.fujitsu.com>
Date: Thu, 03 Jul 2008 14:35:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] hotplug_cpu vs no_hz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config:
CONFIG_DETECT_SOFTLOCKUP=y  # just for call trace
CONFIG_HOTPLUG_CPU=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_NO_HZ=y		# if =n, this 2 bugs can't occur


this 2 bugs occur on 2kernel_vr * 2platform
platform :	i386 2cpus
		x86_64 2core*2cpus

kernel_vr:	2.6.25
		2.6.26-rc8

test 1:(cpu dies)
offline the other cpus, just left cpu#0 cpu#1, and:

i=0
while ((++i))
do
	echo 0 > /sys/devices/system/cpu/cpu1/online
	sleep 1
	echo 1 > /sys/devices/system/cpu/cpu1/online
	sleep 1
	echo $i
done

after several seconds ~ several hours, "echo 1 > /sys/devices/system/cpu/cpu1/online"
was blocked, cpu#1 can not be used and the output of dmesg:

BUG: soft lockup - CPU#1 stuck for 61s! [events/1:9898]
CPU 1:
Modules linked in:
Pid: 9898, comm: events/1 Not tainted 2.6.26-rc8-official-LAI-00089-ge1441b9 #5
RIP: 0010:[<ffffffff80237612>]  [<ffffffff80237612>] __do_softirq+0x4b/0xc7
RSP: 0018:ffff81006b42ff20  EFLAGS: 00000206
RAX: ffff81006a9b9fd8 RBX: ffff81006b42ff40 RCX: 0000000000000006
RDX: 0000000000000042 RSI: ffffffff8022da16 RDI: ffffffff8022da16
RBP: ffff81006b42fea0 R08: ffff81007f2c9178 R09: ffff81007f2c9140
R10: ffff8100807cc000 R11: 0000000000000000 R12: ffffffff8020be36
R13: ffff81006b42fea0 R14: ffffffff807a5100 R15: 0000000000000042
FS:  0000000000000000(0000) GS:ffff81007fb3ccc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f4cc97b6000 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 <IRQ>  [<ffffffff8020c38c>] ? call_softirq+0x1c/0x28
 [<ffffffff8020dad6>] ? do_softirq+0x34/0x72
 [<ffffffff80237586>] ? irq_exit+0x3f/0x80
 [<ffffffff8021b128>] ? smp_apic_timer_interrupt+0x8b/0xa7
 [<ffffffff8020be36>] ? apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8022da16>] ? finish_task_switch+0x31/0x82
 [<ffffffff80590e7d>] ? thread_return+0x3d/0x9c
 [<ffffffff80241ca1>] ? worker_thread+0xa3/0xe5
 [<ffffffff80244780>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff80241bfe>] ? worker_thread+0x0/0xe5
 [<ffffffff80244645>] ? kthread+0x49/0x78
 [<ffffffff8020c018>] ? child_rip+0xa/0x12
 [<ffffffff802445fc>] ? kthread+0x0/0x78
 [<ffffffff8020c00e>] ? child_rip+0x0/0x12

INFO: task syslogd:3835 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syslogd       D ffffffff805af600     0  3835      1
 ffff81007b80fd28 0000000000000082 0000000000000000 ffff81007dd83ec0
 ffff81007f01a820 ffff81007fbb1560 ffff81007f01ab78 0000000100000001
 00000000ffffffff 0000000000000292 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8030f58f>] log_wait_commit+0xa4/0xf4
 [<ffffffff80244780>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8030b1e7>] journal_stop+0x17c/0x1a9
 [<ffffffff8030ba16>] journal_force_commit+0x23/0x25
 [<ffffffff803049d0>] ext3_force_commit+0x26/0x28
 [<ffffffff802fed64>] ext3_write_inode+0x39/0x3f
 [<ffffffff802ad9ad>] __writeback_single_inode+0x180/0x29f
 [<ffffffff802ae353>] sync_inode+0x24/0x31
 [<ffffffff802fb2ff>] ext3_sync_file+0xa3/0xb4
 [<ffffffff802b08f7>] do_fsync+0x54/0xaa
 [<ffffffff802b097b>] __do_fsync+0x2e/0x44
 [<ffffffff802b09ac>] sys_fsync+0xb/0xd
 [<ffffffff8020b1fb>] system_call_after_swapgs+0x7b/0x80



test 2:(time-subsystem was broken)
offline the other cpus, just left cpu0#0 cpu#1, and:

try several times: {
	echo 0 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu1/online
	cat /dev/zero > /dev/null &
	taskset -p 2 $!		# set affinity to cpu#1

	top	# get cpu usage of "cat /dev/zero"
		# if cpu usage=0%, bug of test 1 have occurred
		# stop test

		# if cpu usage>150%, time-subsystem was broken
		# offline/online again, "top" shows huger cpu usage

		# nothing happen, kill "cat /dev/zero" and try again
}

