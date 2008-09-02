Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYIBNFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYIBNFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYIBNFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:05:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:51297 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYIBNFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:05:20 -0400
Date: Tue, 2 Sep 2008 06:05:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 11/13] hrtimer: turn hrtimers into range timers
Message-ID: <20080902060517.60dca448@infradead.org>
In-Reply-To: <1220343732.8609.19.camel@twins>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161336.10a71c9f@infradead.org>
	<1220343732.8609.19.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008 10:22:12 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2008-09-01 at 16:08 -0700, Arjan van de Ven wrote:
> 
> > @@ -847,7 +847,8 @@ static void enqueue_hrtimer(struct hrtimer
> > *timer,
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
> > +static inline void hrtimer_set_expires_range(struct hrtimer
> > *timer, ktime_t time, ktime_t delta) +{
> > +       timer->_softexpires = time;
> > +       timer->_expires = ktime_add_safe(time, delta);
> > +}
> 
> > @@ -241,10 +259,19 @@ static inline ktime_t
> > hrtimer_get_expires(const struct hrtimer *timer) return
> > timer->_expires; }
> >  
> > +static inline ktime_t hrtimer_get_softexpires(const struct hrtimer
> > *timer) +{
> > +	return timer->_expires;
> > +}
> 
> Somehow the function is called softexpires, but returns the hard
> expire time...

argh that's what you get if you split a patch into a series by hand ;-(

> > ktime_sub(hrtimer_get_expires(timer),
> 
> I might be missing something, but this code only looks at the leftmost
> timer, and we're indexed on the hard expire time, which might be
> rather far to the right of here.
> 
> This means that esp for those timers for which we can save most we're
> least likely to do so because we'll plain not see them.

you're missing a little detail ;)

yes we start from left to right, and we stop once we find a timer that
we can't fire anymore. The thing that you missed is that any timer
after that (even if we could fire it now) will just be fired when the
timer we stopped on fires.. so it'll still group them around those
timers that are otherwise ungroupable.
(it's not perfect by any means but it works ;-)

> 
> 
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
