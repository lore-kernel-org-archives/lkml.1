Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYFNWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYFNWbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 18:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYFNWbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 18:31:39 -0400
Received: from in.cluded.net ([195.159.98.120]:48816 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbYFNWbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 18:31:38 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2008 18:31:37 EDT
X-OS: [Linux] 2.6.8 and newer (?)
Message-ID: <485445AE.2010602@uw.no>
Date: Sun, 15 Jun 2008 00:26:54 +0200
From: "Daniel K." <dk@uw.no>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: mingo@elte.hu, peterz@infradead.org, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG: NULL pointer dereference] cgroups and RT scheduling interact
 badly.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following on the latest Linus git tree.

Testcase:

mkdir /dev/cgroup
mount -t cgroup -o cpu,cpuset cgroup /dev/cgroup

mkdir -p /dev/cgroup/burn/oops
cd /dev/cgroup/burn

echo 3 > cpuset.cpus
echo 0 > cpuset.mems
echo 1000000 > cpu.rt_period_us
echo 940000  > cpu.rt_runtime_us

echo 3 > oops/cpuset.cpus
echo 0 > oops/cpuset.mems
echo 100000 > oops/cpu.rt_period_us
echo 4000 > oops/cpu.rt_runtime_us

echo $$ > oops/tasks
schedtool -R -p 1 -e burnP6

And then it breaks into the pieces below, as captured by netconsole.

> [  492.586059] BUG: unable to handle kernel NULL pointer dereference at
0000000000000062
> [  492.586059] IP: [<ffffffff8022e635>] enqueue_rt_entity+0x55/0x1d0
> [  492.586059] PGD 21e439067 PUD 21e438067 PMD 0 
> [  492.586059] Oops: 0002 [1] SMP 
> [  492.586059] CPU 3 
> [  492.586059] Modules linked in: netconsole configfs ipmi_msghandler kvm_amd kvm ipv6 iptable_filter ip_tables x_tables loop af_packet usbhid hid evdev i2c_nforce2 k8temp button pcspkr shpchp pci_hotplug i2c_core tg3 sd_mod ehci_hcd ohci_hcd forcedeth sg usbcore thermal processor fan thermal_sys
> [  492.586059] Pid: 3405, comm: schedtool Not tainted 2.6.26-rc6 #2
> [  492.586059] RIP: 0010:[<ffffffff8022e635>]  [<ffffffff8022e635>] enqueue_rt_entity+0x55/0x1d0
> [  492.586059] RSP: 0018:ffff81021e415e48  EFLAGS: 00010012
> [  492.586059] RAX: ffff810001056d48 RBX: ffff81022309e900 RCX: ffff81022309e860
> [  492.586059] RDX: 0000000000000062 RSI: 0000000000000086 RDI: ffff81022309e900
> [  492.586059] RBP: ffff81021e415e58 R08: ffff810001056e50 R09: 000000009b10fa5a
> [  492.586059] R10: 0000000000000000 R11: ffff810001056670 R12: ffff8100010566f8
> [  492.586059] R13: 0000000000000001 R14: 0000000000000001 R15: ffff81021e415f38
> [  492.586059] FS:  00007f675ec286e0(0000) GS:ffff810223022980(0000) knlGS:0000000000000000
> [  492.586059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  492.586059] CR2: 0000000000000062 CR3: 000000021e44e000 CR4: 00000000000006e0
> [  492.586059] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  492.586059] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  492.586059] Process schedtool (pid: 3405, threadinfo ffff81021e414000, task ffff810221771980)
> [  492.586059] Stack:  ffff81022309e900 ffff810221771980 ffff81021e415e78 ffffffff8022e7e8
> [  492.586059]  0000000000000001 ffff810221771980 ffff81021e415e98 ffffffff80229ea3
> [  492.586059]  ffff810001056670 ffff810001056600 ffff81021e415eb8 ffffffff80229f20
> [  492.586059] Call Trace:
> [  492.586059]  [<ffffffff8022e7e8>] enqueue_task_rt+0x38/0x50
> [  492.586059]  [<ffffffff80229ea3>] enqueue_task+0x13/0x30
> [  492.586059]  [<ffffffff80229f20>] activate_task+0x30/0x50
> [  492.586059]  [<ffffffff8023336f>] sched_setscheduler+0x28f/0x3b0
> [  492.586059]  [<ffffffff8028b818>] ? do_munmap+0x278/0x2d0
> [  492.586059]  [<ffffffff8023350d>] do_sched_setscheduler+0x7d/0x90
> [  492.586059]  [<ffffffff80233554>] sys_sched_setscheduler+0x14/0x20
> [  492.586059]  [<ffffffff8020b77a>] system_call_after_swapgs+0x8a/0x8f
> [  492.586059] 
> [  492.586059] 
> [  492.586059] Code: 85 c9 0f 84 76 01 00 00 8b 81 58 06 00 00 48 98 48 8d 8b 60 ff ff ff 48 c1 e0 04 4a 8d 44 20 10 48 8b 50 08 48 89 03 48 89 58 08 <48> 89 1a 48 89 53 08 48 8b 53 40 48 8d 82 58 06 00 00 48 85 d2 
> [  492.586059] RIP  [<ffffffff8022e635>] enqueue_rt_entity+0x55/0x1d0
> [  492.586059]  RSP <ffff81021e415e48>
> [  492.586059] CR2: 0000000000000062

Some information about the compiler, and Kconfig

daniel@lc01:~/git/linux-2.6$ cat /proc/version
Linux version 2.6.26-rc6 (daniel@lc01) (gcc version 4.2.3 (Ubuntu
4.2.3-2ubuntu7)) #2 SMP Sat Jun 14 21:51:31 CEST 2008

daniel@lc01:~/git/linux-2.6$ cat .config|egrep "(CGROUP|SCHED)"
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_NS is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_IOSCHED="deadline"
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_SCHED_HRTICK=y
CONFIG_NET_SCHED=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set


Daniel K.
