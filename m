Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbXIQWzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbXIQWzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbXIQWzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:55:05 -0400
Received: from ozlabs.org ([203.10.76.45]:45684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbXIQWzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:55:03 -0400
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module
	Mutex
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20070914153230.GA29743@Krystal>
References: <20070906200228.086651361@polymtl.ca>
	 <20070906200314.079453533@polymtl.ca>
	 <20070908072811.GB1819@martell.zuzino.mipt.ru>
	 <1189468414.8023.66.camel@localhost.localdomain>
	 <20070911004541.GA4360@Krystal>
	 <1189487938.20631.53.camel@localhost.localdomain>
	 <20070911142733.GA7850@Krystal>
	 <1189662432.32322.1.camel@localhost.localdomain>
	 <20070913212107.GA15826@Krystal>
	 <1189725317.7262.23.camel@localhost.localdomain>
	 <20070914153230.GA29743@Krystal>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 08:54:19 +1000
Message-Id: <1190069659.7262.141.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 11:32 -0400, Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > Alternatively, if you called it "immediate_init" then the semantics
> > change slightly, but are more obvious (ie. only use this when the value
> > isn't being accessed yet).  But it can't be __init then anyway.
> > 
> 
> I think your idea is good. immediate_init() could be used to update the
> immediate values at boot time _and_ at module load time, and we could
> use an architecture specific arch_immediate_update_init() to support it.

Right.

> As for "when" to use this, it should be used at boot time when
> interrupts are still disabled, still running in UP. It can also be used
> at module load time before any of the module code is executed, as long
> as the module code pages are writable (which they always are, for
> now..). Therefore, the flag seems inappropriate for module load
> arch_immediate_update_init. It cannot be put in __init section neither
> though if we use it like this.

I think from a user's POV it would be nice to have a 1:1 mapping with
normal initialization semantics (ie. it will work as long as you don't
access this value until initialized).  And I think this would be the
case.  eg:

        int foo_func(void)
        {
        	if (immediate_read(&some_immediate))
        		return 0;
        	...
        }
        
        int some_init(void)
        {
        	immediate_init(some_immediate, 0);
        	register_foo(foo_func);
        	...
        }


> > On an unrelated note, did you consider simply IPI-ing and doing the
> > substitution with all CPUs stopped?  If you only updated the immediate
> > references to this particular var, it should be fast enough not to upset
> > the RT guys, even.
> > 
> 
> Yes, I thought about this, but since I use immediate values in the
> kernel markers, which can be put in exception handlers (including nmi,
> mce handler), which cannot be disabled without important side-effects, I
> don't think trying to stop the CPUs is a workable solution.

OK, but can you justify the use of immediates within the nmi or mce
handlers?  They don't strike me as useful candidates for optimization.

> > Well, you can do that in asm without gcc support.  It's a little nasty:
> > since gcc will know nothing about the function call, it can't have side
> > effects which are visible in this function, and you'll have to save and
> > restore *all* regs if you decide to do the function call.  But it's
> > possible (a 5-byte nop gets changed to a call, the call does the pushes
> > and sets the args regs, calls the function, then pops everything and
> > rets).
> 
> GCC support is required if we want to embed inline functions inside
> unlikely branches depending on immediate values (no function call
> there). It also permits passing local variables as arguments to the
> function call (stack setup), which would be tricky, instrumentation site
> specific and non portable if done in assembly.

Well if this is the slow path, you don't want inline anyway.  But it
would be horribly, horribly arch-specific, yes.

Rusty.

