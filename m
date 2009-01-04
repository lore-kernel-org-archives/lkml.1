Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZADBwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZADBwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZADBwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:52:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:8818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZADBwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tsSaJ+bSRoGGNyoDyDV8F1zHe/hQPZQq0kt18BXG7pyg+qqu3CNPyQrww2zNMT1oMm
         /dKuI2JNd+RVKYu7t6lpT5sFOj6N+CKNr5TbuEaJjyXdUERiA1FGp6E+GgWI3yllzbr4
         dkLI0WHFClT8RHF7eidYwzz5X6ip6AO8o87lg=
Date: Sun, 4 Jan 2009 03:53:05 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090104015304.GA5198@localhost>
References: <cover.1230499486.git.eduard.munteanu@linux360.ro> <0d1bc24fa2c8d9df136cf833a36be2b72340bc8f.1230499486.git.eduard.munteanu@linux360.ro> <20090102205345.GB25473@Krystal> <20090102230116.GB5235@localhost> <20090102234254.GB29623@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102234254.GB29623@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 06:42:54PM -0500, Mathieu Desnoyers wrote:
> * Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> > > 
> > > Why do you need the enum kmemtrace_type_id type_id exactly ? Can you
> > > remove this parameter by adding more specific tracepoints ?
> > > 
> > 
> > Already done and moved that enum into the .c file. I've resubmitted the
> > whole thing (2 patches instead of 3). I'll provide an URL if you didn't get
> > those e-mails.
> > 
> 
> I got those, I just replied a little bit late. Thanks. I am not talking
> about moving the enum to a .c file here, I am simply asking why we don't
> use the already existing tracepoint naming rather than adding another
> level of event description in an event field.
>

Yes, already done (not just moved things around) in case I wasn't clear.

> > > > diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> > > > index 7555ce9..e5a8b60 100644
> > > > --- a/include/linux/slab_def.h
> > > > +++ b/include/linux/slab_def.h
> > > > @@ -76,8 +76,9 @@ found:
> > > >  
> > > >  		ret = kmem_cache_alloc_notrace(cachep, flags);
> > > >  
> > > > -		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > > > -				     size, slab_buffer_size(cachep), flags);
> > > > +		trace_kmemtrace_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > > > +				      size, slab_buffer_size(cachep),
> > > 
> > > You'll probably want to give "cachep" as parameter and do the
> > > slab_buffer_size(cachep) within the probe to remove unneeded code from
> > > the caller site.
> > > 
> > 
> > Hmm, I don't see how this could be an improvement.
> 
> Because whatever slab_buffer_size() does will be done on the fastpath of
> the instrumented code *even when instrumentation is disabled*, and this
> is something we need to avoid above all.
>

Oh, I see. You mean the case when kmemtrace is compiled in but not
enabled. For slab_buffer_size() this is no problem, but things like
(1 << order) do result in more computation being performed. I'll fix it.

Heh, I sometimes wish C was more like Haskell (lazy, outer evaluation) :P.

> > Slab code hackers are
> > supposed to see this and keep kmemtrace in line with slab internals.
> > Moving this away only makes things more awkward.
> > 
> 
> I am just saying this should be moved _into_ the kmemtrace probe. This
> code will have to be kept in sync with the kernel anyway.
>

I got that, but I'll try to keep any logic within slab code files. The
kmemtrace probe should call such a function to perform computation, so
developers won't ever need to look at mm/kmemtrace.c.

> > Besides, having a probe for each allocator and each function hardly
> > makes any sense.
> 
> Why ?
> 

Hmm, probably having some get_req_size() & get_alloc_size() defined for
all slab allocators might make more sense. Just like we do now to handle
different kmalloc() variants.

I really feel like having to change both slab code and kmemtrace code to
support some new allocator isn't the way to go. Ideally, one should only
insert calls to probes and provide that get_*_size() interface.

I'll see what can be done. But please comment if you think otherwise.

> > > Why do you need to pass -1 ? Can you have a more specific tracepoint
> > > instead ?
> > >
> > 
> > I've noticed probe functions tend to have really long names. -1 is just
> > very convenient, we could make it typo-proof by taking all negative values as
> > meaning "same node" in userspace, or clamp / warn about it in probes. Anyway,
> > I've seen SLOB does it in its inlines, e.g. kmem_cache_alloc() calls
> > kmem_cache_alloc_node(..., -1).
> > 
> 
> With all due respect, your argument is bogus because it does not take
> into account something far more important than "long function names",
> which is what the resulting assembly looks like, and how much overhead
> you add. Here, you are adding the overhead of 1 more parameter *per
> call* just to keep tracepoint names smaller. The same thing applies to
> your added enumeration. Is it me or it does not sound like a good
> tradeoff ? Remember that tracepoints in the memory allocator code are
> meant to be called *very* often.

Yes, it really is bogus, sorry. Will fix.


	Cheers,
	Eduard

