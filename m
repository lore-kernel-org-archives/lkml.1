Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZDOS6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZDOS6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZDOS6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:58:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:34971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZDOS6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:58:41 -0400
Message-ID: <49E62DFD.6010904@kernel.org>
Date: Wed, 15 Apr 2009 11:57:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: [PATCH] x86: used used_vectors in init_IRQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix panic

Yinghai found:
[  552.616646] general protection fault: 0403 [#1] SMP
[  552.620013] last sysfs file:
/sys/devices/pci0000:00/0000:00:02.0/usb1/1-1/1-1:1.0/host13/target13:0:0/13:0:0:0/block/sr0/size
[  552.620013] CPU 0
[  552.620013] Modules linked in:
[  552.620013] Pid: 0, comm: swapper Not tainted 2.6.30-rc1-tip-01931-g8fcafd8-dirty #28 Sun Fire X4440
[  552.620013] RIP: 0010:[<ffffffff8023bada>]  [<ffffffff8023bada>] default_idle+0x7d/0xda
[  552.620013] RSP: 0018:ffffffff81345e68  EFLAGS: 00010246
[  552.620013] RAX: 0000000000000000 RBX: ffffffff8133d870 RCX: ffffc20000000000
[  552.620013] RDX: 00000000001d0620 RSI: ffffffff8023bad8 RDI: ffffffff802a3169
[  552.620013] RBP: ffffffff81345e98 R08: 0000000000000000 R09: ffffffff812244a0
[  552.620013] R10: ffffffff81345dc8 R11: 7ebe1b6fa0bcac50 R12: 4ec4ec4ec4ec4ec5
[  552.620013] R13: ffffffff813a54d0 R14: ffffffff813a7a40 R15: 0000000000000000
[  552.620013] FS:  00000000006d1880(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
[  552.620013] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  552.620013] CR2: 00007fec9d936a50 CR3: 000000007d1a9000 CR4: 00000000000006e0
[  552.620013] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  552.620013] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  552.620013] Process swapper (pid: 0, threadinfo ffffffff81344000,task ffffffff812244a0)
[  552.620013] Stack:
[  552.620013]  0000000000000000 ffffc20000000000 00000000001d0620 7ebe1b6fa0bcac50
[  552.620013]  ffffffff8133d870 4ec4ec4ec4ec4ec5 ffffffff81345ec8 ffffffff8023bd84
[  552.620013]  4ec4ec4ec4ec4ec5 ffffffff813a54d0 7ebe1b6fa0bcac50 ffffffff8133d870
[  552.620013] Call Trace:
[  552.620013]  [<ffffffff8023bd84>] c1e_idle+0x109/0x124
[  552.620013]  [<ffffffff8023314b>] cpu_idle+0xb8/0x101
[  552.620013]  [<ffffffff80c16d6a>] rest_init+0x7e/0x94
[  552.620013]  [<ffffffff81357efc>] start_kernel+0x3dc/0x3fd
[  552.620013]  [<ffffffff813572a9>] x86_64_start_reservations+0xb9/0xd4
[  552.620013]  [<ffffffff813573b2>] x86_64_start_kernel+0xee/0x109
[  552.620013] Code: 48 8b 04 25 f8 b4 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 8b 04 25 f8 b4 00 00 f6 80 38 e0 ff ff 08 75 09 e8 71 76 06 00 fb f4 <eb> 06 e8 68 76 06 00 fb 65 48 8b 04 25 f8 b4 00 00 83 88 3c e0
[  552.620013] RIP  [<ffffffff8023bada>] default_idle+0x7d/0xda
[  552.620013]  RSP <ffffffff81345e68>
[  552.828646] ---[ end trace 4cbfc5c01382af7f ]---

Joerg Roedel said
	"The 0403 error code means that there was an external interrupt with vector
	0x80. Yinghai, my theory is that the kernel on this machine has no 32bit
	emulation compiled in, right? In this case the selector points to a zero entry
	which may cause the #gpf right after the hlt.
	But I have no idea where the external int 0x80 comes from"

it turns out that we could use 0x80 for external device with 64bit but 32bit emulation is disabled.

but we forget to set gate for it.

try to set gate for it by checking with used_vectors.
also move apic_intr_init() early to avoid set that gate two times.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/irqinit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/irqinit.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit.c
+++ linux-2.6/arch/x86/kernel/irqinit.c
@@ -240,19 +240,19 @@ void __init native_init_IRQ(void)
 	/* Execute any quirks before the call gates are initialised: */
 	x86_quirk_pre_intr_init();
 
+	apic_intr_init();
+
 	/*
 	 * Cover the whole vector space, no vector can escape
 	 * us. (some of these will be overridden and become
 	 * 'special' SMP interrupts)
 	 */
 	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
-		/* IA32_SYSCALL_VECTOR was reserved in trap_init. */
-		if (i != IA32_SYSCALL_VECTOR)
+		/* IA32_SYSCALL_VECTOR could be used in trap_init already. */
+		if (!test_bit(i, used_vectors))
 			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
 	}
 
-	apic_intr_init();
-
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
 
