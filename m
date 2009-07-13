Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZGMN4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZGMN4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbZGMN4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:56:10 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:64391 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbZGMN4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=leIAojoOtLTrdBV2F/KTsV49ulnWOF/MA268Rcc0TI33QY0Qp4lDrtDwz9foSN5Tqp
         l68hf3NmQ+hzSXRwI6Oo/JKQHFsfdORhB4Zb1hQUZwFift9jydToP7PAn4o9PG3zWsYG
         hhNFm58OoCr0Oth3mReU9SMkkUz4edmShk/eQ=
MIME-Version: 1.0
In-Reply-To: <1247476498.7529.54.camel@twins>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
	 <20090711213028.GC6641@nowhere>
	 <d82e647a0907111942o1cf22batb204c38bfbd43c03@mail.gmail.com>
	 <20090713070110.GA28499@elte.hu> <1247476498.7529.54.camel@twins>
Date: Mon, 13 Jul 2009 21:56:09 +0800
Message-ID: <d82e647a0907130656la867a03u2a4759443b299b09@mail.gmail.com>
Subject: Re: [RESEND PATCH 01/11] kernel:lockdep:print the shortest dependency 
	chain if finding a circle
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/13 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Mon, 2009-07-13 at 09:01 +0200, Ingo Molnar wrote:
>>
>> It's a nice byproduct, beyond the primary advantage of not being a
>> stack based recursion check.
>>
>> I think this patch-set is great, and there's just one more step
>> needed to make it round: it would be nice to remove the limitation
>> of maximum number of locks held per task. (MAX_LOCK_DEPTH)
>>
>> The way we could do it is to split out this bit of struct task:
>>
>> #ifdef CONFIG_LOCKDEP
>> # define MAX_LOCK_DEPTH 48UL
>>         u64 curr_chain_key;
>>         int lockdep_depth;
>>         unsigned int lockdep_recursion;
>>         struct held_lock held_locks[MAX_LOCK_DEPTH];
>>         gfp_t lockdep_reclaim_gfp;
>> #endif
>>
>> into a separate 'struct lockdep_state' structure, and allocate it
>> dynamically during fork with a initial pre-set size of say 64 locks
>> depth. If we hit that limit, we'd double the allocation threshold,
>> which would cause a larger structure to be allocated for all newly
>> allocated tasks.
>
> Right, except allocating stuff while in the middle of lockdep is very
> hard since it involves taking more locks :-)

Yes, it is a little dangerous to allocating memory dynamically in lockdep.

>
> I've tried it several times but never quite managed it in a way that I
> felt comfortable with.
>
> It would require having a reserve and serializing over that reserve.

Yes, good idea.


-- 
Lei Ming
