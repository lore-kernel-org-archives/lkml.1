Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZDGB4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZDGB4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZDGB4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:56:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbZDGB4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:56:05 -0400
Date: Mon, 6 Apr 2009 18:51:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
 updates
In-Reply-To: <20090405193944.GA12691@elte.hu>
Message-ID: <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain>
References: <20090405193944.GA12691@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Apr 2009, Ingo Molnar wrote:
> 
> Please pull the latest kmemtrace-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git kmemtrace-for-linus
> 
> We kept this topic separate from the main tracing tree due to the 
> unexpectedly wide and messy-looking scope of the fixes Pekka needed 
> to do to untangle various slab*.h, rcu*.h and fs.h dependency 
> chains.

I'm not sure this is the tree that brings in the problem, but my wife's 
Mac Mini won't boot any more, and it looks like some slub or percpu issue, 
so regardless, roughly the right people are involved in the cc here 
already.

I get odd NUL page faults or GP faults in either __kmalloc, 
__kmalloc_track_caller or kmem_cache_alloc, and they all seem to happen on 
roughly the same code, ie it's something like this:

        movq    752(%r13,%rax,8), %rdx  # <variable>.cpu_slab, c
        movl    24(%rdx), %eax  # <variable>.objsize,
        movl    %eax, -44(%rbp) #, objsize
        movq    (%rdx), %r12    # <variable>.freelist, object
        testq   %r12, %r12      # object
        je      .L617   #,
        mov     20(%rdx), %eax  # <variable>.offset, <variable>.offset
->      movq    (%r12,%rax,8), %rax     #* object, tmp79
        movq    %rax, (%rdx)    # tmp79, <variable>.freelist

where that arrow points to the instruction that seems to be faulting.

I think it's this code:

                object = c->freelist;
                c->freelist = object[c->offset];

and that "object[c->offset]" in particular.

I have not tried to bisect it yet, and I'll do that, but if this sounds 
familiar to anybody, please holler before I waste a lot of time on it.

		Linus
