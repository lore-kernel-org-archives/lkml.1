Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbYJ3TSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbYJ3TSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbYJ3TRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:17:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991AbYJ3TRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:17:47 -0400
Date: Thu, 30 Oct 2008 15:17:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
In-Reply-To: <20081030183714.GA17822@elte.hu>
Message-ID: <alpine.DEB.1.10.0810301447490.15853@gandalf.stny.rr.com>
References: <490A08E3.2040201@gmail.com> <20081030182056.GA14102@elte.hu> <c62985530810301130q41cc5c0ete2d7610d2172775@mail.gmail.com> <20081030183714.GA17822@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Ingo Molnar wrote:
> 
> OTOH, dyn-ftrace changes the picture dramatically, with its NOP 
> insertion and opt-in tricks. Still, one more 5-byte NOP in every 
> function is still something not to be done lightly.

I originally wanted to use -finstrument-functions but looking into it 
caused some problems.

> In that sense your mcount enhancement is better, as it does not 
> increase the default (single NOP) cost. It can also be 
> enabled/disabled dynamically in addition to the 'half-way profiling' 
> mcount solution we have today. So i like it at first sight - if it can 
> be made stable ;-)

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
			22: R_386_32	.bss
  26:	8b 45 04             	mov    0x4(%ebp),%eax
  29:	89 44 24 04          	mov    %eax,0x4(%esp)
  2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
			30: R_386_32	trace_me
  34:	e8 fc ff ff ff       	call   35 <trace_me+0x35>
			35: R_386_PC32	__cyg_profile_func_exit
  39:	c9                   	leave  
  3a:	c3                   	ret    

Here we see that

	mov	%eax, 0x4(%esp)
	movl	$trace_me,(%esp)
	call	_cyg_profile_func_enter

is added at the beginning and

	mov	%eax,0x4(%esp)
	mov	$trace_me,(%esp)
	call	__cyg_profile_func_exit

is added at the end.

This is not 5 extra bytes but 27 extra bytes for a total of 32 bytes
at every function. Also note that this also adds these calls to inline 
functions as well. We could easly stop that by adding "notrace" to the
inline define (which I've done).

But this would make the patching a bit more difficult (not impossible).
But it will bloat the image quite a bit.

I've thought about adding an option to enable this over -pg, which would
be doable, but I wanted to let the current code get settled before doing 
so.

-- Steve

