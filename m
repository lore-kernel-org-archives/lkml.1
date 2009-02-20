Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZBTRwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZBTRwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZBTRwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:52:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZBTRwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:52:35 -0500
Date: Fri, 20 Feb 2009 12:52:33 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] ftrace, x86: make kernel text writable only for
 conversions
In-Reply-To: <20090220173035.GI24538@elte.hu>
Message-ID: <alpine.DEB.2.00.0902201247220.13747@gandalf.stny.rr.com>
References: <20090220163846.709775139@goodmis.org> <20090220164045.827841413@goodmis.org> <20090220173035.GI24538@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index b55b4a7..5564cf3 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -80,4 +80,14 @@ extern void return_to_handler(void);
> >  #endif /* __ASSEMBLY__ */
> >  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> >  
> > +#ifndef __ASSEMBLY__
> > +#ifdef CONFIG_DEBUG_RODATA
> > +void set_kernel_text_rw(void);
> > +void set_kernel_text_ro(void);
> > +#else
> > +static inline void set_kernel_text_rw(void) { }
> > +static inline void set_kernel_text_ro(void) { }
> > +#endif
> > +#endif /* __ASSEMBLY__ */
> 
> The proper place for this is where the other pagetable attribute 
> functions reside: arch/x86/include/asm/cacheflush.h.

Heh, I put it there because I was not sure where the proper place should 
go. I figured someone would comment and tell me where to put it ;-)

> 
> > +/* used by ftrace */
> > +void set_kernel_text_rw(void)
> > +{
> > +	unsigned long start = PFN_ALIGN(_text);
> > +	unsigned long size = PFN_ALIGN(_etext) - start;
> > +
> > +	printk(KERN_INFO "Set kernel text: %lx - %lx for read write\n",
> > +	       start, start+size);
> > +
> > +	set_pages_rw(virt_to_page(start), size >> PAGE_SHIFT);
> 
> Wont this be executed by every suspend/resume cycle? I'm not 
> sure we want a KERN_INFO printout every time.

Yeah, agreed. My original thought was to allow a sysadmin to know when
something was changing the kernel text to read/write. But it does fill
up the logs quite a bit. I'll switch it to a pr_debug.

> 
> > +/* used by ftrace */
> > +void set_kernel_text_rw(void)
> 
> i'd leave out the 'used by ftrace' bit - more uses might arise. 
> How does kprobes get around readonly pages, it uses these APIs 
> too, right?

kprobes uses text_poke. text_poke uses vmap to create its own page table 
pointers to the text memory, does the modification and then removes the 
pointers. This is quite heavy weight and since ftrace needs to modify 10s 
of thousands of areas, converting all of kernel text page tables is much 
more efficient.

Note, if kprobes did change the original page tables, then it too would 
have hit the split_large_page bug too.

-- Steve

