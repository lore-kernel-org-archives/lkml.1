Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXE3VGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXE3VGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbXE3VGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:06:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbXE3VGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:06:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Date: Wed, 30 May 2007 23:11:39 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org> <20070530153740.GA4772@ucw.cz> <200705302244.25927.rjw@sisk.pl>
In-Reply-To: <200705302244.25927.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705302311.40123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 30 May 2007 22:44, Rafael J. Wysocki wrote:
> Hi,
> 
> On Wednesday, 30 May 2007 17:37, Pavel Machek wrote:
> > Hi!
> > 
> > > +Suspend notifiers
> > > +	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
> > > +
> > > +There are some operations that device drivers may want to carry out in their
> > > +.suspend() routines, but shouldn't, because they can cause the hibernation or
> > > +suspend to fail. For example, a driver may want to allocate a substantial amount
> > > +of memory (like 50 MB) in .suspend(), but that shouldn't be done after the
> > > +swsusp's memory shrinker has run.
> > > +
> > > +Also, there may be some operations, that subsystems want to carry out before a
> > > +hibernation/suspend or after a restore/resume, requiring the system to be fully
> > > +functional, so the drivers' .suspend() and .resume() routines are not suitable
> > > +for this purpose.  For example, device drivers may want to upload firmware to
> > > +their devices after a restore from a hibernation image, but they cannot do it by
> > > +calling request_firmware() from their .resume() routines (user land processes
> > > +are frozen at this point).  The solution may be to load the firmware into
> > > +memory before processes are frozen and upload it from there in the .resume()
> > > +routine.  Of course, a hibernation notifier may be used for this purpose.
> > > +
> > > +The subsystems that have such needs can register suspend notifiers that will be
> > > +called upon the following events by the suspend core:
> > > +
> > > +PM_PRE_FREEZE		The system is going to hibernate or suspend, tasks will
> > > +			be frozen immediately
> > 
> > Hmm, looks like bad idea if we are going to remove freezer from
> > suspend...?
> 
> We need PM_PRE_FREEZE anyway and it's a different question whether or not
> it'll be used for suspend (STR) too.
> 
> The timing is not the best one, but so far the freezer is in the suspend code
> path and I need to take this into account.
>  
> > > +PM_POST_THAW		Tasks have just been thawed after a resume or restore
> > > +			from a hibernation image
> > > +
> > > +PM_HIBERNATION_PREPARE	The system is preparing for hibernation.  Tasks have
> > > +			been frozen, memory is going to be freed and devices
> > > +			are going to be suspended.
> > 
> > Is not PRE_FREEZE enough? We can allocate memory for drivers there,
> > too...
> 
> Well, there is a reason for not doing this.  Namely, if the memory if freed on
> PM_POST_HIBERNATION after the image has been created, we can use it for saving
> the image (and speed up the saving).
> 
> Besides, if the freezer is dropped from the suspend code, the notifiers will be
> useful to it anyway IMO, and PRE_FREEZE won't make sense in that case.
> 
> I think the rule should be: If you need to do something _before_ tasks are
> frozen, do it in PM_PRE_FREEZE, but if you can do that after the tasks have
> been frozen, do it on PM_HIBERNATION_PREPARE (or PM_SUSPEND_PREPARE in the
> suspend case).

OTOH, having considered it for a while, I think that for now I can add just
PM_PRE_FREEZE and PM_POST_THAW, as I don't have any user for the other ones.
The other events may be added in the future if need be (along with some users).

I'll post revised patches in a new thread.

Greetings,
Rafael
