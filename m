Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYJAOwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYJAOwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYJAOwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:52:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54759 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYJAOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:52:09 -0400
Date: Wed, 1 Oct 2008 10:52:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 6/6] ftrace: take advantage of variable length entries
In-Reply-To: <20081001075419.GA24509@elte.hu>
Message-ID: <alpine.DEB.1.10.0810011049030.30777@gandalf.stny.rr.com>
References: <20080930030236.230994826@goodmis.org> <20080930030652.883661046@goodmis.org> <20080930203342.5b5ca814@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809301341300.6224@gandalf.stny.rr.com> <20081001075419.GA24509@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 Oct 2008, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > >  	struct trace_entry *entry = iter->ent;
> > > > -	struct mmiotrace_map *m	= &entry->field.mmiomap;
> > > > +	struct mmiotrace_map *m	= (struct mmiotrace_map *)entry;
> > > 
> > > This is different style than above, missing the struct
> > > trace_mmiotrace_map intermediate step. Looks like a bug,
> > > since struct mmiotrace_map is not the first field in
> > > struct trace_mmiotrace_map.
> > 
> > Crap! yes this is a bug. Thanks for pointing this out.
> 
> hm, there's a significant amount of type casts, see the grep below.

Yeah, I don't like that either.

> 
> The ringbuffer becoming type-opaque has exactly these kinds of dangers, 
> and as i suggested a few days ago, please think about a debug mode that 
> stores the record type in the trace entry and validates it on extraction 
> or something like that.
> 
> That might even be a robustness feature: the tracer should not crash if 
> the trace buffer gets corrupted. ftrace had that invariant before, i 
> think we should try to keep as many aspects of it as possible.

Although the ring buffer is type opaque, that isn't the cause of this 
issue. Ftrace still adds the types as needed. But since we no longer have 
the big "one type for all" union entry, we need to be a bit more careful. 
All types start with a one byte type id (giving us 255 types to use for 
ftrace, zero being saved).

The following patch fixes this bug and addresses the issue.

-- Steve

