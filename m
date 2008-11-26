Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYKZQLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYKZQLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYKZQLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:11:31 -0500
Received: from www.tglx.de ([62.245.132.106]:34285 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYKZQLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:11:31 -0500
Date: Wed, 26 Nov 2008 17:10:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
Subject: Re: [patch 21/24] perfmon: Intel architectural PMU support (x86)
In-Reply-To: <7c86c4470811260745s293ae0bbw1cf53642d4f88416@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811261656040.3325@localhost.localdomain>
References: <492d0c0e.06e2660a.1583.ffffcc0a@mx.google.com>  <alpine.LFD.2.00.0811261446070.3325@localhost.localdomain> <7c86c4470811260745s293ae0bbw1cf53642d4f88416@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, stephane eranian wrote:
> In anycase, the idea is to encapsulate as much as possible code
> related into a PMU model
> into each module. That is why you are seing some redundancy.

Makes sense.
 
> There is a difference between enable_mask and used_pmcs. The used_pmcs
> bitmasks shows
> all the config registers in use. Whereas enable_mask shows the all
> config registers which have
> start/stop capabilities. For the basic AMD64 PMU (4 counters)
> used_pmcs and enable_mask
> are equivalent, but that is not the case on Barcelona once we support
> IBS and sampling. So
> for now, I could clean this up and drop enable_mask to use plain used_pmcs.

Understood. If we need that in the near future then it's ok to keep
it, it just did not make any sense from the current code.

But I think you should do this once when you set up the context and
keep that as a separate mask. Right now you evaluate enable_mask and
used_pmcs over and over again.

> >> +     count = pfm_arch_bv_weight(used_mask, max_enable);
> >
> > So we have:
> >
> >   set->used_pmcs and enable_mask and max_enable.
> >
> > Why can set->used_pmcs contain bits which are not in the enable_mask
> > in the first place ? Why does the arch code not tell the generic code
> > which pmcs are available so we can avoid all this mask, weight
> > whatever magic ?
> >
> 
> Because used_pmcs is part of generic code and enable_mask is a x86 construct.
> As I said above, for now, I could drop enable_mask.
> The arch code already export the list of available pmcs and pmds in
> impl_pmcs and impl_pmds.

See above.
 
> > Why are the counters enabled at all when an overflow is pending, which
> > stopped the counters anyway ?
> >
> Because on Intel and AMD64, counters are not automatically frozen on interrupt.
> On Intel X86, they can be configured to do so, but it is an all or
> nothing setting.
> I am not using this option because we would then have a problem with the NMI
> watchdog given that it is also using a counter.

Well, my question was: why do we have to stop the counters when an
overflow is pending already ?

The overflow pending is set inside of stop_save() and cleared
somewhere else. 

stop_save() is called from pfm_arch_stop() and
pfm_arch_ctxswout_thread(). The first thing it does is to disable the
counters.

Now at some points the counters are obviously reenabled for this
context, but why are they reenabled _before_ the pending overflow has
been resolved ? For N counters that N * 2 wrmsrl() overhead.

Thanks,

	tglx
