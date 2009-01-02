Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbZABWil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbZABWil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZABWid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:38:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:22061 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZABWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:38:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kp7wZGwEsZQqc7apueM9aMnLsKFJREoidk0h2klqgcyizZQDXoXnpTneUc553dyd7w
         tGP/C7o4YMrcjGdfB8iSsFA/2DuFF7xDU73suUFNFMWh2RBvHJaB4dUxEL67PQVcmROn
         WV+nMRletjYLDG/XKsIL4MjrnHFQBUuVIk6lU=
Date: Sat, 3 Jan 2009 00:38:50 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090102223850.GA5235@localhost>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro> <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro> <20081230124017.GH28520@ghostprotocols.net> <20081230140232.GG10635@localhost> <20090102214805.GA26654@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102214805.GA26654@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 04:48:05PM -0500, Mathieu Desnoyers wrote:
> Yes, we could (and maybe should) use __always_inline there. Hrm, which
> which tree to you work ? You probably mean DECLARE_TRACE() rather than
> DEFINE_TRACE() ?
> 
> I just went over your patch again. it uses the old DEFINE_TRACE() API.
> You should get the latest tracepoints which have DECLARE_TRACE() (for
> trace/kmemtrace.h) and then a DEFINE_TRACE() in a .c.  Ah I see, you
> work on 2.6.28. You should work on top of -tip, which has this new API.
> Using the tracepoints present in 2.6.28 will not let you do only a
> single definition of the tracepoint structure and it will lead to waste
> of kernel memory by defining multiple instances of tracepoint structures
> (one for each trace_*() use, so one per kmalloc()). The
> Documentation/tracepoints.txt file is updated accordingly.
> 

I'm supposed to merge it through Ingo's tip tree. If we're talking about
the same tree, I'll do as you suggested.

> > But it is quite pointless. Sometimes we need _RET_IP_, sometimes
> > _THIS_IP_ and sometimes a parameter we've been passed. That's because we
> > want the IP of the caller, so it depends on whether this slab function
> > is __always_inline, non-inlined or deeply nested within other functions
> > (which can be as well __always_inline or non-inlined).
> > 
> 
> Hrm ? In the case we just want
> 
>   trace_kmalloc(_THIS_IP, ......);
> 
> If we have __always_inline for the trace_*() declaration, isn't it the
> same to just do this in the probe ?
> 
> void probe_kmalloc(......)
> {
>   ... _RET_IP_ ...;
> 
> }
> 
> This would remove a parameter from the stack created from the
> instrumentation site, which is always good.

No, it's not always possible. Not all allocator functions (not even
those of the same kind, as in alloc/free) make up an __always_inline
chain. For example, there is one or a few instances where we pass a
value other than _RET_IP_ or _THIS_IP_ to probes. It's quite hard to
untangle things without making extensive modifications.

> Mathieu
> 
> > 
> > 	Eduard
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
