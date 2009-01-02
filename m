Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZABXnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZABXnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbZABXm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:42:58 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:39135 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757503AbZABXm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:42:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAMczXklMQWTh/2dsb2JhbACBbL9cCIk1hDgIgTI
Date: Fri, 2 Jan 2009 18:42:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090102234254.GB29623@Krystal>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro> <20090102205345.GB25473@Krystal> <20090102230116.GB5235@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090102230116.GB5235@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:33:27 up 1 day, 23:31,  2 users,  load average: 0.01, 0.03,
	0.00
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Fri, Jan 02, 2009 at 03:53:45PM -0500, Mathieu Desnoyers wrote:
> > * Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> > >  
> > > -#ifdef CONFIG_KMEMTRACE
> > > -
> > >  extern void kmemtrace_init(void);
> > >  
> > > -static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
> > 
> > Why do you need the enum kmemtrace_type_id type_id exactly ? Can you
> > remove this parameter by adding more specific tracepoints ?
> > 
> 
> Already done and moved that enum into the .c file. I've resubmitted the
> whole thing (2 patches instead of 3). I'll provide an URL if you didn't get
> those e-mails.
> 

I got those, I just replied a little bit late. Thanks. I am not talking
about moving the enum to a .c file here, I am simply asking why we don't
use the already existing tracepoint naming rather than adding another
level of event description in an event field.

> > > diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> > > index 7555ce9..e5a8b60 100644
> > > --- a/include/linux/slab_def.h
> > > +++ b/include/linux/slab_def.h
> > > @@ -76,8 +76,9 @@ found:
> > >  
> > >  		ret = kmem_cache_alloc_notrace(cachep, flags);
> > >  
> > > -		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > > -				     size, slab_buffer_size(cachep), flags);
> > > +		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > > +				      size, slab_buffer_size(cachep),
> > 
> > You'll probably want to give "cachep" as parameter and do the
> > slab_buffer_size(cachep) within the probe to remove unneeded code from
> > the caller site.
> > 
> 
> Hmm, I don't see how this could be an improvement.

Because whatever slab_buffer_size() does will be done on the fastpath of
the instrumented code *even when instrumentation is disabled*, and this
is something we need to avoid above all.

> Slab code hackers are
> supposed to see this and keep kmemtrace in line with slab internals.
> Moving this away only makes things more awkward.
> 

I am just saying this should be moved _into_ the kmemtrace probe. This
code will have to be kept in sync with the kernel anyway.

> Besides, having a probe for each allocator and each function hardly
> makes any sense.

Why ?

> 
> Anyway, one could argue for an inline within slab code to handle such
> internals, which does make more sense.
> 

Please keep the logic _outside_ of the memory subsystem fastpath. This
can be done by putting it in the kmemtrace probe callbacks as I propose.

> > > +				      flags, -1);
> > >  
> > >  		return ret;
> > >  	}
> > > @@ -134,9 +135,9 @@ found:
> > >  
> > >  		ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
> > >  
> > > -		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
> > > -					  ret, size, slab_buffer_size(cachep),
> > > -					  flags, node);
> > > +		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
> > > +				      ret, size, slab_buffer_size(cachep),
> > > +				      flags, node);
> > >  
> > >  		return ret;
> > >  	}
> > > diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> > > index dc28432..ce69c68 100644
> > > --- a/include/linux/slub_def.h
> > > +++ b/include/linux/slub_def.h
> > > @@ -220,8 +220,8 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
> > >  	unsigned int order = get_order(size);
> > >  	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
> > >  
> > > -	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > > -			     size, PAGE_SIZE << order, flags);
> > > +	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > > +			      size, PAGE_SIZE << order, flags, -1);
> > 
> > Same here for order.
> 
> Same goes here.
> 
> > Why do you need to pass -1 ? Can you have a more specific tracepoint
> > instead ?
> >
> 
> I've noticed probe functions tend to have really long names. -1 is just
> very convenient, we could make it typo-proof by taking all negative values as
> meaning "same node" in userspace, or clamp / warn about it in probes. Anyway,
> I've seen SLOB does it in its inlines, e.g. kmem_cache_alloc() calls
> kmem_cache_alloc_node(..., -1).
> 

With all due respect, your argument is bogus because it does not take
into account something far more important than "long function names",
which is what the resulting assembly looks like, and how much overhead
you add. Here, you are adding the overhead of 1 more parameter *per
call* just to keep tracepoint names smaller. The same thing applies to
your added enumeration. Is it me or it does not sound like a good
tradeoff ? Remember that tracepoints in the memory allocator code are
meant to be called *very* often.

Mathieu

> > >  
> > >  	return ret;
> > >  }
> > > @@ -242,9 +242,9 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
> > >  
> > >  			ret = kmem_cache_alloc_notrace(s, flags);
> > >  
> > > -			kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
> > > -					     _THIS_IP_, ret,
> > > -					     size, s->size, flags);
> > > +			trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
> > > +					      _THIS_IP_, ret,
> > > +					      size, s->size, flags, -1);
> > >  
> > 
> > Pass s as parameter and do the s->size dereference within the probe.
> > 
> > The same applies to many other caller sites below.
> 
> Same as first comment, it would entail having specific kmemtrace
> functions for specific allocator functions within specific allocators.
> 
> 
> 	Eduard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
