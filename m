Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYDUJOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYDUJOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYDUJO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:14:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36479 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbYDUJOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:14:24 -0400
Subject: Re: Possible circular locking dependency while running valgrind on
	an executable over CIFS
From: Peter Zijlstra <peterz@infradead.org>
To: Brandon Ehle <azverkan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <3c5a513f0804202004y35820ddfse9195f883428a7db@mail.gmail.com>
References: <3c5a513f0804202004y35820ddfse9195f883428a7db@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 11:14:22 +0200
Message-Id: <1208769262.7115.164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-20 at 20:04 -0700, Brandon Ehle wrote:
> While running valgrind on various executables located on a CIFS share,
> I eventually got the message below.  The machine in question is
> running 2.6.25 with a few of the debug options enabled, including lock
> debugging.  Any idea if this is indicative of a real problem or just a
> false positive?

Looks like a simple AB-BA deadlock to me. I admint being a bit ignorant
about CIFS (nor really minding that) however it looks like you need to
delay or decouple the actual sending of the read request from
the .readpages() implementation.

Steve?

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.25 #29
> -------------------------------------------------------
> valgrind.bin/23200 is trying to acquire lock:
>  (sk_lock-AF_INET){--..}, at: [<c0557412>] tcp_sendmsg+0x17/0xb00
> 
> but task is already holding lock:
>  (&mm->mmap_sem){----}, at: [<c05c2abd>] do_page_fault+0x16d/0x8e0
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&mm->mmap_sem){----}:
>      [<c014bb79>] __lock_acquire+0xfa9/0xfdb
>      [<c014bc35>] lock_acquire+0x8a/0xbd
>      [<c05bf4f8>] down_read+0x3d/0x85
>      [<c05c2ad5>] do_page_fault+0x185/0x8e0
>      [<c05c102a>] error_code+0x72/0x78
>      [<c0526357>] memcpy_toiovec+0x43/0x5a
>      [<c0526910>] skb_copy_datagram_iovec+0x47/0x1d7
>      [<c0556e6a>] tcp_recvmsg+0xb3d/0xcc8
>      [<c051ff9f>] sock_common_recvmsg+0x3d/0x53
>      [<c051e8cf>] sock_recvmsg+0x10d/0x12a
>      [<c051f727>] sys_recvfrom+0x7c/0xc7
>      [<c051f7a8>] sys_recv+0x36/0x38
>      [<c051fbe8>] sys_socketcall+0x163/0x25b
>      [<c0104d78>] sysenter_past_esp+0x6d/0xc5
>      [<ffffffff>] 0xffffffff
> 
> -> #0 (sk_lock-AF_INET){--..}:
>      [<c014b771>] __lock_acquire+0xba1/0xfdb
>      [<c014bc35>] lock_acquire+0x8a/0xbd
>      [<c052098c>] lock_sock_nested+0xb5/0xc2
>      [<c0557412>] tcp_sendmsg+0x17/0xb00
>      [<c051ea28>] sock_sendmsg+0xf9/0x116
>      [<c051ed79>] kernel_sendmsg+0x28/0x37
>      [<c02cd885>] SendReceive2+0x197/0x69b
>      [<c02bb122>] CIFSSMBRead+0x110/0x2a0
>      [<c02c4d81>] cifs_readpages+0x18c/0x5c7
>      [<c016db8a>] __do_page_cache_readahead+0x161/0x1e1
>      [<c016dc4f>] do_page_cache_readahead+0x45/0x59
>      [<c0166c6e>] filemap_fault+0x30f/0x467
>      [<c01739f4>] __do_fault+0x56/0x43a
>      [<c0175530>] handle_mm_fault+0x150/0x873
>      [<c05c2ced>] do_page_fault+0x39d/0x8e0
>      [<c05c102a>] error_code+0x72/0x78
>      [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 1 lock held by valgrind.bin/23200:
>  #0:  (&mm->mmap_sem){----}, at: [<c05c2abd>] do_page_fault+0x16d/0x8e0
> 
> stack backtrace:
> Pid: 23200, comm: valgrind.bin Not tainted 2.6.25 #29
>  [<c014a979>] print_circular_bug_tail+0x68/0x6a
>  [<c014b771>] __lock_acquire+0xba1/0xfdb
>  [<c0104e81>] ? restore_nocheck+0x12/0x15
>  [<c014bc35>] lock_acquire+0x8a/0xbd
>  [<c0557412>] ? tcp_sendmsg+0x17/0xb00
>  [<c052098c>] lock_sock_nested+0xb5/0xc2
>  [<c0557412>] ? tcp_sendmsg+0x17/0xb00
>  [<c0557412>] tcp_sendmsg+0x17/0xb00
>  [<c0148a7d>] ? get_lock_stats+0x1b/0x3e
>  [<c0142185>] ? getnstimeofday+0x34/0xde
>  [<c0113253>] ? lapic_next_event+0x15/0x1e
>  [<c051ea28>] sock_sendmsg+0xf9/0x116
>  [<c01689e2>] ? mempool_alloc_slab+0xe/0x10
>  [<c013cb12>] ? autoremove_wake_function+0x0/0x3a
>  [<c05c078f>] ? _spin_unlock+0x27/0x42
>  [<c02cca11>] ? allocate_mid+0xec/0x149
>  [<c051ed79>] kernel_sendmsg+0x28/0x37
>  [<c02cd885>] SendReceive2+0x197/0x69b
>  [<c02bb122>] CIFSSMBRead+0x110/0x2a0
>  [<c02c4d81>] cifs_readpages+0x18c/0x5c7
>  [<c016bdf3>] ? __alloc_pages+0x6d/0x3c7
>  [<c014a3b1>] ? mark_held_locks+0x4d/0x84
>  [<c01604b1>] ? __rcu_read_unlock+0x81/0xa4
>  [<c02c4bf5>] ? cifs_readpages+0x0/0x5c7
>  [<c016db8a>] __do_page_cache_readahead+0x161/0x1e1
>  [<c016dc4f>] do_page_cache_readahead+0x45/0x59
>  [<c0166c6e>] filemap_fault+0x30f/0x467
>  [<c01739f4>] __do_fault+0x56/0x43a
>  [<c0175530>] handle_mm_fault+0x150/0x873
>  [<c0109d8f>] ? native_sched_clock+0xa6/0xea
>  [<c05c2abd>] ? do_page_fault+0x16d/0x8e0
>  [<c0140740>] ? down_read_trylock+0x51/0x59
>  [<c05c2ced>] do_page_fault+0x39d/0x8e0
>  [<c014aea1>] ? __lock_acquire+0x2d1/0xfdb
>  [<c017862a>] ? vma_link+0xbc/0xd4
>  [<c01670c0>] ? __filemap_fdatawrite_range+0x61/0x6d
>  [<c01672ef>] ? filemap_fdatawrite+0x26/0x28
>  [<c02c603e>] ? cifs_flush+0x1c/0x5c
>  [<c0104dc1>] ? sysenter_past_esp+0xb6/0xc5
>  [<c014a596>] ? trace_hardirqs_on+0x10a/0x15a
>  [<c05c2950>] ? do_page_fault+0x0/0x8e0
>  [<c05c102a>] error_code+0x72/0x78
>  =======================

<snip .config>

