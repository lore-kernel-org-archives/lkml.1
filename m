Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZBKNkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZBKNkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZBKNkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:40:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:12102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZBKNkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:40:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l4983f78Fd7eRAjzv+Bcg4zaX+XKGtqYDegF8JU2rRA14jhVbaXeO/N29TvcEDq81/
         /rShtizAGwU10hcDdujR9X8KVcpy26KmS7SKOy5mIrpvetUbkeaAKzbPS8ZCk5M4aeGN
         i2Gl3vX42uTic9+DFPrmjQjytiWN6XZDzefjs=
Date: Wed, 11 Feb 2009 14:40:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: git pull request for tip/tracing/urgent
Message-ID: <20090211134004.GB5914@nowhere>
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com> <20090210183046.GA1342@nowhere> <alpine.DEB.1.10.0902101724190.23505@gandalf.stny.rr.com> <20090211012856.GA4921@nowhere> <20090211090229.GG21105@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211090229.GG21105@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 10:02:29AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > > 
> > > > 
> > > > It thought after the fixup section, the code would continue to rest of the C code.
> > > > Where would it go without the jmp?
> > > 
> > > To the next item the linker placed into the .fixup section.  And that 
> > > would jump back to the location for that fixup. Basically, what you have 
> > > is this:
> > > 
> > > (just picking random and factitious registers)
> > > 
> > > .section .text
> > > [...]
> > > L1:	mov	%a, %b
> > > L2:	cmp	%x, $1
> > > <continue code>
> > > 
> > > 
> > > <Someplace else>
> > > 
> > > .section .text
> > > [...]
> > > L3:	mov	%c, %d
> > > L4:	cmp	%x, $22
> > > [...]
> > > 
> > > .section .fixup
> > > [...]
> > > L5:	mov	$1, %x
> > > 	jmp L2
> > > L6:	mov	$22, %x
> > > 	jmp L4
> > > [...]
> > > 
> > > 
> > > .section __ex_table
> > > [...]
> > > .long	L1, L5
> > > .long	L3, L6
> > > [...]
> > > 
> > > 
> > > So when we take an exception at label L1, the page fault code will look 
> > > to see if it is OK, by doing a binary search of the exception table.
> > > When it finds the L1, L5 pair, it will then set up a return to the L5 
> > > label.
> > > 
> > > When the fault returns to L5, it loads that reg %x with $1 and jumps back 
> > > to L2, where it can see that it took a fault.
> > > 
> > > Now lets look at what happens when we do not have that jump back to L2. 
> > > Instead of going back to the original code, it will load $22 into %x and 
> > > jmp back to the wrong area. God knows what will happen then, since the 
> > > stack pointer thinks it is from where the original fault occurred.
> > 
> > 
> > Heh, that's fairly logic. Don't ask me why, but I did not imagine each
> > part of .fixup unified in a separate contiguous section (but what else can it be?...).
> > 
> > Thanks for your explanations :-)
> 
> This bit:
> 
>   	".section .fixup, \"ax\"\n"
>  	"4: movl $1, %[faulted]\n"
>  	"   jmp 3b\n"
>  	".previous\n"
> 
> Can be thought of as an 'embedded' or 'nested' section - the '.previous'
> directive jumps back to whatever section we were in before. This can be
> nested multiple times too:
> 
>    .section A
>    [...]
>      .section B
>      [...]
>         .section C
>         [...]
>         .previous
>      [...]
>      .previous
>    [...]
>    .previous
> 
> For whatever reason the interaction of the assembler with the linker and
> in particular linker scripts are one of the most undocumented areas of OSS.
> Does anyone know any good reference to start with? 
> 
> Something that explains the principles, how it all works, what the various
> section flags mean in practice, including details like dwarf2/CFI annotations.
> 
> I do not know about any coherent documentation in this area and as a result
> many developers shy away from this area, frequently mess it up if they have to
> touch it and generally treat it as voodoo.
> 
> 	Ingo

When I wrote this part, I used the following documentation:

http://tldp.org/LDP/khg/HyperNews/get/devices/exceptions.html

But yeah, the assembler/linker stuff documentation for gcc are not so much
documented.

There is the raw reference:
http://sourceware.org/binutils/docs/as/index.html

Concerning examples, practical cases, it is exploded on several parts on the web, some good
links can be found on http://asm.sourceforge.net/

Thanks for your explanation.
But I'm confused, if the .previous make a jump to the previous section, then it already
does what jmp 3b does right?

