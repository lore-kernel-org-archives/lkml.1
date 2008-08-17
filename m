Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbYHQQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbYHQQSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 12:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYHQQSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 12:18:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbYHQQSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 12:18:01 -0400
Date: Sun, 17 Aug 2008 09:17:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Fair low-latency rwlock v3
In-Reply-To: <20080817075335.GA25019@Krystal>
Message-ID: <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org>
 <20080817075335.GA25019@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 Aug 2008, Mathieu Desnoyers wrote:
> +/*
> + * Uncontended fastpath.
> + */
> +static int fair_write_lock_irq_fast(struct fair_rwlock *rwlock)

So first off, you should call this "trylock", since it doesn't necessarily 
get the lock at all. It has nothing to do with fast.

Secondly:

> +	value = atomic_long_read(&rwlock->value);
> +	if (likely(!value)) {
> +		/* no other reader nor writer present, try to take the lock */
> +		local_bh_disable();
> +		local_irq_disable();
> +		if (likely(atomic_long_cmpxchg(&rwlock->value, value,

This is actually potentially very slow. 

Why? If the lock is uncontended, but is not in the current CPU's caches, 
the read -> rmw operation generates multiple cache coherency protocol 
events. First it gets the line in shared mode (for the read), and then 
later it turns it into exclusive mode.

So if it's likely that the value is zero (or even if it's just the only 
case we really care about), then you really should do the

	atomic_long_cmpxchg(&rwlock->value, 0, newvalue);

thing as the _first_ access to the lock.

Yeah, yeah, that means that you need to do the local_bh_disable etc first 
too, and undo it if it fails, but the failure path should be the unusual 
one. 

			Linus
