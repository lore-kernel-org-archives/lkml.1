Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbXGEQAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbXGEQAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbXGEQAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:00:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33000 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbXGEQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:00:01 -0400
Subject: Re: [RFC PATCH 2/6] Driver Tracing Interface (DTI) code
From: Tom Zanussi <zanussi@us.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, HOLZHEU@de.ibm.com
In-Reply-To: <20070704031304.GA24590@Krystal>
References: <1183173834.24291.138.camel@ubuntu>
	 <20070704031304.GA24590@Krystal>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 10:59:09 -0500
Message-Id: <1183651149.4517.164.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 23:13 -0400, Mathieu Desnoyers wrote:
> > +void *__dti_reserve(struct dti_info *dti, int prio, size_t len)
> > +{
> > +	struct dti_event *event;
> > +	int event_len;
> > +
> > +	if (!dti)
> > +		return NULL;
> > +
> > +	if (prio > dti->level)
> > +		return NULL;
> > +
> > +	event_len = len + sizeof(*event);
> > +
> > +	event = relay_reserve(dti->trace->rchan, event_len);
> > +	if (!event)
> > +		return NULL;
> > +
> > +	event->time = sched_clock();
> 
> sched_clock() is dangerous.. you have to make sure you provide correct
> clock errors in the trace parsing.. not exactly something interesting
> when you are looking at the "one" case over 10000 that was faulty. See
> the i386 sched-clock.c:
> 
>  * Scheduler clock - returns current time in nanosec units.
>  * All data is local to the CPU.
>  * The values are approximately[1] monotonic local to a CPU, but not
>  * between CPUs.   There might be also an occasionally random error,
>  * but not too bad. Between CPUs the values can be non monotonic.
>  *
>  * [1] no attempt to stop CPU instruction reordering, which can hit
>  * in a 100 instruction window or so.
> 
> How do you plan to use these timestamps to reorder events across CPUs ?
> 

lttng_timestamp()? ;-)


> > +
> > +static int vprintk_normal(struct dti_info *dti, int prio, const char* fmt,
> > +			  va_list args)
> > +{
> > +	struct dti_event *event;
> > +	void *buf;
> > +	int len, event_len, rc = -1;
> > +	unsigned long flags;
> > +
> > +	if (!dti)
> > +		return -1;
> > +
> > +	if (prio > dti->level)
> > +		return -1;
> > +
> > +	local_irq_save(flags);
> > +	buf = dti_printf_tmpbuf[smp_processor_id()];
> > +	len = vsnprintf(buf, DTI_PRINTF_TMPBUF_SIZE, fmt, args);
> 
> As I said, why not put the result of the vsnprintf directly in the
> buffer after the relay_reserve ?
> 

Because I don't know how much to reserve until I've done the
vsnprintf().  I think that to have vsnprintf() print directly into the
relay buffer, I'd need a relay_unreserve() to remove the unused portion.

> > +
> > +/**
> > + *	dti_relog_initbuf - re-log static initbuf into real relay channel
> > + *	@work: work struct that contains the the dti handle
> > + *
> > + *	The global initbuf may contain events from multiple cpus.  These
> > + *	events must be put into their respective cpu buffers once the
> > + *	per-cpu channel is available.
> > + *
> > + *	Internal - exported for setup macros.
> > + */
> > +int dti_relog_initbuf(struct dti_handle *handle)
> > +{
> 
> What do you do with the data recorded by the system while you do this
> buffer copy? Is the timestamp ordering kept? Why do you copy the static
> buffers into other buffers at all anyway ? They could be exported
> through relay (if it supported exporting statically mapped buffers).
> 

You're right, we need to do something about that.  As mentioned before,
we copy the events from the static buffer into the relay channel (the
timestamp ordering is kept) after it becomes available because that
seems like the simplest thing to do.  We could add support to relay to
export another set of (static) buffers, or add the relogging code to
relay if other tracers want to use it.

Tom





