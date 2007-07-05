Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbXGEQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbXGEQIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbXGEQIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:08:06 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33585 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbXGEQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:08:02 -0400
Subject: Re: [RFC PATCH 1/3] Generic Trace Setup and Control (GTSC)
	Documentation
From: Tom Zanussi <zanussi@us.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, dwilder@us.ibm.com,
       hunt@redhat.com
In-Reply-To: <20070704033738.GC24341@Krystal>
References: <1183173868.24291.143.camel@ubuntu>
	 <20070704033738.GC24341@Krystal>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 11:05:19 -0500
Message-Id: <1183651519.4517.167.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 23:37 -0400, Mathieu Desnoyers wrote:
> * Tom Zanussi (zanussi@us.ibm.com) wrote:
> > This is the documentation for the Generic Trace Setup and Control
> > patchset, first submitted a couple of weeks ago.  See
> > 
> > http://marc.info/?l=linux-kernel&m=118214274912586&w=2
> > 
> > for a more detailed description.
> > 
> > I've updated this patch to incorporate the suggestions made by Alexey
> > Dobriyan in that thread.
> > 
> 
> It would be nice, since it claims to be "generic", to support things
> brought forward by other tracers like LTTng, such as : multiple channels
> (for low, medium and high event rate data, with user-selectable sizes),
> hybrid trace mode (combined normal trace channels and flight recorder
> channels).
> 

Those seem like useful things, but it would also be nice for LTTng to
support things brought forward by other tracers too.

GTSC comes from something I posted last year called 'UTT', for 'Unified
Trace Transport':

http://www.ecos.sourceware.org/ml/systemtap/2006-q4/msg00026.html

I wasn't comfortable with the word 'Unified' then, either, since I
thought it was presumptuous (so 'unified' was dropped, and 'generic'
used instead - basically it just means that any tracing application can
use it, not that it attempts to subsume all other tracers).

The idea was to see if the blktrace code could be generalized so that it
could be used for other tracing applications besides block layer
tracing.  The test case was to get systemtap running on top of the
blktrace transport, and it seemed to work fine.  As part of that patch
set, I also posted a couple patches that did the same thing but on top
of LTTng, which also worked fine:

http://www.ecos.sourceware.org/ml/systemtap/2006-q4/msg00028.html
http://www.ecos.sourceware.org/ml/systemtap/2006-q4/msg00027.html

But I never got any comments about it, so I assumed it wasn't something
you were interested in.  In any case, do you really think everyone who
wants to do tracing should wait around for LTTng to get into the kernel
lock, stock, and barrel?  It's been awhile since I did this experiment,
but do you think LTTng is ready today to function as the transport for
systemtap?  How hard do you think it would it be to modify blktrace to
run on top of the the LTTng tracing infrastructure?  My guess is that if
the answers were 'yes' and 'not hard', then LTTng could basically 'own'
tracing and the rest of us could move on to more interesting things.

> Please see comments below,
> 
> > +
> > +void gtsc_printf(struct trace_info *trace, const char *format, ...)
> > +{
> > +	va_list args;
> > +	void *buf;
> > +	int len;
> > +	char *record;
> > +
> > +	if (!trace)
> > +		return;
> > +	if (!trace_running(trace))
> > +		return;
> > +
> > +	/* get a timestamp */
> > +	buf = gtsc_printf_tmpbuf[smp_processor_id()];
> > +	len = sprintf(buf,"[%lld] ", trace_timestamp());
> > +
> > +	/* get the data */
> > +	va_start(args, format);
> > +	len += vsnprintf(buf+len, GTSC_PRINTF_TMPBUF_SIZE, format, args);
> > +	va_end(args);
> > +
> > +	/*
> > +	 * Locking can be eliminated by specifying per-cpu buffers
> > +	 * when calling trace_setup().
> > +	 */
> > +	spin_lock(&gtsc_printf_lock);
> > +
> 
> I really hope nobody is willing to call gtsc_printf from an interrupt
> handler.. :) Easy dead embrace in perspective.
> 

This is just example code in the documentation.  There is no actual
gtsc_printf() in the code.

Tom



