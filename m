Return-Path: <linux-kernel-owner+w=401wt.eu-S965615AbXIGOEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615AbXIGOEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965328AbXIGOEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:04:45 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:36226 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965309AbXIGOEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:04:44 -0400
Date: Fri, 7 Sep 2007 10:04:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: [patch 05/10] Text Edit Lock - Alternative code for i386 and x86_64
Message-ID: <20070907140442.GE9735@Krystal>
References: <20070906200124.595238505@polymtl.ca> <20070906200212.080849869@polymtl.ca> <20070907065936.GH31880@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070907065936.GH31880@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:22:31 up 39 days, 13:41,  4 users,  load average: 1.23, 0.64, 0.70
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Thu, Sep 06, 2007 at 04:01:29PM -0400, Mathieu Desnoyers wrote:
> > +	sync_core();
> > +	/* Not strictly needed, but can speed CPU recovery up. */
> 
> That turned out to break on some VIA CPUs. Should be removed.
> 

Hrm, when does it break ? At boot time ? Is it the cpuid that breaks or
the clflush ? How do you work around the problem when sync_core or
clflush is called from elsewhere; does it cause a problem if I call it
when I update immediate values ?

> > +	if (cpu_has_clflush)
> > +		for (faddr = addr; faddr < addr + len;
> > +				faddr += boot_cpu_data.x86_clflush_size)
> > +			asm("clflush (%0) " :: "r" (faddr) : "memory");
> > +}
> > +
> > +void * text_poke_early(void *addr, const void *opcode,
> > +					size_t len)
> > +{
> > +	memcpy(addr, opcode, len);
> 
> It would be best to copy __inline_memcpy from x86-64 to i386
> and use that here. That avoids the dependency on a patched
> memcpy and is slightly safer.
> 

Is it me or __inline_memcpy is simply a copy of i386's __memcpy ?
Is there any reason for this name change ?

> > +
> > +	if (len > sizeof(long)) {
> > +		printk(KERN_ERR "text_poke of len %zu too big (max %lu)\n",
> > +			len, sizeof(long));
> > +		BUG_ON(1);
> 
> In general BUG_ON only should be enough because these values can
> be recovered from the registers. 
> 

Ok.

> > +	}
> > +	unaligned = (((long)addr + len - 1) & ~(sizeof(long) - 1))
> > +		- ((long)addr & ~(sizeof(long) - 1));
> > +	if (unlikely(unaligned)) {
> > +		printk(KERN_ERR "text_poke of at addr %p of len %zu is "
> > +				"unaligned (%d)\n",
> > +			addr, len, unaligned);
> > +		BUG_ON(1);
> > +	}
> 
> The common code should be in a common function. In fact they're so 
> similar that the caller could just pass a buffer for the text_set
> case, couldn't it?
> 

I found out that doing a text_set is relatively common. What I want to
remove is things such as:

text_poke(addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}, 1);

which is :
  A- ugly
  B- breaking vim syntax highlighting. (actually, all the rest of the
  file becomes weird after that. The problem is similar to declaration
  of #defile name ({ some code }). It does not really matter as long as
  it is in a header, but at the middle of a C file it gets rather
  annoying). (it never though I would use vim as a coding style
  reference) ;)

And what is rather different between the 2 functions is when we want to
fill multiple bytes with the same pattern (I fill the unused part of my
immediate values bypass with 0x90 nops, but I agree that I could use
add_nops if it was exported).

Declaration of a variable length array on text_set's stack would break
older compilers, so I don't think it is a neat solution neither. kmalloc
seems overkill to me.

I'll try to come up with a single static function, called from both
text_set and text_poke, that will merge the code and execute either
memset or memcpy depending on a supplementary argument.

> 
> > +#define kernel_wp_save(cr0)					\
> 
> Is there a real reason this has to be an macro? It could 
> be just a normal function. In fact a shared on in alternative.c.
> That would also avoid adding more include dependencies.
> 

The idea is to mimic the local_irq_save/restore semantic, where the
flags argument is passed without &. This is why I use a macro instead of
an inline function.

> > +	do {							\
> > +		typecheck(unsigned long, cr0);			\
> 
> typecheck is probably overkill
> 

ok, I'll remove it.

> > +		preempt_disable();				\
> 
> Should disable interrupts too just to be safer? 
> 

Well, the only thing that we really don't want here is to be scheduled
to a different CPU, so preempt disable should be enough.

The good effect of disabling interrupts is that it would make sure no
interrupt handler will run with WP flag cleared on the CPU.  However, it
would add a flags parameter to kernel_wp_save/restore which would be
rather ugly :( This is why I prefer to go with preempt_disable, but I am
open to other considerations.

Mathieu

> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
