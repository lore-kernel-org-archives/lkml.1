Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbZABXBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbZABXBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbZABXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:01:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:23570 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZABXBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:01:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ddc1BFn+PR+SeKCcX+CfQAeeEn7CtRJPzCvgH5bsL956h1mHrzFv5bnxCOyPaiSPLA
         BGVlhMfslrbRxX0zSsX3lH5GtLG411/N/R5FeV4eimoBgJMSt8fjMPDi7Zm9Ejal/EjX
         qF9iBCsR+QuYCCamSwI3yEtBLb2xvuq+j0E7I=
Date: Sat, 3 Jan 2009 01:01:17 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090102230116.GB5235@localhost>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro> <20090102205345.GB25473@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102205345.GB25473@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 03:53:45PM -0500, Mathieu Desnoyers wrote:
> * Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> >  
> > -#ifdef CONFIG_KMEMTRACE
> > -
> >  extern void kmemtrace_init(void);
> >  
> > -static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
> 
> Why do you need the enum kmemtrace_type_id type_id exactly ? Can you
> remove this parameter by adding more specific tracepoints ?
> 

Already done and moved that enum into the .c file. I've resubmitted the
whole thing (2 patches instead of 3). I'll provide an URL if you didn't get
those e-mails.

> > diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> > index 7555ce9..e5a8b60 100644
> > --- a/include/linux/slab_def.h
> > +++ b/include/linux/slab_def.h
> > @@ -76,8 +76,9 @@ found:
> >  
> >  		ret = kmem_cache_alloc_notrace(cachep, flags);
> >  
> > -		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > -				     size, slab_buffer_size(cachep), flags);
> > +		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > +				      size, slab_buffer_size(cachep),
> 
> You'll probably want to give "cachep" as parameter and do the
> slab_buffer_size(cachep) within the probe to remove unneeded code from
> the caller site.
> 

Hmm, I don't see how this could be an improvement. Slab code hackers are
supposed to see this and keep kmemtrace in line with slab internals.
Moving this away only makes things more awkward.

Besides, having a probe for each allocator and each function hardly
makes any sense.

Anyway, one could argue for an inline within slab code to handle such
internals, which does make more sense.

> > +				      flags, -1);
> >  
> >  		return ret;
> >  	}
> > @@ -134,9 +135,9 @@ found:
> >  
> >  		ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
> >  
> > -		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
> > -					  ret, size, slab_buffer_size(cachep),
> > -					  flags, node);
> > +		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
> > +				      ret, size, slab_buffer_size(cachep),
> > +				      flags, node);
> >  
> >  		return ret;
> >  	}
> > diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> > index dc28432..ce69c68 100644
> > --- a/include/linux/slub_def.h
> > +++ b/include/linux/slub_def.h
> > @@ -220,8 +220,8 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
> >  	unsigned int order = get_order(size);
> >  	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
> >  
> > -	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > -			     size, PAGE_SIZE << order, flags);
> > +	trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > +			      size, PAGE_SIZE << order, flags, -1);
> 
> Same here for order.

Same goes here.

> Why do you need to pass -1 ? Can you have a more specific tracepoint
> instead ?
>

I've noticed probe functions tend to have really long names. -1 is just
very convenient, we could make it typo-proof by taking all negative values as
meaning "same node" in userspace, or clamp / warn about it in probes. Anyway,
I've seen SLOB does it in its inlines, e.g. kmem_cache_alloc() calls
kmem_cache_alloc_node(..., -1).

> >  
> >  	return ret;
> >  }
> > @@ -242,9 +242,9 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
> >  
> >  			ret = kmem_cache_alloc_notrace(s, flags);
> >  
> > -			kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
> > -					     _THIS_IP_, ret,
> > -					     size, s->size, flags);
> > +			trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC,
> > +					      _THIS_IP_, ret,
> > +					      size, s->size, flags, -1);
> >  
> 
> Pass s as parameter and do the s->size dereference within the probe.
> 
> The same applies to many other caller sites below.

Same as first comment, it would entail having specific kmemtrace
functions for specific allocator functions within specific allocators.


	Eduard

