Return-Path: <linux-kernel-owner+w=401wt.eu-S1752200AbXLaROX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbXLaROX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 12:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXLaROQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 12:14:16 -0500
Received: from mailhub.hp.com ([192.151.27.10]:50569 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXLaROP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 12:14:15 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: James Morris <jmorris@namei.org>
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
Date: Mon, 31 Dec 2007 12:13:32 -0500
User-Agent: KMail/1.9.7
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov
References: <3281504256.5618888@mail.hp.com> <Xine.LNX.4.64.0712270848260.19279@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0712270848260.19279@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311213.32515.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 December 2007 4:52:03 pm James Morris wrote:
> On Thu, 26 Dec 2007, Paul Moore wrote:
> > As James said I'm away right now and computer access is limited.
> > However, I'm stuck in the airport right now and spent some time looking
> > at the code ... Based on what has been found so far I wonder if the
> > problem isn't a race but a problem of skb->iif never being initialized
> > correctly?  To my untrained eye it looks like __netdev_alloc_skb()
> > should be setting skb->iif (like it does for skb->dev) but it currently
> > doesn't.
>
> ->iif will be zeroed during skb allocation, then set during
> netif_receive_skb().

I was able to reproduce this bug this morning by running avahi as James did 
and did a little more digging.  I don't have a fix yet, but thought I would 
pass along what I've found in case this triggers a moment of clarity to 
someone out there ...

The skb->iif value appears to be messed up as early as netif_receive_skb(), in 
my case it is set to 196611 (trust me, I don't have that many interfaces in 
my test machine) which causes the ->iif initialization code in 
netif_receive_skb() to be skipped because ->iif is greater than zero.  This 
particular packet is locally generated and locally consumed.

Hopefully I'll have a fix later this afternoon but if someone has a bright 
idea I'd love to hear it.  Backtrace is below:

WARNING: at security/selinux/hooks.c:3805 selinux_socket_sock_rcv_skb()
Pid: 1454, comm: avahi-daemon Not tainted 2.6.24-rc5 #4
 [<c04aac4e>] selinux_socket_sock_rcv_skb+0x96/0x3ac
 [<c041bddf>] printk+0x1b/0x1f
 [<c04349c9>] __print_symbol+0x21/0x2a
 [<c04a5ae8>] security_sock_rcv_skb+0xc/0xd
 [<c05822c3>] sock_queue_rcv_skb+0x29/0xce
 [<d08f34e9>] ipt_do_table+0x423/0x466 [ip_tables]
 [<c05bf114>] udp_queue_rcv_skb+0x199/0x201
 [<c04caf24>] vsnprintf+0x283/0x450
 [<d08f93e8>] nf_conntrack_in+0x307/0x3d7 [nf_conntrack]
 [<c05bf56a>] __udp4_lib_rcv+0x3ee/0x7a7
 [<d08fc26f>] nf_ct_deliver_cached_events+0x8/0x90 [nf_conntrack]
 [<d0984158>] ipv4_confirm+0x34/0x39 [nf_conntrack_ipv4]
 [<c059e99a>] nf_iterate+0x3a/0x6e
 [<c05a38d3>] ip_local_deliver_finish+0x0/0x191
 [<c05a38d3>] ip_local_deliver_finish+0x0/0x191
 [<c05a39e5>] ip_local_deliver_finish+0x112/0x191
 [<c05a38b4>] ip_rcv_finish+0x254/0x273
 [<c05a3660>] ip_rcv_finish+0x0/0x273
 [<c05a3cd3>] ip_rcv+0x1cc/0x1fb
 [<c05a3660>] ip_rcv_finish+0x0/0x273
 [<c05a3b07>] ip_rcv+0x0/0x1fb
 [<c0587fd7>] netif_receive_skb+0x37d/0x397
 [<c058a111>] process_backlog+0x60/0x92
 [<c0589e16>] net_rx_action+0x67/0x118
 [<c041f164>] __do_softirq+0x35/0x75
 [<c0404f02>] do_softirq+0x3e/0x8d
 [<c041f06e>] local_bh_enable+0x6b/0x79
 [<d08fc26f>] nf_ct_deliver_cached_events+0x8/0x90 [nf_conntrack]
 [<d0984158>] ipv4_confirm+0x34/0x39 [nf_conntrack_ipv4]
 [<d0984124>] ipv4_confirm+0x0/0x39 [nf_conntrack_ipv4]
 [<c059e99a>] nf_iterate+0x3a/0x6e
 [<c05a6ca9>] ip_finish_output+0x0/0x208
 [<c059ea3f>] nf_hook_slow+0x4d/0xb5
 [<c05a6ca9>] ip_finish_output+0x0/0x208
 [<c05a7cb5>] ip_mc_output+0x172/0x18b
 [<c05a6ca9>] ip_finish_output+0x0/0x208
 [<c05a5b79>] ip_push_pending_frames+0x2be/0x311
 [<c05a5790>] dst_output+0x0/0x7
 [<c05bedb6>] udp_push_pending_frames+0x298/0x2d7
 [<c05bfd8b>] udp_sendmsg+0x459/0x55c
 [<c05c4bf9>] inet_sendmsg+0x3b/0x45
 [<c057eead>] sock_sendmsg+0xc8/0xe3
 [<c0429863>] autoremove_wake_function+0x0/0x33
 [<c057eead>] sock_sendmsg+0xc8/0xe3
 [<c0429863>] autoremove_wake_function+0x0/0x33
 [<c04cbb78>] copy_from_user+0x32/0x5e
 [<c04cbb78>] copy_from_user+0x32/0x5e
 [<c057f05a>] sys_sendmsg+0x192/0x1f7
 [<c041eb1b>] current_fs_time+0x13/0x15
 [<c0470b14>] file_update_time+0x21/0x61
 [<c04663f2>] pipe_write+0x3cc/0x3d8
 [<c0460e91>] do_sync_write+0x0/0x109
 [<c0460f57>] do_sync_write+0xc6/0x109
 [<c0429863>] autoremove_wake_function+0x0/0x33
 [<c058029c>] sys_socketcall+0x240/0x261
 [<c0403c72>] syscall_call+0x7/0xb
 =======================

-- 
paul moore
linux security @ hp
