Return-Path: <linux-kernel-owner+w=401wt.eu-S1765870AbXINPhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765870AbXINPhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 11:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXINPhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 11:37:46 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:41356 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbXINPhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 11:37:45 -0400
Date: Fri, 14 Sep 2007 11:32:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module Mutex
Message-ID: <20070914153230.GA29743@Krystal>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.079453533@polymtl.ca> <20070908072811.GB1819@martell.zuzino.mipt.ru> <1189468414.8023.66.camel@localhost.localdomain> <20070911004541.GA4360@Krystal> <1189487938.20631.53.camel@localhost.localdomain> <20070911142733.GA7850@Krystal> <1189662432.32322.1.camel@localhost.localdomain> <20070913212107.GA15826@Krystal> <1189725317.7262.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1189725317.7262.23.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:20:56 up 46 days, 15:39,  4 users,  load average: 0.06, 0.29, 0.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thu, 2007-09-13 at 17:21 -0400, Mathieu Desnoyers wrote:
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > Sure, but why is that the caller's problem?  immediate_set() isn't
> > > fastpath, so why not make it do an "if (early_boot)" internally?
> > 
> > I see two reasons:
> > 1 - early_boot, or anything that looks like this, does not exist
> > currently (and the following reason might show why).
> > 2 - If we use this, we cannot declare the early code with __init, so it
> > will have to stay there forever insteaf of being removable once boot is
> > over.
> > 
> > Therefore, I think it's better to stick to an immediate_set_early
> > version.
> 
> My problem is that I don't know when to use immediate_set_early!  You
> say "early boot": what does that mean?  Is it arch-specific?  And why is
> it my problem anyway?
> 
> Since arch_immediate_update_early() is a memcpy, I don't really buy the
> bloat argument (it has some silly-looking optimization, but that should
> be removed anyway).  I'd really rather see arch_immediate_update()
> examine an internal flag and do the memcpy if it's too early for the
> full algorithm.  That's the only place which really knows, after all.
> You may need some external hook to update that internal "too early"
> flag, of course.
> 
> Alternatively, if you called it "immediate_init" then the semantics
> change slightly, but are more obvious (ie. only use this when the value
> isn't being accessed yet).  But it can't be __init then anyway.
> 

I think your idea is good. immediate_init() could be used to update the
immediate values at boot time _and_ at module load time, and we could
use an architecture specific arch_immediate_update_init() to support it.

As for "when" to use this, it should be used at boot time when
interrupts are still disabled, still running in UP. It can also be used
at module load time before any of the module code is executed, as long
as the module code pages are writable (which they always are, for
now..). Therefore, the flag seems inappropriate for module load
arch_immediate_update_init. It cannot be put in __init section neither
though if we use it like this.


> On an unrelated note, did you consider simply IPI-ing and doing the
> substitution with all CPUs stopped?  If you only updated the immediate
> references to this particular var, it should be fast enough not to upset
> the RT guys, even.
> 

Yes, I thought about this, but since I use immediate values in the
kernel markers, which can be put in exception handlers (including nmi,
mce handler), which cannot be disabled without important side-effects, I
don't think trying to stop the CPUs is a workable solution.


> > > I was thinking that we might find useful specific cases before we get
> > > GCC support, which archs can override with tricky asm if they wish.
> > > 
> > 
> > The first useful case is the Linux Kernel Markers, which really needs a
> > completely boolean if: active or inactive. That would be a good test
> > case to get gcc support.
> 
> Well, you can do that in asm without gcc support.  It's a little nasty:
> since gcc will know nothing about the function call, it can't have side
> effects which are visible in this function, and you'll have to save and
> restore *all* regs if you decide to do the function call.  But it's
> possible (a 5-byte nop gets changed to a call, the call does the pushes
> and sets the args regs, calls the function, then pops everything and
> rets).
> 

GCC support is required if we want to embed inline functions inside
unlikely branches depending on immediate values (no function call
there). It also permits passing local variables as arguments to the
function call (stack setup), which would be tricky, instrumentation site
specific and non portable if done in assembly.

Mathieu

> Cheers,
> Rusty.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
