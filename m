Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbYL3OC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbYL3OC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 09:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYL3OCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 09:02:16 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:46497 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYL3OCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 09:02:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cO2b8L2/kfFJwtTLsDpiYfdizBdgxh+o5tB6IpH+dm9+MAhWDN/PCg/DJGasWYbI/j
         dTMdGio9B6uaMyEKmIy7zmZpj3RBI9rUCd8pzJthLsEyKf95kVO8OCQvQrXtMIyS3L+Z
         IzfvrDNtytSQgYbD2VvYq2CYnnetozQYZJLDo=
Date: Tue, 30 Dec 2008 16:02:32 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20081230140232.GG10635@localhost>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro> <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro> <20081230124017.GH28520@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230124017.GH28520@ghostprotocols.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 10:40:17AM -0200, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 30, 2008 at 09:41:28AM +0200, Eduard - Gabriel Munteanu escreveu:
> > kmemtrace now uses tracepoints instead of markers. We no longer need to
> > use format specifiers. Also dropped kmemtrace_mark_alloc_node(), since
> > it's easy to pass -1 as the NUMA node without providing a needless and
> > long-named variant of the same function.
> > 
> > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> > index 7555ce9..fe3cea2 100644
> > --- a/include/linux/slab_def.h
> > +++ b/include/linux/slab_def.h
> > @@ -76,8 +76,8 @@ found:
> >  
> >  		ret = kmem_cache_alloc_notrace(cachep, flags);
> >  
> > -		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> > -				     size, slab_buffer_size(cachep), flags);
> > +		trace_kmalloc(_THIS_IP_, ret,
> > +			      size, slab_buffer_size(cachep), flags, -1);
> 
> Is there a way for a tracepoint to get the caller without having to pass
> it explicitely?
> 
> - Arnaldo

It might be possible, but for correctness DEFINE_TRACE() should use
__always_inline instead of inline.

But it is quite pointless. Sometimes we need _RET_IP_, sometimes
_THIS_IP_ and sometimes a parameter we've been passed. That's because we
want the IP of the caller, so it depends on whether this slab function
is __always_inline, non-inlined or deeply nested within other functions
(which can be as well __always_inline or non-inlined).


	Eduard

