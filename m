Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZBSWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZBSWrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZBSWrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:47:13 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36615 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbZBSWrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:47:12 -0500
Subject: Re: [PATCH][RFC(again)] Apply NTP frequency/tick changes
	immediately.
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zippel@linux-m68k.org, williams@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090219141234.40f84111.akpm@linux-foundation.org>
References: <1234494121.7042.14.camel@localhost.localdomain>
	 <1235001742.6946.18.camel@localhost.localdomain>
	 <20090219141234.40f84111.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 14:47:08 -0800
Message-Id: <1235083628.7265.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 14:12 -0800, Andrew Morton wrote:
> On Wed, 18 Feb 2009 16:02:22 -0800
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Thu, 2009-02-12 at 19:02 -0800, john stultz wrote:
> > > Hey Roman,
> > > 	It was brought to my attention that since the GENERIC_TIME changes
> > > landed, the adjtimex behavior changed for struct timex.tick and .freq
> > > changes. When the tick or freq value is set, we adjust the
> > > tick_length_base in ntp_update_frequency(). However, this new value
> > > doesn't get applied to tick_length until the next second (via
> > > second_overflow). 
> > > 
> > > This means some applications that do quick time tweaking do not see the
> > > requested change made as quickly as expected.
> > > 
> > > Looking at the code, it doesn't seem like it would be too hard to
> > > immediately apply the change to the tick_length value, so its changed in
> > > the following NTP_INTERVAL, which this patch does.
> > > 
> > > I've run a few tests with this change, and ntpd still functions fine. I
> > > do however note that the drift value for my test system changed from
> > > ~170ppm to ~18ppm, which I didn't quite expect, and needs some
> > > additional research.
> > > 
> > > Anyway, I just wanted to see if you had any thoughts on this sort of
> > > change.
> > 
> > Hey Roman, Just wanted to ping you again to see if you had any
> > objections to this change.
> > 
> > I did find the cause of my test system's drift switching from 170ppm to
> > 18ppm, and it ends up its due to my bouncing between kernel versions.
> > The 170ppm drift was established after running w/ a older 2.6.24 based
> > kernel for awhile, and after the NTP_INTERVAL_LENGTH changes
> > (10a398d04c4a1fc395840f4d040493375f562302) landed the ppm value was
> > expected to change. Comparing the same kernel 2.6.29-rc4 with and
> > without this patch, the ppm value did not change.
> 
> <tries to find a changelog in there, gives up>
> 
> > Anyway, here it is again.
> > 
> > thanks
> > -john
> > 
> > 
> > Apply NTP tick/frequency adjustments immediately instead of waiting for
> > the next second to pass.
> > 
> 
> Please modify the changelog so that it explains the reason for making
> the change.

Sorry about that. It was a bit too brief. Here's one if you want to
paste it in, but I can also resubmit the entire thing:


Since the GENERIC_TIME changes landed, the adjtimex behavior changed for
struct timex.tick and .freq changed. When the tick or freq value is set,
we adjust the tick_length_base in ntp_update_frequency(). However, this
new value doesn't get applied to tick_length until the next second (via
second_overflow).

This means some applications that do quick time tweaking do not see the
requested change made as quickly as expected.

This patch patch makes it so changes to timex.tick and .freq are
immediately applied to the next NTP_INTERVAL_LENGTH.


> I _could_ copy-n-paste the doubly-quoted text from up top, but perhaps
> that isn't how you'd have wanted to changelog it, had you wanted to
> changelog it ;)
> 
> I'm particularly looking for a sense of how urgent this fix is.

Not urgent. The behavior has been this way for quite some time. So I was
hoping to sort out any objections and ideally get it ready for the
2.6.30 window.

Don't get me wrong, I appreciate folks picking things up quickly, its
much better then things getting lost, but I I had to mail Ingo to say
much of the same earlier today.

RFC still means request for comments, not request for commit, right? :)


> >  	tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
> >  	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
> > +	
> > +	/* Don't wait for the next second_overflow, apply
> > +	 * the change to the tick length immediately
> > +	 */
> 
> the comment-layout police will get ya.
> 
> > +	tick_length += tick_length_base - old_tick_length_base;
> >  }
> >  
> >  static void ntp_update_offset(long offset)
> 
> The patch adds new trailing whitespace.  checkpatch whines.

Ah. Sorry, thanks for catching that.
-john


