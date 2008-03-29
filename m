Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYC2RQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYC2RQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYC2RQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:16:39 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:39199 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYC2RQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:16:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag4FAEMW7kdMQWoK/2dsb2JhbACBWqgK
Date: Sat, 29 Mar 2008 13:16:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080329171631.GA1537@Krystal>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <20080327203927.GA19968@Krystal> <20080328133301.GA21660@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080328133301.GA21660@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:47:44 up 29 days, 12:58,  4 users,  load average: 0.87, 0.57,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> >  6a5:   89 5c 24 14             mov    %ebx,0x14(%esp)
> >  6a9:   8b 55 d0                mov    -0x30(%ebp),%edx
> >  6ac:   89 54 24 10             mov    %edx,0x10(%esp)
> >  6b0:   89 4c 24 0c             mov    %ecx,0xc(%esp)
> >  6b4:   c7 44 24 08 f7 04 00    movl   $0x4f7,0x8(%esp)
> >  6bb:   00 
> >  6bc:   c7 44 24 04 00 00 00    movl   $0x0,0x4(%esp)
> >  6c3:   00 
> >  6c4:   c7 04 24 00 00 00 00    movl   $0x0,(%esp)
> >  6cb:   ff 15 0c 00 00 00       call   *0xc
> >  6d1:   e9 c3 fc ff ff          jmp    399 <schedule+0x130>
> > 
> > Which adds an extra 50 bytes.
> 
> you talk about 32-bit while i talk about 64-bit. All these costs go up 
> on 64-bit and you should know that. I measured 44 bytes in the fastpath 
> and 52 bytes in the slowpath, which gives 96 bytes. (with a distro 
> .config and likely with a different gcc)
> 

I did some testing with gcc -Os and -O2 on x86_64 and noticed that -Os
behaves badly in that it does not uses -freorder-blocks. This
optimization is required to have the unlikely branches moved out of the
critical path.

With -O2 :
        mov $0,%al
        movq    %rsi, 1912(%rbx)
        movq    -96(%rbp), %rdi
        incq    (%rdi)
        testb   %al, %al
        jne     .L1785


 4de:   b0 00                   mov    $0x0,%al
 4e0:   48 89 b3 78 07 00 00    mov    %rsi,0x778(%rbx)
 4e7:   48 8b 7d a0             mov    0xffffffffffffffa0(%rbp),%rdi
 4eb:   48 ff 07                incq   (%rdi)
 4ee:   84 c0                   test   %al,%al
 4f0:   0f 85 5f 03 00 00       jne    855 <thread_return+0x2b4>

So, as far as the assembly for the markers in the fast path is
concerned, it adds 10 bytes to the fast path, on x86_64. (I did not
count the %rdi stuff in this since I suppose it's unrelated to markers
and put there by the compiler which reorders instructions)

The bloc which contains the call is much lower at the end of
thread_return.

 855:   49 89 f0                mov    %rsi,%r8
 858:   48 89 d1                mov    %rdx,%rcx
 85b:   31 f6                   xor    %esi,%esi
 85d:   48 89 da                mov    %rbx,%rdx
 860:   48 c7 c7 00 00 00 00    mov    $0x0,%rdi
 867:   31 c0                   xor    %eax,%eax
 869:   ff 15 00 00 00 00       callq  *0(%rip)        # 86f <thread_return+0x2ce>
 86f:   e9 82 fc ff ff          jmpq   4f6 <schedule+0x166>

For an added 31 bytes.

Total size added : 41 bytes, 10 of them being in the fast path.


> 96 bytes _per marker_ sprinkled throughout the kernel. This blows up the 
> cache footprint of the kernel quite substantially, because it's all 
> fragmented - even if this is in the 'slowpath'.
> 
> so yes, that is the bloat i'm talking about.
> 

I think the very different compiler options we use change the picture
significantly.

> dont just compare it to ftrace-sched-switch, compare it to dyn-ftrace 
> which gives us more than 78,000 trace points in the kernel _here and 
> today_ at no measurable runtime cost, with a 5 byte NOP per trace point 
> and _zero_ instruction stream (register scheduling, etc.) intrusion. No 
> slowpath cost.
> 

Markers and dyn-ftrace does not fulfill the same purpose, so I don't see
why we should compare them. dyn-ftrace is good at tracing function
entry/exit, so let's keep it. However, it's not designed to extract
variables at specific locations in the kernel code.

Which slowpath cost are you talking about ? When markers are disabled,
their unused function call instructions are placed carefully out of the
kernel running code, along with BUG_ONs and WARN_ONs which already use
some cache lines. You are talking about no measurable runtime cost :
have you tried to measure the runtime cost of disabled markers ? I have
not been able to measure any significant difference with the complete
LTTng marker set compiled into the kernel.

> and the basic API approach of markers is flawed a well - the coupling to 
> the kernel is too strong. The correct and long-term maintainable 
> coupling is via ASCII symbol names, not via any binding built into the 
> kernel.
> 
> With dyn-ftrace (see sched-devel.git/latest) tracing filters can be 
> installed trivially by users, via function _symbols_, via:
> 
>   /debugfs/tracing/available_filter_functions
>   /debugfs/tracing/set_ftrace_filter
> 
> wildcards are recognized as well, so if you do:
> 
>   echo '*lock' > /debugfs/tracing/set_ftrace_filter
> 
> all functions that have 'lock' in their name will have their tracepoints 
> activated transparently from that point on.
> 
> even multiple names can be passed in at once:
> 
>   echo 'schedule wake_up* *acpi*' > /debugfs/tracing/set_ftrace_filter
> 
> so it's trivial to use it, very powerful and we've only begun exposing 
> it towards users. I see no good reason why we'd patch any marker into 
> the kernel - it's a maintenance cost from that point on.
> 

I did something similar with LTTng :

cat /proc/ltt  lists the available markers
echo "connect marker_name default dynamic channel_name" > /proc/ltt

Which indicates 
- The type of callback to use
- Where the data must be sent (LTTng supports multiple buffers, called
  "channels")

So yes, making this easy to use has been done. It's just that the marker
is one building block of the tracing infrastructure, not its entirety.

By the way, I like your tracing filters interface. It seems rather more
polished than my /proc interface. And personnally I don't care wether we
use /proc, debugfs.. as long as there is an interface to userspace.


> so yes, my argument is: tens of thousands of lightweight tracepoints in 
> the kernel here and today, which are configurable via function names, 
> each of which can be turned on and off individually, and none of which 
> needs any source code level changes - is an obviously superior approach.
> 

It's absolutely good to have that into the kernel, but it does not
_replace_ the markers, as I explained above.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
