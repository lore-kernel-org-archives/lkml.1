Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXAXQzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXAXQzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXAXQzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:55:06 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:53799 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbXAXQzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:55:05 -0500
Date: Wed, 24 Jan 2007 11:55:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       ltt-dev@shafik.org, "Martin J. Bligh" <mbligh@mbligh.org>,
       Douglas Niehaus <niehaus@eecs.ku.edu>, systemtap@sources.redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Richard J Moore <richardj_moore@uk.ibm.com>
Subject: Re: [PATCH 2/2] lockdep reentrancy
Message-ID: <20070124165500.GD4979@Krystal>
References: <20061220235216.GA28643@Krystal> <OFAB3D8A6C.1643F2D3-ON80257262.000581E4-80257262.00088F04@uk.ibm.com> <20070116175631.GB16084@Krystal> <20070123202909.6b7dcd17.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070123202909.6b7dcd17.akpm@osdl.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 11:52:20 up 154 days, 13:59,  4 users,  load average: 1.39, 0.76, 0.62
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

* Andrew Morton (akpm@osdl.org) wrote:
> On Tue, 16 Jan 2007 12:56:31 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Here is a patch to lockdep.c so it behaves correctly when a kprobe breakpoint is
> > put on a marker within hardirq tracing functions as long as the marker is within
> > the lockdep_recursion incremented boundaries. It should apply on 
> > 2.6.20-rc4-git3.
> > 
> > Mathieu
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > 
> > 
> > @@ -1841,33 +1843,36 @@ void trace_hardirqs_on(void)
> 
> You lost the patch headers.
> 
> >  	struct task_struct *curr = current;
> >  	unsigned long ip;
> >  
> >  	if (unlikely(!debug_locks || current->lockdep_recursion))
> >  		return;
> >  
> > +	current->lockdep_recursion++;
> > +	barrier();
> 
> Why can't we use lockdep_off() here?
> 

Because I thought that changing lockdep_off() for the whole system might be a
little different than adding a lockdep recursion protection. See my other email
for the lockdep_on/off() discussion.

And please drop this patch : It sometimes make lockdep trigger false positives
under heavy IRQ load because of a dropped lockdep event.

Mathieu


> >  	if (DEBUG_LOCKS_WARN_ON(unlikely(!early_boot_irqs_enabled)))
> > -		return;
> > +		goto end;
> >  
> >  	if (unlikely(curr->hardirqs_enabled)) {
> >  		debug_atomic_inc(&redundant_hardirqs_on);
> > -		return;
> > +		goto end;
> >  	}
> >  	/* we'll do an OFF -> ON transition: */
> >  	curr->hardirqs_enabled = 1;
> >  	ip = (unsigned long) __builtin_return_address(0);
> >  
> >  	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
> > -		return;
> > +		goto end;
> >  	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
> > -		return;
> > +		goto end;
> >  	/*
> >  	 * We are going to turn hardirqs on, so set the
> >  	 * usage bit for all held locks:
> >  	 */
> >  	if (!mark_held_locks(curr, 1, ip))
> > -		return;
> > +		goto end;
> >  	/*
> >  	 * If we have softirqs enabled, then set the usage
> >  	 * bit for all held locks. (disabled hardirqs prevented
> > @@ -1875,11 +1880,14 @@ void trace_hardirqs_on(void)
> >  	 */
> >  	if (curr->softirqs_enabled)
> >  		if (!mark_held_locks(curr, 0, ip))
> > -			return;
> > +			goto end;
> >  
> >  	curr->hardirq_enable_ip = ip;
> >  	curr->hardirq_enable_event = ++curr->irq_events;
> >  	debug_atomic_inc(&hardirqs_on_events);
> > +end:
> > +	barrier();
> > +	current->lockdep_recursion--;
> 
> lockdep_on()?
> 
> >  }
> >  
> >  EXPORT_SYMBOL(trace_hardirqs_on);
> > @@ -1888,14 +1896,17 @@ void trace_hardirqs_off(void)
> >  {
> >  	struct task_struct *curr = current;
> >  
> >  	if (unlikely(!debug_locks || current->lockdep_recursion))
> >  		return;
> >  
> > +	current->lockdep_recursion++;
> > +	barrier();
> 
> lockdep_off()?
> 
> >  	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
> > -		return;
> > +		goto end;
> >  
> >  	if (curr->hardirqs_enabled) {
> >  		/*
> > @@ -1910,6 +1921,9 @@ void trace_hardirqs_off(void)
> >  		debug_atomic_inc(&hardirqs_off_events);
> >  	} else
> >  		debug_atomic_inc(&redundant_hardirqs_off);
> > +end:
> > +	barrier();
> > +	current->lockdep_recursion--;
> 
> lockdep_on()?

-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
