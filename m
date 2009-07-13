Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZGMNvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZGMNvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZGMNvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:51:13 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:64992 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbZGMNvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SifkGgq9foawgP8bQdBRxU4MNt1NtrNTACsb/AGj7bYN0FB9WraRlK7sb7zeYZiBlU
         cg3LjOnpV9ODa6g6FLOBwgoJrWLgPWjVkvO2n5tjPZwHsTmLFt1WrJzaL5BBTiHJMcSd
         7RaDcSGwAZC5a6FAxYMObfVaIoPcRcMBDddrk=
MIME-Version: 1.0
In-Reply-To: <20090713070110.GA28499@elte.hu>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
	 <20090711213028.GC6641@nowhere>
	 <d82e647a0907111942o1cf22batb204c38bfbd43c03@mail.gmail.com>
	 <20090713070110.GA28499@elte.hu>
Date: Mon, 13 Jul 2009 21:51:12 +0800
Message-ID: <d82e647a0907130651s37799190gff9acc1fe4622a5b@mail.gmail.com>
Subject: Re: [RESEND PATCH 01/11] kernel:lockdep:print the shortest dependency 
	chain if finding a circle
From: Ming Lei <tom.leiming@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/13 Ingo Molnar <mingo@elte.hu>:
>
> * Ming Lei <tom.leiming@gmail.com> wrote:
>> No, as you said, the shortest circle is not very important, and it
>> is just a byproduct and we have no reason to reject it.
>
> It's a nice byproduct, beyond the primary advantage of not being a
> stack based recursion check.
>
> I think this patch-set is great, and there's just one more step
> needed to make it round: it would be nice to remove the limitation
> of maximum number of locks held per task. (MAX_LOCK_DEPTH)

IMHO,  it seems that removing the MAX_LOCK_DEPTH limitation is another
topic,  and is nothing to do with this patch-set.  We may still make it round
with the limitation like before.

Can we plan to remove the limitation of MAX_LOCK_DEPTH after merging
the patch-set?

Thanks.

>
> The way we could do it is to split out this bit of struct task:
>
> #ifdef CONFIG_LOCKDEP
> # define MAX_LOCK_DEPTH 48UL
>        u64 curr_chain_key;
>        int lockdep_depth;
>        unsigned int lockdep_recursion;
>        struct held_lock held_locks[MAX_LOCK_DEPTH];
>        gfp_t lockdep_reclaim_gfp;
> #endif
>
> into a separate 'struct lockdep_state' structure, and allocate it
> dynamically during fork with a initial pre-set size of say 64 locks
> depth. If we hit that limit, we'd double the allocation threshold,
> which would cause a larger structure to be allocated for all newly
> allocated tasks.
>
> ( This means that the task that hits this threshold needs to have
>  lockdep disabled until it exits - but that's OK. )
>
>        Ingo
>

-- 
Lei Ming
