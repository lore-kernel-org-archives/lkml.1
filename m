Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbXIKO1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbXIKO1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXIKO1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:27:37 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:33758 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465AbXIKO1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:27:36 -0400
Date: Tue, 11 Sep 2007 10:27:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module Mutex
Message-ID: <20070911142733.GA7850@Krystal>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.079453533@polymtl.ca> <20070908072811.GB1819@martell.zuzino.mipt.ru> <1189468414.8023.66.camel@localhost.localdomain> <20070911004541.GA4360@Krystal> <1189487938.20631.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1189487938.20631.53.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:14:31 up 43 days, 14:33,  5 users,  load average: 0.59, 1.87, 1.84
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Mon, 2007-09-10 at 20:45 -0400, Mathieu Desnoyers wrote:
> > Code patching of _live_ SMP code is allowed. This is why I went through
> > all this trouble on i386.
> 
> Oh, I was pretty sure it wasn't.  OK.
> 
> So now why three versions of immediate_set()?  And why are you using my
> lock for exclusion?  Against what?
> 

If we need to patch code at boot time, when interrupts are still
disabled (it happens when we parse the kernel arguments for instance),
we cannot afford to use IPIs to call sync_core() on each cpu, using
breakpoints/notifier chains could be tricky (because we are very early
at boot and alternatives or paravirt may not have been applied yet).

So, for early boot code patching, immediate_set_early() is used. It
presumes that variables are not used when the code is patched, that we
are in UP context and it is really minimalistic.

On the other hand, immediate_set() updates kernel and module variables
while the (potentially smp) system is running. It provides coherent
variable updates even if the code referencing then is executing.

_immediate_set() has been introduced because of the way immediate values
are used by markers: the linux kernel markers already hold the module
mutex when they need to update the immediate values. Taking the mutex
twice makes no sence, so _immediate_set() is used when the caller
already holds the module mutex.


> Why not just have one immediate_set() which iterates through and fixes
> up all the references?

(reasons explained above)

> It can use an internal lock if you want to avoid
> concurrent immediate_set() calls.
> 

An internal lock won't protect against modules load/unload race. We have
to iterate on the module list.

> I understand the need for a "module_immediate_fixup()" but that can also
> use your internal lock.

It looks interesting.. can you elaborate a little bit more on this idea?
If we can find a way to encapsulate in module.c everything that needs to
touch the module list, I am all for it.

> 
> > > 2) immediate_if() needs an implementation before you introduce it.  Your
> > > assumption that it's always unlikely seems non-orthogonal.
> > 
> > I could remove the unlikely(), no problem with that. Your point about
> > this is valid. However, I would like to leave the immediate_if() there
> > because it may become very useful if someday gcc permits to extract the
> > address of a branch instruction (and to generate assembly that would not
> > be reached without doing code patching).
> 
> Why is it easier to patch the sites now than later?  Currently it's just
> churn.  You could go back and find them when this mythical patch gets
> merged into this mythical future gcc version.  It could well need a
> completely different macro style, like "cond_imm(var, code)".
> 

Maybe you're right. My though was that if we have a way to express a
strictly boolean if() statement that can later be optimized further by
gcc using a jump rather than a conditionnal branch and currently emulate
it by using a load immediate/test/branch, we might want to do so right
now so we don't have to do a second code transition from
if (immediate_read(&var)) to immediate_if (&var) later. But you might be
right in that the form could potentially change anyway when the
implementation would come, although I don't see how.

Mathieu

> Rusty.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
