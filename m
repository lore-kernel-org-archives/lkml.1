Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZBUVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZBUVPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 16:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZBUVPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 16:15:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60795 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbZBUVPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 16:15:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFD] Automatic suspend
Date: Sat, 21 Feb 2009 22:14:57 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902211135170.7396-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902211135170.7396-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902212214.59660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 February 2009, Alan Stern wrote:
> On Sat, 21 Feb 2009, Rafael J. Wysocki wrote:
> 
> > > I think everything that uses a "trigger" logic from user space is not
> > > a good idea. This will necessary introduce a race between the decision
> > > and the execution during which circumstances can change.
> > 
> > Well, in this particulare case if the circumstances change in the meantime,
> > the kernel will just refuse to suspend.  Also, even if the kernel starts
> > automatic suspend, it _still_ is possible that the conditions change in the
> > meantime (for example, one of the tasks may enter a state in which it wouldn't
> > like to the suspend to happen just after the operation is started and before
> > it's frozen).
> > 
> > > So it seems to me that an allow/disallow system from user space
> > > would be better.
> > 
> > I don't really see the benefit, but I can easily see drawbacks (the handling
> > of graphics that requires user space quirks, for instance).
> 
> This discussion is circling around an important point: How should 
> auto-sleep be initiated?
> 
> If userspace holds any wakelocks then the system mustn't auto-sleep.  
> So auto-sleep can be initiated when the last userspace wakelock is
> released.  That requires calling into the kernel anyway, so it isn't a
> problem.
> 
> But what about kernel wakelocks?  Again, the simplest approach is to 
> initiate an auto-sleep when the last one is released.  But now this 
> depends on how the implementation works.
> 
> In Rafael's scheme there isn't really such a thing as a kernel 
> wakelock.  Instead there are driver methods, so the only way to find 
> out whether auto-sleep is allowed is to poll every driver.  This is not 
> good for systems that want to auto-sleep as soon as possible.

You have a valid point here, although I don't think it would be a problem in
practice (I don't expect the systems using automatic suspend to have that
many drivers).

> A variant on the scheme would use a new field in the dev_pm_info 
> structure.  I don't know if this is better or worse the a new method; 
> it seems likely that the new method would have to work by checking the 
> value of some field anyway.  In any case, it shares the drawback that 
> polling is required.
> 
> If kernel wakelocks were implemented more like refcounts, then
> releasing the last one could immediately initiate an auto-sleep.  The 
> problem with refcounts is that you can't tell (for accounting or 
> debugging purposes) who owns the outstanding references.  However we 
> ought to be able to come up with something intermediate between a 
> full-blown wakelock and a simple refcount that would satisfy everybody.  
> 
> For example, we could use _both_ a new field in dev_pm_info and a 
> refcount.  Or even a per-cpu refcount, to avoid cache-line contention 
> since drivers are likely to acquire and release these things quite 
> often.

Yes, I like this idea.

Automatic suspend will not occur if the refcount is greater than zero and then
the debug/stats code can use the field in dev_pm_info to report who had
increased it.

> What about the overhead of having a permanent kernel thread that does
> nothing but handle auto-sleeps?  This might well be an acceptable
> tradeoff for many people.  Besides, you need something like it if a
> driver wants to release the last wakelock while in interrupt context.  
> Unless you fall back on polling -- and then you need a thread to do the
> polling.

But that may be a user space process.

I generally think that deciding whether to start automatic suspend should
belong to the user space, because it may involve some policies and user
preferences etc.

If you agree with that, there are two possible approaches.  First, there may be
a kernel thread checking periodically if automatic suspend is possible and
initiating it if that's the case.  For this purpose, the user space has to be
able to tell the kernel thread whether it wants automatic suspend to happen
(this is where user space wakelocks are handy).  Second, there may be a user
space process calling the kernel whenever it finds that automatic suspend is
desirable.  I personally prefer the latter, since the user space process can
listen to some events and react to them as soon as they occur (also, it
adheres to the rule of thumb that if something can be implemented in user
space, it better should be left in there ;-)).

In both cases we need to be able to abort an already started automatic suspend
if the conditions change after the decision has been made and I think that
using a per-process flag for that would be efficient, since we have to freeze
the user space anyway, so we need to check some per-task flags for each task.
Still, it may be optimized a bit by using a refcount (that may be the same
refcount as for drivers IMO) that will be increased every time a process sets
its "automatic_suspend_undesirable" flag.  Then, we may export the refcount
via sysfs so that the user space power manager can monitor it and take its
value into account when deciding whether to start automatic suspend.

To summarize, we can:
* Use a refcount such that automatic suspend will only be possible if it's
  equal to zero (but that need not be the only criterion).
* Use a per-device flag in dev_pm_info that will be set whenever the device
  driver increases the refcount and unset whenever the driver decreases the
  refcount.
* Use a per-process flag that will be set whenever the process increases the
  refcount and unset whenever the process decreases the refcount.

Thanks,
Rafael
