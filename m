Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXETSFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXETSFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 14:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbXETSFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 14:05:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbXETSFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 14:05:33 -0400
Date: Sun, 20 May 2007 20:05:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Bill Huey <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070520180522.GA20805@elte.hu>
References: <1179657026.5915.10.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179657026.5915.10.camel@lappy>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Add lock contention tracking to lockdep
> 
> [root@taijtu ~]# cat /proc/lockdep_contentions | sort -rnk 2 | head
> dcache_lock: 3000 0 [618] [<ffffffff8033badd>] _atomic_dec_and_lock+0x39/0x58 [17] [<ffffffff802d6dce>] sysfs_open_file+0x28/0x25a [160] [<ffffffff802a5b61>] d_instantiate+0x2a/0xad [52] [<ffffffff8029d926>] __link_path_walk+0x270/0xde9
> &inode->i_mutex: 235 0 [15] [<ffffffff8029b053>] pipe_read+0x74/0x39d [23] [<ffffffff8029a9f8>] pipe_wait+0x86/0x8d [105] [<ffffffff8029bc9a>] do_lookup+0x81/0x1ae [85] [<ffffffff802a0be7>] vfs_readdir+0x5c/0xa9
> &zone->lru_lock: 141 0 [11] [<ffffffff8027366b>] activate_page+0x37/0xd6 [75] [<ffffffff80273327>] release_pages+0xb2/0x16c [42] [<ffffffff80273443>] __pagevec_lru_add_active+0x62/0xe5 [12] [<ffffffff80273529>] __pagevec_lru_add+0x63/0xe2

looks really nice!

>  6 files changed, 266 insertions(+), 18 deletions(-)

wow, that's really simple!

in general i like this alot because it cleverly reuses all the lock API 
wrappers and lock tracking infrastructure that lockdep already adds.

    Acked-by: Ingo Molnar <mingo@elte.hu>

i'd suggest to add a CONFIG_DEBUG_LOCK_STAT Kconfig method to turn this 
on without any of the other lock-dependency tracking costs that lockdep 
has.

here are a few minor nits about the code:

> +struct lockdep_contention_point {
> +	unsigned long ip;
> +	atomic_t count;
> +};

i'd say rename this to "lock_contention_point" - this is not really a 
lockdep thing. Lockdep offers the machinery to track lock usage, but 
there's no "dependency" portion of this.

> +	printk("%s/%d is trying to content lock (",

s/content/contend

> +static int lockdep_contentions_show(struct seq_file *m, void *v)
> +ssize_t lockdep_contentions_write(struct file *file, const char __user *buf,

s/lockdep/lock

> +			for (i = 0; i < ARRAY_SIZE(class->contention_point);
> +					i++)
> +				class->contention_point[i].ip = 0;

(loop body needs curly braces because the whole construct is 3-line.)

> +	entry = create_proc_entry("lockdep_contentions", S_IRUSR, NULL);

s/lockdep/lock

> @@ -20,7 +20,10 @@ void down_read(struct rw_semaphore *sem)
>  	might_sleep();
>  	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
>  
> -	__down_read(sem);
> +	if (!__down_read_trylock(sem)) {
> +		lock_contended(&sem->dep_map, 1, _RET_IP_);
> +		__down_read(sem);
> +	}

heh, clever trick that avoids the touching of dozens of architectures 
;-) I guess make this dependent on CONFIG_LOCK_STAT though, because gcc 
cannot optimize this away even if lock_contended() is a NOP.

(same for the other trylock additions in rwsem.c and spinlock.c)

	Ingo
