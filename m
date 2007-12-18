Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbXLRRO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbXLRRO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759026AbXLRROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:14:20 -0500
Received: from styx.suse.cz ([82.119.242.94]:43062 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757685AbXLRROU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:14:20 -0500
Date: Tue, 18 Dec 2007 18:14:17 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: Lockdep warning with netlink
Message-ID: <20071218171417.GF31091@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I'm getting the following lockdep warning on my test machine (running
reasonably recent kernel from -git):

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc3-g406f602d-dirty #28
-------------------------------------------------------
quota_nld/3253 is trying to acquire lock:
 (genl_mutex){--..}, at: [<c02ee382>] ctrl_dumpfamily+0x37/0xea

but task is already holding lock:
 (nlk->cb_mutex){--..}, at: [<c02ead8d>] netlink_dump+0x3a/0x16f

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (nlk->cb_mutex){--..}:
       [<c0130eff>] __lock_acquire+0xa12/0xbd9
       [<c01314a9>] lock_acquire+0x5f/0x78
       [<c033b9c7>] mutex_lock_nested+0xff/0x273
       [<c02ecb92>] netlink_dump_start+0xcb/0x13b
       [<c02ee2a2>] genl_rcv_msg+0xa3/0x14c
       [<c02ebc09>] netlink_rcv_skb+0x30/0x86
       [<c02ee4f9>] genl_rcv+0x1e/0x2d
       [<c02eb9dc>] netlink_unicast+0x19a/0x1f2
       [<c02ec5bb>] netlink_sendmsg+0x251/0x25d
       [<c02d4ecf>] sock_sendmsg+0xcc/0xe5
       [<c02d5039>] sys_sendmsg+0x151/0x1af
       [<c02d5e9f>] sys_socketcall+0x203/0x222
       [<c01026be>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

-> #0 (genl_mutex){--..}:
       [<c0130df3>] __lock_acquire+0x906/0xbd9
       [<c01314a9>] lock_acquire+0x5f/0x78
       [<c033b9c7>] mutex_lock_nested+0xff/0x273
       [<c02ee382>] ctrl_dumpfamily+0x37/0xea
       [<c02eada5>] netlink_dump+0x52/0x16f
       [<c02ec0f8>] netlink_recvmsg+0x15f/0x21d
       [<c02d4dea>] sock_recvmsg+0xd6/0xef
       [<c02d5897>] sys_recvmsg+0xf8/0x188
       [<c02d5eb4>] sys_socketcall+0x218/0x222
       [<c01026be>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by quota_nld/3253:
 #0:  (nlk->cb_mutex){--..}, at: [<c02ead8d>] netlink_dump+0x3a/0x16f

stack backtrace:
 [<c0103707>] show_trace_log_lvl+0x1a/0x2f
 [<c010409a>] show_trace+0x12/0x14
 [<c010418c>] dump_stack+0x16/0x18
 [<c012f5e1>] print_circular_bug_tail+0x5f/0x68
 [<c0130df3>] __lock_acquire+0x906/0xbd9
 [<c01314a9>] lock_acquire+0x5f/0x78
 [<c033b9c7>] mutex_lock_nested+0xff/0x273
 [<c02ee382>] ctrl_dumpfamily+0x37/0xea
 [<c02eada5>] netlink_dump+0x52/0x16f
 [<c02ec0f8>] netlink_recvmsg+0x15f/0x21d
 [<c02d4dea>] sock_recvmsg+0xd6/0xef
 [<c02d5897>] sys_recvmsg+0xf8/0x188
 [<c02d5eb4>] sys_socketcall+0x218/0x222
 [<c01026be>] sysenter_past_esp+0x5f/0xa5
 =======================

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
