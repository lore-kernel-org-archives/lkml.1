Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYJJHXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYJJHXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYJJHXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:23:04 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:35690 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbYJJHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:23:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAPab7khMQWq+/2dsb2JhbACBcrtXgWo
Date: Fri, 10 Oct 2008 03:23:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Markers : fix check format with rcu callback race
Message-ID: <20081010072300.GB23247@Krystal>
References: <20081010054444.GB19481@Krystal> <48EEF3A6.3050205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48EEF3A6.3050205@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:21:30 up 127 days, 12:01,  9 users,  load average: 0.88, 0.64,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > The fix "markers: fix unchecked format" introduced an RCU callback race. This
> > patch takes care of calling any pending RCU callback before set_format is
> > called.
> > 
> 
> marker_set_format() has this statement:
> 
> 	if ((*entry)->rcu_pending)
> 		rcu_barrier_sched();
> 

True, therefore my fix is not needed.

Mathieu

> > 
> > * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> >> bit-field is not thread-safe nor smp-safe.
> >>
> >> struct marker_entry.rcu_pending is not protected by any lock
> >> in rcu-callback free_old_closure().
> >> so we must turn it into a safe type.
> >>
> > 
> > All struct marker_entry.rcu_pending accesses are done with the
> > markers_mutex held, except the one done in free_old_closure(). Normally,
> > there should be a
> >         if (entry->rcu_pending)
> >            rcu_barrier_sched();
> > 
> > At the beginning of each markers_mutex section (just after get_marker())
> > to make sure any pending callback is executed at that point before any
> > of rcu_pending or ptype are touched. 
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> >  kernel/marker.c |   24 +++++++++++++-----------
> >  1 file changed, 13 insertions(+), 11 deletions(-)
> > 
> > Index: linux-2.6-lttng/kernel/marker.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/marker.c	2008-10-10 01:35:32.000000000 -0400
> > +++ linux-2.6-lttng/kernel/marker.c	2008-10-10 01:35:32.000000000 -0400
> > @@ -657,21 +657,23 @@ int marker_probe_register(const char *na
> >  		entry = add_marker(name, format);
> >  		if (IS_ERR(entry))
> >  			ret = PTR_ERR(entry);
> > -	} else if (format) {
> > -		if (!entry->format)
> > -			ret = marker_set_format(&entry, format);
> > -		else if (strcmp(entry->format, format))
> > -			ret = -EPERM;
> > +	} else {
> > +		/*
> > +		 * If we detect that a call_rcu is pending for this marker,
> > +		 * make sure it's executed now.
> > +		 */
> > +		if (entry->rcu_pending)
> > +			rcu_barrier_sched();
> > +		if (format) {
> > +			if (!entry->format)
> > +				ret = marker_set_format(&entry, format);
> > +			else if (strcmp(entry->format, format))
> > +				ret = -EPERM;
> > +		}
> >  	}
> >  	if (ret)
> >  		goto end;
> >  
> > -	/*
> > -	 * If we detect that a call_rcu is pending for this marker,
> > -	 * make sure it's executed now.
> > -	 */
> > -	if (entry->rcu_pending)
> > -		rcu_barrier_sched();
> >  	old = marker_entry_add_probe(entry, probe, probe_private);
> >  	if (IS_ERR(old)) {
> >  		ret = PTR_ERR(old);
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
