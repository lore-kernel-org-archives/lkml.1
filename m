Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbYFDSHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbYFDSHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYFDSHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:07:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47991 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYFDSHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:07:36 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5310"; a="3678240"
Message-ID: <4846D9FE.4030804@qualcomm.com>
Date: Wed, 04 Jun 2008 11:07:58 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com
Subject: Stop machine threads are getting preemted by the rt period enforcement
References: <20080601213019.14ea8ef8.pj@sgi.com> <20080602164203.GA2477@sgi.com> <48443E66.6060205@qualcomm.com> <20080602214151.GA7072@sgi.com> <48446D46.2010903@qualcomm.com> <20080603144010.GA25948@sgi.com> <20080604140036.GC18993@sgi.com>
In-Reply-To: <20080604140036.GC18993@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Ingo,

Take a look at the report below (came up during isolcpu= remove discussions).

It looks like stop_machine threads are getting forcefully preempted because
they exceed their RT quanta. It's strange because rt period is pretty long.
But given that disabling rt period logic solves the issue the machine was not
really stuck.

Max




Dimitri Sivanich wrote:
> On Tue, Jun 03, 2008 at 09:40:10AM -0500, Dimitri Sivanich wrote:
>> I tried the following scenario on an ia64 Altix running 2.6.26-rc4 with cpusets compiled in but cpuset fs unmounted.  Do your patches already address this?
>>
>> $ taskset -cp 3 $$   (attach to cpu 3)
>> pid 4591's current affinity list: 0-3
>> pid 4591's new affinity list: 3
>> $ echo 0 > /sys/devices/system/cpu/cpu2/online  (down cpu 2)
>>   (above command hangs)
>>
>> Backtrace of pid 4591 (bash)
>>
>> Call Trace:
>>  [<a00000010078e990>] schedule+0x1210/0x13c0
>>                                 sp=e0000060b6dffc90 bsp=e0000060b6df11e0
>>  [<a00000010078ef60>] schedule_timeout+0x40/0x180
>>                                 sp=e0000060b6dffce0 bsp=e0000060b6df11b0
>>  [<a00000010078d3e0>] wait_for_common+0x240/0x3c0
>>                                 sp=e0000060b6dffd10 bsp=e0000060b6df1180
>>  [<a00000010078d760>] wait_for_completion+0x40/0x60
>>                                 sp=e0000060b6dffd40 bsp=e0000060b6df1160
>>  [<a000000100114ee0>] __stop_machine_run+0x120/0x160
>>                                 sp=e0000060b6dffd40 bsp=e0000060b6df1120
>>  [<a000000100765ae0>] _cpu_down+0x2a0/0x600
>>                                 sp=e0000060b6dffd80 bsp=e0000060b6df10c8
>>  [<a000000100765ea0>] cpu_down+0x60/0xa0
>>                                 sp=e0000060b6dffe20 bsp=e0000060b6df10a0
>>  [<a000000100768090>] store_online+0x50/0xe0
>>                                 sp=e0000060b6dffe20 bsp=e0000060b6df1070
>>  [<a0000001004f8800>] sysdev_store+0x60/0xa0
>>                                 sp=e0000060b6dffe20 bsp=e0000060b6df1038
>>  [<a00000010022e370>] sysfs_write_file+0x250/0x300
>>                                 sp=e0000060b6dffe20 bsp=e0000060b6df0fe0
>>  [<a00000010018a750>] vfs_write+0x1b0/0x300
>>                                 sp=e0000060b6dffe20 bsp=e0000060b6df0f90
>>  [<a00000010018b350>] sys_write+0x70/0xe0
>>                                 sp=e0000060b6dffe20 bsp=e0000060b6df0f18
>>  [<a00000010000af80>] ia64_ret_from_syscall+0x0/0x20
>>                                 sp=e0000060b6dffe30 bsp=e0000060b6df0f18
>>  [<a000000000010720>] ia64_ivt+0xffffffff00010720/0x400
>>                                 sp=e0000060b6e00000 bsp=e0000060b6df0f18
> 
> The following workaround alleviates the symptom and hopefully is a hint as to the solution:
> 	echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
