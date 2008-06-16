Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYFPPJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYFPPJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYFPPJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:09:18 -0400
Received: from in.cluded.net ([195.159.98.120]:52709 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYFPPJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:09:17 -0400
X-OS: [Linux] 2.6.8 and newer (?)
Message-ID: <485682B0.8010805@uw.no>
Date: Mon, 16 Jun 2008 17:11:44 +0200
From: "Daniel K." <dk@uw.no>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG: NULL pointer dereference] cgroups and RT	scheduling	interact
 badly.
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>	 <4856671B.1020304@uw.no>  <1213624312.16944.104.camel@twins> <1213627148.16944.106.camel@twins>
In-Reply-To: <1213627148.16944.106.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-06-16 at 15:51 +0200, Peter Zijlstra wrote:
>> On Mon, 2008-06-16 at 15:14 +0200, Daniel K. wrote:
>>> Peter Zijlstra wrote:
>>>
>>> Although this patch seems to be correct, this is what shows up on my
>>> netconsole, when applying it -- with an offset, do you have other fixes
>>> applied as well?
>> I had indeed, although nothing touching the rt scheduler. I popped all
>> my patches and pulled an update from Linus, but I fail to reproduce the
>> below.
>>
>> /me goes look for that burnp6 thing, I used a simple while (1); loop.
> 
> found it, still seems to work for me. do you have a funny number of
> cpus? or anything else noteworthy?

I don't think so, this is on a SUN X2200 M2, with two AMD Opteron 2214
processors, and 8G RAM.

If I follow the procedure up to 'echo 4000 > oops/cpu.rt_runtime_us'
then I can

# burnP6 &
[1] 3395
# schedtool -R -p 1 3395

but

# echo -n 3395 > /dev/cgroup/burn/oops/tasks

yields this:

> [ 1116.296418] ------------[ cut here ]------------
> [ 1116.296559] Kernel BUG at ffffffff8022acea [verbose debug info unavailable]
> [ 1116.296644] invalid opcode: 0000 [1] SMP 
> [ 1116.296721] CPU 3 
> [ 1116.296788] Modules linked in: netconsole configfs ipmi_msghandler kvm_amd kvm ipv6 iptable_filter ip_tables x_tables af_packet usbhid hid loop tg3 evdev i2c_nforce2 o
> hci_hcd i2c_core ehci_hcd k8temp button thermal processor pcspkr usbcore shpchp pci_hotplug forcedeth sd_mod sg fan thermal_sys
> [ 1116.297161] Pid: 3395, comm: burnP6 Not tainted 2.6.26-rc6 #4
> [ 1116.297240] RIP: 0010:[<ffffffff8022acea>]  [<ffffffff8022acea>] pick_next_task_rt+0x5a/0x90
> [ 1116.297390] RSP: 0000:ffff81021edf7ea0  EFLAGS: 00010002
> [ 1116.297467] RAX: 0000000000000064 RBX: ffffffff8049ec00 RCX: ffff81021ef5e800
> [ 1116.297551] RDX: ffff8102214d7c00 RSI: 0000000000000003 RDI: ffff810001056600
> [ 1116.298666] RBP: ffff81021edf7ea0 R08: ffff810001050660 R09: 00000000000010a8
> [ 1116.298750] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000000000
> [ 1116.298833] R13: ffff810001056600 R14: 0000000000000003 R15: 0000000000000000
> [ 1116.298917] FS:  00007fecf7cc76e0(0000) GS:ffff810223022980(0000) knlGS:0000000000000000
> [ 1116.299060] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [ 1116.299142] CR2: 0000000001a0d958 CR3: 0000000220c79000 CR4: 00000000000006e0
> [ 1116.299225] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1116.299309] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1116.299393] Process burnP6 (pid: 3395, threadinfo ffff81021edf6000, task ffff81022178aca0)
> [ 1116.299535] Stack:  ffff81021edf7f70 ffffffff8048c302 0000000000000000 ffff8102210b1b00
> [ 1116.299682]  ffffffff80689600 ffffffff80689600 ffffffff806858a0 ffffffff80689600
> [ 1116.299827]  ffff81022178af18 0000000000000000 0000000000000292 ffff81022178aca0
> [ 1116.299914] Call Trace:
> [ 1116.300046]  [<ffffffff8048c302>] thread_return+0x101/0x4af
> [ 1116.300130]  [<ffffffff8020bdee>] retint_careful+0x1c/0x42
> [ 1116.300210] 
> [ 1116.300273] 
> [ 1116.300335] Code: 48 c1 e0 04 48 8b 14 08 48 85 d2 74 49 48 8b 4a 40 48 85 c9 74 1b 48 8b 01 48 85 c0 75 d4 48 0f bc 41 08 83 c0 40 83 f8 63 7e d0 <0f> 0b eb fe 66 

I'll go say hello to mr. proper, and report back.


Daniel K.

