Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYHKOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYHKOa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYHKOaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:30:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61980 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYHKOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:30:18 -0400
Date: Mon, 11 Aug 2008 10:30:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       tglx@linutronix.de
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
In-Reply-To: <48A048FD.30909@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0808111027370.29861@gandalf.stny.rr.com>
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>  <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>  <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>  <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>
  <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>  <48A046F5.2000505@linux-foundation.org> <1218463774.7813.291.camel@penberg-laptop> <48A048FD.30909@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Aug 2008, Christoph Lameter wrote:

> Pekka Enberg wrote:
> > On Mon, 2008-08-11 at 09:04 -0500, Christoph Lameter wrote:
> >> Eduard - Gabriel Munteanu wrote:
> >>
> >>
> >>
> >>>  static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
> >>>  {
> >>> +	void *ret;
> >>> +
> >>>  	if (__builtin_constant_p(size) &&
> >>>  		size <= PAGE_SIZE && !(flags & SLUB_DMA)) {
> >>>  			struct kmem_cache *s = kmalloc_slab(size);
> >>> @@ -239,7 +280,13 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
> >>>  		if (!s)
> >>>  			return ZERO_SIZE_PTR;
> >>>  
> >>> -		return kmem_cache_alloc_node(s, flags, node);
> >>> +		ret = kmem_cache_alloc_node_notrace(s, flags, node);
> >>> +
> >>> +		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
> >>> +					  _THIS_IP_, ret,
> >>> +					  size, s->size, flags, node);
> >>> +
> >>> +		return ret;
> >> You could simplify the stuff in slub.h if you would fall back to the uninlined
> >> functions in the case that kmemtrace is enabled. IMHO adding additional inline
> >> code here does grow these function to a size where inlining is not useful anymore.
> > 
> > So, if CONFIG_KMEMTRACE is enabled, make the inlined version go away
> > completely? I'm okay with that though I wonder if that means we now take
> > a performance hit when CONFIG_KMEMTRACE is enabled but tracing is
> > disabled at run-time...
> 
> We already take a performance hit because of the additional function calls.
> 
> With the above approach the kernel binary will grow significantly because you
> are now inserting an additional function call at all call sites.
> 

The kmemtrace_mark_alloc_node itself is an inline function, which calls 
another inline function "trace_mark" which is designed to test a 
read_mostly variable, and will do an "unlikely" jmp if the variable is 
set (which it is when tracing is enabled), to the actual function call.

There should be no extra function calls when this is configured on but 
tracing disabled. We try very hard to keep the speed of the tracer as 
close to a non tracing kernel as possible when tracing is disabled.

-- Steve

