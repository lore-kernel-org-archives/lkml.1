Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbYEMOdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbYEMOdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbYEMOdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:33:10 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51535
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195AbYEMOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:33:09 -0400
Message-ID: <4829A6A0.5040208@qumranet.com>
Date: Tue, 13 May 2008 17:33:04 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Subject: [BUG] cpu hotplug vs scheduler
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing host cpu hotplug with kvm.  Basically running 7 guests on a 
4 core machine, offlining and onlining host cpus at random.  Eventually 
I hit this:

[4298303.496645] Booting processor 3/7 ip 6000
[4298303.506116] Initializing CPU#3
[4298303.506116] Calibrating delay using timer specific routine.. 
5319.66 BogoMIPS (lpj=2659833)
[4298303.506116] CPU: L1 I cache: 32K, L1 D cache: 32K
[4298303.506116] CPU: L2 cache: 4096K
[4298303.506116] CPU: Physical Processor ID: 3
[4298303.506116] CPU: Processor Core ID: 1
[4298303.506116] x86 PAT enabled: cpu 3, old 0x7040600070406, new 
0x7010600070106
[4298303.582937] CPU3: Intel(R) Xeon(R) CPU            5150  @ 2.66GHz 
stepping 06
[4298303.585087] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[4298303.707287] Switched to high resolution mode on CPU 3
[4298303.712943] kvm: enabling virtualization on CPU3
[4298303.713955] CPU0 attaching sched-domain:
[4298303.713901] BUG: unable to handle kernel NULL pointer dereference 
at 0000000000000158
[4298303.713901] IP: [<ffffffff8022e722>] pick_next_task_fair+0x55/0x7c
[4298303.713901] PGD 0
[4298303.713901] Oops: 0000 [1] PREEMPT SMP
[4298303.713901] CPU 3
[4298303.713901] Modules linked in: kvm_intel kvm netconsole autofs4 nfs 
lockd nfs_acl sunrpc bridge llc acpi_cpufreq backlight sg e1000 button 
serio_raw rtc_cmos rtc_core rtc_lib ata_piix dm_snapshot dm_mod ahci 
libata dock sd_mod scsi_mod [last unloaded: kvm]
[4298303.713901] Pid: 15115, comm: migration/3 Not tainted 2.6.26-rc2 #723
[4298303.713901] RIP: 0010:[<ffffffff8022e722>]  [<ffffffff8022e722>] 
pick_next_task_fair+0x55/0x7c
[4298303.713901] RSP: 0018:ffff81004fdfbe20  EFLAGS: 00010046
[4298303.713901] RAX: 0000000000000000 RBX: ffff81000103df80 RCX: 
0000000000000000
[4298303.713901] RDX: ffff81000103e038 RSI: 000000003b9aca00 RDI: 
ffff81000103df00
[4298303.713901] RBP: ffff81004fdfbe40 R08: ffff81004fdfbdd0 R09: 
ffff81000103a0a0
[4298303.713901] R10: 0000000000000000 R11: 0000000000000003 R12: 
0000000000000000
[4298303.713901] R13: ffff81000103df00 R14: ffffffff8060a140 R15: 
0000000000000003
[4298303.713901] FS:  0000000000000000(0000) GS:ffff81007f806a80(0000) 
knlGS:0000000000000000
[4298303.713901] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[4298303.713901] CR2: 0000000000000158 CR3: 0000000000201000 CR4: 
00000000000026a0
[4298303.713901] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[4298303.713901] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[4298303.713901] Process migration/3 (pid: 15115, threadinfo 
ffff81004fdfa000, task ffff81003f5f0700)
[4298303.713901] Stack:  ffff81004fdfbe40 ffff81000103df00 
ffffffff804543c0 ffff810020985bf8
[4298303.713901]  ffff81004fdfbee0 ffffffff804373fe ffff81004fdfbe80 
ffffffff8023060a
[4298303.713901]  ffff81000103df00 ffff81003f5f0700 0000000000000000 
ffff81003f5f0a60
[4298303.713901] Call Trace:
[4298303.713901]  [<ffffffff804373fe>] schedule+0x414/0x6ab
[4298303.713901]  [<ffffffff8023060a>] ? hrtick_set+0x9d/0xe8
[4298303.713901]  [<ffffffff8043772f>] ? thread_return+0x9a/0xbf
[4298303.713901]  [<ffffffff80231652>] migration_thread+0x185/0x22d
[4298303.713901]  [<ffffffff802314cd>] ? migration_thread+0x0/0x22d
[4298303.713901]  [<ffffffff8024afe6>] kthread+0x49/0x77
[4298303.713901]  [<ffffffff8020d228>] child_rip+0xa/0x12
[4298303.713901]  [<ffffffff8024af9d>] ? kthread+0x0/0x77
[4298303.713901]  [<ffffffff8020d21e>] ? child_rip+0x0/0x12
[4298303.713901]
[4298303.713901]
[4298303.713901] Code: c0 74 28 48 8b 7b 58 4c 8d 60 f0 48 85 ff 74 10 
4c 89 e6 e8 df cc ff ff 85 c0 75 04 4c 8b 63 58 4c 89 e6 48 89 df e8 4a 
e5 ff ff <49> 8b 9c 24 58 01 00 00 48 85 db 75 bf 49 83 ec 38 4c 89 ef 4c
[4298303.713901] RIP  [<ffffffff8022e722>] pick_next_task_fair+0x55/0x7c

This seems to be the assignment to cfs_rq after pick_next_entity().

I'm running kvm.git, which is currently 2.6.26-rc2 plus a few kvm 
patches.  It could be kvm's fault, but it doesn't appear so from the traces.

-- 
error compiling committee.c: too many arguments to function

