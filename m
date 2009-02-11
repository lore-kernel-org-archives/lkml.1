Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZBKJDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZBKJDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZBKJCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:02:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48286 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZBKJCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:02:45 -0500
Date: Wed, 11 Feb 2009 10:02:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: git pull request for tip/tracing/urgent
Message-ID: <20090211090229.GG21105@elte.hu>
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com> <20090210183046.GA1342@nowhere> <alpine.DEB.1.10.0902101724190.23505@gandalf.stny.rr.com> <20090211012856.GA4921@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211012856.GA4921@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > 
> > > 
> > > It thought after the fixup section, the code would continue to rest of the C code.
> > > Where would it go without the jmp?
> > 
> > To the next item the linker placed into the .fixup section.  And that 
> > would jump back to the location for that fixup. Basically, what you have 
> > is this:
> > 
> > (just picking random and factitious registers)
> > 
> > .section .text
> > [...]
> > L1:	mov	%a, %b
> > L2:	cmp	%x, $1
> > <continue code>
> > 
> > 
> > <Someplace else>
> > 
> > .section .text
> > [...]
> > L3:	mov	%c, %d
> > L4:	cmp	%x, $22
> > [...]
> > 
> > .section .fixup
> > [...]
> > L5:	mov	$1, %x
> > 	jmp L2
> > L6:	mov	$22, %x
> > 	jmp L4
> > [...]
> > 
> > 
> > .section __ex_table
> > [...]
> > .long	L1, L5
> > .long	L3, L6
> > [...]
> > 
> > 
> > So when we take an exception at label L1, the page fault code will look 
> > to see if it is OK, by doing a binary search of the exception table.
> > When it finds the L1, L5 pair, it will then set up a return to the L5 
> > label.
> > 
> > When the fault returns to L5, it loads that reg %x with $1 and jumps back 
> > to L2, where it can see that it took a fault.
> > 
> > Now lets look at what happens when we do not have that jump back to L2. 
> > Instead of going back to the original code, it will load $22 into %x and 
> > jmp back to the wrong area. God knows what will happen then, since the 
> > stack pointer thinks it is from where the original fault occurred.
> 
> 
> Heh, that's fairly logic. Don't ask me why, but I did not imagine each
> part of .fixup unified in a separate contiguous section (but what else can it be?...).
> 
> Thanks for your explanations :-)

This bit:

  	".section .fixup, \"ax\"\n"
 	"4: movl $1, %[faulted]\n"
 	"   jmp 3b\n"
 	".previous\n"

Can be thought of as an 'embedded' or 'nested' section - the '.previous'
directive jumps back to whatever section we were in before. This can be
nested multiple times too:

   .section A
   [...]
     .section B
     [...]
        .section C
        [...]
        .previous
     [...]
     .previous
   [...]
   .previous

For whatever reason the interaction of the assembler with the linker and
in particular linker scripts are one of the most undocumented areas of OSS.
Does anyone know any good reference to start with? 

Something that explains the principles, how it all works, what the various
section flags mean in practice, including details like dwarf2/CFI annotations.

I do not know about any coherent documentation in this area and as a result
many developers shy away from this area, frequently mess it up if they have to
touch it and generally treat it as voodoo.

	Ingo
