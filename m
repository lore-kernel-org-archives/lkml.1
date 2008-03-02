Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbYCBTNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbYCBTNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYCBTM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:12:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbYCBTM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:12:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Sun, 2 Mar 2008 20:11:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <Pine.LNX.4.44L0.0803021018420.9430-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803021018420.9430-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803022011.50976.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 2 of March 2008, Alan Stern wrote:
> On Sun, 2 Mar 2008, Rafael J. Wysocki wrote:
> 
> > If new children get registered when the parent is suspended, that's already
> > wrong, because the children should have been suspended before.  Think of a case
> > when the parent is a bus and the children are devices on it.  In that case, by
> > suspending the parent before the children we can make the children
> > unresponsive etc. (that would break the PCI PM rules, for one example).
> 
> Agreed.  That's why I've been saying all along that once the parent has
> been moved to dpm_off, we should either block or fail child
> registrations.

That's not enough, though.  As soon as the state of the parent has changed,
it's incorrect to register any new children.  Moving the parent to dpm_off is
only a confirmation of the change of the parent's state.

> Drivers trying to register a child at such times are clearly buggy anyway.

Yes, they are.

> What we are really trying to agree on is how the PM core should handle 
> child registrations just before and while the parent is suspending.  
> Drivers trying to register a child at such times need not be buggy at 
> all; they may simply have lost a race.
> 
> I agree that the core needs to protect itself, but I also think that
> drivers should need minimal changes -- preferably none.  If the core
> becomes moderately more complicated as a tradeoff for keeping drivers a
> little simpler, then IMO it's a win since there are lots and lots of
> drivers but only one PM core.

Would you agree, however, that the driver should be prepared for its
->resume() being called right after ->suspend() and the ->suspend() repeated
immediately after that?  This is not a trivial change too ...

> > I think that the rule "the driver must not register new children after
> > ->suspend() has run" is not a good one, because in fact we don't want
> > ->suspend() to be called while new children are being registered.
> 
> But you do agree that "drivers must not register new children after 
> ->suspend() has run" is correct, right?  You just don't think it goes 
> far enough.

Yes.

> >  IMO, we
> > should make the rule that "device registration may fail if it's carried out
> > concurrently with the parent's ->suspend() method".  At least, that will tell
> > the drivers what to do or avoid.
> 
> In doing this you are putting a tremendous extra burden on drivers.  
> You force _them_ to handle registration failure caused by an impending
> suspend, something the driver has no way to know about beforehand!
> 
> In effect, you are trying to take the extra complication my patch adds
> to the PM core and instead add that complication to _every_
> hotpluggable driver.  This is not a good approach.

As I said above, I think that resuming the parent in case of a concurrent
child registration is not a trivial modification.  It may seem trivial, but
it's not.  In effect, my approach is not much worse than that.

> > I agree it's not a good idea to hold the locks throughout the entire cycle,
> > but that can be overcome if we use an additional variable under
> > dev_pm_info (see patch below).
> 
> The new patch is no better.  If a driver tries to create a new child
> just before its suspend method is called, the registration will fail
> with -EBUSY for no reason the driver is aware of.  So now the driver
> has to detect the failure (which many drivers don't do!) and figure out
> how to retry it later on.

That's correct.  However, if such a child registration happens with the code
we currently have, there will be a problem, so the driver doing that may be
considered as buggy _right_ _now_.  Thus, in fact, we need not worry about
any existing drivers and we may require future drivers to follow the additional
rule.

> > In fact, drivers _should_ check for device_add() failures and if they don't,
> > it's a plain bug.
> 
> Of course they should check.  But they shouldn't have to deal with 
> failures that need to be retried for no good reason.

Arguably, they can avoid that, for example by using notifiers.

> In the long run, I still believe the best approach is to tell drivers
> beforehand they should stop registering children.  That will make both
> of us happy: The PM core can fail all later registration attempts with
> no qualms, and drivers won't have to worry about unexpected failures.  
> 
> How many subsystems register new children at arbitrary times?  The
> earlier we can fix them up, the better.

Agreed.

> > Well, I think it's not correct to allow the parent to suspend with active (not
> > suspended) children.
> 
> And I think it's a bad idea to make drivers responsible for recovering 
> from these failures.  Especially since the effort writing that recovery 
> code would be better spent in writing "prevent_new_children" and 
> "allow_new_children" methods.
> 
> >  However, if we make the rule that device_add() may fail
> > if it's run concurrently with the parent's ->suspend(), the changes of the
> > drivers need not be substantial (they should check for the failures of
> > device_add() anyway).
> 
> But this is different.  The failures you want to add are things which 
> _should_ succeed -- in fact they would succeed if they were delayed 
> until after the system wakes back up.

