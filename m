Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbZJGNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbZJGNJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933353AbZJGNJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:09:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57762 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbZJGNJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:09:16 -0400
Subject: Re: [RFC][PATCH 1/9] tracing/events: Add 'signed' field to format
 files
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       lizf@cn.fujitsu.com, hch@infradead.org
In-Reply-To: <1254891887.28917.190.camel@tropicana>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
	 <1254809398-8078-2-git-send-email-tzanussi@gmail.com>
	 <1254877572.1696.48.camel@gandalf.stny.rr.com>
	 <1254891887.28917.190.camel@tropicana>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 09:07:17 -0400
Message-Id: <1254920837.1696.130.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 00:04 -0500, Tom Zanussi wrote:
> On Tue, 2009-10-06 at 21:06 -0400, Steven Rostedt wrote:
> > On Tue, 2009-10-06 at 01:09 -0500, Tom Zanussi wrote:
> > > The sign info used for filters in the kernel is also useful to
> > > applications that process the trace stream.  Add it to the format
> > > files and make it available to userspace.
> > > 
> > > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > > ---
> > >  include/trace/ftrace.h              |   15 +++++++++------
> > >  kernel/trace/ring_buffer.c          |   15 +++++++++------
> > >  kernel/trace/trace_events.c         |   24 ++++++++++++------------
> > >  kernel/trace/trace_export.c         |   25 ++++++++++++++-----------
> > >  kernel/trace/trace_syscalls.c       |   20 +++++++++++++-------
> > >  tools/perf/util/trace-event-parse.c |   24 ++++++++++++++++++++++++
> > >  tools/perf/util/trace-event.h       |    1 +
> > >  7 files changed, 82 insertions(+), 42 deletions(-)
> > > 
> > > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > > index cc0d966..c9bbcab 100644
> > > --- a/include/trace/ftrace.h
> > > +++ b/include/trace/ftrace.h
> > > @@ -120,9 +120,10 @@
> > >  #undef __field
> > >  #define __field(type, item)					\
> > >  	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
> > > -			       "offset:%u;\tsize:%u;\n",		\
> > > +			       "offset:%u;\tsize:%u;\tsigned:%u;\n",	\
> > >  			       (unsigned int)offsetof(typeof(field), item), \
> > > -			       (unsigned int)sizeof(field.item));	\
> > > +			       (unsigned int)sizeof(field.item),	\
> > > +			       (unsigned int)is_signed_type(type));	\
> > >  	if (!ret)							\
> > >  		return 0;
> > 
> > I don't mind this change, but it makes me nervous. We really need to
> > solidify the output format file. This is adding a new field and will
> > already break the parsers in perf and trace_cmd.
> > 
> > Is there anything else that is needed? I really want to make sure that
> > we don't need to modify the output of the format files any more.
> > 
> 
> One of the things I had in mind when writing this patchset was to make
> sure that what was there already was enough to write something real on
> top of.  The only thing I found I needed to add was the signed field,
> and that was enough at least for the Perl case, where everything can be
> mapped into 3 types - signed, unsigned and string.
> 
> Other languages might demand more - I haven't looked into it - so I
> couldn't say whether anything else is needed, but it would seem to me
> that the current combination of type description strings, sizes and
> signs for each field should be enough information to allow any field to
> be passed into any scripting interpreter.  Actually, you could probably
> forget about signs and sizes and just manage on type description strings
> alone, if you had a typemap that mapped from the C type descriptions to
> the types expected by a given interpreter.  That might be what some
> language implementations would end up doing, but at least for the Perl
> implementation, it's much more convenient to have the is_signed field.

Actually I was thinking that the print format part of the format file
would give enough to know if the object was signed or not, or even the
type (unsigned long, etc). But we are still early in this game, and I
would like to think that we are still early enough to be able to change
these formats. But it's getting close that they will soon be locked in
stone.

-- Steve


