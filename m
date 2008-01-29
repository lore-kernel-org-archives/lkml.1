Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbYA2Ch6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbYA2Ch6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 21:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYA2Chs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 21:37:48 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61058 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYA2Chr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 21:37:47 -0500
Date: Mon, 28 Jan 2008 18:44:36 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: fix overlap between pagetable with bss section
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801281844.36940.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: fix overlap between pagetable with bss section

one early crash on one 8 node 256g machine

Command line: console=uart8250,io,0x3f8,115200n8 initrd=kernel.org/mydisk11_x86_64.gz rw root=/dev/ram0 debug initcall_debug apic=debug acpi.debug_level=0x0000000f pci=routeirq ip=dhcp load_ramdisk=1 ramdisk_size=131072 BOOT_IMAGE=kernel.org/bzImage_2.6.25_k8.1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
 BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dffe0000 (usable)
 BIOS-e820: 00000000dffe0000 - 00000000dffee000 (ACPI data)
 BIOS-e820: 00000000dffee000 - 00000000dffff050 (ACPI NVS)
 BIOS-e820: 00000000dffff050 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000004020000000 (usable)
Early serial console at I/O port 0x3f8 (options '115200n8')
console [uart0] enabled
end_pfn_map = 67239936
Kernel panic - not syncing: Duplicated early reservation d40000-e42000

Pid: 0, comm: swapper Not tainted 2.6.24-smp-g5a514e21-dirty #3

Call Trace:
 [<ffffffff80221545>] lapic_get_maxlvt+0x0/0x10
 [<ffffffff80221657>] clear_local_APIC+0x5/0xcf
 [<ffffffff80221726>] disable_local_APIC+0x5/0x17
 [<ffffffff8021fe16>] smp_send_stop+0x46/0x4c
 [<ffffffff80235293>] panic+0x94/0x13e
 [<ffffffff80bc3b03>] sctp_eps_proc_init+0x12/0x34
 [<ffffffff80b9f1c5>] reserve_early+0x30/0x6c
 [<ffffffff80803925>] init_memory_mapping+0x2cd/0x2dc
 [<ffffffff80b9dc01>] setup_arch+0x21f/0x44e
 [<ffffffff80b978be>] start_kernel+0x6f/0x2c7
 [<ffffffff80b971cc>] _sinittext+0x1cc/0x1d3

one later oops on other machine

Calling initcall 0xffffffff80bc33ac: sctp_init+0x0/0x711()
BUG: unable to handle kernel NULL pointer dereference at 000000000000005f
IP: [<ffffffff802bfe55>] proc_register+0xe7/0x10f
PGD 0
Oops: 0000 [1] SMP
CPU 7
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-smp-g5a514e21-dirty #1
RIP: 0010:[<ffffffff802bfe55>]  [<ffffffff802bfe55>] proc_register+0xe7/0x10f
RSP: 0000:ffff811074c55e60  EFLAGS: 00010246
RAX: 0000000000008d8d RBX: ffff811074d78d80 RCX: ffff811074c55e08
RDX: 0000000000000000 RSI: 0000000000000141 RDI: ffffffff80cc2460
RBP: ffffffffffffffff R08: 0000000000000000 R09: ffff811074d78d80
R10: 0000000000000000 R11: ffffffff80b78750 R12: ffff811074c55e6c
R13: 0000000000000000 R14: ffff811074c55ee0 R15: 00000006eb27426e
FS:  0000000000000000(0000) GS:ffff811074cc7f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000005f CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff811074c54000, task ffff810874c54000)
Stack:  ffffffff80a57340 0000014100000000 ffff811074d78d80 0000000000000000
 00000000ffffff97 ffffffff802bfef0 0000000000000000 ffffffffffffffff
 0000000000000000 ffffffff80bc3b41 ffff811074c55ee0 ffffffff80bc349b
Call Trace:
 [<ffffffff802bfef0>] ? create_proc_entry+0x73/0x8a
 [<ffffffff80bc3b41>] ? sctp_snmp_proc_init+0x1c/0x34
 [<ffffffff80bc349b>] ? sctp_init+0xef/0x711
 [<ffffffff80b976e3>] ? kernel_init+0x175/0x2e1
 [<ffffffff8020ccf8>] ? child_rip+0xa/0x12
 [<ffffffff80b9756e>] ? kernel_init+0x0/0x2e1
 [<ffffffff8020ccee>] ? child_rip+0x0/0x12


Code: 1e 48 83 7b 38 00 75 08 48 c7 43 38 f0 e8 82 80 48 83 7b 30 00 75 08 48 c7 43 30 d0 e9 82 80 48 c7 c7 60 24 cc 80 e8 bd 5a 54 00 <48> 8b 45 60 48 89 6b 58 48 89 5d 60 48 89 43 50 fe 05 f5 25 a0
RIP  [<ffffffff802bfe55>] proc_register+0xe7/0x10f
 RSP <ffff811074c55e60>
CR2: 000000000000005f
---[ end trace c97bfb5810c69e0c ]---
Kernel panic - not syncing: Attempted to kill init!

it turns out there is overlap between pgtable and bss...

need to round up table_start to PAGE

also make the panic more informative.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index f8b7beb..6f07bab 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -70,8 +70,8 @@ void __init reserve_early(unsigned long start, unsigned long end)
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		r = &early_res[i];
 		if (end > r->start && start < r->end)
-			panic("Duplicated early reservation %lx-%lx\n",
-			      start, end);
+			panic("Overlap early reservation %lx-%lx to %lx-%lx\n",
+			      start, end, r->start, r->end);
 	}
 	if (i >= MAX_EARLY_RES)
 		panic("Too many early reservations");
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b09faf2..bf02f7e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -358,6 +358,8 @@ static void __init find_early_table_space(unsigned long end)
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
+	/* need to round it up to avoid overlap less one page */
+	table_start = round_up(table_start, PAGE_SIZE);
 	table_start >>= PAGE_SHIFT;
 	table_end = table_start;
 
