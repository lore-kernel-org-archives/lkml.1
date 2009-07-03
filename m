Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZGCRie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZGCRie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 13:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZGCRi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 13:38:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736AbZGCRiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 13:38:25 -0400
Date: Fri, 3 Jul 2009 10:38:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <eric.dumazet@gmail.com>, David Howells <dhowells@redhat.com>,
       akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: atomic64_t: Improve atomic64_add_return()
In-Reply-To: <20090703120159.GB7161@elte.hu>
Message-ID: <alpine.LFD.2.01.0907031035340.3210@localhost.localdomain>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain>
 <20090703120159.GB7161@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Jul 2009, Ingo Molnar wrote:
>  u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
>  {
> +	/*
> +	 * Try first with a (probably incorrect) assumption about
> +	 * what we have there. We'll do two loops most likely,
> +	 * but we'll get an ownership MESI transaction straight away
> +	 * instead of a read transaction followed by a
> +	 * flush-for-ownership transaction:
> +	 */
> +	u64 old_val, new_val, real_val = 1ULL << 32;
>  
>  	do {
> +		old_val = real_val;
>  		new_val = old_val + delta;
>  
> +		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
> +
> +	} while (real_val != old_val);

For the case where we actually have to keep looping until we succeed, 
we're probably better off starting with a good guess rather than a bad 
one.

So I'd suggest using 'real_val = 0', which gives smaller code, rather than 
the 1ull << 32 that is actively trying to be a bad guess.

It won't matter all that much (since 0 really isn't a much better guess 
than 1ull<<32), but I'd rather have a simple constant that doesn't matter, 
over an odd constant that makes no sense.

			Linus
