Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYHCSfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYHCSfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 14:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYHCSfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 14:35:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53453 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYHCSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 14:35:05 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5352"; a="5277830"
Message-ID: <4895FA6F.8050209@qualcomm.com>
Date: Sun, 03 Aug 2008 11:35:27 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
       David Miller <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Circular locking (rtnl_mutex & _xmit_IEEE80211) during suspend
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this lockdep complaint yesterday

--

wlan0: disassociating by local choice (reason=3)

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-rc1 #29
---------------------------------------------
NetworkManager/1744 is trying to acquire lock:
 (_xmit_IEEE80211#2){-+..}, at: [<ffffffff804b18ea>] dev_deactivate+0x9a/0x150

but task is already holding lock:
 (_xmit_IEEE80211#2){-+..}, at: [<ffffffff804b18ea>] dev_deactivate+0x9a/0x150

other info that might help us debug this:
2 locks held by NetworkManager/1744:
 #0:  (rtnl_mutex){--..}, at: [<ffffffff804ac8fa>] rtnetlink_rcv+0x1a/0x40
 #1:  (_xmit_IEEE80211#2){-+..}, at: [<ffffffff804b18ea>]
dev_deactivate+0x9a/0x150

stack backtrace:
Pid: 1744, comm: NetworkManager Not tainted 2.6.27-rc1 #29

Call Trace:
 [<ffffffff80261dcf>] __lock_acquire+0x92f/0x1020
 [<ffffffff80260dfd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80260dd1>] ? trace_hardirqs_on_caller+0xe1/0x100
 [<ffffffff804b15cb>] ? dev_deactivate_queue+0x4b/0x60
 [<ffffffff802406ed>] ? local_bh_disable+0xd/0x10
 [<ffffffff8026251b>] lock_acquire+0x5b/0x80
 [<ffffffff804b18ea>] ? dev_deactivate+0x9a/0x150
 [<ffffffff80532f6f>] _spin_lock+0x2f/0x40
 [<ffffffff804b18ea>] dev_deactivate+0x9a/0x150
 [<ffffffff804a2955>] dev_close+0x55/0xb0
 [<ffffffff8050777d>] ieee80211_stop+0x36d/0x450
 [<ffffffff804a2966>] dev_close+0x66/0xb0
 [<ffffffff804a2541>] dev_change_flags+0xa1/0x1e0
 [<ffffffff804ab6ac>] do_setlink+0x20c/0x3a0
 [<ffffffff805366e0>] ? sub_preempt_count+0x80/0xd0
 [<ffffffff80532ce0>] ? _read_unlock+0x30/0x60
 [<ffffffff804aba0d>] rtnl_setlink+0x10d/0x150
 [<ffffffff804acaad>] rtnetlink_rcv_msg+0x18d/0x240
 [<ffffffff804ac920>] ? rtnetlink_rcv_msg+0x0/0x240
 [<ffffffff804b52b9>] netlink_rcv_skb+0x89/0xb0
 [<ffffffff804ac909>] rtnetlink_rcv+0x29/0x40
 [<ffffffff804b4e59>] ? netlink_sendmsg+0x139/0x2d0
 [<ffffffff804b4d0d>] netlink_unicast+0x2cd/0x2e0
 [<ffffffff8049b9de>] ? __alloc_skb+0x6e/0x150
 [<ffffffff804b4ef3>] netlink_sendmsg+0x1d3/0x2d0
 [<ffffffff80493a0f>] sock_sendmsg+0xdf/0x110
 [<ffffffff80251a70>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80260dfd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80260dd1>] ? trace_hardirqs_on_caller+0xe1/0x100
 [<ffffffff80260dfd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff802b7c2e>] ? fget_light+0xce/0xe0
 [<ffffffff80492a8b>] ? move_addr_to_kernel+0x2b/0x40
 [<ffffffff8049c9dc>] ? verify_iovec+0x3c/0xd0
 [<ffffffff80493bc9>] sys_sendmsg+0x189/0x320
 [<ffffffff80494807>] ? move_addr_to_user+0x67/0x80
 [<ffffffff80493015>] ? sockfd_lookup_light+0x25/0x90
 [<ffffffff80493e5f>] ? sys_sendto+0xff/0x120
 [<ffffffff80260dd1>] ? trace_hardirqs_on_caller+0xe1/0x100
 [<ffffffff805327d6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b

iwl3945 0000:0c:00.0: PCI INT A disabled
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
