Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZJKJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZJKJBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbZJKJBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:01:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZJKJBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:01:22 -0400
Date: Sun, 11 Oct 2009 11:00:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, hch@infradead.org
Subject: Re: [RFC][PATCH 1/9] tracing/events: Add 'signed' field to format
	files
Message-ID: <20091011090035.GG14995@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <1254809398-8078-2-git-send-email-tzanussi@gmail.com> <1254877572.1696.48.camel@gandalf.stny.rr.com> <1254891887.28917.190.camel@tropicana> <1254920837.1696.130.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254920837.1696.130.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2009-10-07 at 00:04 -0500, Tom Zanussi wrote:
> > On Tue, 2009-10-06 at 21:06 -0400, Steven Rostedt wrote:
> > > On Tue, 2009-10-06 at 01:09 -0500, Tom Zanussi wrote:
> > > > The sign info used for filters in the kernel is also useful to
> > > > applications that process the trace stream.  Add it to the format
> > > > files and make it available to userspace.
> > > > 
> > > > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > > > ---
> > > >  include/trace/ftrace.h              |   15 +++++++++------
> > > >  kernel/trace/ring_buffer.c          |   15 +++++++++------
> > > >  kernel/trace/trace_events.c         |   24 ++++++++++++------------
> > > >  kernel/trace/trace_export.c         |   25 ++++++++++++++-----------
> > > >  kernel/trace/trace_syscalls.c       |   20 +++++++++++++-------
> > > >  tools/perf/util/trace-event-parse.c |   24 ++++++++++++++++++++++++
> > > >  tools/perf/util/trace-event.h       |    1 +
> > > >  7 files changed, 82 insertions(+), 42 deletions(-)
> > > > 
> > > > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > > > index cc0d966..c9bbcab 100644
> > > > --- a/include/trace/ftrace.h
> > > > +++ b/include/trace/ftrace.h
> > > > @@ -120,9 +120,10 @@
> > > >  #undef __field
> > > >  #define __field(type, item)					\
> > > >  	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
> > > > -			       "offset:%u;\tsize:%u;\n",		\
> > > > +			       "offset:%u;\tsize:%u;\tsigned:%u;\n",	\
> > > >  			       (unsigned int)offsetof(typeof(field), item), \
> > > > -			       (unsigned int)sizeof(field.item));	\
> > > > +			       (unsigned int)sizeof(field.item),	\
> > > > +			       (unsigned int)is_signed_type(type));	\
> > > >  	if (!ret)							\
> > > >  		return 0;
> > > 
> > > I don't mind this change, but it makes me nervous. We really need to
> > > solidify the output format file. This is adding a new field and will
> > > already break the parsers in perf and trace_cmd.
> > > 
> > > Is there anything else that is needed? I really want to make sure that
> > > we don't need to modify the output of the format files any more.
> > > 
> > 
> > One of the things I had in mind when writing this patchset was to make
> > sure that what was there already was enough to write something real on
> > top of.  The only thing I found I needed to add was the signed field,
> > and that was enough at least for the Perl case, where everything can be
> > mapped into 3 types - signed, unsigned and string.
> > 
> > Other languages might demand more - I haven't looked into it - so I 
> > couldn't say whether anything else is needed, but it would seem to 
> > me that the current combination of type description strings, sizes 
> > and signs for each field should be enough information to allow any 
> > field to be passed into any scripting interpreter.  Actually, you 
> > could probably forget about signs and sizes and just manage on type 
> > description strings alone, if you had a typemap that mapped from the 
> > C type descriptions to the types expected by a given interpreter.  
> > That might be what some language implementations would end up doing, 
> > but at least for the Perl implementation, it's much more convenient 
> > to have the is_signed field.
> 
> Actually I was thinking that the print format part of the format file 
> would give enough to know if the object was signed or not, or even the 
> type (unsigned long, etc). But we are still early in this game, and I 
> would like to think that we are still early enough to be able to 
> change these formats. But it's getting close that they will soon be 
> locked in stone.

Note, the format _must_ be extensible, even if existing bits are cast 
into stone. I.e. if a new type or a new sub-type comes up, we want to be 
able to add it - and we want to fix all parsers to be ready for that.

	Ingo
