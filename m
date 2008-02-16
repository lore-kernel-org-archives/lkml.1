Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbYBPS1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbYBPS1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYBPS1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:27:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:61883 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbYBPS1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:27:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HpexP6OCCDgjzmiDs5sBB1hAx1IbZZWPwiKluHBbFxhXqKGssu7fUzYEXxS+saHkXjjrxdVQ8iA9nGDcnuEkpRuOreWPZD45EXHbZEbic0V1Ur6DZxu5byIwOmPssAjwpq1AuIn5Wl/iSJIArZfk93tAjppbqYS9N7NQl9Q6YIM=
Message-ID: <5a4c581d0802161027yf1cfefctbc82f08196c1e10c@mail.gmail.com>
Date: Sat, 16 Feb 2008 19:27:42 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc2: wpa_supplicant BUGs kernel in rwlock recursion
In-Reply-To: <5a4c581d0802160914m7778cf3av5c01c54374f26f5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0802160914m7778cf3av5c01c54374f26f5b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2008 6:14 PM, Alessandro Suardi <alessandro.suardi@gmail.com> wrote:
> Fedora 8 / x86, Dell D610, ipw2200
>
> testcase:

Forgot to mention that this is 100% reproducable.

> 1. boot into runlevel 3
> 2. log on as root on tty1
> 3. start wpa_supplicant
>
> 2.6.25-rc1-git4 is okay
> 2.6.25-rc2 BUGs dumping stack on console, but nothing gets in /var/log/messages
> 2.6.25-rc2-git1 BUGs dumping stack on console, ONLY this in /var/log/messages:
>
> Feb 16 16:51:49 sandman kernel: BUG: rwlock recursion on CPU#0,
> wpa_supplicant/2342, c0440220
>
> Will now look for changes between -rc1-git4 and -rc2... .config files
>  are the same for the two kernels, and available if needed.
>
> I might be able to provide full stack via netconsole, but there's some work
>  to do to set it up.

OK, here goes netconsole output, hoping GMail doesn't munge it too much...

