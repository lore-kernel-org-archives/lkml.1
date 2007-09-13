Return-Path: <linux-kernel-owner+w=401wt.eu-S1765657AbXIMVVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765657AbXIMVVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXIMVVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:21:14 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:35310 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbXIMVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:21:13 -0400
Date: Thu, 13 Sep 2007 17:21:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module Mutex
Message-ID: <20070913212107.GA15826@Krystal>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.079453533@polymtl.ca> <20070908072811.GB1819@martell.zuzino.mipt.ru> <1189468414.8023.66.camel@localhost.localdomain> <20070911004541.GA4360@Krystal> <1189487938.20631.53.camel@localhost.localdomain> <20070911142733.GA7850@Krystal> <1189662432.32322.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1189662432.32322.1.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:32:47 up 45 days, 18:51,  5 users,  load average: 0.19, 0.28, 0.43
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Tue, 2007-09-11 at 10:27 -0400, Mathieu Desnoyers wrote: 
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > On Mon, 2007-09-10 at 20:45 -0400, Mathieu Desnoyers wrote:
> > > > Code patching of _live_ SMP code is allowed. This is why I went through
> > > > all this trouble on i386.
> > > 
> > > Oh, I was pretty sure it wasn't.  OK.
> > > 
> > > So now why three versions of immediate_set()?  And why are you using my
> > > lock for exclusion?  Against what?
> > > 
> > 
> > If we need to patch code at boot time, when interrupts are still
> > disabled (it happens when we parse the kernel arguments for instance),
> > we cannot afford to use IPIs to call sync_core() on each cpu, using
> > breakpoints/notifier chains could be tricky (because we are very early
> > at boot and alternatives or paravirt may not have been applied yet).
> 
> Hi Mathieu,
> 
> Sure, but why is that the caller's problem?  immediate_set() isn't
> fastpath, so why not make it do an "if (early_boot)" internally?
> 

I see two reasons:
1 - early_boot, or anything that looks like this, does not exist
currently (and the following reason might show why).
2 - If we use this, we cannot declare the early code with __init, so it
will have to stay there forever insteaf of being removable once boot is
over.

Therefore, I think it's better to stick to an immediate_set_early
version.

> > _immediate_set() has been introduced because of the way immediate values
> > are used by markers: the linux kernel markers already hold the module
> > mutex when they need to update the immediate values. Taking the mutex
> > twice makes no sence, so _immediate_set() is used when the caller
> > already holds the module mutex.
> 
> > Why not just have one immediate_set() which iterates through and fixes
> > > up all the references?
> > 
> > (reasons explained above)
> > 
> > > It can use an internal lock if you want to avoid
> > > concurrent immediate_set() calls.
> > > 
> > 
> > An internal lock won't protect against modules load/unload race. We have
> > to iterate on the module list.
> 
> Sure, but it seems like that's fairly easy to do within module.c:
> 
> /* This updates all the immediates even though only one might have
> * changed.  But it's so rare it's not worth optimizing. */
> void module_update_immediates(void)
> {
> mutex_lock(&module_mutex);
> list_for_each_entry(mod, &modules, list)
> update_immediates(mod->immediate, mod->num_immediate);
> mutex_unlock(&module_mutex);
> }
> 
> Then during module load you do:
> 
> update_immediates(mod->immediate, mod->num_immediate);
> 
> Your immediate_update() just becomes:
> 
> update_immediates(__start___immediate,
> 		  __stop___immediate - __start___immediate);
> module_update_immediates();
> 
> update_immediates() can grab the immediate_mutex if you want.
> 

Yup, excellent idea. I just changed the linux kernel markers too.


> > > Why is it easier to patch the sites now than later?  Currently it's just
> > > churn.  You could go back and find them when this mythical patch gets
> > > merged into this mythical future gcc version.  It could well need a
> > > completely different macro style, like "cond_imm(var, code)".
> > 
> > Maybe you're right. My though was that if we have a way to express a
> > strictly boolean if() statement that can later be optimized further by
> > gcc using a jump rather than a conditionnal branch and currently emulate
> > it by using a load immediate/test/branch, we might want to do so right
> > now so we don't have to do a second code transition from
> > if (immediate_read(&var)) to immediate_if (&var) later. But you might be
> > right in that the form could potentially change anyway when the
> > implementation would come, although I don't see how.
> 
> I was thinking that we might find useful specific cases before we get
> GCC support, which archs can override with tricky asm if they wish.
> 

The first useful case is the Linux Kernel Markers, which really needs a
completely boolean if: active or inactive. That would be a good test
case to get gcc support.

Mathieu

> Cheers,
> Rusty.
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
