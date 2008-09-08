Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYIHU2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYIHU2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYIHU2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:28:14 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58237 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbYIHU2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:28:13 -0400
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Parisc List <linux-parisc@vger.kernel.org>
In-Reply-To: <200809081213.37705.david-b@pacbell.net>
References: <1220889205.8074.16.camel@localhost.localdomain>
	 <200809081119.45074.david-b@pacbell.net>
	 <1220899189.8074.58.camel@localhost.localdomain>
	 <200809081213.37705.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 15:28:09 -0500
Message-Id: <1220905689.8074.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 12:13 -0700, David Brownell wrote:
> On Monday 08 September 2008, James Bottomley wrote:
> > On Mon, 2008-09-08 at 11:19 -0700, David Brownell wrote:
> > > On Monday 08 September 2008, James Bottomley wrote:
> > > > Put it back again by making RTC_CLASS 
> > > > unselectable if the architecture is parisc.
> > > 
> > > Easier if those distros just wouldn't select RTC_CLASS then.  :)
> > 
> > Yes, but think of distro config people rather like users ... if you can
> > prevent them from doing something stupid, it's a good idea.  In this
> > case, there's currently no way anyone should ever select RTC_CLASS on
> > parisc, so we should make that clear in the Kconfig file.
> 
> Preventing them from doing stupid stuff is exactly why we
> have Kconfig prevent both legacy *AND* framework RTC code
> from being selected.  :)
> 
> Of course stupidity is infinite, and we didn't know about
> this particular instance in advance...
> 
> 
> > > And long term, better to work with RTC_CLASS.  Eliminate that
> > > crufty asm-parisc/rtc.h file and one more GEN_RTC user; and
> > > share more widely-used infrastructure.
> > > 
> > > If I read things right, that would be easy:  the PARISC RTC is
> > > two firmware calls, ptc_tod_{read,set}(), which would map to
> > > RTC class {read,set}_time() methods of about six lines each.
> > > The RTC framework can do UIE emulation, if needed.
> > 
> > OK, I can look at that, but in the mean time could we make the option
> > that causes the damage unselectable?
> 
> I'd worry if "the mean time" takes too long.  But lacking a
> PARISC laptop to fix this on, I'm unlikely to complain much.

What is the expectation?  If you're expecting all the architectures to
migrate over to RTC_CLASS, actually telling linux-arch and saying why
its a good idea would have been helpful.

All the PDC real time clock calls can do are read and set, nothing else,
so it's idealy suited to the GEN_RTC infrastructure ... what's the
benefit in moving it to RTC_CLASS?

> >	 This is technically a regression 
> > because before your patch GEN_RTC would override RTC_CLASS, now it's the
> > other way around.
> 
> Well, previously there was no override ... I think you mean
> that parisc just completely ignored RTC_CLASS, treating it
> like junk DNA.

No, it's a regression.  You made it so when you added this

#
# These legacy RTC drivers just cause too many conflicts with the
generic
# RTC framework ... let's not even try to coexist any more.
#
if RTC_LIB=n

Around the GEN_RTC configuration.  This turns off the ability to select
GEN_RTC if you've said yes to RTC_CLASS.  Since RTC_CLASS is currently
unsupported on parisc, we need to fix that by making the RTC_CLASS
option unselectable on parisc.

James


