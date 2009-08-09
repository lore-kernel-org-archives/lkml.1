Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZHINKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZHINKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 09:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZHINKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 09:10:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42505 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbZHINKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 09:10:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH update x2] PM: Introduce core framework for run-time PM of I/O devices (rev. 13)
Date: Sun, 9 Aug 2009 15:10:55 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908082219380.27004-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908082219380.27004-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908091510.55216.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009, Alan Stern wrote:
> On Sat, 8 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > The problem with this is that it calls pm_runtime_disable() at a time 
> > > when the driver is still supposed to be in control of the device.  
> > > Interfering with the driver's legitimate activity in this way is a bad 
> > > thing to do.
> > > 
> > > The difficulty here is that our requirements are a little
> > > contradictory.  We want to prevent all runtime PM callbacks while the
> > > remove method is running, but we also want the remove method to be able
> > > to carry out its own runtime PM activities.
> > > 
> > > So maybe what we really need is more like a barrier.  That is,
> > > something that will do a "get", wait for outstanding callbacks to
> > > finish, carry out a resume if one is pending, and cancel other pending
> > > requests.  This could easily share code with pm_runtime_disable.  We 
> > > should be able to use this for both probe and remove.
> > 
> > Isn't it what's done in rev. 14?
> > 
> > pm_runtime_disable(dev);
> > pm_runtime_get_noresume(dev);
> > pm_runtime_enable(dev);
> > 
> > is exactly a barrier like this.
> 
> It's not exactly the same because it disables runtime PM for a short 
> time.  A barrier never disables runtime PM.
> 
> >  How exactly would you like to implement it
> > instead?
> 
> As described above.  The barrier would be equivalent to
> pm_runtime_get_noresume followed by pm_runtime_disable except that it
> wouldn't actually disable anything.

OK, I can do that, but the only difference between that and the above sequence
of three calls will be the possibility to call resume helpers while the
"barrier" is in progress.

> > > Perhaps this means we don't want to disable runtime PM during system
> > > sleep callbacks, but instead use the "barrier" scheme.
> > 
> > I'm not really sure about that.  I'd rather do what's right now in the patch
> > (well, that's why it's in there) until drivers and bus types start using the
> > runtime PM framework.  If it turns out to be problematic, we'll change it
> > later.
> 
> All right.  Since it involves a race, the problem may not show up for a
> while.

Allowing runtime PM helpers to be run during system sleep transitions would be
problematic IMHO, because the run-time PM 'states' are not well defined at that
time.  Consequently, the rules that the PM helpers follow do not really hold
during system sleep transitions.

Also, in principle the device driver's ->suspend() routine  (the non-runtime
one), or even the ->prepare() callback, may notice that the remote wake-up has
happened and put the device back into the full power state and return -EBUSY.

Still, we can allow runtime PM requests to be put into the workqueue during
system sleep transitions, to be executed after the resume (or in case the
suspend fails, that will make the action described in the previous paragraph
somewhat easier).  It seems we'd need a separate flag for it, though.

Best,
Rafael
