Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZBCPMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZBCPMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbZBCPM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:12:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbZBCPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:12:26 -0500
Date: Tue, 3 Feb 2009 16:12:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC WIP] x86/paravirt: add register-saving thunks to
	reduce caller register pressure
Message-ID: <20090203151213.GE29046@elte.hu>
References: <4980A07D.3010008@goop.org> <20090130210625.GD1253@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130210625.GD1253@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> 
> > This patch seeks to alleviate this pressure by introducing wrapper
> > thunks that will do the register saving/restoring, so that the
> > callsite doesn't need to worry about it, but the callee function can
> > be conventional compiler-generated code.  In many cases (particularly
> > performance-sensitive cases) the callee will be in assembler anyway,
> > and need not use the compiler's calling convention.
> >
> > Standard calling convention is:
> > 	 arguments	    return	scratch
> > x86-32	 eax edx ecx	    eax		?
> 
> esi edi ebp ?

No, they are not scratch [callee-clobbered] registers, they are 
callee-saved.

Jeremy's table is incomplete (and incorrect on 64-bit):

|  Standard calling convention is:
|           arguments          return	scratch
|  x86-32   eax edx ecx        eax         ?
|  x86-64   rdi rsi rdx rcx    rax         r8 r9 r10 r11

The correct one is:

 x86 function calling convention, 64-bit:
 ----------------------------------------
  arguments            |  callee-saved       | extra caller-saved | return
 [callee-clobbered]    |                     | [callee-clobbered] |
 ---------------------------------------------------------------------------
 rdi rsi rdx rcx r8 r9 | rbx rbp [*] r12-r15 | r10, r11           | rax [**]

 ( rsp is obviously invariant across normal function calls. (gcc can 'merge'
   functions when it sees tail-call optimization possibilities) rflags is
   clobbered. Leftover arguments are passed over the stack frame. )

 [*]  In the frame-pointers case ebp is fixed to the stack frame.

 [**] for struct return values wider than 64 bits the return convention is a 
      bit more complex: up to 128 bits width we return small structures 
      straight in rax, rdx. For structures larger than that (3 words or 
      larger) the caller puts a pointer to an on-stack return struct 
      [allocated in the caller's stack frame] into the first argument - i.e. 
      into rdi. All other arguments shift up by one in this case. 
      Fortunately this case is rare in the kernel.

As you can see r8 and r9 are regparm arguments for 5 or 6 parameter calls 
and not just extra scratch registers. (although they certainly can be used 
as such too - all regparm arguments are callee-clobbered on x86)

For 32-bit we have the following conventions - kernel is build with 
-mregparm=3 and -freg-struct-return:

 x86 function calling convention, 32-bit:
 ----------------------------------------
  arguments         | callee-saved        | extra caller-saved | return
 [callee-clobbered] |                     | [callee-clobbered] |
 -------------------------------------------------------------------------
 eax edx ecx        | ebx edi esi ebp [*] | <none>             | eax, [**]

 ( here too esp is obviously invariant across normal function calls. eflags
   is clobbered. Leftover arguments are passed over the stack frame. )

 [*]  In the frame-pointers case ebp is fixed to the stack frame.

 [**] We build with -freg-struct-return, which on 32-bit means similar
      semantics as on 64-bit: edx can be used for a second return value 
      (i.e. covering structure sizes up to 64 bits) - after that it gets 
      more complex and more expensive: 3-word or larger struct returns get 
      done in the caller's frame and the pointer to the return struct goes 
      into regparm0, i.e. eax - the other arguments shift up and the 
      function's register parameters degenerate to regparm=2 in essence.

> actually standard calling convention is all arguments on stack iirc but we 
> use regparm=3 for kernel...?

Correct, 32-bit x86 gets built with:

   KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return

	Ingo