Feb 16 20:13:01 sandman kernel: BUG: rwlock recursion on CPU#0,
wpa_supplicant/2243, c0440220
Feb 16 20:13:01 sandman kernel: Pid: 2243, comm: wpa_supplicant Not
tainted 2.6.25-rc2-git1 #2
Feb 16 20:13:01 sandman kernel:  [<c01df8e8>] rwlock_bug+0x36/0x40
Feb 16 20:13:01 sandman kernel:  [<c01dfbe2>] _raw_write_lock+0x2e/0x54
Feb 16 20:13:01 sandman kernel:  [<c032857f>] _write_lock_bh+0x12/0x15
Feb 16 20:13:01 sandman kernel:  [<c02b5506>] do_setlink+0x2ad/0x325
Feb 16 20:13:01 sandman kernel:  [<c02b6505>] rtnl_setlink+0xc9/0xe7
Feb 16 20:13:01 sandman kernel:  [<c02b643c>] ? rtnl_setlink+0x0/0xe7
Feb 16 20:13:01 sandman kernel:  [<c02b62b4>] rtnetlink_rcv_msg+0x195/0x1af
Feb 16 20:13:01 sandman kernel:  [<c02b611f>] ? rtnetlink_rcv_msg+0x0/0x1af
Feb 16 20:13:01 sandman kernel:  [<c02bb98c>] netlink_rcv_skb+0x30/0x82
Feb 16 20:13:01 sandman kernel:  [<c02b6117>] rtnetlink_rcv+0x17/0x1f
Feb 16 20:13:01 sandman kernel:  [<c02bb76f>] netlink_unicast+0x1b8/0x21c
Feb 16 20:13:01 sandman kernel:  [<c02bbf3a>] netlink_sendmsg+0x25b/0x268
Feb 16 20:13:01 sandman kernel:  [<c02a4801>] sock_sendmsg+0xdd/0xf8
Feb 16 20:13:01 sandman kernel:  [<c0125a15>] ?
autoremove_wake_function+0x0/0x33
Feb 16 20:13:01 sandman kernel:  [<c01604e3>] ? __link_path_walk+0x97c/0xa96
Feb 16 20:13:01 sandman kernel:  [<c02a503d>] sys_sendto+0xa4/0xc3
Feb 16 20:13:01 sandman kernel:  [<c013d06b>] ? find_lock_page+0x6e/0x75
Feb 16 20:13:01 sandman kernel:  [<c013ec28>] ? filemap_fault+0x18f/0x2ee
Feb 16 20:13:01 sandman kernel:  [<c013cf3c>] ? unlock_page+0x24/0x27
Feb 16 20:13:01 sandman kernel:  [<c01471c5>] ? __do_fault+0x303/0x341
Feb 16 20:13:01 sandman kernel:  [<c016897e>] ? generic_drop_inode+0x133/0x137
Feb 16 20:13:01 sandman kernel:  [<c02a5074>] sys_send+0x18/0x1a
Feb 16 20:13:01 sandman kernel:  [<c02a576e>] sys_socketcall+0xe6/0x186
Feb 16 20:13:01 sandman kernel:  [<c0103c32>] syscall_call+0x7/0xb
Feb 16 20:13:01 sandman kernel:  =======================
Feb 16 20:13:01 sandman kernel: BUG: sleeping function called from
invalid context at mm/slab.c:3055
Feb 16 20:13:01 sandman kernel: in_atomic():1, irqs_disabled():0
Feb 16 20:13:01 sandman kernel: Pid: 2243, comm: wpa_supplicant Not
tainted 2.6.25-rc2-git1 #2
Feb 16 20:13:01 sandman kernel:  [<c01116cc>] __might_sleep+0x97/0x9e
Feb 16 20:13:01 sandman kernel:  [<c0155d14>] kmem_cache_alloc+0x22/0x8e
Feb 16 20:13:01 sandman kernel:  [<c02a99b2>] __alloc_skb+0x2c/0xf8
Feb 16 20:13:01 sandman kernel:  [<c02b5e80>] rtmsg_ifinfo+0x36/0xb4
Feb 16 20:13:01 sandman kernel:  [<c02ae11f>] netdev_state_change+0x29/0x2c
Feb 16 20:13:01 sandman kernel:  [<c02b5567>] do_setlink+0x30e/0x325
Feb 16 20:13:01 sandman kernel:  [<c02b6505>] rtnl_setlink+0xc9/0xe7
Feb 16 20:13:01 sandman kernel:  [<c02b643c>] ? rtnl_setlink+0x0/0xe7
Feb 16 20:13:01 sandman kernel:  [<c02b62b4>] rtnetlink_rcv_msg+0x195/0x1af
Feb 16 20:13:01 sandman kernel:  [<c02b611f>] ? rtnetlink_rcv_msg+0x0/0x1af
Feb 16 20:13:01 sandman kernel:  [<c02bb98c>] netlink_rcv_skb+0x30/0x82
Feb 16 20:13:01 sandman kernel:  [<c02b6117>] rtnetlink_rcv+0x17/0x1f
Feb 16 20:13:01 sandman kernel:  [<c02bb76f>] netlink_unicast+0x1b8/0x21c
Feb 16 20:13:01 sandman kernel:  [<c02bbf3a>] netlink_sendmsg+0x25b/0x268
Feb 16 20:13:01 sandman kernel:  [<c02a4801>] sock_sendmsg+0xdd/0xf8
Feb 16 20:13:01 sandman kernel:  [<c0125a15>] ?
autoremove_wake_function+0x0/0x33
Feb 16 20:13:01 sandman kernel:  [<c01604e3>] ? __link_path_walk+0x97c/0xa96
Feb 16 20:13:01 sandman kernel:  [<c02a503d>] sys_sendto+0xa4/0xc3
Feb 16 20:13:01 sandman kernel:  [<c013d06b>] ? find_lock_page+0x6e/0x75
Feb 16 20:13:01 sandman kernel:  [<c013ec28>] ? filemap_fault+0x18f/0x2ee
Feb 16 20:13:01 sandman kernel:  [<c013cf3c>] ? unlock_page+0x24/0x27
Feb 16 20:13:01 sandman kernel:  [<c01471c5>] ? __do_fault+0x303/0x341
Feb 16 20:13:01 sandman kernel:  [<c016897e>] ? generic_drop_inode+0x133/0x137
Feb 16 20:13:01 sandman kernel:  [<c02a5074>] sys_send+0x18/0x1a
Feb 16 20:13:01 sandman kernel:  [<c02a576e>] sys_socketcall+0xe6/0x186
Feb 16 20:13:01 sandman kernel:  [<c0103c32>] syscall_call+0x7/0xb
Feb 16 20:13:01 sandman kernel:  =======================
Feb 16 20:13:01 sandman kernel: BUG: scheduling while atomic:
wpa_supplicant/2243/0x10000200
Feb 16 20:13:01 sandman kernel: Pid: 2243, comm: wpa_supplicant Not
tainted 2.6.25-rc2-git1 #2
Feb 16 20:13:01 sandman kernel:  [<c0113c3b>] __schedule_bug+0x42/0x47
Feb 16 20:13:01 sandman kernel:  [<c0326be2>] schedule+0x42/0x24c
Feb 16 20:13:01 sandman kernel:  [<c0113c65>] __cond_resched+0x25/0x3b
Feb 16 20:13:01 sandman kernel:  [<c0326e50>] _cond_resched+0x24/0x2f
Feb 16 20:13:01 sandman kernel:  [<c0155d19>] kmem_cache_alloc+0x27/0x8e
Feb 16 20:13:01 sandman kernel:  [<c02a99b2>] __alloc_skb+0x2c/0xf8
Feb 16 20:13:01 sandman kernel:  [<c02b5e80>] rtmsg_ifinfo+0x36/0xb4
Feb 16 20:13:01 sandman kernel:  [<c02ae11f>] netdev_state_change+0x29/0x2c
Feb 16 20:13:01 sandman kernel:  [<c02b5567>] do_setlink+0x30e/0x325
Feb 16 20:13:01 sandman kernel:  [<c02b6505>] rtnl_setlink+0xc9/0xe7
Feb 16 20:13:01 sandman kernel:  [<c02b643c>] ? rtnl_setlink+0x0/0xe7
Feb 16 20:13:01 sandman kernel:  [<c02b62b4>] rtnetlink_rcv_msg+0x195/0x1af
Feb 16 20:13:01 sandman kernel:  [<c02b611f>] ? rtnetlink_rcv_msg+0x0/0x1af
Feb 16 20:13:01 sandman kernel:  [<c02bb98c>] netlink_rcv_skb+0x30/0x82
Feb 16 20:13:01 sandman kernel:  [<c02b6117>] rtnetlink_rcv+0x17/0x1f
Feb 16 20:13:01 sandman kernel:  [<c02bb76f>] netlink_unicast+0x1b8/0x21c
Feb 16 20:13:01 sandman kernel:  [<c02bbf3a>] netlink_sendmsg+0x25b/0x268
Feb 16 20:13:01 sandman kernel:  [<c02a4801>] sock_sendmsg+0xdd/0xf8
Feb 16 20:13:01 sandman kernel:  [<c0125a15>] ?
autoremove_wake_function+0x0/0x33
Feb 16 20:13:01 sandman kernel:  [<c01604e3>] ? __link_path_walk+0x97c/0xa96
Feb 16 20:13:01 sandman kernel:  [<c02a503d>] sys_sendto+0xa4/0xc3
Feb 16 20:13:01 sandman kernel:  [<c013d06b>] ? find_lock_page+0x6e/0x75
Feb 16 20:13:01 sandman kernel:  [<c013ec28>] ? filemap_fault+0x18f/0x2ee
Feb 16 20:13:01 sandman kernel:  [<c013cf3c>] ? unlock_page+0x24/0x27
Feb 16 20:13:01 sandman kernel:  [<c01471c5>] ? __do_fault+0x303/0x341
Feb 16 20:13:01 sandman kernel:  [<c016897e>] ? generic_drop_inode+0x133/0x137
Feb 16 20:13:01 sandman kernel:  [<c02a5074>] sys_send+0x18/0x1a
Feb 16 20:13:01 sandman kernel:  [<c02a576e>] sys_socketcall+0xe6/0x186
Feb 16 20:13:01 sandman kernel:  [<c0103c32>] syscall_call+0x7/0xb
Feb 16 20:13:01 sandman kernel:  =======================
Feb 16 20:13:01 sandman kernel: BUG: scheduling while atomic:
wpa_supplicant/2243/0x10000200
Feb 16 20:13:01 sandman kernel: Pid: 2243, comm: wpa_supplicant Not
tainted 2.6.25-rc2-git1 #2
Feb 16 20:13:01 sandman kernel:  [<c0113c3b>] __schedule_bug+0x42/0x47
Feb 16 20:13:01 sandman kernel:  [<c0326be2>] schedule+0x42/0x24c
Feb 16 20:13:01 sandman kernel:  [<c0113c65>] __cond_resched+0x25/0x3b
Feb 16 20:13:01 sandman kernel:  [<c0326e50>] _cond_resched+0x24/0x2f
Feb 16 20:13:01 sandman kernel:  [<c03277b2>] mutex_lock+0x1a/0x24
Feb 16 20:13:01 sandman kernel:  [<c02af87e>] netdev_run_todo+0x13/0x1d9
Feb 16 20:13:01 sandman kernel:  [<c02b60ef>] rtnl_unlock+0x12/0x14
Feb 16 20:13:01 sandman kernel:  [<c02b611c>] rtnetlink_rcv+0x1c/0x1f
Feb 16 20:13:01 sandman kernel:  [<c02bb76f>] netlink_unicast+0x1b8/0x21c
Feb 16 20:13:01 sandman kernel:  [<c02bbf3a>] netlink_sendmsg+0x25b/0x268
Feb 16 20:13:01 sandman kernel:  [<c02a4801>] sock_sendmsg+0xdd/0xf8
Feb 16 20:13:01 sandman kernel:  [<c0125a15>] ?
autoremove_wake_function+0x0/0x33
Feb 16 20:13:01 sandman kernel:  [<c01604e3>] ? __link_path_walk+0x97c/0xa96
Feb 16 20:13:01 sandman kernel:  [<c02a503d>] sys_sendto+0xa4/0xc3
Feb 16 20:13:01 sandman kernel:  [<c013d06b>] ? find_lock_page+0x6e/0x75
Feb 16 20:13:01 sandman kernel:  [<c013ec28>] ? filemap_fault+0x18f/0x2ee
Feb 16 20:13:01 sandman kernel:  [<c013cf3c>] ? unlock_page+0x24/0x27
Feb 16 20:13:01 sandman kernel:  [<c01471c5>] ? __do_fault+0x303/0x341
Feb 16 20:13:01 sandman kernel:  [<c016897e>] ? generic_drop_inode+0x133/0x137
Feb 16 20:13:01 sandman kernel:  [<c02a5074>] sys_send+0x18/0x1a
Feb 16 20:13:01 sandman kernel:  [<c02a576e>] sys_socketcall+0xe6/0x186
Feb 16 20:13:01 sandman kernel:  [<c0103c32>] syscall_call+0x7/0xb
Feb 16 20:13:01 sandman kernel:  =======================
Feb 16 20:13:01 sandman kernel: wpa_supplicant[2243]: segfault at
8074760 ip 08074760 sp bfcf7e4c error 4
Feb 16 20:13:01 sandman kernel: BUG: scheduling while atomic:
wpa_supplicant/2243/0x00000200
Feb 16 20:13:01 sandman kernel: Pid: 2243, comm: wpa_supplicant Not
tainted 2.6.25-rc2-git1 #2
Feb 16 20:13:01 sandman kernel:  [<c0113c3b>] __schedule_bug+0x42/0x47
Feb 16 20:13:01 sandman kernel:  [<c0326be2>] schedule+0x42/0x24c
Feb 16 20:13:01 sandman kernel:  [<c010edd6>] ? do_page_fault+0x0/0x4be
Feb 16 20:13:01 sandman kernel:  [<c0103cae>] work_resched+0x5/0x16
Feb 16 20:13:01 sandman kernel:  =======================
Feb 16 20:13:01 sandman kernel: BUG: scheduling while atomic:
wpa_supplicant/2243/0x10000200
Feb 16 20:13:01 sandman kernel: Pid: 2243, comm: wpa_supplicant Not
tainted 2.6.25-rc2-git1 #2
Feb 16 20:13:01 sandman kernel:  [<c0113c3b>] __schedule_bug+0x42/0x47
Feb 16 20:13:01 sandman kernel:  [<c0326be2>] schedule+0x42/0x24c
Feb 16 20:13:01 sandman kernel:  [<c0113c65>] __cond_resched+0x25/0x3b
Feb 16 20:13:01 sandman kernel:  [<c0326e50>] _cond_resched+0x24/0x2f
Feb 16 20:13:01 sandman kernel:  [<c0327aba>] down_write+0x1a/0x30
Feb 16 20:13:01 sandman kernel:  [<c015cbd7>] do_coredump+0x8e/0x6ff
Feb 16 20:13:01 sandman kernel:  [<c02b9896>] ? netpoll_send_udp+0x252/0x25c
Feb 16 20:13:01 sandman kernel:  [<c0328561>] ? _spin_unlock+0x8/0xa
Feb 16 20:13:01 sandman kernel:  [<c01d0105>] ? _atomic_dec_and_lock+0x25/0x30
Feb 16 20:13:01 sandman kernel:  [<c011e089>] ? __sigqueue_free+0x2e/0x31
Feb 16 20:13:01 sandman kernel:  [<c011e43d>] ? __dequeue_signal+0xf3/0x14f
Feb 16 20:13:01 sandman kernel:  [<c011eaa4>] ? recalc_sigpending+0xd/0x2d
Feb 16 20:13:01 sandman kernel:  [<c011f9ce>] ? dequeue_signal+0x103/0x11f
Feb 16 20:13:01 sandman kernel:  [<c011fd6b>] get_signal_to_deliver+0x2ad/0x2d8
Feb 16 20:13:01 sandman kernel:  [<c010edd6>] ? do_page_fault+0x0/0x4be
Feb 16 20:13:01 sandman kernel:  [<c0103273>] do_notify_resume+0x94/0x754
Feb 16 20:13:01 sandman kernel:  [<c010edd6>] ? do_page_fault+0x0/0x4be
Feb 16 20:13:01 sandman kernel:  [<c01d2cb9>] ? rb_insert_color+0x99/0xbc
Feb 16 20:13:01 sandman kernel:  [<c0110f01>] ? __dequeue_entity+0x23/0x27
Feb 16 20:13:01 sandman kernel:  [<c032862e>] ? _spin_unlock_irq+0x8/0xb
Feb 16 20:13:01 sandman kernel:  [<c01139d1>] ? finish_task_switch+0x28/0x58
Feb 16 20:13:01 sandman kernel:  [<c0326dc7>] ? schedule+0x227/0x24c
Feb 16 20:13:01 sandman kernel:  [<c010edd6>] ? do_page_fault+0x0/0x4be
Feb 16 20:13:01 sandman kernel:  [<c0103cd2>] work_notifysig+0x13/0x19
Feb 16 20:13:01 sandman kernel:  =======================
Feb 16 20:13:01 Kernel panic - not syncing: Aiee, killing interrupt handler!

As always available for patch testing.

thanks,

--alessandro

 "We act as though comfort and luxury were the chief requirements
   of life, when all that we need to make us really happy is
   something to be enthusiastic about."

   (Charles Kingsley)
