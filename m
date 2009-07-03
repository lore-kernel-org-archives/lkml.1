Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZGCGGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZGCGGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZGCGGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:06:23 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:52455 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbZGCGGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:06:21 -0400
Message-ID: <4A4D9FC4.1070201@gmail.com>
Date: Fri, 03 Jul 2009 08:05:56 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, mingo@elte.hu,
       akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com>
In-Reply-To: <4A4D2239.5000602@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 03 Jul 2009 08:05:58 +0200 (CEST)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> I got a 4 x speedup on a dual quad core (Intel E5450) machine if all cpus try 
> to *read* the same atomic64 location.
> 
> I tried various init value and got additional 5 % speedup chosing a
> value *most probably* different than actual atomic64 one,
> like (1LL << 32), with nice asm output...
> 
> static inline unsigned long long atomic64_read(atomic64_t *ptr)
> {
> 	unsigned long long old = (1LL << 32) ;
> 
> 	return cmpxchg8b(&ptr->counter, old, old);
> }
> 

My last suggestion would be :

static inline unsigned long long atomic64_read(const atomic64_t *ptr)
{
	unsigned long long res;

	asm volatile(
		"mov     %%ebx, %%eax\n\t"
		"mov     %%ecx, %%edx\n\t"
		LOCK_PREFIX "cmpxchg8b %1\n"
			: "=A" (res)
			: "m" (*ptr)
		);
	return res;
}

ebx/ecx being read only, and their value can be random, they are not even
mentioned in asm constraints, so gcc is allowed to keep useful values
in these registers.

So the following (stupid) example

        for (i = 0; i < 10000000; i++) {
                res += atomic64_read(&myvar);
        }

gives :
        xorl    %esi, %esi
.L2:
        mov     %ebx, %eax
        mov     %ecx, %edx
        lock;cmpxchg8b myvar
        addl    %eax, %ecx
        adcl    %edx, %ebx
        addl    $1, %esi
        cmpl    $10000000, %esi
        jne     .L2
