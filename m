Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbZGFIGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbZGFIGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZGFIGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:06:04 -0400
Received: from mga10.intel.com ([192.55.52.92]:3796 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756645AbZGFIF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:05:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,355,1243839600"; 
   d="scan'208";a="472244362"
Subject: [BUG] Deadlock between cpufreq kondemand and process cpuspeed
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pallipadi@vger.kernel.org, Venkatesh <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 06 Jul 2009 16:06:23 +0800
Message-Id: <1246867583.2560.526.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I run a series of testing against 2.6.31-rc2 on my Tulsa x8664 machine,
kernel reports a block issue. Below is the log.


kondemand/3   D ffffffff81029ff9     0  1474      2 0x00000000
 ffff88027ccb8650 0000000000000046 0000000000000000 0000000000000000
 ffff88027ed51310 ffff88027ccb88e0 00000000ffff0b68 0000000000000000
 0000000000000000 ffffffff81029b34 0000000000000000 0000000100000000
Call Trace:
 [<ffffffff81029b34>] ? clear_buddies+0x15/0x23
 [<ffffffff8130734c>] ? do_dbs_timer+0x0/0x272
 [<ffffffff813cfa94>] ? __down_write_nested+0x79/0x93
 [<ffffffff81305ab7>] ? lock_policy_rwsem_write+0x3e/0x6a
 [<ffffffff813073a9>] ? do_dbs_timer+0x5d/0x272
 [<ffffffff8130734c>] ? do_dbs_timer+0x0/0x272
 [<ffffffff81049c77>] ? worker_thread+0x15b/0x1f5
 [<ffffffff8104cd0a>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81049b1c>] ? worker_thread+0x0/0x1f5
 [<ffffffff8104cbfd>] ? kthread+0x84/0x8f
 [<ffffffff81048178>] ? __call_usermodehelper+0x0/0x66
 [<ffffffff8100bcfa>] ? child_rip+0xa/0x20
 [<ffffffff8104cb79>] ? kthread+0x0/0x8f
 [<ffffffff8100bcf0>] ? child_rip+0x0/0x20
INFO: task cpuspeed:4445 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
cpuspeed      D ffffffff81029ff9     0  4445   4370 0x00000000
 ffff88027ceff910 0000000000000086 0000000000000000 000280da00000010
 ffff88027eea3850 ffff88027ceffba0 00000000ffff0b49 00000000280c3300
 0000000000000005 ffffffff8102f3b8 0000000000000000 0000000100000000
Call Trace:
 [<ffffffff8102f3b8>] ? find_busiest_group+0x1e6/0x831
 [<ffffffff813ce952>] ? schedule_timeout+0x23/0x161
 [<ffffffff8107ebbc>] ? get_page_from_freelist+0x414/0x58b
 [<ffffffff8118d7f8>] ? number+0x118/0x204
 [<ffffffff813ce804>] ? wait_for_common+0xb8/0x11e
 [<ffffffff81031ebe>] ? default_wake_function+0x0/0x9
 [<ffffffff8102ba4d>] ? __wake_up+0x30/0x44
 [<ffffffff810491de>] ? __cancel_work_timer+0x107/0x160
 [<ffffffff8118d9d2>] ? vsscanf+0xee/0x657
 [<ffffffff81048e80>] ? wq_barrier_func+0x0/0x9
 [<ffffffff813077ef>] ? cpufreq_governor_dbs+0x231/0x29d
 [<ffffffff8118cc23>] ? __up_read+0x13/0x8a
 [<ffffffff81304f0c>] ? __cpufreq_governor+0x98/0xcf
 [<ffffffff813050af>] ? __cpufreq_set_policy+0x16c/0x1fb
 [<ffffffff81305638>] ? store_scaling_governor+0x170/0x1b9
 [<ffffffff81305bdf>] ? handle_update+0x0/0x28
 [<ffffffff813062b5>] ? store+0x4d/0x6c
 [<ffffffff810ec748>] ? sysfs_write_file+0xd2/0x110
 [<ffffffff810a84ce>] ? vfs_write+0xad/0x149
 [<ffffffff810a8a16>] ? sys_write+0x45/0x6e
 [<ffffffff8100ad6b>] ? system_call_fastpath+0x16/0x1b


As a matter of fact, it's triggerred by "/bin/sh /etc/init.d/cpuspeed stop".

Consider below call chain of process cpuspeed:
store (get lock by lock_policy_rwsem_write) =>
	﻿store_scaling_governor =>
		﻿__cpufreq_set_policy =>
			﻿__cpufreq_governor =>
				﻿cpufreq_governor_dbs =>
					dbs_timer_exit =>
						cancel_delayed_work_sync =>
							wait_on_cpu_work
go to sleep.

While thread kondemand is trying to execute the work at do_dbs_timer and
sleep at lock_policy_rwsem_write, because ﻿cpuspeed got the lock and is
sleeping now.

The race is cpuspeed get the lock firstly, and kondemand sleeps on the lock
when trying to process the work. But cpuspeed waits for the work completion.

It seems b14893a62c73af0eca414cfed505b8c09efc613c causes it.

yanmin


