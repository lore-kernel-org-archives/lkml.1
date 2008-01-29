Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYA2D7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYA2D7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbYA2D7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:59:00 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62447 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYA2D67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:58:59 -0500
Date: Mon, 28 Jan 2008 20:05:43 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: fix overlap between pagetable with bss section v2
In-reply-to: <200801281844.36940.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801282005.43993.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801281844.36940.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: fix overlap between pagetable with bss section v2

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

it turns out there is overlap between pgtable and bss...

in System.map we have
ffffffff80d40420 b rsi_table
ffffffff80d40620 B krb5_seq_lock
ffffffff80d40628 b i.20437
ffffffff80d40630 b xprt_rdma_inline_write_padding
ffffffff80d40638 b sunrpc_table_header
ffffffff80d40640 b zero
ffffffff80d40644 b min_memreg
ffffffff80d40648 b rpcrdma_tk_lock_g
ffffffff80d40650 B sctp_assocs_id_lock
ffffffff80d40658 B proc_net_sctp
ffffffff80d40660 B sctp_assocs_id
ffffffff80d40680 B sysctl_sctp_mem
ffffffff80d40690 B sysctl_sctp_rmem
ffffffff80d406a0 B sysctl_sctp_wmem
ffffffff80d406b0 b sctp_ctl_socket
ffffffff80d406b8 b sctp_pf_inet6_specific
ffffffff80d406c0 b sctp_pf_inet_specific
ffffffff80d406c8 b sctp_af_v4_specific
ffffffff80d406d0 b sctp_af_v6_specific
ffffffff80d406d8 b sctp_rand.33270
ffffffff80d406dc b sctp_memory_pressure
ffffffff80d406e0 b sctp_sockets_allocated
ffffffff80d406e4 b sctp_memory_allocated
ffffffff80d406e8 b sctp_sysctl_header
ffffffff80d406f0 b zero
ffffffff80d406f4 A __bss_stop
ffffffff80d406f4 A _end

need to round up table_start to PAGE_SIZE

also make the panic more informative.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -70,8 +70,8 @@ void __init reserve_early(unsigned long 
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
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -358,6 +358,13 @@ static void __init find_early_table_spac
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
+	/*
+	 * when you have a lot of ram like 256g, early_table will not fit
+	 * into 0x8000 range, find_e820_area will find area after kerne bss
+	 * but the table_start is not page align, so need to round it up to
+	 * avoid overlap with bss
+	 */
+	table_start = round_up(table_start, PAGE_SIZE);
 	table_start >>= PAGE_SHIFT;
 	table_end = table_start;
 
