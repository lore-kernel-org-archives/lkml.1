Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZB1WyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZB1WyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZB1WyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:54:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZB1WyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:54:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Sat, 28 Feb 2009 23:53:38 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
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
References: <200902192215.18365.rjw@sisk.pl> <200902281118.14595.rjw@sisk.pl> <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com>
In-Reply-To: <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902282353.39763.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Arve Hjønnevåg wrote:
> On Sat, Feb 28, 2009 at 2:18 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday 27 February 2009, Arve Hjønnevåg wrote:
> >> On Fri, Feb 27, 2009 at 12:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Friday 27 February 2009, Pavel Machek wrote:
> >> >> On Fri 2009-02-27 15:22:39, Rafael J. Wysocki wrote:
> >> >> > On Friday 27 February 2009, Pavel Machek wrote:
> >> >> > > Hi!
> >> >> > >
> >> >> > > > > > Then, the decision making logic will be able to use /sys/power/sleep whenever
> >> >> > > > > > it wishes to and the kernel will be able to refuse to suspend if it's not
> >> >> > > > > > desirable at the moment.
> >> >> > > > > >
> >> >> > > > > > It seems to be flexible enough to me.
> >> >> > > > >
> >> >> > > > > This seems flexible enough to avoid race conditions, but it forces the
> >> >> > > > > user space power manager to poll when the kernel refuse suspend.
> >> >> > > >
> >> >> > > > And if the kernel is supposed to start automatic suspend, it has to monitor
> >> >> > > > all of the wakelocks.  IMO, it's better to allow the power manager to poll the
> >> >> > > > kernel if it refuses to suspend.
> >> >> > >
> >> >> > > polling is evil -- it keeps CPU wake up => wastes power.
> >> >> > >
> >> >> > > Wakelocks done right are single atomic_t... and if you set it to 0,
> >> >> > > you just unblock "sleeper" thread or something. Zero polling and very
> >> >> > > simple...
> >> >> >
> >> >> > Except that you have to check all of the wakelocks periodically in a loop =>
> >> >> > polling.  So?
> >> >>
> >> >> No. I want to have single atomic_t for all the wakelocks... at least
> >> >> in non-debug version. Debug version will be slower. I believe you
> >> >> originally suggested that.
> >> >
> >> > I did, but please don't call it "wakelocks".  It's confusing.
> >>
> >> What you are talking about here is mostly an optimization of the
> >> wakelock api. You have removed timeout support and made each wakelock
> >> reference counted.
> >
> > I also removed the arbitrary number of wakelocks (I really _hate_ the name,
> > can we please stop using it from now on?).
> 
> What do you mean by this? You removed the struct wake_lock?

Basically, yes.

> >> If you ignore wakelocks with timeouts, the current
> >> wakelock interface can be implemented with a global atomic_t to
> >> prevent suspend, and a per wakelock atomic_t to prevent a single
> >> client from changing the global reference count by more than one.
> >>
> >> There are a couple of reasons that I have not done this. It removes
> >> the ability to easily inspect the system when it is not suspending.
> >
> > Care to elaborate?
> 
> If you have a single atomic_t and it is not 0, you do not know who
> incremented it.

That's why it was proposed to use per-process and per-driver flags in addition
to the refcount.

> >> I do provide an option to turn off the wakelock stats, which makes
> >> wake_lock/unlock significantly faster, but we never run with wakelock
> >> stats off. Also, it pushes timeout handling to the drivers. I know may
> >> of you don't like timeout support, but ignoring the problem is not a
> >> solution. If each driver that needs timeouts uses its own timer, then
> >> you will often wakeup from idle just to unlock a wakelock that will
> >> not trigger suspend. This wakeup is a thousand times as costly on the
> >> msm platform as a wakelock/unlock pair (with wakelock stats enabled).
> >
> > Well, at least a couple of people told you that the timeouts are hardly
> > acceptable and they told you why.  Please stop repeating the same arguments you
> > have given already for a couple of times.  They're not convincing.
> 
> And you keep ignoring them.

Not ignoring, but considering them as insufficient.  And since they've already
been considered as insufficient, there's no point repeating them over and over
again.  That doesn't make them any better.

> > Instead of trying to convince everyone to accept your solution that you're
> > not willing to change, please try to listen and think how to do things
> > differently so that everyone is comfortable with them.  I'm sure you're more
> > than capable of doing that.
> 
> Can you summarize what the problems with my current api are? I get the
> impression that you think the overhead of using a list is too high,
> and that timeout support should be removed because you think all
> drivers that use it are broken.

In no particular order:
1. One user space process can create an unlimited number of wakelocks.  This
   shouldn't be possible.  Moreover, it is not even necessary for any process
   to have more than one wakelock held at any time.
2. Timeouts are wrong, because they don't really _solve_ any problem.  They are
   useful for working around the fact that you can't or you don't want to
   modify every piece of code that in principle should take a wakelock and
   that's it.  However,  entire concept of having one code path acting on
   behalf of another one on a hunch that it might be doing something making
   suspend undesirable is conceptually broken IMO.
3. The overhead of using a list is unnecessary and _therefore_ too high (not
   just too high).
4. There seems to be a race between user space wakelocks and the freezer
   (perhaps I overlooked something, in which case please disregard this item).
5. The name "wakelocks" is confusing, because they aren't locks and they
   affect suspend, not wake.
6. Last time I saw the patches they were barely commented and the changelogs
   didn't describe the code well (if at all).
7. There's no clear distinction between debug/stats code and the basic
   functionality.

I'm sure the other people could add something to the list.

> > I do realize that you consider your current solution as the best thing since
> > the sliced bread, but please accept the fact that the other people think
> > differently.
> 
> I certainly do not think my current solution is the best, it is very
> invasive. I do however think your proposed solution is worse. The only
> proposed alternative that we could actually ship a product on today is
> to not use suspend at all.

Well, I'm sure your code is useful for the Android platform, but the question
is whether we want this code in the mainline kernel.  For now, the answer is
"no, we don't".  Moreover, since you're the one who wants the code to be
merged, it's your burden to make it acceptable for us.  However you're going
to do it is up to you, but certainly trying to force your current code on us
is not going to work.

BTW, I think you handled the thing wrong.  If I were you, I wouldn't even try
to push the code as you did.  I would instead make it as simple as reasonably
possible so that the basic idea was clear and understandable to everyone.
Then, if there were any doubts with respect to the basic idea, I'd try to
clarify them and I'd consider modifying the code to address objections.
I'd only try to add more features after the basic idea had been accepted.

Thanks,
Rafael
