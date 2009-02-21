Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZBUQwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZBUQwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 11:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZBUQwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 11:52:41 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1655 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751738AbZBUQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 11:52:40 -0500
Date: Sat, 21 Feb 2009 11:52:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>,
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
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <200902210040.50344.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0902211135170.7396-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009, Rafael J. Wysocki wrote:

> > I think everything that uses a "trigger" logic from user space is not
> > a good idea. This will necessary introduce a race between the decision
> > and the execution during which circumstances can change.
> 
> Well, in this particulare case if the circumstances change in the meantime,
> the kernel will just refuse to suspend.  Also, even if the kernel starts
> automatic suspend, it _still_ is possible that the conditions change in the
> meantime (for example, one of the tasks may enter a state in which it wouldn't
> like to the suspend to happen just after the operation is started and before
> it's frozen).
> 
> > So it seems to me that an allow/disallow system from user space
> > would be better.
> 
> I don't really see the benefit, but I can easily see drawbacks (the handling
> of graphics that requires user space quirks, for instance).

This discussion is circling around an important point: How should 
auto-sleep be initiated?

If userspace holds any wakelocks then the system mustn't auto-sleep.  
So auto-sleep can be initiated when the last userspace wakelock is
released.  That requires calling into the kernel anyway, so it isn't a
problem.

But what about kernel wakelocks?  Again, the simplest approach is to 
initiate an auto-sleep when the last one is released.  But now this 
depends on how the implementation works.

In Rafael's scheme there isn't really such a thing as a kernel 
wakelock.  Instead there are driver methods, so the only way to find 
out whether auto-sleep is allowed is to poll every driver.  This is not 
good for systems that want to auto-sleep as soon as possible.

A variant on the scheme would use a new field in the dev_pm_info 
structure.  I don't know if this is better or worse the a new method; 
it seems likely that the new method would have to work by checking the 
value of some field anyway.  In any case, it shares the drawback that 
polling is required.

If kernel wakelocks were implemented more like refcounts, then
releasing the last one could immediately initiate an auto-sleep.  The 
problem with refcounts is that you can't tell (for accounting or 
debugging purposes) who owns the outstanding references.  However we 
ought to be able to come up with something intermediate between a 
full-blown wakelock and a simple refcount that would satisfy everybody.  

For example, we could use _both_ a new field in dev_pm_info and a 
refcount.  Or even a per-cpu refcount, to avoid cache-line contention 
since drivers are likely to acquire and release these things quite 
often.

What about the overhead of having a permanent kernel thread that does
nothing but handle auto-sleeps?  This might well be an acceptable
tradeoff for many people.  Besides, you need something like it if a
driver wants to release the last wakelock while in interrupt context.  
Unless you fall back on polling -- and then you need a thread to do the
polling.

Alan Stern

