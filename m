Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYACW6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYACW6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYACW6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:58:15 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:33957 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbYACW6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:58:14 -0500
Date: Thu, 3 Jan 2008 23:58:06 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: linux-kernel@vger.kernel.org
cc: jfs-discussion@lists.sourceforge.net
Subject: 2.6.24-rc6: possible recursive locking detected
Message-ID: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

a few minutes after upgrading from -rc5 to -rc6 I got:

[ 1310.670986] =============================================
[ 1310.671690] [ INFO: possible recursive locking detected ]
[ 1310.672097] 2.6.24-rc6 #1
[ 1310.672421] ---------------------------------------------
[ 1310.672828] FahCore_a0.exe/3692 is trying to acquire lock:
[ 1310.673238]  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
[ 1310.673869]
[ 1310.673870] but task is already holding lock:
[ 1310.674567]  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
[ 1310.675267]
[ 1310.675268] other info that might help us debug this:
[ 1310.675952] 5 locks held by FahCore_a0.exe/3692:
[ 1310.676334]  #0:  (rcu_read_lock){..--}, at: [<c038b620>] net_rx_action+0x60/0x1b0
[ 1310.677251]  #1:  (rcu_read_lock){..--}, at: [<c0388d60>] netif_receive_skb+0x100/0x470
[ 1310.677924]  #2:  (rcu_read_lock){..--}, at: [<c03a7fb2>] ip_local_deliver_finish+0x32/0x210
[ 1310.678460]  #3:  (clock-AF_INET){-.-?}, at: [<c038164e>] sock_def_readable+0x1e/0x80
[ 1310.679250]  #4:  (&q->lock){++..}, at: [<c011544b>] __wake_up+0x1b/0x50
[ 1310.680151]
[ 1310.680152] stack backtrace:
[ 1310.680772] Pid: 3692, comm: FahCore_a0.exe Not tainted 2.6.24-rc6 #1
[ 1310.681209]  [<c01038aa>] show_trace_log_lvl+0x1a/0x30
[ 1310.681659]  [<c0104322>] show_trace+0x12/0x20
[ 1310.682085]  [<c0104cba>] dump_stack+0x6a/0x70
[ 1310.682512]  [<c0138ec1>] __lock_acquire+0x971/0x10c0
[ 1310.682961]  [<c013966e>] lock_acquire+0x5e/0x80
[ 1310.683392]  [<c0419b78>] _spin_lock_irqsave+0x38/0x50
[ 1310.683914]  [<c011544b>] __wake_up+0x1b/0x50
[ 1310.684337]  [<c018e2ba>] ep_poll_safewake+0x9a/0xc0
[ 1310.684822]  [<c018f11b>] ep_poll_callback+0x8b/0xe0
[ 1310.685265]  [<c0114418>] __wake_up_common+0x48/0x70
[ 1310.685712]  [<c0115467>] __wake_up+0x37/0x50
[ 1310.686136]  [<c03816aa>] sock_def_readable+0x7a/0x80
[ 1310.686579]  [<c0381c2b>] sock_queue_rcv_skb+0xeb/0x150
[ 1310.687028]  [<c03c7d99>] udp_queue_rcv_skb+0x139/0x2a0
[ 1310.687554]  [<c03c81f1>] __udp4_lib_rcv+0x2f1/0x7e0
[ 1310.687996]  [<c03c86f2>] udp_rcv+0x12/0x20
[ 1310.688415]  [<c03a80a5>] ip_local_deliver_finish+0x125/0x210
[ 1310.688881]  [<c03a84ed>] ip_local_deliver+0x2d/0x90
[ 1310.689323]  [<c03a7d6b>] ip_rcv_finish+0xeb/0x300
[ 1310.689760]  [<c03a8425>] ip_rcv+0x195/0x230
[ 1310.690182]  [<c0388fdc>] netif_receive_skb+0x37c/0x470
[ 1310.690632]  [<c038ba39>] process_backlog+0x69/0xc0
[ 1310.691175]  [<c038b6f7>] net_rx_action+0x137/0x1b0
[ 1310.691681]  [<c011e5c2>] __do_softirq+0x52/0xb0
[ 1310.692006]  [<c0104e94>] do_softirq+0x94/0xe0
[ 1310.692301]  =======================


This is a single CPU machine, and the box was quite busy due to disk I/O 
(load 6-8). The machine continues to run and all is well now. Even the 
application mentioned above (FahCore_a0.exe) is running fine 
("Folding@Home", cpu bound). The binary is located on an jfs filesystem, 
which was also under heavy I/O. Can someone tell me why the backtrace 
shows so much net* stuff? There was not much net I/O...

more details and .config: http://nerdbynature.de/bits/2.6.24-rc6

Thanks,
Christian.
-- 
BOFH excuse #312:

incompatible bit-registration operators
