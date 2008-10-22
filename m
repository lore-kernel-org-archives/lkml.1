Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYJVLH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYJVLH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYJVLHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:07:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbYJVLHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:07:15 -0400
Date: Wed, 22 Oct 2008 07:07:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: make dynamic ftrace more robust
In-Reply-To: <20081022065346.GD17485@elte.hu>
Message-ID: <alpine.DEB.1.10.0810220658380.21358@gandalf.stny.rr.com>
References: <20081021164018.889518687@goodmis.org> <20081021164302.399002797@goodmis.org> <20081022065346.GD17485@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +enum {
> > +	FTRACE_CODE_MODIFIED,
> 
> i'd suggest to name it FTRACE_CODE_MODIFIED_OK here, to make it stand 
> out from the failure codes.
> 
> > +	FTRACE_CODE_FAILED_READ,
> > +	FTRACE_CODE_FAILED_CMP,
> > +	FTRACE_CODE_FAILED_WRITE,
> 
> but maybe we should just use the standard kernel return codes. 0 for 
> success, -EINVAL for the rest. Is there any real value to know exactly 
> why it failed? We just know the modification was fishy (this is an 
> exception situation), and want to stop ftrace ASAP and then print a 
> warning so a kernel developer can debug it.

Yes it is important to know the reason of failure, since it helps with
diagnosing the issue.

> 
> Complicating error handling by introducing similar-looking return code 
> names just makes it easier to mess up accidentally, hence it _reduces_ 
> robustness.

I had in mind for 2.6.29 that I would let an arch add another non-error 
code that says, "FAIL NICELY". This is a way, for example, to let an
arch not be able to modify the code because it does not have the ability
yet. Like with the trampoline example. I wanted to let the arch say,
I do not make this kind of change, but it is not a bug (I didn't modify
anything) simply ignore. And have ftrace simply remove the record and go
on.

> 
> > --- linux-compile.git.orig/include/linux/init.h	2008-10-20 19:39:54.000000000 -0400
> > +++ linux-compile.git/include/linux/init.h	2008-10-20 19:40:06.000000000 -0400
> > @@ -75,15 +75,15 @@
> >  
> >  
> >  #ifdef MODULE
> > -#define __exitused
> > +#define __exitused  notrace
> >  #else
> > -#define __exitused  __used
> > +#define __exitused  __used  notrace
> >  #endif
> >  
> >  #define __exit          __section(.exit.text) __exitused __cold
> >  
> >  /* Used for HOTPLUG */
> > -#define __devinit        __section(.devinit.text) __cold
> > +#define __devinit        __section(.devinit.text) __cold notrace
> >  #define __devinitdata    __section(.devinit.data)
> >  #define __devinitconst   __section(.devinit.rodata)
> >  #define __devexit        __section(.devexit.text) __exitused __cold
> > @@ -91,7 +91,7 @@
> >  #define __devexitconst   __section(.devexit.rodata)
> >  
> >  /* Used for HOTPLUG_CPU */
> > -#define __cpuinit        __section(.cpuinit.text) __cold
> > +#define __cpuinit        __section(.cpuinit.text) __cold notrace
> >  #define __cpuinitdata    __section(.cpuinit.data)
> >  #define __cpuinitconst   __section(.cpuinit.rodata)
> >  #define __cpuexit        __section(.cpuexit.text) __exitused __cold
> > @@ -99,7 +99,7 @@
> >  #define __cpuexitconst   __section(.cpuexit.rodata)
> >  
> >  /* Used for MEMORY_HOTPLUG */
> > -#define __meminit        __section(.meminit.text) __cold
> > +#define __meminit        __section(.meminit.text) __cold notrace
> >  #define __meminitdata    __section(.meminit.data)
> >  #define __meminitconst   __section(.meminit.rodata)
> >  #define __memexit        __section(.memexit.text) __exitused __cold
> 
> there's no justification given for this in the changelog and the change 
> looks fishy.

Sorry, I missed writing this. I had it in other patches, but forgot to
add the change log here. These are areas, just like the __init section
that I have no way ok finding out in an arch independent way, what to
remove from the ftrace records. So by not adding these notraces, we are
guaranteed to hit the warnings above!

> 
> >  static void ftrace_free_rec(struct dyn_ftrace *rec)
> >  {
> > +	/*
> > +	 * No locking, only called from kstop_machine, or
> > +	 * from module unloading with module locks and interrupts
> > +	 * disabled to prevent kstop machine from running.
> > +	 */
> > +
> > +	WARN_ON(rec->flags & FTRACE_FL_FREE);
> 
> this should _NOT_ be just a WARN_ON(). It should immediately stop ftrace 
> entirely, then print _one_ warning. Then it should never ever run up to 
> the next reboot.
> 
> this is a basic principle for instrumentation. If we detect a bug we 
> disable ourselves immediately and print a _single_ warning.
> 
> Do _not_ print possibly thousands of warnings and continue as if nothing 
> happened ...

Fine. I'll replace all WARN_ONs with FTRACE_WARN_ONS.

> 
> > +					/* kprobes was not the fault */
> > +					ftrace_kill_atomic();
> 
> while at it, ftrace_kill_atomic() is a misnomer.
> 
> Please use something more understandable and less ambigious, like 
> "ftrace_turn_off()". Both 'kill' and 'atomic' are heavily laden phrases 
> used for many other things in the kernel.
> 
> And any such facility must work from any context, because we might call 
> it from crash paths, etc. So dont name it _atomic() - it must obviously 
> be atomic.

The reason for the naming was that ftrace_kill was used when I knew 
something was wrong but not seriously wrong. But enough to disable ftrace 
with the kstop_machine. But fine, I'll fix it.

-- Steve

