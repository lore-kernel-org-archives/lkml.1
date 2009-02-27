Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbZB0Xmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbZB0Xmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZB0XmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:42:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50653 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZB0XmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:42:23 -0500
Date: Sat, 28 Feb 2009 00:44:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090227234458.GB2089@elf.ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200902271522.41915.rjw@sisk.pl> <20090227204053.GB1387@ucw.cz> <200902272155.42010.rjw@sisk.pl> <d6200be20902271456w77951afata1d5f378ddbe6b84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20902271456w77951afata1d5f378ddbe6b84@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > > Wakelocks done right are single atomic_t... and if you set it to 0,
> >> > > you just unblock "sleeper" thread or something. Zero polling and very
> >> > > simple...
> >> >
> >> > Except that you have to check all of the wakelocks periodically in a loop =>
> >> > polling.  So?
> >>
> >> No. I want to have single atomic_t for all the wakelocks... at least
> >> in non-debug version. Debug version will be slower. I believe you
> >> originally suggested that.
> >
> > I did, but please don't call it "wakelocks".  It's confusing.
> 
> What you are talking about here is mostly an optimization of the
> wakelock api. You have removed timeout support and made each wakelock
> reference counted. If you ignore wakelocks with timeouts, the current
> wakelock interface can be implemented with a global atomic_t to
> prevent suspend, and a per wakelock atomic_t to prevent a single
> client from changing the global reference count by more than one.

Actually I'd go to global atomic_t to prevent suspend, and make sure
single client only changes it once by design.

> There are a couple of reasons that I have not done this. It removes
> the ability to easily inspect the system when it is not suspending. I
> do provide an option to turn off the wakelock stats, which makes
> wake_lock/unlock significantly faster, but we never run with wakelock
> stats off.

It seems wrong to design for the "debugging" case. ... even if you run
with debugging enabled.

> Also, it pushes timeout handling to the drivers. I know
> may
> of you don't like timeout support, but ignoring the problem is not a
> solution. If each driver that needs timeouts uses its own timer, then
> you will often wakeup from idle just to unlock a wakelock that will
> not trigger suspend. This wakeup is a thousand times as costly on the
> msm platform as a wakelock/unlock pair (with wakelock stats
> enabled).

Well, you are free to have a library (or something) those broken
drivers can use. But you have to understand that those drivers are
broken... and please don't make it part of core API.

It should also make the merging easier; merge non-contraversial parts
first (single atomic_t), then add debugging infrastructure, then maybe
add timeout handling if those drivers can really not be fixed in a
nicer way...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
