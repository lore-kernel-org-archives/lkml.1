Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYELUcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYELUcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYELUcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:32:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:30798 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYELUcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:sender;
        b=RO4LETo23mvmDrxWgxGoItw7/+pqNfncDk7aMZ4aL2RalfE+xn2JhqiAuMDFksj5rQ2zHknjbL9dUuBsuiB0J+5Q1lu/eB1Y1pGFDn4IpJJwrcFwC/yuPmlYIteIFmqeQnBwLq4/aTdYhjOjWHdaP8NL3CTcpgqvZ/3XudJyZ4M=
Message-ID: <4828A940.2090604@panasas.com>
Date: Mon, 12 May 2008 13:32:00 -0700
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] SLUB: clear c->freelist in __slab_alloc()/load_freelist:/SlabDebug
 path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the __slab_alloc()/load_freelist:/SlabDebug(c->page) path we only
use the object at the head of c->page->freelist
and the tail goes back to c->page->freelist.
We then set c->node = -1 to force __slab_alloc in next allocation.
c->freelist therefore needs to be cleared as it is invalid at this point.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 mm/slub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Hit while running cthon04 test from an IBM AIX client
against my nfs41 tree.

Stack trace excerpt:

May 12 11:18:19 client kernel: general protection fault: 0000 [2] SMP
May 12 11:18:19 client kernel: CPU 3
May 12 11:18:19 client kernel: Modules linked in: panfs(P) nfsd auth_rpcgss exportfs autofs4 hidp nfs lockd nfs_acl fuse rfcomm l2cap bluetooth sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4 ipt_REJECT iptable_filter ip_tables nf_conntrack_ipv6 xt_state nf_conntrack xt_tcpudp ip6t_ipv6header ip6t_REJECT ip6table_filter ip6_tables x_tables ipv6 dm_multipath video output sbs sbshc battery ac e1000e i5000_edac iTCO_wdt iTCO_vendor_support i2c_i801 edac_core button sr_mod pcspkr i2c_core sg cdrom floppy dm_snapshot dm_zero dm_mirror dm_mod ata_piix libata shpchp pci_hotplug mptsas mptscsih mptbase scsi_transport_sas sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
May 12 11:18:19 client kernel: Pid: 2815, comm: nfsd Tainted: P      D  2.6.25-nfs41 #2
May 12 11:18:19 client kernel: RIP: 0010:[<ffffffff8108c0c8>]  [<ffffffff8108c0c8>] kmem_cache_alloc+0x3d/0x65
May 12 11:18:19 client kernel: RSP: 0018:ffff8104212c3de0  EFLAGS: 00010006
May 12 11:18:19 client kernel: RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffffffff883546df
May 12 11:18:19 client kernel: RDX: 3200100010100000 RSI: 00000000000080d0 RDI: ffffffff813eadb8
May 12 11:18:19 client kernel: RBP: ffff810001029e60 R08: 0000000000000000 R09: ffff8103f118d130
May 12 11:18:19 client kernel: R10: ffff81041b076018 R11: ffffffff8826c313 R12: 00000000000080d0
May 12 11:18:19 client kernel: R13: ffff8104211aa000 R14: ffff81041b076000 R15: ffff8104239c8000
May 12 11:18:19 client kernel: FS:  00007f08fb8626f0(0000) GS:ffff81042fc02e80(0000) knlGS:0000000000000000
May 12 11:18:19 client kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 12 11:18:19 client kernel: CR2: 00007fdaf41cf030 CR3: 0000000420827000 CR4: 00000000000006e0
May 12 11:18:19 client kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 12 11:18:19 client kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 12 11:18:19 client kernel: Process nfsd (pid: 2815, threadinfo ffff8104212c2000, task ffff81042381c940)
May 12 11:18:19 client kernel: Stack:  ffff8104211ab000 ffff8103f118d000 0000000022270000 ffffffff883546df
May 12 11:18:19 client kernel:  ffffffff88373cb8 0000000000000000 ffff8103f118d130 ffff8104239c8000
May 12 11:18:19 client kernel:  ffffffff88373cb8 000000000000001c ffff81041b076018 ffff81041b076000
May 12 11:18:19 client kernel: Call Trace:
May 12 11:18:19 client kernel:  [<ffffffff883546df>] ? :nfsd:nfsd4_proc_compound+0xa9/0x3f6
May 12 11:18:19 client kernel:  [<ffffffff88346245>] ? :nfsd:nfsd_dispatch+0xde/0x1b6
May 12 11:18:19 client kernel:  [<ffffffff88268bb7>] ? :sunrpc:svc_process_common+0x2e8/0x5a9
May 12 11:18:19 client kernel:  [<ffffffff8834667c>] ? :nfsd:nfsd+0x0/0x2b4
May 12 11:18:19 client kernel:  [<ffffffff88269d16>] ? :sunrpc:svc_process+0x127/0x13d
May 12 11:18:19 client kernel:  [<ffffffff88346819>] ? :nfsd:nfsd+0x19d/0x2b4May 12 11:18:19 client kernel:  [<ffffffff8100cac8>] ? child_rip+0xa/0x12
May 12 11:18:19 client kernel:  [<ffffffff8834667c>] ? :nfsd:nfsd+0x0/0x2b4
May 12 11:18:19 client last message repeated 2 times
May 12 11:18:19 client kernel:  [<ffffffff8100cabe>] ? child_rip+0x0/0x12
May 12 11:18:19 client kernel:
May 12 11:18:19 client kernel:
May 12 11:18:19 client kernel: Code: 25 24 00 00 00 48 98 48 8b ac c7 d8 02 00 00 48 8b 55 00 48 85 d2 75 10 83 ca ff 49 89 e8 e8 7e f8 ff ff 48 89 c2 eb 0b 8b 45 14 <48> 8b 04 c2 48 89 45 00 53 9d 66 45 85 e4 79 10 48 85 d2 74 0b
May 12 11:18:19 client kernel: RIP  [<ffffffff8108c0c8>] kmem_cache_alloc+0x3d/0x65
May 12 11:18:19 client kernel:  RSP <ffff8104212c3de0>
May 12 11:18:19 client kernel: ---[ end trace 9b6f5806f68a2b8c ]---

$ grep SL.B .config
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLABINFO=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set

diff --git a/mm/slub.c b/mm/slub.c
index a505a82..0d1d820 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1606,6 +1606,7 @@ debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
 		goto another_slab;
 
+	c->freelist = NULL;
 	c->page->inuse++;
 	c->page->freelist = object[c->offset];
 	c->node = -1;
-- 
1.5.3.3

