Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZBKB3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZBKB3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZBKB3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:29:03 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:42362 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZBKB3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:29:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hWZrsSTGdJevAATHAwkQZeRw5zg5i+FFeSolXhPrk2rI6lT6jBoxJuUig5YA9Sx4Mg
         dmAqj/xvDN0KqRPdJZhog9tS/Yli0/PEQBjviplgF6zg3gg5vRKtFxlVVrTMu/4P4g+L
         qT7yb41TFc8ynCu2c1pR20GwhSmcZpys4rFfA=
Date: Wed, 11 Feb 2009 02:28:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: git pull request for tip/tracing/urgent
Message-ID: <20090211012856.GA4921@nowhere>
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com> <20090210183046.GA1342@nowhere> <alpine.DEB.1.10.0902101724190.23505@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902101724190.23505@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 06:00:14PM -0500, Steven Rostedt wrote:
> 
> 
> On Tue, 10 Feb 2009, Frederic Weisbecker wrote:
> > > 
> > > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > > index 1b43086..9d549e4 100644
> > > --- a/arch/x86/kernel/ftrace.c
> > > +++ b/arch/x86/kernel/ftrace.c
> > > @@ -491,13 +491,15 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
> > >  		"1: " _ASM_MOV " (%[parent_old]), %[old]\n"
> > >  		"2: " _ASM_MOV " %[return_hooker], (%[parent_replaced])\n"
> > >  		"   movl $0, %[faulted]\n"
> > > +		"3:\n"
> > >  
> > >  		".section .fixup, \"ax\"\n"
> > > -		"3: movl $1, %[faulted]\n"
> > > +		"4: movl $1, %[faulted]\n"
> > > +		"   jmp 3b\n"
> > >  		".previous\n"
> > 
> > 
> > It thought after the fixup section, the code would continue to rest of the C code.
> > Where would it go without the jmp?
> 
> To the next item the linker placed into the .fixup section.  And that 
> would jump back to the location for that fixup. Basically, what you have 
> is this:
> 
> (just picking random and factitious registers)
> 
> .section .text
> [...]
> L1:	mov	%a, %b
> L2:	cmp	%x, $1
> <continue code>
> 
> 
> <Someplace else>
> 
> .section .text
> [...]
> L3:	mov	%c, %d
> L4:	cmp	%x, $22
> [...]
> 
> .section .fixup
> [...]
> L5:	mov	$1, %x
> 	jmp L2
> L6:	mov	$22, %x
> 	jmp L4
> [...]
> 
> 
> .section __ex_table
> [...]
> .long	L1, L5
> .long	L3, L6
> [...]
> 
> 
> So when we take an exception at label L1, the page fault code will look 
> to see if it is OK, by doing a binary search of the exception table.
> When it finds the L1, L5 pair, it will then set up a return to the L5 
> label.
> 
> When the fault returns to L5, it loads that reg %x with $1 and jumps back 
> to L2, where it can see that it took a fault.
> 
> Now lets look at what happens when we do not have that jump back to L2. 
> Instead of going back to the original code, it will load $22 into %x and 
> jmp back to the wrong area. God knows what will happen then, since the 
> stack pointer thinks it is from where the original fault occurred.


Heh, that's fairly logic. Don't ask me why, but I did not imagine each
part of .fixup unified in a separate contiguous section (but what else can it be?...).

Thanks for your explanations :-)

 
> -- Steve
> 

