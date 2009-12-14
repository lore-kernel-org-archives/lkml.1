Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbZLNRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbZLNRwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbZLNRwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:52:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:58553 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbZLNRwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:52:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ljcv5nOSyF56e+b5ryXjkzjRuao3IULwf+3tpTzdAcDQiKBSSwl5JmZC6QpEsOhQ2M
         awPvm1rdh9H5jLA9Uak8tibPIXl7Os2IrZYoDEDp2ME7KESL6Yr5621qk/YMlqeZZF7n
         cSP2f03MAzxQsBjvQK1OolTms5cGVD33eC/9Y=
Date: Mon, 14 Dec 2009 18:52:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Neil Horman <nhorman@tuxdriver.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: packet_sendmsg_spkt sleeping from invalid context
Message-ID: <20091214175211.GA5102@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't know if it has been reported already.
I get the following warning on boot, with latest upstream tree:

[   32.776502] sched: BUG: sleeping function called from invalid context at mm/slab.c:3032
[   32.802173] sched: in_atomic(): 1, irqs_disabled(): 0, pid: 3555, name: dhclient3
[   32.821141] 1 lock held by dhclient3/3555:
[   32.821147]  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff815d177d>] packet_sendmsg_spkt+0x7d/0x2c0
[   32.821174] Pid: 3555, comm: dhclient3 Tainted: G        W  2.6.32-tip+ #134
[   32.821181] Call Trace:
[   32.821194]  [<ffffffff810811c3>] ? __debug_show_held_locks+0x13/0x30
[   32.821207]  [<ffffffff8103d6b8>] __might_sleep+0x118/0x140
[   32.821219]  [<ffffffff81110c23>] kmem_cache_alloc+0x173/0x190
[   32.821231]  [<ffffffff815483d9>] __alloc_skb+0x49/0x170
[   32.821241]  [<ffffffff81542238>] sock_wmalloc+0x38/0x80
[   32.821250]  [<ffffffff815d182b>] packet_sendmsg_spkt+0x12b/0x2c0
[   32.821260]  [<ffffffff815d177d>] ? packet_sendmsg_spkt+0x7d/0x2c0
[   32.821272]  [<ffffffff8153ded7>] sock_sendmsg+0x127/0x140
[   32.821285]  [<ffffffff8106f4a0>] ? autoremove_wake_function+0x0/0x40
[   32.821297]  [<ffffffff810f467b>] ? might_fault+0x7b/0xd0
[   32.821306]  [<ffffffff810f467b>] ? might_fault+0x7b/0xd0
[   32.821318]  [<ffffffff815401aa>] ? move_addr_to_kernel+0x6a/0x70
[   32.821328]  [<ffffffff8154029f>] sys_sendto+0xef/0x120
[   32.821340]  [<ffffffff81131479>] ? mntput_no_expire+0x29/0x110
[   32.821355]  [<ffffffff810027db>] system_call_fastpath+0x16/0x1b

