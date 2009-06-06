Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZFFVxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZFFVxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFFVxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:53:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:33827 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbZFFVxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:53:16 -0400
Message-ID: <4A2AE523.9090204@kernel.org>
Date: Sat, 06 Jun 2009 14:52:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] kvm: fix kvm reboot crash when MAXSMP is used
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <4A2A356B.6090102@redhat.com> <4A2A38B9.7030809@kernel.org> <4A2A3969.5030101@redhat.com> <4A2A4B80.1010605@kernel.org> <4A2AE4AC.60805@kernel.org>
In-Reply-To: <4A2AE4AC.60805@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Avi Kivity <avi@redhat.com>

one system was found there is crash during reboot then kvm/MAXSMP
Sending all processes the KILL signal...                              done
Please stand by while rebooting the system...
[ 1721.856538] md: stopping all md devices.
[ 1722.852139] kvm: exiting hardware virtualization
[ 1722.854601] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 1722.872219] IP: [<ffffffff8102c6b6>] hardware_disable+0x4c/0xb4
[ 1722.877955] PGD 0
[ 1722.880042] Oops: 0000 [#1] SMP
[ 1722.892548] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/target0:2:0/0:2:0:0/vendor
[ 1722.900977] CPU 9
[ 1722.912606] Modules linked in:
[ 1722.914226] Pid: 0, comm: swapper Not tainted 2.6.30-rc7-tip-01843-g2305324-dirty #299 ...
[ 1722.932589] RIP: 0010:[<ffffffff8102c6b6>]  [<ffffffff8102c6b6>] hardware_disable+0x4c/0xb4
[ 1722.942709] RSP: 0018:ffffc900010b6ed8  EFLAGS: 00010046
[ 1722.956121] RAX: 0000000000000000 RBX: ffffc9000e253140 RCX: 0000000000000009
[ 1722.972202] RDX: 000000000000b020 RSI: ffffc900010c3220 RDI: ffffffffffffd790
[ 1722.977399] RBP: ffffc900010b6f08 R08: 0000000000000000 R09: 0000000000000000
[ 1722.995149] R10: 00000000000004b8 R11: 966912b6c78fddbd R12: 0000000000000009
[ 1723.011551] R13: 000000000000b020 R14: 0000000000000009 R15: 0000000000000000
[ 1723.019898] FS:  0000000000000000(0000) GS:ffffc900010b3000(0000) knlGS:0000000000000000
[ 1723.034389] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1723.041164] CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006e0
[ 1723.056192] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1723.072546] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1723.080562] Process swapper (pid: 0, threadinfo ffff88107e464000, task ffff88047e5a2550)
[ 1723.096144] Stack:
[ 1723.099071]  0000000000000046 ffffc9000e253168 966912b6c78fddbd ffffc9000e253140
[ 1723.115471]  ffff880c7d4304d0 ffffc9000e253168 ffffc900010b6f28 ffffffff81011022
[ 1723.132428]  ffffc900010b6f48 966912b6c78fddbd ffffc900010b6f48 ffffffff8100b83b
[ 1723.141973] Call Trace:
[ 1723.142981]  <IRQ> <0> [<ffffffff81011022>] kvm_arch_hardware_disable+0x26/0x3c
[ 1723.158153]  [<ffffffff8100b83b>] hardware_disable+0x3f/0x55
[ 1723.172168]  [<ffffffff810b95f6>] generic_smp_call_function_interrupt+0x76/0x13c
[ 1723.178836]  [<ffffffff8104cbea>] smp_call_function_interrupt+0x3a/0x5e
[ 1723.194689]  [<ffffffff81035bf3>] call_function_interrupt+0x13/0x20
[ 1723.199750]  <EOI> <0> [<ffffffff814ad3b4>] ? acpi_idle_enter_c1+0xd3/0xf4
[ 1723.217508]  [<ffffffff814ad3ae>] ? acpi_idle_enter_c1+0xcd/0xf4
[ 1723.232172]  [<ffffffff814ad4bc>] ? acpi_idle_enter_bm+0xe7/0x2ce
[ 1723.235141]  [<ffffffff81a8d93f>] ? __atomic_notifier_call_chain+0x0/0xac
[ 1723.253381]  [<ffffffff818c3dff>] ? menu_select+0x58/0xd2
[ 1723.258179]  [<ffffffff818c2c9d>] ? cpuidle_idle_call+0xa4/0xf3
[ 1723.272828]  [<ffffffff81034085>] ? cpu_idle+0xb8/0x101
[ 1723.277085]  [<ffffffff81a80163>] ? start_secondary+0x1bc/0x1d7
[ 1723.293708] Code: b0 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 e0 31 c0 48 8b 04 cd 30 ee 27 82 49 89 cc 49 89 d5 48 8b 04 10 48 8d b8 90 d7 ff ff <48> 8b 87 70 28 00 00 48 8d 98 90 d7 ff ff eb 16 e8 e9 fe ff ff
[ 1723.335524] RIP  [<ffffffff8102c6b6>] hardware_disable+0x4c/0xb4
[ 1723.342076]  RSP <ffffc900010b6ed8>
[ 1723.352021] CR2: 0000000000000000
[ 1723.354348] ---[ end trace e2aec53dae150aa1 ]---

it turns out that we need clear cpus_hardware_enabled in that case.

Reporte-and-tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>


Index: linux-2.6/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/virt/kvm/kvm_main.c
+++ linux-2.6/virt/kvm/kvm_main.c
@@ -2301,7 +2301,7 @@ int kvm_init(void *opaque, unsigned int
 
 	bad_pfn = page_to_pfn(bad_page);
 
-	if (!alloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
 		goto out_free_0;
 	}
