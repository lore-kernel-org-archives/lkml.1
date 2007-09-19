Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbXISL1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbXISL1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXISL1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:27:08 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:45406 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbXISL1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:27:07 -0400
Date: Wed, 19 Sep 2007 07:27:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Message-ID: <20070919112704.GG15500@Krystal>
References: <20070917184224.549435917@polymtl.ca> <200709182101.12284.vda.linux@googlemail.com> <20070918204718.GB12994@Krystal> <200709190957.53300.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200709190957.53300.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:25:44 up 51 days, 11:44,  3 users,  load average: 2.75, 1.86, 1.53
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko (vda.linux@googlemail.com) wrote:
> On Tuesday 18 September 2007 21:47, Mathieu Desnoyers wrote:
> > * Denys Vlasenko (vda.linux@googlemail.com) wrote:
> > > On Tuesday 18 September 2007 18:59, Mathieu Desnoyers wrote:
> > > > * Denys Vlasenko (vda.linux@googlemail.com) wrote:
> > > > > On Monday 17 September 2007 19:42, Mathieu Desnoyers wrote:
> > > > > > Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> > > > > > ===================================================================
> > > > > > --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-17 13:25:06.000000000 -0400
> > > > > > +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-17 13:35:50.000000000 -0400
> > > > > > @@ -122,6 +122,13 @@
> > > > > >  		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
> > > > > >  	}								\
> > > > > >  									\
> > > > > > +	/* Immediate values: pointers */				\
> > > > > > +	__immediate : AT(ADDR(__immediate) - LOAD_OFFSET) {		\
> > > > > > +		VMLINUX_SYMBOL(__start___immediate) = .;		\
> > > > > > +		*(__immediate)						\
> > > > > > +		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > > > > > +	}								\
> > > > > > +									\
> > > > > 
> > > > > Why do you need an output section for that? IOW: will this work too?
> > > > > 
> > > > > .data : ... { 
> > > > > ...
> > > > > 
> > > > > 		VMLINUX_SYMBOL(__start___immediate) = .;		\
> > > > > 		*(__immediate)						\
> > > > > 		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > > > > ...
> > > > > }
> > > > > 
> > > > 
> > > > This last one could cause alignment problems. We either have to use the
> > > > proper ALIGN() before the section, or let AT(ADDR(__immediate) -
> > > > LOAD_OFFSET) take care of it. I prefer the latter.
> > > 
> > > This adds yet another output section in vmlinux, and there is
> > > no tools which need that. We already have 30+ sections there while we need ~20.
> > > 
> > > I am trying to fix the mess. Please don't add to it.
> > > 
> > > Re alignment: (1) do you really realy REALLY need it? Last I checked,
> > > i386 was handling unaligned accesses just fine; and
> > > (2) this works:
> > > 
> > > 		. = ALIGN(4)
> > >  		VMLINUX_SYMBOL(__start___immediate) = .;		\
> > >  		*(__immediate)						\
> > >  		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > > 
> > > 
> > 
> > Alignment: I need the __start___immediate and __stop___immediate values
> > to be at the same alignment as the *(__immediate) content, or else we
> > end up thinking that padding is data.
> > 
> > . = ALIGN(4) works fine as long as the structure within the section is
> > not bigger or equal to 32 bytes: gcc has the habit to align 32 bytes
> > structure on 32 bytes multiples. The safest way I found to do it is to
> > declare the section as I do: it will cause no breakage if anybody append
> > data to the structure.
> 
> If your structure will be padded by gcc, then this:
> 
> +#define immediate_read(name)                                           \
> +       ({                                                              \
> +               __typeof__(name##__immediate) value;                    \
> +               switch (sizeof(value)) {                                \
> +               case 1:                                                 \
> +                       asm (   ".section __immediate, \"a\", @progbits;\n\t" \
> +                                       ".long %1, (0f)+1, 1;\n\t"      \
> +                                       ".previous;\n\t"                \
> +                                       "0:\n\t"                        \
> +                                       "mov %2,%0;\n\t"                \
> +                               : "=r" (value)                          \
> +                               : "m" (name##__immediate),              \
> +                                 "i" (0));                             \
> +                       break;                                          \
> 
> will produce wrongly-sized "struct __immediate" (truncated one),
> since gcc has no idea that you are building struct __immediate there,
> and here:
> 
> +void immediate_update_range(const struct __immediate *begin,
> +               const struct __immediate *end)
> +{
> +       const struct __immediate *iter;
> +       int ret;
> +
> +       for (iter = begin; iter < end; iter++) {
> +               mutex_lock(&immediate_mutex);
> +               kernel_text_lock();
> +               ret = arch_immediate_update(iter);
> +               kernel_text_unlock();
> +               if (ret)
> +                       printk(KERN_WARNING "Invalid immediate value. "
> +                                           "Variable at %p, "
> +                                           "instruction at %p, size %lu\n",
> +                                           (void*)iter->immediate,
> +                                           (void*)iter->var, iter->size);
> +               mutex_unlock(&immediate_mutex);
> +       }
> +}
> 
> iter++ will go off rails.

You are right. It's ok here since we are actually smaller than 32 bytes,
but I should force the structure alignment so that if the structure
grows, the assembly declaration follows. I'll go for the gcc attribute
and then we can remove the section declaration.

Mathieu

> --
> vda

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
