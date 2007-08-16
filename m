Return-Path: <linux-kernel-owner+w=401wt.eu-S1766001AbXHPQC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766001AbXHPQC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760982AbXHPQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:02:46 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:60045 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761560AbXHPQCo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:02:44 -0400
Date: Thu, 16 Aug 2007 12:02:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] Immediate Values - Architecture Independent Code
Message-ID: <20070816160240.GA2506@Krystal>
References: <20070812150702.769065566@polymtl.ca> <20070812150814.414317013@polymtl.ca> <20070813205137.GA5870@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070813205137.GA5870@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:08:40 up 15 days, 13:27,  2 users,  load average: 3.73, 3.11, 2.12
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Sun, Aug 12, 2007 at 11:07:04AM -0400, Mathieu Desnoyers wrote:
> > Immediate values are used as read mostly variables that are rarely updated. They
> > use code patching to modify the values inscribed in the instruction stream. It
> > provides a way to save precious cache lines that would otherwise have to be used
> > by these variables.
> > 
> > There is a generic _immediate_read() version, which uses standard global
> > variables, and optimized per architecture immediate_read() implementations,
> > which use a load immediate to remove a data cache hit. When the immediate values
> > functionnality is disabled in the kernel, it falls back to global variables.
> > 
> > It adds a new rodata section "__immediate" to place the pointers to the enable
> > value. Immediate values activation functions sits in kernel/immediate.c.
> > 
> > Immediate values refer to the memory address of a previously declared integer.
> > This integer holds the information about the state of the immediate values
> > associated, and must be accessed through the API found in linux/immediate.h.
> > 
> > At module load time, each immediate value is checked to see if it must be
> > enabled. It would be the case if the variable they refer to is exported from
> > another module and already enabled.
> > 
> > In the early stages of start_kernel(), the immediate values are updated to
> > reflect the state of the variable they refer to.
> > 
> > * Why should this be merged *
> > 
> > It improves performances on heavy memory I/O workloads.
> > 
> > An interesting result shows the potential this infrastructure has by
> > showing the slowdown a simple system call such as getppid() suffers when it is
> > used under heavy user-space cache trashing:
> > 
> > Random walk L1 and L2 trashing surrounding a getppid() call:
> > (note: in this test, do_syscal_trace was taken at each system call, see
> > Documentation/immediate.txt in these patches for details)
> > - No memory pressure :   getppid() takes  1573 cycles
> > - With memory pressure : getppid() takes 15589 cycles
> > 
> > We therefore have a slowdown of 10 times just to get the kernel variables from
> > memory. Another test on the same architecture (Intel P4) measured the memory
> > latency to be 559 cycles. Therefore, each cache line removed from the hot path
> > would improve the syscall time of 3.5% in these conditions.
> 
> I still think this is bad idea:
> 1) already existing CPU erratas against popular models. As I learned
>    yesterday -- SILENT reboot (often) or hang (rare).

I understand your fears. Actually, I had the same reaction when I heard
about the djprobes project. What I am doing with the immediate values
are a quite simpler version of live code patching which limits what has
to be patched to a very simple subset of instructions which layout
(alignment, etc) can be controlled.

I have taken the said erratas into consideration and developed the
algorithms that makes sure they won't be triggered. I would suggest that
you present test cases that proves your fear right, or if you could cite
documentation of the specific CPU models upon which you base your
comment.

Reproducing the errata both on PIII and Intel Core2 duo seems very hard
to achieve. If anyone out there have a "known" test case to trigger the
fault, I would gladly do some more testing to show the behavior without
my algorithm (non working) vs with my algorithm in the same conditions.


> 2) new type pretending to be standard and idiomatic -- immediate_t

Representing the data referred to by immediate_reads seems important to
me, because not doing so would result in people updating the variable
directly without using immediate_set, which, of course, would not update
all the references to the variable. If you have better suggestions, I am
open to them.

> 3) new almost-C-keyword -- immediate_if. What does it mean? You'll never
>    guess just by looking at it.

It's a special if() statement that uses its argument (an immediate
value) as a condition for a branch. The reason why it's not under the
form if (immediate_read(var)) is because I want to leave room from
improvement if gcc guys ever want to implement nop/jmp based branches
that could be patchable at runtime.

> 4) numbers! it's very entertaining to look at numbers with 4 digits
>    after comma and without any attempts to do error estimates.

Here are the test redone with error estimates :

