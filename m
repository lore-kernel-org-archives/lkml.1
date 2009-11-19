Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZKSRlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZKSRlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZKSRlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:41:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbZKSRlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:41:45 -0500
Date: Thu, 19 Nov 2009 09:39:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911190934070.2793@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Nov 2009, Thomas Gleixner wrote:
> 
> standard function start:
> 
> 	 push	%ebp
> 	 mov	%esp, %ebp
> 	 ....
> 	 call   mcount
> 
> modified function start on a handful of functions only seen with gcc
> 4.4.x on x86 32 bit:
> 
> 	push   %edi
> 	lea    0x8(%esp),%edi
> 	and    $0xfffffff0,%esp
> 	pushl  -0x4(%edi)
> 	push   %ebp
> 	mov    %esp,%ebp
> 	...
> 	call   mcount

That's some crazy sh*t anyway, since we don't _want_ the stack to be 
16-byte aligned in the kernel. We do

        KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)

why is that not working?

So this looks like a gcc bug, plain and simple.

> This modification leads to a hard to solve problem in the kernel
> function graph tracer which assumes that the stack looks like:
> 
>        return address
>        saved  ebp

Umm. But it still does, doesn't it? That

	pushl  -0x4(%edi)
	push   %ebp

should do it - the "-0x4(%edi)" thing seems to be trying to reload the 
return address. No? 

Maybe I misread the code - but regardless, it does look like a gcc code 
generation bug if only because we really don't want a 16-byte aligned 
stack anyway, and have asked for it to not be done.

So I agree that gcc shouldn't do that crazy prologue (and certainly _not_ 
before calling mcount anyway), but I'm not sure I agree with that detail 
of your analysis or explanation.

				Linus
