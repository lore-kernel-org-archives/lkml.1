Return-Path: <linux-kernel-owner+w=401wt.eu-S935374AbXEWRBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935374AbXEWRBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbXEWRBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:01:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115AbXEWRBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:01:30 -0400
Message-ID: <46547345.8000808@redhat.com>
Date: Wed, 23 May 2007 13:00:53 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] local_softirq_pending storm
References: <200705091942.22920.kernel@prachanda.hub> <200705191525.28400.kernel@prachanda.hub> <1179601868.12981.127.camel@chaos> <200705200253.44992.kernel@prachanda.hub> <1179697388.6570.26.camel@chaos> <6bffcb0e0705221203s1ba21ed3j641e91036859db7d@mail.gmail.com> <20070522201046.GA6113@elte.hu>
In-Reply-To: <20070522201046.GA6113@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> Bad news - I hit a bug in 2.6.22-rc2-hrt3. Bug symptoms:
>> - X hangs (keyboard, mouse, sound etc.)
>> - only Magic SysRq works
> 
> please try the patch below! I think we have nailed this bug.
> 
> 	Ingo
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -4212,9 +4212,7 @@ int __sched cond_resched_softirq(void)
>  	BUG_ON(!in_softirq());
>  
>  	if (need_resched() && system_state == SYSTEM_RUNNING) {
> -		raw_local_irq_disable();
> -		_local_bh_enable();
> -		raw_local_irq_enable();
> +		local_bh_enable();
>  		__cond_resched();
>  		local_bh_disable();
>  		return 1;

We may have a problem with that:

 BUG: warning at kernel/softirq.c:138/local_bh_enable() (Not tainted)
  [<c042b2ef>] local_bh_enable+0x45/0x92
  [<c06036b7>] cond_resched_softirq+0x2c/0x42
  [<c059d5d0>] release_sock+0x54/0xa3
  [<c05c9428>] tcp_sendmsg+0x91b/0xa0c
  [<c05e1bb9>] inet_sendmsg+0x3b/0x45
  [<c059af34>] sock_aio_write+0xf9/0x105
  [<c0476035>] do_sync_write+0xc7/0x10a
  [<c0437265>] autoremove_wake_function+0x0/0x35
  [<c047688e>] vfs_write+0xbc/0x154
  [<c0476e8c>] sys_write+0x41/0x67
  [<c0404f70>] syscall_call+0x7/0xb

That's:
        WARN_ON_ONCE(irqs_disabled());


And another, tainted but probably valid:

BUG: warning at kernel/softirq.c:138/local_bh_enable() (Tainted: P      )
 [<c042b2ef>] local_bh_enable+0x45/0x92
 [<c06036b7>] cond_resched_softirq+0x2c/0x42
 [<c059d5d0>] release_sock+0x54/0xa3
 [<c05c9428>] tcp_sendmsg+0x91b/0xa0c
 [<c04e8b30>] copy_to_user+0x3c/0x50
 [<c05a1b71>] memcpy_toiovec+0x27/0x4a
 [<c059d58f>] release_sock+0x13/0xa3
 [<c0604ad5>] _spin_unlock_bh+0x5/0xd
 [<c05e1bb9>] inet_sendmsg+0x3b/0x45
 [<c059af34>] sock_aio_write+0xf9/0x105
 [<c0475f31>] do_sync_readv_writev+0xc1/0xfe
 [<c0437265>] autoremove_wake_function+0x0/0x35
 [<c04e88e0>] copy_from_user+0x3a/0x66
 [<c0475dec>] rw_copy_check_uvector+0x5c/0xb0
 [<c047667a>] do_readv_writev+0xbc/0x187
 [<c059ae3b>] sock_aio_write+0x0/0x105
 [<c0476782>] vfs_writev+0x3d/0x48
 [<c0476bee>] sys_writev+0x41/0x95
 [<c0404f70>] syscall_call+0x7/0xb


https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=240982
