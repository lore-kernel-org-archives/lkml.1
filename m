Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYIBLJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYIBLJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYIBLIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:08:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYIBLIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:08:52 -0400
Subject: Re: [PATCH 11/13] hrtimer: turn hrtimers into range timers
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <1220343732.8609.19.camel@twins>
References: <20080901160343.75a89ec9@infradead.org>
	 <20080901161336.10a71c9f@infradead.org>  <1220343732.8609.19.camel@twins>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 13:08:45 +0200
Message-Id: <1220353725.8609.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 10:22 +0200, Peter Zijlstra wrote:
> On Mon, 2008-09-01 at 16:08 -0700, Arjan van de Ven wrote:
> 
> > @@ -847,7 +847,8 @@ static void enqueue_hrtimer(struct hrtimer *timer,
> >                  * We dont care about collisions. Nodes with
> >                  * the same expiry time stay together.
> >                  */
> > -               if (timer->expires.tv64 < entry->expires.tv64) {
> > +               if (hrtimer_get_expires_tv64(timer) <
> > +                               hrtimer_get_expires_tv64(entry)) {
> >                         link = &(*link)->rb_left;
> >                 } else {
> >                         link = &(*link)->rb_right;
> 
> On Mon, 2008-09-01 at 16:13 -0700, Arjan van de Ven wrote:
> 
> > +static inline void hrtimer_set_expires_range(struct hrtimer *timer, ktime_t time, ktime_t delta)
> > +{
> > +       timer->_softexpires = time;
> > +       timer->_expires = ktime_add_safe(time, delta);
> > +}
> 
> > @@ -241,10 +259,19 @@ static inline ktime_t hrtimer_get_expires(const struct hrtimer *timer)
> >  	return timer->_expires;
> >  }
> >  
> > +static inline ktime_t hrtimer_get_softexpires(const struct hrtimer *timer)
> > +{
> > +	return timer->_expires;
> > +}
> 
> Somehow the function is called softexpires, but returns the hard expire
> time...
> 
> >  static inline s64 hrtimer_get_expires_tv64(const struct hrtimer *timer)
> >  {
> >  	return timer->_expires.tv64;
> >  }
> > +static inline s64 hrtimer_get_softexpires_tv64(const struct hrtimer *timer)
> > +{
> > +	return timer->_softexpires.tv64;
> > +}
> >  
> >  static inline s64 hrtimer_get_expires_ns(const struct hrtimer *timer)
> >  {
> 
> > @@ -1309,7 +1309,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
> >  
> >  			timer = rb_entry(node, struct hrtimer, node);
> >  
> > -			if (basenow.tv64 < hrtimer_get_expires_tv64(timer)) {
> > +			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
> >  				ktime_t expires;
> >  
> >  				expires = ktime_sub(hrtimer_get_expires(timer),
> 
> I might be missing something, but this code only looks at the leftmost
> timer, and we're indexed on the hard expire time, which might be rather
> far to the right of here.
> 
> This means that esp for those timers for which we can save most we're
> least likely to do so because we'll plain not see them.

What you need is a data structure that supports stabbing queries on
overlapping intervals, such like a Priority Search Tree.

If I'm not mistaken, then the augmented Red-Black tree from the EEVDF
paper is identical to PST [*].

This data-structure adds a Heap property to each RB-node, allowing one
to search the tree on a different property.

So what you can do in this case, is index the RB-tree on the soft
expire, and index the heap on the hard expire.

Then you can find the leftmost hard expire by traversing the tree using
the heap property - and program the clock-event using that time.

And you can search for soft expired entries using the RB-tree like we do
now.


[*] Fabio implemented it on top of the linux RB-tree for their wf2q+
implementation that they used for their BFQ I/O scheduler:

http://feanor.sssup.it/~fabio/linux/wfq/

And I borrowed their implementation for my scheduler work:

http://programming.kicks-ass.net/kernel-patches/sched-eevdf/sched-eedf.patch