10 runs of 100 iterations each: (I don't have more time to do the 10000
iterations I've done the first time, sorry, stats will take care of
showing the errors appropriately). Tests done on a 3GHz P4. Here I run
getppid with syscall trace inactive, comparing memory pressure and w/o
memory pressure. (sorry, my system is not setup to execute syscall_trace
this time, but it will make the point anyway).

No memory pressure
Reading timestamps:     150.92 cycles,     std dev.    1.01 cycles
getppid:               1462.09 cycles,     std dev.   18.87 cycles

With memory pressure
Reading timestamps:     578.22 cycles,     std dev.  269.51 cycles
getppid:              17113.33 cycles,     std dev. 1655.92 cycles


Now for memory read timing: (10 runs, branches per test: 100000)
Memory read based branch:
                       644.09 cycles,      std dev.   11.39 cycles
L1 cache hit based branch:
                        88.16 cycles,      std dev.    1.35 cycles


So, now that we have the raw results, let's calculate:

Memory read:
644.09±11.39 - 88.16±1.35 = 555.93±11.46 cycles

Getppid without memory pressure:
1462.09±18.87 - 150.92±1.01 = 1311.17±18.90 cycles

Getppid with memory pressure:
17113.33±1655.92 - 578.22±269.51 = 16535.11±1677.71 cycles

Therefore, if we add 2 markers not based on immediate values to the getppid
code, which would add 2 memory reads, we would add
2 * 555.93±12.74 = 1111.86±25.48 cycles

Therefore,

1111.86±25.48 / 16535.11±1677.71 = 0.0672
 relative error: sqrt(((25.48/1111.86)^2)+((1677.71/16535.11)^2))
                     = 0.1040
 absolute error: 0.1040 * 0.0672 = 0.0070

Therefore: 0.0672±0.0070 * 100% = 6.72±0.70 %

We can therefore affirm that adding 2 markers to getppid, on a system
with high memory pressure, would have a performance hit of at least 6.0
% on the system call time, all within the uncertainty limits of these
tests. The same applies to other kernel code paths. The smaller those
code paths are, the highest the impact ratio will be.


> 5) examples!
> 
> 	DEFINE_IMMEDIATE_TYPE(struct task_struct*, immediate_task_struct_ptr_t);
> 	immediate_task_struct_ptr_t myptr;
> 
>    this is close to hungarian notation, and threats were made to use
>    immediate stuff everywhere.

Same reason as 2). Note that the standard case is immediate_int_t,
immediate_long_t... and is not as bad as having to express the whole
pointer type in the type name. That's the best tradeoff between
restricting direct update of these pointers and code readability I have
seen. I am open to better solutions...


> 6) hundreds lines of new code playing with dynamic modifying
> 
> 
> For what you ask?
> 
> 
> For 1 (one) cacheline saving in schedule() which
> unlike getpid/getppid is non-trivial function, so all rosy numbers about
> speed savings aren't really applicable. And nobody measured how big it is
> on macro benchmark.
> 
> 
> So, this stuff should be put into CoolHacks case and put aside.
> It just not worth it!
> 

I think you are missing the whole point there. The scheduler profiling
patch is only an example of how immediate values can be used. Timer
stats would perfectly fit too, blktrace, .... actually, any feature that
is very useful to have in a distro, but where the choice much be made at
compile time can now be temporarily activated at runtime when needed.

"unlike getpid/getppid is non-trivial function" : I am instrumenting a
*lot* of kernel paths with LTTng, including do_syscall_entry and
do_syscall_exit, which happen to be executed upon *all* system calls
when tracing is active. I used getppid (tracing inactive, but
do_syscal_trace forced) to exemplify the performance difference of a
simple system call, but you must note that it applies to _every_ system
call in the kernel. I've seen people complain when impact of a dormant
tracer on the select() system call is noticeable _at all_, so, yes, a
3.5% impact on getppid is meaningful.

> A side note, folks at KS can discuss barrier for merging speed improvements.
> My feelings are around 1%.
> 

Should they discuss what performance deterioration is acceptable for new
infrastructures such as tracer too ? In the end, they may decide that
"it can be compiled away anyway", but distros will not ship kernels with
features that slows down the kernel and people will still complain that
Linux does not ship with a tracing alternative comparable to Dtrace.

The question that arises when selecting a new feature is not "what is
the average performance improvement of this", but rather "what is the
worse case performance hit". This is exactly what I address.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
