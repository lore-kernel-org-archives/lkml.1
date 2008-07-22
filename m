Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYGVE7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYGVE7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYGVE7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:59:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:44313 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYGVE7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:59:09 -0400
Subject: Re: [RFC] schedule_timeout_range()
From: David Woodhouse <dwmw2@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org
In-Reply-To: <200807221450.10146.nickpiggin@yahoo.com.au>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
	 <200807221433.32412.nickpiggin@yahoo.com.au>
	 <1216701925.18980.75.camel@shinybook.infradead.org>
	 <200807221450.10146.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Organization: Intel Corporation
Date: Tue, 22 Jul 2008 00:58:52 -0400
Message-Id: <1216702732.18980.83.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 14:50 +1000, Nick Piggin wrote:
> On Tuesday 22 July 2008 14:45, David Woodhouse wrote:
> > On Tue, 2008-07-22 at 14:33 +1000, Nick Piggin wrote:
> > > The only thing I dislike about explicit times is that when a driver or
> > > someone doesn't _really_ know how much to specify. Do you say 10s, 100s?
> >
> > This is true, but they certainly have a _better_ idea than we do. If the
> > individual callers can't even come up with an answer, how are we ever
> > going to come up with a generic policy that does the right thing?
> 
> OK, how about still having a never-until-machine-is-already-awake?

For timers we have that already -- it's called a deferrable timer. All
I've done to create the 'range timer' is couple that with a normal
timer, to implement the 'some time between X and Y' behaviour in a
fashion which is simple for people to use.

I did add the 'never-until-machine-is-already-awake' behaviour you
request to schedule_timeout_range() -- you get it by setting 'timeout'
to your intended minimum time, and setting the other argument (which was
called 'deadline' in my original patch) to MAX_SCHEDULE_TIMEOUT.

> > I really don't think that applying this kind of policy in generic code
> > is useful -- I'd like the callers to provide numbers even if they _do_
> > pull it out of their wossname.
> >
> > The number they provide is the _maximum_ amount of time they should be
> > prepared to wait (let's assume for a moment that they stayed sober and
> > remembered Linux isn't a real-time kernel, so all guarantees are taken
> > with a pinch of salt. Let's not get bogged down in nomenclature).
> 
> Well, I think it is still wise to avoid words like deadline, hard,
> and timeout in the same sentence ;)

Probably true :)

> > In practice, they'll almost always get called before that maximum time
> > expires -- that's the whole _point_, of course. But we can't _invent_
> > that maximum in generic code; that's really up to the caller.
> 
> Not a maximum, but just an "I don't know... a lot?" define. But yeah
> I guess there aren't too many good reasons for that.

I'd really like to avoid it. It puts the responsibility for coming up
with a number a _long_ way from where it should be, in the individual
caller.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


