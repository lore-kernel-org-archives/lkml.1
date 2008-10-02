Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYJBNGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYJBNGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYJBNGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:06:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYJBNGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:06:14 -0400
Date: Thu, 2 Oct 2008 09:06:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] ring_buffer: allocate buffer page pointer
In-Reply-To: <20081002020615.4840542a.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810020901400.19018@gandalf.stny.rr.com>
References: <20080930000307.GA2929@Krystal> <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com> <20080930034603.GA13801@Krystal> <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins>
 <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com>
 <20081002085030.GF26084@elte.hu> <20081002020615.4840542a.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Oct 2008, Andrew Morton wrote:
> > 
> > This patch adds a macro to assign all entries of ftrace using the type
> > of the variable and checking the entry id. The typecasts are now done
> > in the macro for only those types that it knows about, which should
> > be all the types that are allowed to be read from the tracer.
> > 
> 
> I'm somewhat at a loss here because I'm unable to find any version of
> kernel/trace/trace.c which looks anything like the one which is being
> patched, but...

As Ingo mentioned, you don't have this yet. And be happy that you don't 
;-)

This patch is to fix the patch that did this.

> 
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -1350,7 +1350,9 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
> >  	}
> >  	switch (entry->type) {
> >  	case TRACE_FN: {
> > -		struct ftrace_entry *field = (struct ftrace_entry *)entry;
> 
> Why was this code using a cast in the first place?  It should be using
> entry->some_field_i_dont_have_here?  That was the whole point in using 
> the anonymous union in struct trace_entry?

Because the ring_buffer now allows for variable length entries, having a 
one size fits all entry is not optimal.

But because C is not the best for typecasting, we have this macro to help 
solve the issue. Instead of registering everything into a single union and 
causing small fields to be large, we have a macro you can register your
type with instead.

-- Steve

