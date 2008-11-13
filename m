Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYKMTEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYKMTEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYKMTD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:03:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYKMTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:03:58 -0500
Date: Thu, 13 Nov 2008 14:03:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function
 return tracer lockless
In-Reply-To: <20081113185515.GA3810@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0811131349090.31899@gandalf.stny.rr.com>
References: <491B4F0A.3080901@gmail.com> <87od0jd6ds.fsf@basil.nowhere.org> <c62985530811130901t7ddf84beof39a964582fb94a0@mail.gmail.com> <20081113171220.GX3810@one.firstfloor.org> <alpine.DEB.1.10.0811131219250.23751@gandalf.stny.rr.com>
 <20081113173451.GY3810@one.firstfloor.org> <alpine.DEB.1.10.0811131230470.23751@gandalf.stny.rr.com> <20081113182937.GZ3810@one.firstfloor.org> <alpine.DEB.1.10.0811131330350.23751@gandalf.stny.rr.com> <20081113185515.GA3810@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, Andi Kleen wrote:
>>> 
>>> I did not refer to CPU caches, but the compiler's register allocation
>>> [ok if you want the registers are the "level 0 cache"]. A memory barrier
>>> all messes it up. That is why it is better to only clobber specific
>>> memory regions, which is what local_* does.
>>> 

>> Now tell me again how local_* is more efficient than barrier?
> 
> Look at the generated assembler, not the source. The M386 check is two instructions
> with the i386 stuff just moved away somewhere out of line that is
> about never taken. The rest is short and straight forward in asm too.
> And a lot of kernels are not compiled with 386 support anyways.
> 

OK, lets look at just the asm.

barrier:
	__asm__ __volatile__("": : :"memory")

local_add_return:
	asm volatile(_ASM_XADD "%0, %1;"
		     : "+r" (i), "+m" (l->a.counter)
		     : : "memory");


Your argument was that barrier clobbers memory, but it looks like the 
local_add_return does the same.

Lets go look at the code that we are talking about:

 	index = ++ti->curr_ret_stack;
 	ti->ret_stack[index].ret = ret;
 	ti->ret_stack[index].func = func;
 	ti->ret_stack[index].calltime = time;

Which as you stated was incorrect, and it is. But you suggested that we 
should switch to using local_add_return which would cause us to change a 
lot of code to handle the type change. When this is ported to other archs, 
they will copy that too, and then be using a lesser efficient algorithm.

All that is needed is to change the pointer to always point to the next 
item, and then do:

        index = ti->curr_ret_stack++;
	barrier();
        ti->ret_stack[index].ret = ret;
        ti->ret_stack[index].func = func;
        ti->ret_stack[index].calltime = time;

I don't see any major gain in switching to local_add_return.

-- Steve
