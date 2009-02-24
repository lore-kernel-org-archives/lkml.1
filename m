Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZBXFr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZBXFr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 00:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZBXFrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 00:47:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:57705 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbZBXFri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 00:47:38 -0500
Message-ID: <49A389F7.9030002@kernel.org>
Date: Tue, 24 Feb 2009 14:47:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com, mingo@elte.hu,
       tony.luck@intel.com
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <200902192221.52835.rusty@rustcorp.com.au> <499E1D01.2040408@kernel.org> <200902241326.23605.rusty@rustcorp.com.au>
In-Reply-To: <200902241326.23605.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 05:47:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
> On Friday 20 February 2009 13:31:21 Tejun Heo wrote:
>>>    One question.  Are you thinking that to be defined by every SMP arch
>>> long-term?
>> Yeap, definitely.
> 
> Excellent.  That opens some really nice stuff.

Yeap, I think it'll be pretty interesting.

>>> Because there are benefits in having &<percpuvar> == valid
>>> percpuptr, such as passing them around as parameters.  If so, IA64
>>> will want a dedicated per-cpu area for statics (tho it can probably
>>> just map it somehow, but it has to be 64k).
>> Hmmm...  Don't have much idea about ia64 and its magic 64k.  Can it
>> somehow be used for the first chunk?
> 
> Yes, but I think that chunk must not be handed out for dynamic allocations
> but kept in reserve for modules.
> 
> IA64 uses a pinned TLB entry to map this cpu's 64k at __phys_per_cpu_start.
> See __ia64_per_cpu_var() in arch/ia64/include/asm/percpu.h.  This means they
> can also optimize cpu_local_* and read_cpuvar (or whatever it's called now).
> IIUC IA64 needs this region internally, using it for percpu vars is a bonus.

I'll take a look.

>>> These pseudo-constants seem like a really weird thing to do to me.
>> I explained this in the reply to Andrew's comment.  It's
>> non-really-constant-but-should-be-considered-so-by-users thing.  Is it
>> too weird?  Even if I add comment explaning it?
> 
> It's weird; I'd make them __read_mostly and be done with it.

Already dropped.  It seems I was the only one liking it.

>> Hmmm... the reverse mapping can be piggy backed on vmalloc by adding a
>> private pointer to the vm_struct but rbtree isn't too difficult to use
>> so I just did it directly.  Nick, what do you think about adding
>> private field to vm_struct and providing a reverse map function?
> 
> Naah, just walk the arrays to do the mapping.  Cuts a heap of code, and
> we can optimize when someone complains :)
> 
> Walking arrays is cache friendly, too.

It won't make much difference cache line wise here as it needs to
dereference anyway.  It will cut less than a hundred lines of code
comments included.  Given the not-so-large amount of reduced
complexity, I'm a little bit reluctant to cut the code but please feel
free to submit a patch to kill it if you think it's really necessary.

>> As for the sl*b allocation thing, can you please explain in more
>> detail or point me to the patches / threads?
> 
> lkml from 2008-05-30:
> 
> Message-Id: <20080530040021.800522644@sgi.com>:
> Subject: [patch 32/41] cpu alloc: Use in slub
> And:
> Subject: [patch 33/41] cpu alloc: Remove slub fields
> Subject: [patch 34/41] cpu alloc: Page allocator conversion

I'll read them.  Thanks.

>> Thanks.  :-)
> 
> Don't thank me: you're doing all the work!
> Rusty.

Heh... I'm just being coward.  I keep thanks around so that I can
remove it when I wanna curse.  :-P

-- 
tejun