IMO they are things done at a wrong time.  What we're talking about is a driver
trying to ignore the fact that it may be suspended and do all things as though
that's never going to happen.  In fact, if you use separate threads for the
registration of children etc., you should have implement a notification
mechanism that will let you know when a suspend is going to occur.  Otherwise,
you do things in a racy way and expecting that they'll never fail is just
overoptimistic. :-)

> I admit these failures will be very rare, since they depend on a race
> with a small window.  Here's a compromise: I'll agree to let these
> registrations fail if you'll agree to add "prevent_new_children" and
> "allow_new_children" methods along with the new pm_ops patch you and
> Alex have prepared.  Then drivers and subsystems can implement the
> methods later on, after which they won't have to worry about spurious
> registration failures.

I'm fine with that, although I'd call the new methods ->begin() and ->end() or
something like this, since they may generally be used for other purposes
too.

> The prevent_new_children methods should be called in a separate initial
> forward pass through the dpm_active list -- rather like the reverted
> lock_all_devices() routine.  Similarly for the allow_new_children 
> methods (a final backward pass like unlock_all_devices()).

Agreed.
 
> The PM notifier messages can serve as a "prevent new children" 
> announcement to prevent registration of devices with no parent.
> 
> > > There must some strange interactions going on.  For instance, what if a
> > > device sends a remote wakeup request before the system is fully asleep?
> > 
> > On the systems I'm talking about there are some devices referred to by the
> > ACPI _PTS method, so they must be on line whey this method is being executed.
> > Since we don't know a priori what devices they are, we must put all devices on
> > line (into the full power state) before executing _PTS.

Well, "must" is too strong here ...

> Um.  Nobody has mentioned this before.  Are you saying that a disk 
> drive (for example) which has been spun down and put in a low-power 
> runtime-PM state must be spun up again before the system can suspend?

On the systems in question (some NVidia chipsets for K8) USB controllers have
to be in the full power state before executing _PTS.

IMO these systems are just badly designed and we can blacklist or something
 like this.  It also is against the ACPI 2.0 spec, although it's compliant
with ACPI 1.0 .

> > Below is the current version of the patch for handling device registrations
> > in the PM core.  In this version, the new registrations are failed if done too
> > late (or too early) and the locks are not held during the entire suspend/resume
> > cycle.
> 
> Actually you can simplify the whole thing by getting rid of 
> dev->power.lock entirely.  Protect the "sleeping" flag by dpm_list_mtx.

Then, if a child registration occurs while suspend_device(parent) is being
run, dpm_active will be in a wrong order, unless suspend_device(parent) returns
an error (which, BTW, also imposes a new rule on drivers).
 
> You could even change the flag from bool to an enum, with a special
> "GONE" state for devices that were unregistered during a system sleep
> transition.

I'm not sure the "GONE" state willl really be necessary.

> Once you do that, the whole thing starts to look a lot like a simplified
> version of my patch. 
> 
> How does this sound?

Well, we can add new callbacks for notifying drivers of an impending suspend.
In that case, say we add a ->begin() callback for this purpose (in fact that
would be two callbacks, ->suspend_begin() and ->hibernate_begin(), but let's
simplify things a bit for now), so there are the following questions:
* Is it going to return a result?
* If it is, should we fail the suspend if an error is returned?
* In that case, should the ->suspend() callback return a result?
* Perhaps we can require ->suspend() to always succeed after ->begin() has
  succeeded?

OTOH, IMO requiring ->suspend() to return an error if there's been a concurrent
child registration and resuming the device if that happens is not a trivial
change and it may require as many driver modifications as failing the
registration of the child right away.

Thanks,
Rafael
