Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbZABVxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbZABVxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbZABVxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:53:15 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:34905 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759034AbZABVxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:53:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAH8YXklMQWTh/2dsb2JhbACBbMhqhXI
Date: Fri, 2 Jan 2009 16:48:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20090102214805.GA26654@Krystal>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro> <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro> <20081230124017.GH28520@ghostprotocols.net> <20081230140232.GG10635@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081230140232.GG10635@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:33:31 up 1 day, 21:31,  2 users,  load average: 0.05, 0.03,
	0.00
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Tue, Dec 30, 2008 at 10:40:17AM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Dec 30, 2008 at 09:41:28AM +0200, Eduard - Gabriel Munteanu escreveu:
> > > kmemtrace now uses tracepoints instead of markers. We no longer need to
> > > use format specifiers. Also dropped kmemtrace_mark_alloc_node(), since
> > > it's easy to pass -1 as the NUMA node without providing a needless and
> > > long-named variant of the same function.
> > > 
> > > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > > diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> > > index 7555ce9..fe3cea2 100644
> > > --- a/include/linux/slab_def.h
> > > +++ b/include/linux/slab_def.h
> > > @@ -76,8 +76,8 @@ found:
> > >  
> > >  		ret = kmem_cache_alloc_notrace(cachep, flags);
> > >  
> > > -		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > > -				     size, slab_buffer_size(cachep), flags);
> > > +		trace_kmalloc(_THIS_IP_, ret,
> > > +			      size, slab_buffer_size(cachep), flags, -1);
> > 
> > Is there a way for a tracepoint to get the caller without having to pass
> > it explicitely?
> > 
> > - Arnaldo
> 
> It might be possible, but for correctness DEFINE_TRACE() should use
> __always_inline instead of inline.
> 

Yes, we could (and maybe should) use __always_inline there. Hrm, which
which tree to you work ? You probably mean DECLARE_TRACE() rather than
DEFINE_TRACE() ?

I just went over your patch again. it uses the old DEFINE_TRACE() API.
You should get the latest tracepoints which have DECLARE_TRACE() (for
trace/kmemtrace.h) and then a DEFINE_TRACE() in a .c.  Ah I see, you
work on 2.6.28. You should work on top of -tip, which has this new API.
Using the tracepoints present in 2.6.28 will not let you do only a
single definition of the tracepoint structure and it will lead to waste
of kernel memory by defining multiple instances of tracepoint structures
(one for each trace_*() use, so one per kmalloc()). The
Documentation/tracepoints.txt file is updated accordingly.


> But it is quite pointless. Sometimes we need _RET_IP_, sometimes
> _THIS_IP_ and sometimes a parameter we've been passed. That's because we
> want the IP of the caller, so it depends on whether this slab function
> is __always_inline, non-inlined or deeply nested within other functions
> (which can be as well __always_inline or non-inlined).
> 

Hrm ? In the case we just want

  trace_kmalloc(_THIS_IP, ......);

If we have __always_inline for the trace_*() declaration, isn't it the
same to just do this in the probe ?

void probe_kmalloc(......)
{
  ... _RET_IP_ ...;

}

This would remove a parameter from the stack created from the
instrumentation site, which is always good.

Mathieu

> 
> 	Eduard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
