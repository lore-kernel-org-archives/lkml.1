Return-Path: <linux-kernel-owner+w=401wt.eu-S1761480AbYC0Ujk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480AbYC0Ujk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758405AbYC0Ujc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:39:32 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:59679 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758265AbYC0Ujb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:39:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFAEqi60dMQWoK/2dsb2JhbACBWqoA
Date: Thu, 27 Mar 2008 16:39:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080327203927.GA19968@Krystal>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080327154053.GA5890@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:29:22 up 27 days, 16:40,  6 users,  load average: 0.71, 0.60,
	0.46
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Andrew,
> > 
> > After a few RFC rounds, I propose these markers for 2.6.26. They 
> > include work done after comments from the memory management community. 
> > Most of them have been used by the LTTng project for about 2 years.
> 
> very strong NACK. When markers went into 2.6.24 i initially believed 
> your claims that my earlier objections about markers have been resolved 
> and that it's a lightweight, useful facility.
> 
> so we optimistically used markers in ftrace (see sched-devel.git) for 
> the scheduler, and i was shocked about marker impact:
> 
> just 3 ftrace markers in the scheduler plus their support code bloated 
> the kernel by 5k (!), 288 bytes for only 3 markers in the scheduler 
> itself, the rest in support code to manage the markers - that's 96 bytes 
> added per every marker (44 (!) bytes of that in the fastpath!).
> 
> 44 bytes per marker per fastpast is _NOT_ acceptable in any way, shape 
> or form. Those 3 limited markers have the same cache cost as adding 
> mcount callbacks for dyn-ftrace to the _whole_ scheduler ...
> 
> as i told you many, many moons ago, repeatedly: acceptable cost is a 5 
> bytes callout that is patched to a NOP, and _maybe_ a little bit more to 
> prepare parameters for the function calls. Not 44 bytes. Not 96 bytes. 
> Not 5K total cost. Paravirt ops are super-lightweight in comparison.
> 
> and this stuff _can_ be done sanely and cheaply and in fact we have done 
> it: see ftrace in sched-devel.git, and compare its cost.
> 
> see further details in the tongue-in-cheek commit below.
> 

Hi Ingo,

Let's compare one marker against one ftrace statement in sched.o on the
sched-dev tree on x86_32 and see where your "bloat" impression about markers
comes from. I think it's mostly due to the different metrics we use.


sched.o w/o CONFIG_CONTEXT_SWITCH_TRACER
   text    data     bss     dec     hex filename
  46564    2924     200   49688    c218 kernel/sched.o

Let's get an idea of CONFIG_CONTEXT_SWITCH_TRACER impact on sched.o :

sched.o with CONFIG_CONTEXT_SWITCH_TRACER

  text    data     bss     dec     hex filename
  46788    2924     200   49912    c2f8 kernel/sched.o

224 bytes added for 6 ftrace_*(). This is partly due to the helper function
ftrace_all_fair_tasks(). So let's be fair and not take it in account.

Only the cost for one ftrace_*(). All the others commented out, leaving this
one :

static inline void
context_switch(struct rq *rq, struct task_struct *prev,
               struct task_struct *next)
{
        struct mm_struct *mm, *oldmm;

        prepare_task_switch(rq, prev, next);
        ftrace_ctx_switch(rq, prev, next);
...

   text    data     bss     dec     hex filename
  46644    2924     200   49768    c268 kernel/sched.o

Commenting this one out :

   text    data     bss     dec     hex filename
  46628    2924     200   49752    c258 kernel/sched.o

For an extra 16 bytes (13 + alignment).

Due to this addition to schedule fast path :

        movl    %ebx, %ecx
        movl    -48(%ebp), %edx
        movl    -40(%ebp), %eax
        call    ftrace_ctx_switch

corresponding to :

 38c:   89 d9                   mov    %ebx,%ecx
 38e:   8b 55 d0                mov    -0x30(%ebp),%edx
 391:   8b 45 d8                mov    -0x28(%ebp),%eax
 394:   e8 fc ff ff ff          call   395 <schedule+0x12c>

Which adds 13 bytes to the fast path. It reads the stack to populate the
registers even when the code is dynamically disabled. The size of this code
directly depends on the number of parameters passed to the tracer. It would also
have to dereference pointers from memory if there would happen to be some data
not present on the stack. All this when disabled. I suppose you patch a no-op
instead of the call to dynamically disable it.

Changing this for a trace_mark :

        trace_mark(ctx_switch, "rq %p prev %p next %p", rq, prev, next);

Adds this to schedule fast path :
(this is without immediate values)

        cmpb    $0, __mark_ctx_switch.33881+8
        jne     .L2164

corresponding to :

