Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZDCEVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZDCEVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 00:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZDCEVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 00:21:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:33964 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZDCEU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 00:20:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l0zjF1m4KFg2cqLGK4znIuaN3TyDL9rcIRONbaVidvbn70whOYiJ0J796YkLvEGXXW
         Z+iQxBEbu7Ps1SqiQGChyF/6RvUpCaqEzbUtjkdc6w8fzwwhWB4fii8h1K7ktzRzfigA
         gJTDWpThkyszpX48QQX/ClUT1z+BLFnmWOwvg=
Date: Fri, 3 Apr 2009 07:21:32 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, alexn@dsv.su.se, akpm@linux-foundation.org,
       alexn@telia.com, apw@shadowen.org, cl@linux-foundation.org,
       haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
Message-ID: <20090403042131.GA15669@localhost>
References: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org> <20090401111540.GC15442@elte.hu> <20090401125506.GA6406@csn.ul.ie> <20090401131713.GQ12966@elte.hu> <20090401133220.GB6406@csn.ul.ie> <20090401134917.GC18677@elte.hu> <1238597398.23857.11.camel@penberg-laptop> <20090401152251.GB23390@elte.hu> <1238656331.26286.17.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238656331.26286.17.camel@penberg-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 10:12:11AM +0300, Pekka Enberg wrote:
> On Wed, 2009-04-01 at 17:22 +0200, Ingo Molnar wrote:
> > > +kmemtrace_print_page_alloc_user(struct trace_iterator *iter,
> > > +				struct kmemtrace_page_alloc_entry *entry)
> > > +{
> > > +	struct kmemtrace_user_event_page_alloc *ev_alloc;
> > > +	struct trace_seq *s = &iter->seq;
> > > +	struct kmemtrace_user_event *ev;
> > > +
> > > +	ev = trace_seq_reserve(s, sizeof(*ev));
> > > +	if (!ev)
> > > +		return TRACE_TYPE_PARTIAL_LINE;
> > > +
> > > +	ev->event_id		= KMEMTRACE_USER_PAGE_ALLOC;
> > > +	ev->type_id		= entry->type_id;
> > > +	ev->event_size		= sizeof(*ev) + sizeof(*ev_alloc);
> > > +	ev->cpu			= iter->cpu;
> > > +	ev->timestamp		= iter->ts;
> > > +	ev->call_site		= 0ULL;	/* FIXME */
> > > +	ev->ptr			= 0ULL;	/* FIXME */
> > 
> > Here we could call save_stack_trace(), in a way like this, to save 
> > up to 8 entries of the allocation back-trace:
> 
> The example code compiled as-is so here's an updated patch! :-) We
> should probably do stack traces for _all_ events like you suggested but
> that's a bigger ABI change so I did it only for the new page allocation
> event.

I've thought about exporting a stack trace instead of a call-site
pointer, sounds nice. But I figure we should leave ev->call_site filled
as before, it's useful in some cases to show who is the intended caller,
e.g. caller-tracking variants of kmalloc.

It could also work out-of-the-box with the existing kmemtrace, since we
consume and ignore the remaining ev->event_size bytes we don't know how to
interpret. Moreover, events can hold 2^16 bytes which is enough to
export more than 8 previous frames.

One thing I'm not sure about this patch is whether it manages to record
an allocation only once, i.e. does it log a single event when/if the slab
allocator requests pages? Some time ago I sent a patch adding GFP_NOTRACE
to gfp.h, but was rejected. Maybe this could be a way out of the mess.

(GFP_NOTRACE would also allow us to log "backend" allocations easily and
treat them separately, for the record, or simply filter them out.)


	Cheers,
	Eduard

