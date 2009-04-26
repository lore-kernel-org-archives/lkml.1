Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZDZQJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZDZQJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZDZQJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:09:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38937 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbZDZQJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:09:39 -0400
Date: Sun, 26 Apr 2009 18:08:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Message-ID: <20090426160859.GA5420@elte.hu>
References: <20090424100055.A30408@sedona.ch.intel.com> <20090424011328.b5e949ce.akpm@linux-foundation.org> <20090424083128.GI24912@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E9BA9BB93@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9BA9BB93@irsmsx504.ger.corp.intel.com>
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Friday, April 24, 2009 10:31 AM
> >To: Andrew Morton
> >Cc: Metzger, Markus T; a.p.zijlstra@chello.nl; markus.t.metzger@gmail.com; roland@redhat.com;
> >eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
> >kernel@vger.kernel.org; tglx@linutronix.de; hpa@zytor.com
> >Subject: Re: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
> >
> >
> >* Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> On Fri, 24 Apr 2009 10:00:55 +0200 Markus Metzger <markus.t.metzger@intel.com> wrote:
> >>
> >> > Use vmalloc to allocate the branch trace buffer.
> >> >
> >> > Peter Zijlstra suggested to use vmalloc rather than kmalloc to
> >> > allocate the potentially multi-page branch trace buffer.
> >>
> >> The changelog provides no reason for this change.  It should do so.
> >>
> >> > Is there a way to have vmalloc allocate a physically non-contiguous
> >> > buffer for test purposes? Ideally, the memory area would have big
> >> > holes in it with sensitive data in between so I would know immediately
> >> > when this is overwritten.
> >>
> >> I suppose you could allocate the pages by hand and then vmap() them.
> >> Allocating 2* the number you need and then freeing every second one
> >> should make them physically holey.
> >>
> >> > --- a/arch/x86/kernel/ptrace.c
> >> > +++ b/arch/x86/kernel/ptrace.c
> >> > @@ -22,6 +22,7 @@
> >> >  #include <linux/seccomp.h>
> >> >  #include <linux/signal.h>
> >> >  #include <linux/workqueue.h>
> >> > +#include <linux/vmalloc.h>
> >> >
> >> >  #include <asm/uaccess.h>
> >> >  #include <asm/pgtable.h>
> >> > @@ -626,7 +627,7 @@ static int alloc_bts_buffer(struct bts_c
> >> >  	if (err < 0)
> >> >  		return err;
> >> >
> >> > -	buffer = kzalloc(size, GFP_KERNEL);
> >> > +	buffer = vmalloc(size);
> >> >  	if (!buffer)
> >> >  		goto out_refund;
> >> >
> >> > @@ -646,7 +647,7 @@ static inline void free_bts_buffer(struc
> >> >  	if (!context->buffer)
> >> >  		return;
> >> >
> >> > -	kfree(context->buffer);
> >> > +	vfree(context->buffer);
> >> >  	context->buffer = NULL;
> >> >
> >>
> >> The patch looks like a regression to me.  vmalloc memory is slower
> >> to allocate, slower to free, slower to access and can exhaust or
> >> fragment the vmalloc arena.  Confused.
> >
> >Performance does not matter here (this is really a slowpath), but
> >fragmentation does matter, especially on 32-bit systems.
> >
> >I'd not uglify the code via vmap() - and vmap has the same
> >fundamental address space limitations on 32-bit as vmalloc().
> >
> >The existing kmalloc() is fine. We do larger than PAGE_SIZE
> >allocations elsewhere too (the kernel stack for example), and this
> >is a debug facility, so failing the allocation is not a big problem
> >even if it happens.
> 
> OK. I'll drop 2/2 and send out 1/2 as a patch, then.

ok - i've already applied 1/2 so unless you can see a bug we should 
be fine.

> The original suggestion was to use the page allocator and vmap(). 
> I assume you don't want that, either.

Yeah - i'd rather suggest to avoid that complexity - unless there 
are good reasons.

	Ingo
