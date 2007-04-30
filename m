Return-Path: <linux-kernel-owner+w=401wt.eu-S1946710AbXD3TUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946710AbXD3TUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946715AbXD3TUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:20:20 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36136 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946710AbXD3TTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:19:49 -0400
Date: Tue, 1 May 2007 00:49:34 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Allow selective freezing of the system for different events
Message-ID: <20070430191934.GA4142@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200704271737.31192.rjw@sisk.pl> <200704271740.17972.rjw@sisk.pl> <20070428013446.GA20242@in.ibm.com> <200704291951.05425.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704291951.05425.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 07:51:04PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Sorry for the delay.

No problems! Even I was out for the weekend.

> >  /*
> >   * Tell the freezer to exempt this task from freezing
> > + * for events in freeze_event_mask.
> >   */
> > -static inline void freezer_exempt(struct task_struct *p)
> 
> I, personally, would introduce
> 
> static inline void freezer_exempt_event(struct task_struct *p,
> 				  unsigned long freeze_event_mask)
> {
> 	atomic_set_mask(freeze_event_mask, &p->freezer_flags);
> }
> 
> and then
> 
> static inline void freezer_exempt(struct task_struct *p)
> {
> 	freezer_exempt_event(p, FE_ALL);
> }
> 
> The patch would be shorter. ;-)
> 

Agreed. Will do that.

> [In that case I'd probably rename freezer_should_exempt() to
> freezer_should_exempt_event(), for symmetry.]
> 

Ok. 

> > +
> > +static inline int thawable(struct task_struct *p)
> > +{
> > +	if (!freezeable(p))
> > +		return 0;
> > +
> > +	/* Thaw p iff it is frozen for current_freezer_event alone */
> > +	 if (process_frozen_event_mask(p) & ~current_freezer_event)
> > +	 	return 0;
> > +
> > +	return 1;
> 
> I would do
> 
> 	return !(process_frozen_event_mask(p) & ~current_freezer_event);

I was wondering if the statement
	 if (process_frozen_event_mask(p) & ~current_freezer_event)
	 	return 0;

would be readable in the first place! 
Yeah, we can do what you have suggested.

> > -int freeze_processes(void)
> > +int freeze_processes(unsigned long freeze_event)
> >  {
> > -	unsigned int nr_unfrozen;
> > +	unsigned int nr_unfrozen = 0;
> > +
> > +	mutex_lock(&freezer_mutex);
> > +	if (system_frozen_event_mask & freeze_event)
> > +		goto out;
> > +
> > +	current_freezer_event = freeze_event;
> >  
> >  	printk("Stopping tasks ... ");
> >  	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
> >  	if (nr_unfrozen)
> > -		return nr_unfrozen;
> > +		goto out;
> >  
> >  	sys_sync();
> >  	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
> >  	if (nr_unfrozen)
> > -		return nr_unfrozen;
> > +		goto out;
> >  
> > +	system_frozen_event_mask |= current_freezer_event;
> >  	printk("done.\n");
> >  	BUG_ON(in_atomic());
> 
> The BUG_ON() is still valid if tasks are already frozen for this event.

Right! So we would need one more label. How about the following?

	mutex_lock(&freezer_mutex);
	/* check if already frozen for the event */
	if (system_frozen_event_mask & freeze_event)
		goto out_frozen;
		.
		.
		.

out_frozen: 
	BUG_ON(in_atomic());
out:
	current_freezer_event = 0;
	mutex_unlock(&freezer_mutex);
	return nr_unfrozen;
}

> 

> > -void thaw_processes(void)
> > +void thaw_processes(unsigned long thaw_event)
> >  {
> > +	mutex_lock(&freezer_mutex);
> > +	if (!(system_frozen_event_mask & thaw_event)) {
> > +		WARN_ON(1);
> 
> Hmm, I wouldn't use the WARN_ON() here.  There's nothing wrong in calling
> this twice in a row as long as we do the sanity checking.  There's even one
> case in which that may be convenient, actually.

Well, yes. But I put the warn on from the perspective of someone trying
to thaw_processes for the event for which they have not frozen. I hadn't
thought about a double thaw. Will rethink.

Thanks for the Review.
Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
