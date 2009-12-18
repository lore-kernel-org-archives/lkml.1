Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZLRM7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZLRM7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZLRM67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:58:59 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47466 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZLRM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:58:17 -0500
Subject: Re: [2.6.33-rc1] slab: possible recursive locking detected
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
       cl@linux-foundation.org
In-Reply-To: <20091218115843.GB7728@osiris.boeblingen.de.ibm.com>
References: <20091218115843.GB7728@osiris.boeblingen.de.ibm.com>
Date: Fri, 18 Dec 2009 14:58:13 +0200
Message-Id: <1261141094.5014.11.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Fri, 2009-12-18 at 12:58 +0100, Heiko Carstens wrote:
> Just got this with CONFIG_SLAB:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.33-rc1-dirty #23
> ---------------------------------------------
> events/5/20 is trying to acquire lock:
>  (&(&parent->list_lock)->rlock){..-...}, at: [<00000000000ee898>] cache_flusharray+0x3c/0x12c
> 
> but task is already holding lock:
>  (&(&parent->list_lock)->rlock){..-...}, at: [<00000000000eee52>] drain_array+0x52/0x100
> 
> other info that might help us debug this:
> 4 locks held by events/5/20:
>  #0:  (events){+.+.+.}, at: [<000000000006cbec>] worker_thread+0x1ec/0x33c
>  #1:  ((&(reap_work)->work)){+.+...}, at: [<000000000006cbec>] worker_thread+0x1ec/0x33c
>  #2:  (cache_chain_mutex){+.+.+.}, at: [<00000000000ef03a>] cache_reap+0x32/0x164
>  #3:  (&(&parent->list_lock)->rlock){..-...}, at: [<00000000000eee52>] drain_array+0x52/0x100
> 
> stack backtrace:
> CPU: 5 Not tainted 2.6.33-rc1-dirty #23
> Process events/5 (pid: 20, task: 000000003fa48a38, ksp: 000000003fa4fc60)
> 000000003fa4f9b0 000000003fa4f930 0000000000000002 0000000000000000 
>        000000003fa4f9d0 000000003fa4f948 000000003fa4f948 00000000003dce2a 
>        0000000000000000 0000000000000000 000000003fa49190 0000000000827108 
>        000000000000000d 000000000000000c 000000003fa4f998 0000000000000000 
>        0000000000000000 00000000000174fa 000000003fa4f930 000000003fa4f970 
> Call Trace:
> ([<0000000000017402>] show_trace+0xee/0x144)
>  [<0000000000088f88>] validate_chain+0xa2c/0x1100
>  [<0000000000089b70>] __lock_acquire+0x514/0xc4c
>  [<000000000008a354>] lock_acquire+0xac/0xd4
>  [<00000000003e0c68>] _raw_spin_lock+0x58/0x94
>  [<00000000000ee898>] cache_flusharray+0x3c/0x12c
>  [<00000000000eebd8>] kmem_cache_free+0xd4/0xf8
>  [<00000000000eeda4>] free_block+0x11c/0x178
>  [<00000000000eee92>] drain_array+0x92/0x100
>  [<00000000000ef0fe>] cache_reap+0xf6/0x164
>  [<000000000006cc6e>] worker_thread+0x26e/0x33c
>  [<0000000000072d14>] kthread+0xa0/0xa8
>  [<000000000001c10a>] kernel_thread_starter+0x6/0xc
>  [<000000000001c104>] kernel_thread_starter+0x0/0xc
> INFO: lockdep is turned off.
> 
> config attached.

Thanks for the report! Does reverting the following commit make the
warning go away?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce79ddc8e2376a9a93c7d42daf89bfcbb9187e62

			Pekka

