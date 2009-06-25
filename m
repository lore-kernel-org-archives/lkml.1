Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbZFYTiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbZFYTiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZFYTh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:37:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbZFYTh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:37:56 -0400
Date: Thu, 25 Jun 2009 12:37:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: possible recursive locking detected at kmem_cache_free
Message-Id: <20090625123750.734b7f50.akpm@linux-foundation.org>
In-Reply-To: <20090625185942.GA29401@linux-os.sc.intel.com>
References: <20090625185942.GA29401@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 11:59:42 -0700
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> 
> Not sure if this has been reported elsewhere. I started seeing this with git
> kernel from this morning on a system with RedHat EL5 base installation with
> ext3 root file system. Attached is the config I am using.
> 
> Let me know if you need any more details. This seems to be at every boot. I
> am trying the bisect right now.
> 

Thanks.  Let's cc Pekka.

> 
> [   11.554714] 
> [   11.554715] =============================================
> [   11.555249] [ INFO: possible recursive locking detected ]
> [   11.555560] 2.6.31-rc1 #896
> [   11.555861] ---------------------------------------------
> [   11.556127] udevd/1899 is trying to acquire lock:
> [   11.556436]  (&nc->lock){-.-...}, at: [<ffffffff810c337f>] kmem_cache_free+0xcd/0x25b
> [   11.557101] 
> [   11.557102] but task is already holding lock:
> [   11.557706]  (&nc->lock){-.-...}, at: [<ffffffff810c3cd0>] kfree+0x137/0x292
> [   11.558109] 
> [   11.558109] other info that might help us debug this:
> [   11.558720] 2 locks held by udevd/1899:
> [   11.558983]  #0:  (&nc->lock){-.-...}, at: [<ffffffff810c3cd0>] kfree+0x137/0x292
> [   11.559734]  #1:  (&parent->list_lock){-.-...}, at: [<ffffffff810c36c7>] __drain_alien_cache+0x3b/0xbd
> [   11.560442] 
> [   11.560443] stack backtrace:
> [   11.561009] Pid: 1899, comm: udevd Not tainted 2.6.31-rc1 #896
> [   11.561276] Call Trace:
> [   11.561632]  [<ffffffff81065ed6>] __lock_acquire+0x15ec/0x168f
> [   11.561901]  [<ffffffff81065f60>] ? __lock_acquire+0x1676/0x168f
> [   11.562171]  [<ffffffff81063c52>] ? trace_hardirqs_on_caller+0x113/0x13e
> [   11.562490]  [<ffffffff8150c337>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   11.562807]  [<ffffffff8106603a>] lock_acquire+0xc1/0xe5
> [   11.563073]  [<ffffffff810c337f>] ? kmem_cache_free+0xcd/0x25b
> [   11.563385]  [<ffffffff8150c8fc>] _spin_lock+0x31/0x66
> [   11.563696]  [<ffffffff810c337f>] ? kmem_cache_free+0xcd/0x25b
> [   11.563964]  [<ffffffff810c337f>] kmem_cache_free+0xcd/0x25b
> [   11.564235]  [<ffffffff8109bf8c>] ? __free_pages+0x1b/0x24
> [   11.564551]  [<ffffffff810c3564>] slab_destroy+0x57/0x5c
> [   11.564860]  [<ffffffff810c3641>] free_block+0xd8/0x123
> [   11.565126]  [<ffffffff810c372e>] __drain_alien_cache+0xa2/0xbd
> [   11.565441]  [<ffffffff810c3ce5>] kfree+0x14c/0x292
> [   11.565752]  [<ffffffff8144a007>] skb_release_data+0xc6/0xcb
> [   11.566020]  [<ffffffff81449cf0>] __kfree_skb+0x19/0x86
> [   11.566286]  [<ffffffff81449d88>] consume_skb+0x2b/0x2d
> [   11.566631]  [<ffffffff8144cbe0>] skb_free_datagram+0x14/0x3a
> [   11.566901]  [<ffffffff81462eef>] netlink_recvmsg+0x164/0x258
> [   11.567170]  [<ffffffff81443461>] sock_recvmsg+0xe5/0xfe
> [   11.567486]  [<ffffffff810ab063>] ? might_fault+0xaf/0xb1
> [   11.567802]  [<ffffffff81053a78>] ? autoremove_wake_function+0x0/0x38
> [   11.568073]  [<ffffffff810d84ca>] ? core_sys_select+0x3d/0x2b4
> [   11.568378]  [<ffffffff81065f60>] ? __lock_acquire+0x1676/0x168f
> [   11.568693]  [<ffffffff81442dc1>] ? sockfd_lookup_light+0x1b/0x54
> [   11.568961]  [<ffffffff81444416>] sys_recvfrom+0xa3/0xf8
> [   11.569228]  [<ffffffff81063c8a>] ? trace_hardirqs_on+0xd/0xf
> [   11.569546]  [<ffffffff8100af2b>] system_call_fastpath+0x16/0x1b
> 
