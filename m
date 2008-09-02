Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYIBNrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYIBNrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYIBNrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:47:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:56044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYIBNrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:47:09 -0400
Subject: Re: [PATCH 11/13] hrtimer: turn hrtimers into range timers
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
In-Reply-To: <20080902060517.60dca448@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
	 <20080901161336.10a71c9f@infradead.org> <1220343732.8609.19.camel@twins>
	 <20080902060517.60dca448@infradead.org>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 15:47:07 +0200
Message-Id: <1220363227.8609.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 06:05 -0700, Arjan van de Ven wrote:
> On Tue, 02 Sep 2008 10:22:12 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2008-09-01 at 16:08 -0700, Arjan van de Ven wrote:
> > 
> > > @@ -847,7 +847,8 @@ static void enqueue_hrtimer(struct hrtimer
> > > *timer,
> > >                  * We dont care about collisions. Nodes with
> > >                  * the same expiry time stay together.
> > >                  */
> > > -               if (timer->expires.tv64 < entry->expires.tv64) {
> > > +               if (hrtimer_get_expires_tv64(timer) <
> > > +                               hrtimer_get_expires_tv64(entry)) {
> > >                         link = &(*link)->rb_left;
> > >                 } else {
> > >                         link = &(*link)->rb_right;
> > 
> > On Mon, 2008-09-01 at 16:13 -0700, Arjan van de Ven wrote:
> > 
> > > +static inline void hrtimer_set_expires_range(struct hrtimer
> > > *timer, ktime_t time, ktime_t delta) +{
> > > +       timer->_softexpires = time;
> > > +       timer->_expires = ktime_add_safe(time, delta);
> > > +}
> > 
> > > @@ -241,10 +259,19 @@ static inline ktime_t
> > > hrtimer_get_expires(const struct hrtimer *timer) return
> > > timer->_expires; }
> > >  
> > > +static inline ktime_t hrtimer_get_softexpires(const struct hrtimer
> > > *timer) +{
> > > +	return timer->_expires;
> > > +}
> > 
> > Somehow the function is called softexpires, but returns the hard
> > expire time...
> 
> argh that's what you get if you split a patch into a series by hand ;-(
> 
> > > ktime_sub(hrtimer_get_expires(timer),
> > 
> > I might be missing something, but this code only looks at the leftmost
> > timer, and we're indexed on the hard expire time, which might be
> > rather far to the right of here.
> > 
> > This means that esp for those timers for which we can save most we're
> > least likely to do so because we'll plain not see them.
> 
> you're missing a little detail ;)
> 
> yes we start from left to right, and we stop once we find a timer that
> we can't fire anymore. The thing that you missed is that any timer
> after that (even if we could fire it now) will just be fired when the
> timer we stopped on fires.. so it'll still group them around those
> timers that are otherwise ungroupable.
> (it's not perfect by any means but it works ;-)

Gah, right. How about adding the following:

/*
 * The immediate goal is minimizing wakeups, not running
 * timers at the earliest interrupt after their soft expiration.
 * This allows us to avoid using a Priority Search Tree,
 * which can answer a stabbing querry for overlapping
 * intervals and instead use the simple BST we already have.
 * We don't add extra wakeups by delaying timers that are
 * right-of a not yet expired timer, because that timer will
 * have to trigger a wakeup anyway.
 */



