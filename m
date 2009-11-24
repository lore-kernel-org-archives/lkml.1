Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZKXESS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZKXESS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 23:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZKXESR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 23:18:17 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47947 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757922AbZKXESQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 23:18:16 -0500
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 23:18:16 EST
From: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Nov 2009 22:54:53 -0500
Subject: oops BUG: using smp_processor_id() in preemptible [00000000]
Thread-Topic: oops BUG: using smp_processor_id() in preemptible [00000000]
Thread-Index: AcpsueExh6bHGJCDRUCd+FQ2Xrrfhw==
Message-ID: <8C8865ED624BB94F8FE50259E2B5C5B304593DAB1D@palmail03.lsi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any ideas on hang reported below?

Release:
FC10 release, 2.6.31.6-rt19 #1 SMP PREEMPT RT Wed Nov 18 22:20:20 CST 2009 i686 i686 i386 GNU/Linux CPU core duo, T8400
First experienced problem in 2.6.29.6-rt23

Description:
The problem does not occur when running FC10 release without RT patch. I have three "threads" on the RT host A (affinity set to CPU0 
App is named smash.

Thread 1 (started using pthread, priority 49)
Start:
Set posix timer to expire in 5 msec
Output 128 packets (120 bytes each) to a single raw socket to Host B 
Go to start

Thread 2 (run from main, priority 37)
Start:
Epoll for a single event on raw socket
Read one packet from Host B
Go to Start

Thread 3 (started from pthread, priority 25) Print the rx and tx packet count

On other non-RT FC10 host B on network the same thread is running, so they are exchanging packets. Usually I can get 10 minutes to 4 hours, and then the RT system hangs. Converting Host A to non-rt allows me to run 24 hours or more (no failures recorded). 

Hang details:
1 The UI freezes. No keyboard or mouse. Graphics OK but screen freeze. 
2 Host B reports no data from Host A. When Host B is terminated and unplugged from network, the network card on Host A still blinks as if it is sending or receiving data. Unplugging Host A stops the blinking. Plugging A back in starts the blinking. I have waited up to 20 minutes or more and card still blinking.
3 It appears that if I stop Host B and wait long enough (10 - 15 minutes) Host A recovers enough to respond to ctl-c. However, if Host B continues to pound the interface with packets, Host A will revert back to a freeze state and becomes inoperable.
4 sysrq commands with serial console do not function when in the hang state.
5 Host B eventually starts reporting destination unreachables during Host A outage.

Frequency of Occurrence:
9/10 times within 10 - 15 minutes of start. Other times program can run for 2 -3 hours and seems as if user activity (top, or vi, eclipse, wireshark or just about anything) induces the freeze within a few seconds or minutes of activity. Have never been successful with overnight test.

Other bits of info:
>From program start to program start, the irq-net-rx is taking between 0% and 20% CPU. I can start the program and top report 50% CPU loading and net-rx at 20%. Kill the app restart and I get 1%/0% (in fact, net-rx never makes it to top of list). Kill the app and restart and I get 80%/10% and net-rx is pegged at top of list, etc, etc. 

When top reports CPU load at 1% and net-rx at 0%, this seems to give me my longest run time without crash (I don't think I've recorded one in this state), however it might take 20 starts or more to get into this state. So there is some sort of phase relationship. Whether or not the app is receiving data at time of program start doesn't seem to have any effect on the variance reported by top. Seems random.

Note: BUG message spews about 284 times a second... any ideas on disabling SMP at boot or other things to troubleshoot or workaround?

Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: smash/3062
Nov 23 17:24:15 localhost kernel: caller is __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted 2.6.31.6-rt19 #1
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
Nov 23 17:24:15 localhost kernel: [<c06dc70e>] __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: smash/3062
Nov 23 17:24:15 localhost kernel: caller is __schedule+0xe/0x7d4
Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted 2.6.31.6-rt19 #1
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
Nov 23 17:24:15 localhost kernel: [<c06dc689>] __schedule+0xe/0x7d4
Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: smash/3062
Nov 23 17:24:15 localhost kernel: caller is __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted 2.6.31.6-rt19 #1
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
Nov 23 17:24:15 localhost kernel: [<c06dc70e>] __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: smash/3062
Nov 23 17:24:15 localhost kernel: caller is __schedule+0xe/0x7d4
Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted 2.6.31.6-rt19 #1
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
Nov 23 17:24:15 localhost kernel: [<c06dc689>] __schedule+0xe/0x7d4
Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: smash/3062
Nov 23 17:24:15 localhost kernel: caller is __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted 2.6.31.6-rt19 #1
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
Nov 23 17:24:15 localhost kernel: [<c06dc70e>] __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: smash/3062
Nov 23 17:24:15 localhost kernel: caller is __schedule+0xe/0x7d4
Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted 2.6.31.6-rt19 #1
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
Nov 23 17:24:15 localhost kernel: [<c06dc689>] __schedule+0xe/0x7d4
Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: smash/3062
Nov 23 17:24:15 localhost kernel: caller is __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted 2.6.31.6-rt19 #1
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
Nov 23 17:24:15 localhost kernel: [<c06dc70e>] __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: INFO: task hald-addon-stor:2010 blocked for more than 120 seconds.
Nov 23 17:24:15 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 17:24:15 localhost kernel: hald-addon-st D ea88bc31     0  2010   1860 0x00000080
Nov 23 17:24:15 localhost kernel: f61d3a94 00000082 f6ae0500 ea88bc31 000007f9 00000008 f70d70d0 f6aa8000
Nov 23 17:24:15 localhost kernel: 00000000 f6aa8074 f61e8170 f61e83f8 c1fad200 00000001 f6aa8098 f6164a40
Nov 23 17:24:15 localhost kernel: f6aa9558 00000001 f61d3a78 00000246 00000000 f6aa9558 f72b8c40 c06dd89a
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c0452ac9>] ? rt_spin_lock_fastlock+0x27/0x5e
Nov 23 17:24:15 localhost kernel: [<c06dcfeb>] schedule+0xe/0x1f
Nov 23 17:24:15 localhost kernel: [<c06dd10c>] schedule_timeout+0x17/0xc1
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c0452ac9>] ? rt_spin_lock_fastlock+0x27/0x5e
Nov 23 17:24:15 localhost kernel: [<c06dc5c9>] wait_for_common+0x96/0xd4
Nov 23 17:24:15 localhost kernel: [<c042bcb0>] ? default_wake_function+0x0/0xf
Nov 23 17:24:15 localhost kernel: [<c06dc679>] wait_for_completion+0x12/0x14
Nov 23 17:24:15 localhost kernel: [<c05372c1>] blk_execute_rq+0x80/0x97
Nov 23 17:24:15 localhost kernel: [<c05371a0>] ? blk_end_sync_rq+0x0/0x28
Nov 23 17:24:15 localhost kernel: [<c053e7ad>] ? cfq_set_request+0x0/0x29b
Nov 23 17:24:15 localhost kernel: [<c052ce8f>] ? elv_set_request+0x17/0x26
Nov 23 17:24:15 localhost kernel: [<c05344c2>] ? get_request+0x1ab/0x287
Nov 23 17:24:15 localhost kernel: [<c0534a4b>] ? get_request_wait+0x18/0x157
Nov 23 17:24:15 localhost kernel: [<c05c74c5>] scsi_execute+0xcd/0x121
Nov 23 17:24:15 localhost kernel: [<c05c756e>] scsi_execute_req+0x55/0x7d
Nov 23 17:24:15 localhost kernel: [<c05d0827>] sr_test_unit_ready+0x41/0x9d
Nov 23 17:24:15 localhost kernel: [<c05d0a62>] sr_media_change+0x3e/0x1fb
Nov 23 17:24:15 localhost kernel: [<c04b3fad>] ? pollwake+0x0/0x63
Nov 23 17:24:15 localhost kernel: [<c05ea5e5>] media_changed+0x43/0x72
Nov 23 17:24:15 localhost kernel: [<c05ea640>] cdrom_media_changed+0x2c/0x32
Nov 23 17:24:15 localhost kernel: [<c05d08cc>] sr_block_media_changed+0x11/0x13
Nov 23 17:24:15 localhost kernel: [<c04c6703>] check_disk_change+0x19/0x42
Nov 23 17:24:15 localhost kernel: [<c05ee286>] cdrom_open+0x77f/0x7e1
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c0452ac9>] ? rt_spin_lock_fastlock+0x27/0x5e
Nov 23 17:24:15 localhost kernel: [<c0421b6f>] ? need_resched+0x14/0x1e
Nov 23 17:24:15 localhost kernel: [<c06dcff6>] ? schedule+0x19/0x1f
Nov 23 17:24:15 localhost kernel: [<c06dd10c>] ? schedule_timeout+0x17/0xc1
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c0452ac9>] ? rt_spin_lock_fastlock+0x27/0x5e
Nov 23 17:24:15 localhost kernel: [<c06dc5fd>] ? wait_for_common+0xca/0xd4
Nov 23 17:24:15 localhost kernel: [<c042bcb0>] ? default_wake_function+0x0/0xf
Nov 23 17:24:15 localhost kernel: [<c06dc679>] ? wait_for_completion+0x12/0x14
Nov 23 17:24:15 localhost kernel: [<c05372c1>] ? blk_execute_rq+0x80/0x97
Nov 23 17:24:15 localhost kernel: [<c05371a0>] ? blk_end_sync_rq+0x0/0x28
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c0452ac9>] ? rt_spin_lock_fastlock+0x27/0x5e
Nov 23 17:24:15 localhost kernel: [<c04a2b5e>] ? slab_irq_enable+0x4c/0x6d
Nov 23 17:24:15 localhost kernel: [<c04a2f8f>] ? kmem_cache_free+0x2a/0x73
Nov 23 17:24:15 localhost kernel: [<c05413dc>] ? kobject_get+0x12/0x17
Nov 23 17:24:15 localhost kernel: [<c0538f40>] ? get_disk+0xd0/0xe9
Nov 23 17:24:15 localhost kernel: [<c05413dc>] ? kobject_get+0x12/0x17
Nov 23 17:24:15 localhost kernel: [<c05b896f>] ? get_device+0x13/0x18
Nov 23 17:24:15 localhost kernel: [<c05c12d0>] ? scsi_device_get+0x20/0xdf
Nov 23 17:24:15 localhost kernel: [<c05d0a02>] sr_block_open+0x6d/0x82
Nov 23 17:24:15 localhost kernel: [<c04c726f>] __blkdev_get+0x89/0x2b9
Nov 23 17:24:15 localhost kernel: [<c04c74a9>] blkdev_get+0xa/0xc
Nov 23 17:24:15 localhost kernel: [<c04c7511>] blkdev_open+0x66/0x92
Nov 23 17:24:15 localhost kernel: [<c04a5f53>] __dentry_open+0x1c3/0x2bd
Nov 23 17:24:15 localhost kernel: [<c05109e1>] ? security_inode_permission+0x1e/0x20
Nov 23 17:24:15 localhost kernel: [<c04a60e7>] nameidata_to_filp+0x2c/0x43
Nov 23 17:24:15 localhost kernel: [<c04c74ab>] ? blkdev_open+0x0/0x92
Nov 23 17:24:15 localhost kernel: [<c04b0521>] do_filp_open+0x3ed/0x756
Nov 23 17:24:15 localhost kernel: [<c05eb452>] ? cdrom_release+0x16c/0x19f
Nov 23 17:24:15 localhost kernel: [<c05412f6>] ? kobject_put+0x37/0x3c
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c06dd89a>] ? rt_spin_lock_slowlock+0x0/0x1b3
Nov 23 17:24:15 localhost kernel: [<c0452ac9>] ? rt_spin_lock_fastlock+0x27/0x5e
Nov 23 17:24:15 localhost kernel: [<c04b8848>] ? alloc_fd+0xc8/0xd2
Nov 23 17:24:15 localhost kernel: [<c04a5c99>] do_sys_open+0x4a/0xe2
Nov 23 17:24:15 localhost kernel: [<c04a5d73>] sys_open+0x1e/0x26
Nov 23 17:24:15 localhost kernel: [<c040320c>] sysenter_do_call+0x12/0x28
