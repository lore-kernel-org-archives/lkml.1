Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYFQVuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYFQVuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbYFQVu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:50:28 -0400
Received: from in.cluded.net ([195.159.98.120]:55941 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809AbYFQVu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:50:27 -0400
X-OS: [Linux] 2.6.8 and newer (?)
Message-ID: <48583122.7080409@uw.no>
Date: Tue, 17 Jun 2008 21:48:18 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [BUG: NULL pointer dereference] cgroups and	RT scheduling interact
 badly.
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>	 <4856671B.1020304@uw.no>  <1213624312.16944.104.camel@twins>	 <1213627148.16944.106.camel@twins>  <485682B0.8010805@uw.no>	 <1213629536.16944.109.camel@twins> <1213692557.16944.153.camel@twins>	 <4857AD38.2090601@uw.no> <1213732878.3223.95.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1213732878.3223.95.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-06-17 at 14:25 +0200, Daniel K. wrote:
>> Peter Zijlstra wrote:
>>> How's this [patch] work for you? (includes the previuos patchlet too)
>> Thanks,
>>
>> this patch fixed the obvious problem, namely
>>
>> # echo $$ > /dev/cgroup/burn/oops/tasks
>> # schedtool -R -p 1 -e burnP6 &
>>
>> now works again. However, the last step below
>>
>> # echo $$ > /dev/cgroup/tasks
>> # burnP6 &
>> [1] 3414
>> # echo 3414 > /dev/cgroup/burn/oops/tasks
>> # schedtool -R -p 1 3414
>>
>> gives this new and shiny Oops instead.
> 
> Whilst I'm gracious for your testing, I truly hope you're done breaking
> my stuff ;-)
> 
> How's this for you?

root@lc01:/dev/cgroup/burn# burnP6 &
[1] 3393
root@lc01:/dev/cgroup/burn# schedtool -R -p 1 3393
root@lc01:/dev/cgroup/burn# echo 3393 > oops/tasks
root@lc01:/dev/cgroup/burn# schedtool -R -p 1 3393
root@lc01:/dev/cgroup/burn# schedtool -R -p 1 3393

Multiple redundant schedtool invocations now work without incident.

I had almost given up trying to break it, but then this happened.

root@lc01:/dev/cgroup/burn# echo $$ > /dev/cgroup/burn/oops/tasks
root@lc01:/dev/cgroup/burn# schedtool -R -p 1 -e burnP6 &
[2] 3397

The following Oops happened immediately, but note that it was the first
burnP6 process (PID 3393) that is reported as the offender.

I tried the above procedure a second time, and now it ran for about one
second before the same Oops manifested itself, but this time with the
other burnP6 process as the culprit (the equivalent of PID 3397)

Yes, I realize I'm starting to sound like a broken record.


Daniel K.

> [  444.197275] BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
> [  444.197543] IP: [<ffffffff80229823>] requeue_task_rt+0x53/0x70
> [  444.197702] PGD 21f133067 PUD 21f5fb067 PMD 0 
> [  444.197923] Oops: 0002 [1] SMP 
> [  444.198102] CPU 3 
> [  444.198240] Modules linked in: netconsole configfs ipmi_msghandler kvm_amd kvm ipv6 iptable_filter ip_tables x_tables loop af_packet usbhid hid evdev i2c_nforce2 button i2c_core shpchp pci_hotplug k8temp pcspkr tg3 sd_mod sg forcedeth ehci_hcd ohci_hcd usbcore thermal processor fan
> [  444.199793] Pid: 3393, comm: burnP6 Not tainted 2.6.26-rc6 #4
> [  444.199906] RIP: 0010:[<ffffffff80229823>]  [<ffffffff80229823>] requeue_task_rt+0x53/0x70
> [  444.200123] RSP: 0000:ffff8102230fbe78  EFLAGS: 00010012
> [  444.200234] RAX: ffff810001056d08 RBX: ffff810221685fa0 RCX: ffff81021f5e9d80
> [  444.200352] RDX: 0000000000000064 RSI: ffff8100010566b8 RDI: ffff81021f5e9d80
> [  444.200470] RBP: ffff8102230fbe78 R08: 0000000000000000 R09: ffff810223026c48
> [  444.200588] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8100010565c0
> [  444.200706] R13: 0000000000000003 R14: 7fffffffffffffff R15: 0000000000000001
> [  444.200824] FS:  00007f2d7fea46e0(0000) GS:ffff810223022980(0000) knlGS:0000000000000000
> [  444.201001] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [  444.201114] CR2: 0000000000000064 CR3: 000000021f1fa000 CR4: 00000000000006e0
> [  444.201232] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  444.201350] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  444.201468] Process burnP6 (pid: 3393, threadinfo ffff810220cfa000, task ffff810221685fa0)
> [  444.201644] Stack:  ffff8102230fbe98 ffffffff8022f357 ffff810221685fa0 ffff8100010565c0
> [  444.202009]  ffff8102230fbec8 ffffffff802352a4 0000000000000001 0000000000000003
> [  444.202331]  ffff810221685fa0 ffff810001052680 0000000000000001 ffffffff8024291d
> [  444.202561] Call Trace:
> [  444.202759]  <IRQ>  [<ffffffff8022f357>] task_tick_rt+0xc7/0xe0
> [  444.202917]  [<ffffffff802352a4>] scheduler_tick+0xb4/0x1c0
> [  444.203032]  [<ffffffff8024291d>] update_process_times+0x4d/0x70
> [  444.203151]  [<ffffffff802573b9>] ? tick_sched_timer+0x69/0xd0
> [  444.203266]  [<ffffffff80250120>] ? __run_hrtimer+0x90/0xb0
> [  444.203380]  [<ffffffff80250e08>] ? hrtimer_interrupt+0x108/0x180
> [  444.203499]  [<ffffffff8021d039>] ? smp_apic_timer_interrupt+0x79/0xc0
> [  444.204829]  [<ffffffff8020c5a2>] ? apic_timer_interrupt+0x72/0x80
> [  444.204943]  <EOI> 
> [  444.205082] 
> [  444.205179] Code: d2 48 8b 57 08 48 0f 44 c1 48 8b 0f 8b 00 48 89 51 08 48 89 0a 48 98 48 c1 e0 04 48 8d 44 30 10 48 8b 50 08 48 89 07 48 89 78 08 <48> 89 3a 48 89 57 08 48 8b 7f 30 48 85 ff 75 ad c9 c3 66 66 2e 
> [  444.207862] RIP  [<ffffffff80229823>] requeue_task_rt+0x53/0x70
> [  444.208017]  RSP <ffff8102230fbe78>
> [  444.208122] CR2: 0000000000000064

