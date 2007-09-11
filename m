Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbXIKApw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbXIKApw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 20:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbXIKApp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 20:45:45 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:48032 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345AbXIKApo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 20:45:44 -0400
Date: Mon, 10 Sep 2007 20:45:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module Mutex
Message-ID: <20070911004541.GA4360@Krystal>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.079453533@polymtl.ca> <20070908072811.GB1819@martell.zuzino.mipt.ru> <1189468414.8023.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1189468414.8023.66.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:20:36 up 43 days, 39 min,  3 users,  load average: 2.15, 1.27, 1.07
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Sat, 2007-09-08 at 11:28 +0400, Alexey Dobriyan wrote:
> > On Thu, Sep 06, 2007 at 04:02:29PM -0400, Mathieu Desnoyers wrote:
> > > Remove "static" from module_mutex and the modules list so it can be used by
> > > other builtin objects in the kernel. Otherwise, every code depending on the
> > > module list would have to be put in kernel/module.c. Since the immediate values
> > > depends on the module list but can be considered as logically different, it
> > > makes sense to implement them in their own file.
> 
> If I understand this code correctly, then changing immediate values
> needs some exclusion to avoid patching live code.  You leave this to the
> user with some very unclear rules.
> 

I think you really misunderstood some major features of these patches
then. Doing an immediate_set on a variable has the same semantic as
setting a normal static variable. If the write to the equivalent
variable would be performed atomically (e.g. 32 bits or less variable on
a 32 bits architecture), it will also be done atomically on an
immediate value reference.

Code patching of _live_ SMP code is allowed. This is why I went through
all this trouble on i386.

So the locking is the same for an immediate value that it would be for a
static variable. If you are concerned about the fact that we have to
iterate on multiple load immediate sites to enable the variable (which
is done non atomically when there are multiple references), we end up in
a moment where references may be in a different state at a given time.
But this is no different from out of order read/writes of/from a static
variable and how older copies may be seen by another CPU : if you hope
that multiple CPUs will see a coherent copy of a static variable at a
given point in time, you clearly have to use the proper locking that
will order read/writes.

Immediate values are mostly meant to be used in contexts where we can
allow this time window where, during the update, some references will
have one value and others won't. Therefore, doing :

immediate_int_t var;
in function:
BUG_ON(immediate_read(&var) != immediate_read(&var));

might fail if it is executed while an immediate_set is done on var. But
if we would have:

volatile int var;
in function:
BUG_ON(var != var);

and, in another thread:
var++;

We _might_ race and see a different value. What is do different about
it?

When we activate a feature that is protected by a boolean, we currently
have to accept that we will, at some point, be in a state where code
paths will see the enabled value and others will see the disabled one.
(this is the choice we do in tracing, and the choice that has to be done
when using atomic updates without locking).

The only guarantee you get is that once the immediate_set is over, all
further references to the variable in memory will see the new variable.

> The result is a real mess that has nothing to do with the module mutex
> and list.  These patches need a lot more work 8(
> 

module mutex is only there to allow coherent iteration on the module
list so we can patch each module's code.

> 1) The immediate types are just kind of silly.  See per-cpu for how it
> handles this already.  DECLARE_IMMEDIATE(type, var) is probably enough.
> 

I would be ok with that.

> 2) immediate_if() needs an implementation before you introduce it.  Your
> assumption that it's always unlikely seems non-orthogonal.
> 

I could remove the unlikely(), no problem with that. Your point about
this is valid. However, I would like to leave the immediate_if() there
because it may become very useful if someday gcc permits to extract the
address of a branch instruction (and to generate assembly that would not
be reached without doing code patching).

Quoting my discussion with H. Peter Anvin:

<quote>
Mathieu Desnoyers wrote:
>
> If we can change the compiler, here is what we could do:
>
> Tell GCC to put NOPs that could be altered by a branch alternative to
> some specified code. We should be able to get the instruction pointers
> (think of inlines) to these nop/branch instructions so we can change
> them dynamically.
>

Changing the compiler should be perfectly feasible, *BUT* I think we
need a transitional solution that works on existing compilers.

> I suspect this would be inherently tricky. If someone is ready to do
> this and tells me "yes, it will be there in 1 month", I am more than
> ready to switch my markers to this and help, but since the core of my
> work is kernel tracing, I don't have the time nor the ressources to
> tackle this problem.
>
> In the event that someone answers "we'll do this in the following 3
> years", I might consider to change the if (immediate(var)) into an
> immediate_if (var) so we can later proceed to the change with simple
> ifdefs without rewriting all the kernel code that would use it.

This is much more of "we'll do that in the following 1-2 years", since
we have to deal with a full gcc development cycle.  However, I really
want to see this being implemented in a way that would let us DTRT in
the long run."
</quote>



> 3) immediate_set(), _immediate_set() and immediate_set_early()?  No
> thanks!  AFAICT you really want an "init_immediate(var, val)".  This
> means "you can patch all the references now, they're not executing".
> Later on we could possibly have a super-stop-machine version which
> ensures noone's preempted and handles the concurrent case.  Maybe.
> 
> 4) With an "init" interface not a "set" interface, you don't need
> locking.  Simpler.
> 

We don't need to stop execution of references at all. Not needed. (as
explained above). I wouldn't want that anyway, since I want to use this
for tracing which must be as non-intrusive as possible.

No locking, live update, is imho much simpler :)


> Hope that helps,
> Rusty.
> 

Thanks for the review,

Mathieu

> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
