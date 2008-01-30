Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbYA3D2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbYA3D2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYA3DVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:21:23 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33303 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbYA3DVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:21:21 -0500
Date: Tue, 29 Jan 2008 19:28:13 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/2] x86_64: make bootmap_start page align v3
In-reply-to: <200801291114.49030.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801291928.13927.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801291114.49030.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/2] x86_64: make bootmap_start page align v3

boot oops when system get 64g or 128 installed

Calling initcall 0xffffffff80bc33b6: sctp_init+0x0/0x711()
BUG: unable to handle kernel NULL pointer dereference at 000000000000005f
IP: [<ffffffff802bfe55>] proc_register+0xe7/0x10f
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-smp-g5a514e21-dirty #6
RIP: 0010:[<ffffffff802bfe55>]  [<ffffffff802bfe55>] proc_register+0xe7/0x10f
RSP: 0000:ffff810824c57e60  EFLAGS: 00010246
RAX: 000000000000d7d7 RBX: ffff811024c5fa80 RCX: ffff810824c57e08
RDX: 0000000000000000 RSI: 0000000000000195 RDI: ffffffff80cc2460
RBP: ffffffffffffffff R08: 0000000000000000 R09: ffff811024c5fa80
R10: 0000000000000000 R11: 0000000000000002 R12: ffff810824c57e6c
R13: 0000000000000000 R14: ffff810824c57ee0 R15: 00000006abd25bee
FS:  0000000000000000(0000) GS:ffffffff80b4d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000005f CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff810824c56000, task ffff812024c52000)
Stack:  ffffffff80a57348 0000019500000000 ffff811024c5fa80 0000000000000000
 00000000ffffff97 ffffffff802bfef0 0000000000000000 ffffffffffffffff
 0000000000000000 ffffffff80bc3b4b ffff810824c57ee0 ffffffff80bc34a5
Call Trace:
 [<ffffffff802bfef0>] ? create_proc_entry+0x73/0x8a
 [<ffffffff80bc3b4b>] ? sctp_snmp_proc_init+0x1c/0x34
 [<ffffffff80bc34a5>] ? sctp_init+0xef/0x711
 [<ffffffff80b976e3>] ? kernel_init+0x175/0x2e1
 [<ffffffff8020ccf8>] ? child_rip+0xa/0x12
 [<ffffffff80b9756e>] ? kernel_init+0x0/0x2e1
 [<ffffffff8020ccee>] ? child_rip+0x0/0x12


Code: 1e 48 83 7b 38 00 75 08 48 c7 43 38 f0 e8 82 80 48 83 7b 30 00 75 08 48 c7 43 30 d0 e9 82 80 48 c7 c7 60 24 cc 80 e8 bd 5a 54 00 <48> 8b 45 60 48 89 6b 58 48 89 5d 60 48 89 43 50 fe 05 f5 25 a0
RIP  [<ffffffff802bfe55>] proc_register+0xe7/0x10f
 RSP <ffff810824c57e60>
CR2: 000000000000005f
---[ end trace 02c2d78def82877a ]---
Kernel panic - not syncing: Attempted to kill init!

it turns out some variables near end of bss is corrupted already.

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

and setup_node_bootmem() will use that page 0xd40000 for bootmap
Bootmem setup node 0 0000000000000000-0000000828000000
  NODE_DATA [000000000008a485 - 0000000000091484]
  bootmap [0000000000d406f4 -  0000000000e456f3] pages 105
Bootmem setup node 1 0000000828000000-0000001028000000
  NODE_DATA [0000000828000000 - 0000000828006fff]
  bootmap [0000000828007000 -  0000000828106fff] pages 100
Bootmem setup node 2 0000001028000000-0000001828000000
  NODE_DATA [0000001028000000 - 0000001028006fff]
  bootmap [0000001028007000 -  0000001028106fff] pages 100
Bootmem setup node 3 0000001828000000-0000002028000000
  NODE_DATA [0000001828000000 - 0000001828006fff]
  bootmap [0000001828007000 -  0000001828106fff] pages 100

the patch update bootmap_start to page_align to make sure we can extra range
for alignment.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -224,6 +224,9 @@ void __init setup_node_bootmem(int nodei
 	}
 	bootmap_start = __pa(bootmap);
 
+	/* make sure bootmap is not overlapped with bss section */
+	bootmap_start = round_up(bootmap_start, PAGE_SIZE);
+
 	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
 					 bootmap_start >> PAGE_SHIFT,
 					 start_pfn, end_pfn);
