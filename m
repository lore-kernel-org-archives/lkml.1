Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbXGEQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbXGEQOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbXGEQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:14:41 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:37099 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757794AbXGEQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:14:40 -0400
Date: Thu, 5 Jul 2007 12:14:38 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Subject: Re: [RFC PATCH 2/6] Driver Tracing Interface (DTI) code
Message-ID: <20070705161438.GA23668@Krystal>
References: <1183173834.24291.138.camel@ubuntu> <20070704031304.GA24590@Krystal> <1183651149.4517.164.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1183651149.4517.164.camel@ubuntu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:07:22 up 4 days, 10:50,  3 users,  load average: 0.42, 0.30, 0.22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Zanussi (zanussi@us.ibm.com) wrote:
> On Tue, 2007-07-03 at 23:13 -0400, Mathieu Desnoyers wrote:
> > > +void *__dti_reserve(struct dti_info *dti, int prio, size_t len)
> > > +{
> > > +	struct dti_event *event;
> > > +	int event_len;
> > > +
> > > +	if (!dti)
> > > +		return NULL;
> > > +
> > > +	if (prio > dti->level)
> > > +		return NULL;
> > > +
> > > +	event_len = len + sizeof(*event);
> > > +
> > > +	event = relay_reserve(dti->trace->rchan, event_len);
> > > +	if (!event)
> > > +		return NULL;
> > > +
> > > +	event->time = sched_clock();
> > 
> > sched_clock() is dangerous.. you have to make sure you provide correct
> > clock errors in the trace parsing.. not exactly something interesting
> > when you are looking at the "one" case over 10000 that was faulty. See
> > the i386 sched-clock.c:
> > 
> >  * Scheduler clock - returns current time in nanosec units.
> >  * All data is local to the CPU.
> >  * The values are approximately[1] monotonic local to a CPU, but not
> >  * between CPUs.   There might be also an occasionally random error,
> >  * but not too bad. Between CPUs the values can be non monotonic.
> >  *
> >  * [1] no attempt to stop CPU instruction reordering, which can hit
> >  * in a 100 instruction window or so.
> > 
> > How do you plan to use these timestamps to reorder events across CPUs ?
> > 
> 
> lttng_timestamp()? ;-)
> 

Yeah, this problem is not easy.. I have a set of per architecture
timestamping implementations that detects the limitations of the
hardware and overcomes them (32 bits TSC -> 64 bits extension that
supports read from NMI context, detect TSCs not in sync (AMDs and some
intels) that falls back to what is more or less a logical clock then,
printing warnings. I also keep a recipe cookbook about what people
should disable on these architectures to get precise timestamps.
> 
> > > +
> > > +static int vprintk_normal(struct dti_info *dti, int prio, const char* fmt,
> > > +			  va_list args)
> > > +{
> > > +	struct dti_event *event;
> > > +	void *buf;
> > > +	int len, event_len, rc = -1;
> > > +	unsigned long flags;
> > > +
> > > +	if (!dti)
> > > +		return -1;
> > > +
> > > +	if (prio > dti->level)
> > > +		return -1;
> > > +
> > > +	local_irq_save(flags);
> > > +	buf = dti_printf_tmpbuf[smp_processor_id()];
> > > +	len = vsnprintf(buf, DTI_PRINTF_TMPBUF_SIZE, fmt, args);
> > 
> > As I said, why not put the result of the vsnprintf directly in the
> > buffer after the relay_reserve ?
> > 
> 
> Because I don't know how much to reserve until I've done the
> vsnprintf().  I think that to have vsnprintf() print directly into the
> relay buffer, I'd need a relay_unreserve() to remove the unused portion.
> 

This is why I use a 2 pass approach in LTTng: the first one, given a
NULL buffer, calculates the reserve size, and then the second pass does
the copy.

> > > +
> > > +/**
> > > + *	dti_relog_initbuf - re-log static initbuf into real relay channel
> > > + *	@work: work struct that contains the the dti handle
> > > + *
> > > + *	The global initbuf may contain events from multiple cpus.  These
> > > + *	events must be put into their respective cpu buffers once the
> > > + *	per-cpu channel is available.
> > > + *
> > > + *	Internal - exported for setup macros.
> > > + */
> > > +int dti_relog_initbuf(struct dti_handle *handle)
> > > +{
> > 
> > What do you do with the data recorded by the system while you do this
> > buffer copy? Is the timestamp ordering kept? Why do you copy the static
> > buffers into other buffers at all anyway ? They could be exported
> > through relay (if it supported exporting statically mapped buffers).
> > 
> 
> You're right, we need to do something about that.  As mentioned before,
> we copy the events from the static buffer into the relay channel (the
> timestamp ordering is kept) after it becomes available because that
> seems like the simplest thing to do.  We could add support to relay to
> export another set of (static) buffers, or add the relogging code to
> relay if other tracers want to use it.
> 
> 

The problem with relogging is that it will be a huge timestamping mess.
I doubt that we can reliably continue tracing while we do this copy.
Therefore, we will end up losing events or having timestamps jumping
backward.

A solution that would export the static buffers separately to user-space
and (maybe) allows them to be (somehow?) de-allocated once they have
been read by user-space seems cleaner to me. The switch between the
static buffers and the normal relay buffers could then be done
atomically in a simple pointer overwrite.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
