Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZGCM1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZGCM1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757108AbZGCM10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:27:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586AbZGCM1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:27:25 -0400
Date: Fri, 3 Jul 2009 14:27:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
Message-ID: <20090703122710.GC7161@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <4A4D9FC4.1070201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4D9FC4.1070201@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> My last suggestion would be :
> 
> static inline unsigned long long atomic64_read(const atomic64_t *ptr)
> {
> 	unsigned long long res;
> 
> 	asm volatile(
> 		"mov     %%ebx, %%eax\n\t"
> 		"mov     %%ecx, %%edx\n\t"
> 		LOCK_PREFIX "cmpxchg8b %1\n"
> 			: "=A" (res)
> 			: "m" (*ptr)
> 		);
> 	return res;
> }
> 
> ebx/ecx being read only, and their value can be random, they are 
> not even mentioned in asm constraints, so gcc is allowed to keep 
> useful values in these registers.
> 
> So the following (stupid) example
> 
>         for (i = 0; i < 10000000; i++) {
>                 res += atomic64_read(&myvar);
>         }
> 
> gives :
>         xorl    %esi, %esi
> .L2:
>         mov     %ebx, %eax
>         mov     %ecx, %edx
>         lock;cmpxchg8b myvar
>         addl    %eax, %ecx
>         adcl    %edx, %ebx
>         addl    $1, %esi
>         cmpl    $10000000, %esi
>         jne     .L2

Ok, agreed. We dont want to inline it - cmpxchg8b is way too fat - 
but your code above is a valid optimization for the out-of-line 
variant as well. So i have applied it as such, will post the whole 
atomic64_t series soon, after some testing.

	Ingo
