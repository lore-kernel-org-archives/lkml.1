Return-Path: <linux-kernel-owner+w=401wt.eu-S1030811AbXCTAgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811AbXCTAgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030810AbXCTAgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:36:37 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:33363 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811AbXCTAgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:36:36 -0400
Message-ID: <45FF2C7B.6080107@cosmosbay.com>
Date: Tue, 20 Mar 2007 01:36:11 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/13] signal/timer/event fds v7 - timerfd core ...
References: <send-serie.davidel@xmailserver.org.15249.1174348074.6>
In-Reply-To: <send-serie.davidel@xmailserver.org.15249.1174348074.6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 20 Mar 2007 01:36:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :

> +struct timerfd_ctx {
> +	struct hrtimer tmr;
> +	ktime_t tintv;
> +	spinlock_t lock;
> +	wait_queue_head_t wqh;
> +	unsigned long ticks;
> +};

> +static struct kmem_cache *timerfd_ctx_cachep;

> +	timerfd_ctx_cachep = kmem_cache_create("timerfd_ctx_cache",
> +						sizeof(struct timerfd_ctx),
> +						0, SLAB_PANIC, NULL, NULL);


Do we really expect thousands of active timerfd_ctx ?

If not, using kmalloc()/kfree() would be fine, because sizeof(struct 
timerfd_ctx) is so small.

on SMP / NUMA platforms, each new kmem_cache is rather expensive. (memory 
allocated at kmem_cache_create(), but also memory used when cache is not 
empty, with slabs in freelist for each cpu/node)

Using a general cache might be cheaper : No memory overhead for yet another 
kmem_cache.

I know individual caches are good to spot memory leaks, but in timerfd case, 
you dont have mem leaks, do you ? :)



