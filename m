Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbZGCMl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbZGCMl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZGCMlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:41:19 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:44328 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbZGCMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:41:18 -0400
Message-ID: <4A4DFC17.4090809@cosmosbay.com>
Date: Fri, 03 Jul 2009 14:39:51 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <4A4D9FC4.1070201@gmail.com> <20090703122710.GC7161@elte.hu>
In-Reply-To: <20090703122710.GC7161@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 03 Jul 2009 14:39:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> My last suggestion would be :
>>
>> static inline unsigned long long atomic64_read(const atomic64_t *ptr)
>> {
>> 	unsigned long long res;
>>
>> 	asm volatile(
>> 		"mov     %%ebx, %%eax\n\t"
>> 		"mov     %%ecx, %%edx\n\t"
>> 		LOCK_PREFIX "cmpxchg8b %1\n"
>> 			: "=A" (res)
>> 			: "m" (*ptr)
>> 		);
>> 	return res;
>> }
>>
>> ebx/ecx being read only, and their value can be random, they are 
>> not even mentioned in asm constraints, so gcc is allowed to keep 
>> useful values in these registers.
>>
>> So the following (stupid) example
>>
>>         for (i = 0; i < 10000000; i++) {
>>                 res += atomic64_read(&myvar);
>>         }
>>
>> gives :
>>         xorl    %esi, %esi
>> .L2:
>>         mov     %ebx, %eax
>>         mov     %ecx, %edx
>>         lock;cmpxchg8b myvar
>>         addl    %eax, %ecx
>>         adcl    %edx, %ebx
>>         addl    $1, %esi
>>         cmpl    $10000000, %esi
>>         jne     .L2
> 
> Ok, agreed. We dont want to inline it - cmpxchg8b is way too fat - 
> but your code above is a valid optimization for the out-of-line 
> variant as well. So i have applied it as such, will post the whole 
> atomic64_t series soon, after some testing.

I just changed "=A" constraint to "+A" or gcc could use %edx/%eax in "ptr"
address computation. I discovered this after crashing my box :)