 38c:   80 3d 08 00 00 00 00    cmpb   $0x0,0x8
 393:   0f 85 0c 03 00 00       jne    6a5 <schedule+0x43c>

(13 bytes in the fast path, including a memory reference)

With immediate values optimization, we do better :

        mov $0,%al
        testb   %al, %al
        jne     .L2164

Corresponding to :

 389:   b0 00                   mov    $0x0,%al
 38b:   84 c0                   test   %al,%al
 38d:   0f 85 0c 03 00 00       jne    69f <schedule+0x436>

(10 bytes in the fast path instead of 13, and we remove any memory reference)


Near the end of schedule, we find the jump target :


.L2164:
        movl    %ebx, 20(%esp)
        movl    -48(%ebp), %edx
        movl    %edx, 16(%esp)
        movl    %ecx, 12(%esp)
        movl    $.LC108, 8(%esp)
        movl    $0, 4(%esp)
        movl    $__mark_ctx_switch.33881, (%esp)
        call    *__mark_ctx_switch.33881+12
        jmp     .L2126


 6a5:   89 5c 24 14             mov    %ebx,0x14(%esp)
 6a9:   8b 55 d0                mov    -0x30(%ebp),%edx
 6ac:   89 54 24 10             mov    %edx,0x10(%esp)
 6b0:   89 4c 24 0c             mov    %ecx,0xc(%esp)
 6b4:   c7 44 24 08 f7 04 00    movl   $0x4f7,0x8(%esp)
 6bb:   00 
 6bc:   c7 44 24 04 00 00 00    movl   $0x0,0x4(%esp)
 6c3:   00 
 6c4:   c7 04 24 00 00 00 00    movl   $0x0,(%esp)
 6cb:   ff 15 0c 00 00 00       call   *0xc
 6d1:   e9 c3 fc ff ff          jmp    399 <schedule+0x130>

Which adds an extra 50 bytes.

With immediate values optimization, we have a total size of 

   text    data     bss     dec     hex filename
  46767    2956     200   49923    c303 kernel/sched.o

(baseline)

   text    data     bss     dec     hex filename
  46638    2924     200   49762    c262 kernel/sched.o

We add 129 bytes of text here. Which does not balance. We should add 60 bytes. I
guess some code alignment is the cause. Let's look at the size of schedule()
instead, since this is the only code I touch :

With immediate values optimization, with the marker :
00000269 <schedule>
...
0000086c <cond_resched_softirq>
1539 bytes

And without the marker :
00000269 <schedule>
...
0000082d <cond_resched_softirq>
1476 bytes

For an added 63 bytes to schedule, which balances modulo some alignment.

If we look at the surrounding of the added 50 bytes (label .L2164) at the end of
schedule(), we see the assembly :

....
.L2103:
        movl    -32(%ebp), %eax
        testl   %eax, %eax
        je      .L2101
        movl    $0, 68(%esi)
        jmp     .L2089
.L2106:
        movl    $0, -32(%ebp)
        .p2align 4,,3
        jmp     .L2089
.L2164:
        movl    %ebx, 20(%esp)
        movl    -48(%ebp), %edx
        movl    %edx, 16(%esp)
        movl    %ecx, 12(%esp)
        movl    $.LC108, 8(%esp)
        movl    $0, 4(%esp)
        movl    $__mark_ctx_switch.33909, (%esp)
        call    *__mark_ctx_switch.33909+12
        jmp     .L2126
.L2124:
        movl    -40(%ebp), %eax
        call    _spin_unlock_irq
        .p2align 4,,6
        jmp     .L2141
.L2161:
        movl    $1, %ecx
        movl    $2, %eax
        call    profile_hits
        .p2align 4,,4
        jmp     .L2069
.L2160:
        movl    -48(%ebp), %edx
        movl    192(%edx), %eax
        testl   %eax, %eax
        jne     .L2066
        movl    %edx, %eax
        call    __schedule_bug
        jmp     .L2066
....

Which are all targets of "unlikely" branches. Therefore, it shares a cache line
with these targets on architectures with associative L1 i-cache. I don't see
how this could be considered as "fast path".

Therefore, on a 3 arguments marker (with immediate values), the marker seems
to outperform ftrace on the following items :

- Adds 10 bytes to the fast path instead of 13.
- No memory read is required on the fast path when the marker is dynamically
  disabled.
- The added fast path code size does not depend on the number of parameters
  passed.
- The runtime cost, when dynamically disabled, does not depend on the number of
  parameters passed.

However, you are right in that the _total_ code size of the ftrace statement is
smaller, but since it is all located and executed in the fast path, even when
dynamically disabled, I don't see this as an overall improvement.

About the cost of code size required to handle the data afterward : it will be
amortized by a common infrastructure such as LTTng, where the same code will
translate the data received as parameter into a trace.

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
