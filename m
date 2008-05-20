Return-Path: <linux-kernel-owner+w=401wt.eu-S932746AbYETOkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbYETOkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763640AbYETOkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:40:05 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:33805 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757535AbYETOkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:40:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Oops in fs_enet driver with preempt-rt
Date: Tue, 20 May 2008 09:40:30 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B046E728C@ismail.innsys.innovsys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Oops in fs_enet driver with preempt-rt
Thread-Index: Aci6h3OGhRkBaFRJS1aUcSwgWuuDOQ==
From: "Rune Torgersen" <runet@innovsys.com>
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I am trying to get preempt-rt (v2.6.25.4-rt1) to work on a Freescale
8280 CPU (arch/powerpc)

I get the follwing oops when trying to enable ethernet:
(looks like a null pointer dereference in
drivers/net/fs_enet/fs_enet-main.c:106)

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc0197efc
Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT Innovative Systems ApMax
Modules linked in:
NIP: c0197efc LR: c0197c48 CTR: c01986c4
REGS: df84de90 TRAP: 0300   Not tainted  (2.6.25.4-rt1)
MSR: 00009032 <EE,ME,IR,DR>  CR: 42004022  XER: 00000000
DAR: 00000000, DSISR: 20000000
TASK = df82ea70[7] 'sirq-net-rx/0' THREAD: df84c000
GPR00: e105a350 df84df40 df82ea70 df37f000 00000011 c034ed90 c034ed70
00000000
GPR08: 00000000 e105a340 00000000 00000009 0000df80 ffffffff 0fffd000
00000028
GPR16: 00400558 00800000 ffffffff df3e71e0 00000011 00000000 00000000
00000000
GPR24: df37f000 00000000 00000000 00000000 fffb9e82 0000012c 00000011
df37f5a0
NIP [c0197efc] fs_enet_rx_napi+0x2f0/0x3ac
LR [c0197c48] fs_enet_rx_napi+0x3c/0x3ac
Call Trace:
[df84df40] [c024a1b4] __spin_unlock+0x18/0x3c (unreliable)
[df84df80] [c01d9d28] net_rx_action+0x84/0x1ac
[df84dfa0] [c0022f18] ksoftirqd+0x158/0x25c
[df84dfd0] [c0033fa0] kthread+0x4c/0x88
[df84dff0] [c000fb34] kernel_thread+0x44/0x60
Instruction dump:
73202000 3b7b0008 41820008 837f00bc 813f00a0 7f03c378 81290034 7d2903a6
4e800421 7f96a000 409c00a8 7c0004ac <a01b0000> 0c000000 4c00012c
5419043e
---[ end trace c548f7dabfe5b3de ]---


0xc0197efc is in fs_enet_rx_napi (include/asm/io.h:124).
119             DEF_MMIO_OUT(name, u##size, __stringify(insn)"%U0%X0
%1,%0")
120     #define DEF_MMIO_OUT_LE(name, size, insn) \
121             DEF_MMIO_OUT(name, u##size, __stringify(insn)" %1,0,%2")
122
123     DEF_MMIO_IN_BE(in_8,     8, lbz);
124     DEF_MMIO_IN_BE(in_be16, 16, lhz);
125     DEF_MMIO_IN_BE(in_be32, 32, lwz);
126     DEF_MMIO_IN_LE(in_le16, 16, lhbrx);
127     DEF_MMIO_IN_LE(in_le32, 32, lwbrx);
128

0xc0197c48 is in fs_enet_rx_napi
(drivers/net/fs_enet/fs_enet-main.c:106).
101              * These get messed up if we get called due to a busy
condition.
102              */
103             bdp = fep->cur_rx;
104
105             /* clear RX status bits for napi*/
106             (*fep->ops->napi_clear_rx_event)(dev);
107
108             while (((sc = CBDR_SC(bdp)) & BD_ENET_RX_EMPTY) == 0) {
109                     curidx = bdp - fep->rx_bd_base;
110
