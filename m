Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZBJXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZBJXAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZBJXAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:00:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47978 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbZBJXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:00:17 -0500
Date: Tue, 10 Feb 2009 18:00:14 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: git pull request for tip/tracing/urgent
In-Reply-To: <20090210183046.GA1342@nowhere>
Message-ID: <alpine.DEB.1.10.0902101724190.23505@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com> <20090210183046.GA1342@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Feb 2009, Frederic Weisbecker wrote:
> > 
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index 1b43086..9d549e4 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -491,13 +491,15 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
> >  		"1: " _ASM_MOV " (%[parent_old]), %[old]\n"
> >  		"2: " _ASM_MOV " %[return_hooker], (%[parent_replaced])\n"
> >  		"   movl $0, %[faulted]\n"
> > +		"3:\n"
> >  
> >  		".section .fixup, \"ax\"\n"
> > -		"3: movl $1, %[faulted]\n"
> > +		"4: movl $1, %[faulted]\n"
> > +		"   jmp 3b\n"
> >  		".previous\n"
> 
> 
> It thought after the fixup section, the code would continue to rest of the C code.
> Where would it go without the jmp?

To the next item the linker placed into the .fixup section.  And that 
would jump back to the location for that fixup. Basically, what you have 
is this:

(just picking random and factitious registers)

.section .text
[...]
L1:	mov	%a, %b
L2:	cmp	%x, $1
<continue code>


<Someplace else>

.section .text
[...]
L3:	mov	%c, %d
L4:	cmp	%x, $22
[...]

.section .fixup
[...]
L5:	mov	$1, %x
	jmp L2
L6:	mov	$22, %x
	jmp L4
[...]


.section __ex_table
[...]
.long	L1, L5
.long	L3, L6
[...]


So when we take an exception at label L1, the page fault code will look 
to see if it is OK, by doing a binary search of the exception table.
When it finds the L1, L5 pair, it will then set up a return to the L5 
label.

When the fault returns to L5, it loads that reg %x with $1 and jumps back 
to L2, where it can see that it took a fault.

Now lets look at what happens when we do not have that jump back to L2. 
Instead of going back to the original code, it will load $22 into %x and 
jmp back to the wrong area. God knows what will happen then, since the 
stack pointer thinks it is from where the original fault occurred.

-- Steve

