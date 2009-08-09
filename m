Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbZHIUtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbZHIUtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 16:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZHIUtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 16:49:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43389 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZHIUtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 16:49:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH update x2] PM: Introduce core framework for run-time PM of I/O devices (rev. 13)
Date: Sun, 9 Aug 2009 22:49:53 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0908091100470.10326-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908091100470.10326-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908092249.53401.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009, Alan Stern wrote:
> On Sun, 9 Aug 2009, Rafael J. Wysocki wrote:
> 
> > > >  How exactly would you like to implement it
> > > > instead?
> > > 
> > > As described above.  The barrier would be equivalent to
> > > pm_runtime_get_noresume followed by pm_runtime_disable except that it
> > > wouldn't actually disable anything.
> > 
> > OK, I can do that, but the only difference between that and the above sequence
> > of three calls will be the possibility to call resume helpers while the
> > "barrier" is in progress.
> 
> Exactly.  In other words, if the driver tries to carry out a resume
> while the barrier is running, the resume won't get lost.  Whereas with 
> the temporarily-disable approach, it _would_ get lost.
> 
> > Allowing runtime PM helpers to be run during system sleep transitions would be
> > problematic IMHO, because the run-time PM 'states' are not well defined at that
> > time.  Consequently, the rules that the PM helpers follow do not really hold
> > during system sleep transitions.
> 
> The workqueue will be frozen, so runtime PM helpers will run only if
> they are invoked more or less directly by the driver (i.e., through
> pm_runtime_resume, ...).  I think we should allow drivers to do what
> they want, especially between the "prepare" and "suspend" stages.

Well, I'm not sure if that's a good idea, but also I have no good techincal
arguments against it at the moment.  And I'm too tired to argue. ;-)

> > Also, in principle the device driver's ->suspend() routine  (the non-runtime
> > one), or even the ->prepare() callback, may notice that the remote wake-up has
> > happened and put the device back into the full power state and return -EBUSY.
> 
> It may.  But then again, it may not -- it may depend on the runtime PM  
> core to make sure that resume requests get forwarded appropriately.
> 
> Furthermore, if you disable runtime PM _before_ calling the prepare 
> method, that leaves a window during which the driver has no reason to 
> realize that anything unusual is going on.
> 
> > Still, we can allow runtime PM requests to be put into the workqueue during
> > system sleep transitions, to be executed after the resume (or in case the
> > suspend fails, that will make the action described in the previous paragraph
> > somewhat easier).  It seems we'd need a separate flag for it, though.
> 
> If every device gets resumed at the end of a system sleep, even the
> ones that were runtime-suspended before the sleep began, then there's
> no reason to preserve requests in the workqueue.  But if
> previously-suspended devices don't get resumed at the end of a system
> sleep, then we should allow requests to remain in the workqueue.

We also should preserve the requests in case the system sleep transition
fails.

> In the end, it's probably safer and easier just to leave the workqueue 
> alone -- freeze and unfreeze it, but don't meddle with its contents.
> 
> The whole question of remote wakeup vs. runtime suspend vs. system 
> sleep is complicated, and people haven't dealt with all the issues yet.

Agreed.
 
> For instance, it seems quite likely that with some devices you would 
> want to enable remote wakeup during runtime suspend but not during 
> system sleep.  We don't have any good way to do this.

Yes, for now we have to assume that any device with wakeup enabled is a
wakeup device.

OK, I'll post the new version of the patch shortly.  Please check if the
barrier mechanism is implemeted and used correctly.

Best,
Rafael
