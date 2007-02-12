Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbXBLJJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbXBLJJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964799AbXBLJI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:08:58 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:44181 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:40:30 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 09/10] nfnetlink_log: fix NULL pointer dereference
Message-ID: <20070212004030.GJ8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the nasty NULL dereference on multiple packets per netlink message.

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000004
 printing eip:
f8a4b3bf
*pde = 00000000
Oops: 0002 [#1]
SMP 
Modules linked in: nfnetlink_log ipt_ttl ipt_REDIRECT xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 xt_state ipt_ipp2p xt_NFLOG xt_hashlimit ip6_tables iptable_filter xt_multiport xt_mark ipt_set iptable_raw xt_MARK iptable_mangle ip_tables cls_fw cls_u32 sch_esfq sch_htb ip_set_ipmap ip_set ipt_ULOG x_tables dm_snapshot dm_mirror loop e1000 parport_pc parport e100 floppy ide_cd cdrom
CPU:    0
EIP:    0060:[<f8a4b3bf>]    Not tainted VLI
EFLAGS: 00010206   (2.6.20 #5)
EIP is at __nfulnl_send+0x24/0x51 [nfnetlink_log]
eax: 00000000   ebx: f2b5cbc0   ecx: c03f5f54   edx: c03f4000
esi: f2b5cbc8   edi: c03f5f54   ebp: f8a4b3ec   esp: c03f5f30
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, ti=c03f4000 task=c03bece0 task.ti=c03f4000)
Stack: f2b5cbc0 f8a4b401 00000100 c0444080 c012af49 00000000 f6f19100 f6f19000 
       c1707800 c03f5f54 c03f5f54 00000123 00000021 c03e8d08 c0426380 00000009 
       c0126932 00000000 00000046 c03e9980 c03e6000 0047b007 c01269bd 00000000 
Call Trace:
 [<f8a4b401>] nfulnl_timer+0x15/0x25 [nfnetlink_log]
 [<c012af49>] run_timer_softirq+0x10a/0x164
 [<c0126932>] __do_softirq+0x60/0xba
 [<c01269bd>] do_softirq+0x31/0x35
 [<c0104f6e>] do_IRQ+0x62/0x74
 [<c01036cb>] common_interrupt+0x23/0x28
 [<c0101018>] default_idle+0x0/0x3f
 [<c0101045>] default_idle+0x2d/0x3f
 [<c01010fa>] cpu_idle+0xa0/0xb9
 [<c03fb7f5>] start_kernel+0x1a8/0x1ac
 [<c03fb293>] unknown_bootoption+0x0/0x181
 =======================
Code: 5e 5f 5b 5e 5f 5d c3 53 89 c3 8d 40 1c 83 7b 1c 00 74 05 e8 2c ee 6d c7 83 7b 14 00 75 04 31 c0 eb 34 83 7b 10 01 76 09 8b 43 18 <66> c7 40 04 03 00 8b 53 34 8b 43 14 b9 40 00 00 00 e8 08 9a 84 
EIP: [<f8a4b3bf>] __nfulnl_send+0x24/0x51 [nfnetlink_log] SS:ESP 0068:c03f5f30
 <0>Kernel panic - not syncing: Fatal exception in interrupt
 <0>Rebooting in 5 seconds..

Panic no more!

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.7	2007-02-11 22:41:18.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 23:59:01.000000000 +0100
@@ -560,6 +560,7 @@ __build_packet_message(struct nfulnl_ins
 	}
 		
 	nlh->nlmsg_len = inst->skb->tail - old_tail;
+	inst->lastnlh = nlh;
 	return 0;
 
 nlmsg_failure:
