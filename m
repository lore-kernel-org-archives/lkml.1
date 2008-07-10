Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYGJMBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYGJMBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYGJMA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:00:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:27051 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYGJMA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Bbb0Ydar3PcJ0PGPqNPfR6YYMwAD7Txjg9wqpATCHJa/nSvO8Jmh0Adc8D9wXfyKFr
         nnYb3t5/9QNysTAvSY3LZHEk4SF7G2iDSgUurJu0NZ2d+Y1d2tmU6ztW4i7HCoKRYaOO
         8AYvKc0ixkGRaInSsnToIfqYUjg3xirIQSxEw=
Date: Thu, 10 Jul 2008 13:59:55 +0200
To: Yanmin <yanmin_zhang@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>, miaox@cn.fujitsu.com,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
Subject: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Message-ID: <20080710115954.GA3639@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks like CPU hotplug still has some problems. Just got this on
latest mainline, and I couldn't find the exact same report on LKML
or kerneloops, maybe it can be helpful for debugging the existing
problem(s)?

lockdep: fixing up alternatives.
------------[ cut here ]------------
kernel BUG at kernel/sched.c:5858!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 3934, comm: bash Not tainted (2.6.26-rc9-00057-g60d678c #3)
EIP: 0060:[<c057f7c5>] EFLAGS: 00210046 CPU: 0
EIP is at migration_call+0x495/0x4d0
EAX: 00000000 EBX: c0803f00 ECX: f6bd0000 EDX: 017b0000
ESI: e7d24fb0 EDI: c1fb3f00 EBP: f62e7e78 ESP: f62e7e48
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process bash (pid: 3934, ti=f62e6000 task=f60fbfc0 task.ti=f62e6000)
Stack: 00000000 c06ddf70 f62e7e6c 00200246 c0803f00 00000001 c1fb3f00 f62e7e6c 
       c0581fcf c074ec70 ffffffff 00000000 f62e7e98 c014d5a7 00000001 00000007 
       c074ecf4 ffffffff 00000001 e7c86f90 f62e7eac c014d619 ffffffff 00000000 
Call Trace:
 [<c0581fcf>] ? preempt_schedule+0x3f/0x50
 [<c014d5a7>] ? notifier_call_chain+0x37/0x70
 [<c014d619>] ? __raw_notifier_call_chain+0x19/0x20
 [<c014d63a>] ? raw_notifier_call_chain+0x1a/0x20
 [<c055ff68>] ? _cpu_down+0x148/0x240
 [<c015da8f>] ? cpu_maps_update_begin+0xf/0x20
 [<c056008b>] ? cpu_down+0x2b/0x40
 [<c05612a9>] ? store_online+0x39/0x80
 [<c0561270>] ? store_online+0x0/0x80
 [<c02fba7b>] ? sysdev_store+0x2b/0x40
 [<c01dd0f2>] ? sysfs_write_file+0xa2/0x100
 [<c019ed76>] ? vfs_write+0x96/0x130
 [<c01dd050>] ? sysfs_write_file+0x0/0x100
 [<c019f43d>] ? sys_write+0x3d/0x70
 [<c0104ceb>] ? sysenter_past_esp+0x78/0xd1
 =======================
Code: 45 e8 e8 2f 53 00 00 b8 01 00 00 00 e9 a2 fb ff ff bb 60 36 59 c0 eb 02 8b
 1b 89 f8 ff 53 18 85 c0 89 c6 74 f3 90 e9 89 fe ff ff <0f> 0b eb fe 8d b4 26 00
 00 00 00 e8 8b 82 bd ff 89 f0 50 9d 0f 
EIP: [<c057f7c5>] migration_call+0x495/0x4d0 SS:ESP 0068:f62e7e48


Oh, I just saw

commit dc7fab8b3bb388c57c6c4a43ba68c8a32ca25204
Author: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date:   Thu Jul 10 00:32:40 2008 +0200

   sched: fix cpu hotplug

will apply and retry. Is this likely to fix the oops I saw, though?


Vegard


$ grep SCHED .config
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_HRTICK=y
# CONFIG_NET_SCHED is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
