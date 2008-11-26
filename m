Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYKZTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYKZTWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYKZTV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:21:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYKZTV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:21:57 -0500
Date: Wed, 26 Nov 2008 14:21:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Bird <tim.bird@am.sony.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] tracing/function-return-tracer: Support for dynamic
 ftrace on function return tracer
In-Reply-To: <492D940F.6090500@am.sony.com>
Message-ID: <alpine.DEB.1.10.0811261419120.28287@gandalf.stny.rr.com>
References: <491FA94E.9090207@gmail.com>  <alpine.DEB.1.10.0811241707240.907@gandalf.stny.rr.com> <c62985530811241421t1cd56b4el1ada0754df9a229@mail.gmail.com> <492D940F.6090500@am.sony.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[
  Sorry Tim to reply again, but alpine broke on Frederic's funny 
  characters in his email address, and it chopped off all the Cc's :-(
]

On Wed, 26 Nov 2008, Tim Bird wrote:
> 
> Very sorry I'm coming to this thread late.  I didn't notice it until
> today.
> 
> Not to question the whole approach, and sorry if this was
> discussed before, but why wasn't -finstrument-functions used
> to instrument the function exits.  This worked well for KFT
> (See http://elinux.org/Kernel_Function_Trace).  I'm not sure if the
> function prologue and epilogue modifications done by -mcount are
> different than -finstrument-functions, but I thought I remember 
something
> about Steven testing -finstrument-functions in an early version of 
ftrace.
> 
> By the way, I'm really excited to see this "function_cost" stuff being
> worked on.  It has proven to be extremely useful for analyzing early 
boot
> latencies at Sony.
> 

No prob Tim. I need to make a standard template to explain the reason not 
to use -finstrument-functions. (/me goes look for a previous post...)

Here it is:

 (here's the original post: http://lkml.org/lkml/2008/10/30/372 that
  was posted at the beginning of Frederic's work)

========================================================
Lets take a simple C file called traceme.c:


---
static int x;

void trace_me(void)
{
        x++;
}
---

Normal compiling of:

gcc -c traceme.c

produces:

00000000 <trace_me>:
   0:   55                      push   %ebp
   1:   89 e5                   mov    %esp,%ebp
   3:   a1 00 00 00 00          mov    0x0,%eax
                        4: R_386_32     .bss
   8:   83 c0 01                add    $0x1,%eax
   b:   a3 00 00 00 00          mov    %eax,0x0
                        c: R_386_32     .bss
  10:   5d                      pop    %ebp
  11:   c3                      ret    


With

gcc -c -pg traceme.c

00000000 <trace_me>:
   0:   55                      push   %ebp
   1:   89 e5                   mov    %esp,%ebp
   3:   e8 fc ff ff ff          call   4 <trace_me+0x4>
                        4: R_386_PC32   mcount
   8:   a1 00 00 00 00          mov    0x0,%eax
                        9: R_386_32     .bss
   d:   83 c0 01                add    $0x1,%eax
  10:   a3 00 00 00 00          mov    %eax,0x0
                        11: R_386_32    .bss
  15:   5d                      pop    %ebp
  16:   c3                      ret    


The only difference between the two is an added "call mcount".
5 byte op to replace with dynamic ftrace.

But now lets look at:

gcc -c -finstrument-functions traceme.c

00000000 <trace_me>:
   0:   55                      push   %ebp
   1:   89 e5                   mov    %esp,%ebp
   3:   83 ec 18                sub    $0x18,%esp
   6:   8b 45 04                mov    0x4(%ebp),%eax
   9:   89 44 24 04             mov    %eax,0x4(%esp)
   d:   c7 04 24 00 00 00 00    movl   $0x0,(%esp)
                        10: R_386_32    trace_me
  14:   e8 fc ff ff ff          call   15 <trace_me+0x15>
                        15: R_386_PC32  __cyg_profile_func_enter
  19:   a1 00 00 00 00          mov    0x0,%eax
                        1a: R_386_32    .bss
  1e:   83 c0 01                add    $0x1,%eax
  21:   a3 00 00 00 00          mov    %eax,0x0
                        22: R_386_32    .bss
  26:   8b 45 04                mov    0x4(%ebp),%eax
  29:   89 44 24 04             mov    %eax,0x4(%esp)
  2d:   c7 04 24 00 00 00 00    movl   $0x0,(%esp)
                        30: R_386_32    trace_me
  34:   e8 fc ff ff ff          call   35 <trace_me+0x35>
                        35: R_386_PC32  __cyg_profile_func_exit
  39:   c9                      leave  
  3a:   c3                      ret    

Here we see that

        mov     %eax, 0x4(%esp)
        movl    $trace_me,(%esp)
        call    _cyg_profile_func_enter

is added at the beginning and

        mov     %eax,0x4(%esp)
        mov     $trace_me,(%esp)
        call    __cyg_profile_func_exit

is added at the end.

This is not 5 extra bytes but 27 extra bytes for a total of 32 bytes
at every function.

========================================================

The overhead of -finstrument-functions is way too big. Remember, with 
using mcount, we can also patch away the callers. It's 5 bytes on both 
x86_64 and i386 and 4 bytes on most other archs. To patch away the 
-finstrument-functions would be too large, not to mention, you could not 
do it with nops. You whould have to have a jump, since patching more than 
one op code would lead to race conditions with a task being preempted in 
the middle of those nops.

I need to file this information away to give the next person that asks 
this question ;-)

> Sorry again I didn't catch this and previous related threads
> earlier.  I have some post-processing tools which might be useful here.
> Also, I've found it very handy to have the capability to filter by 
minimum
> function duration.  Is there any work to do that with the
> current system.  If not, maybe I could take a look at that and see if
> I can add something.
> 

Actually, I probably should have Cc'd you anyway. I know you did similar 
work. You may be able to add that filtering to the dynamic ftrace so that 
the tracer will filter them out as well.  If you want to work on this, 
feel free. There's already been a lot of good ideas (and code) coming from 
other developers :-)

-- Steve

