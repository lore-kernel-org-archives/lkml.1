Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYCBQW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYCBQW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 11:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYCBQWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 11:22:47 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3400 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753980AbYCBQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 11:22:46 -0500
Date: Sun, 2 Mar 2008 11:22:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <200803021437.31977.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803021018420.9430-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008, Rafael J. Wysocki wrote:

> If new children get registered when the parent is suspended, that's already
> wrong, because the children should have been suspended before.  Think of a case
> when the parent is a bus and the children are devices on it.  In that case, by
> suspending the parent before the children we can make the children
> unresponsive etc. (that would break the PCI PM rules, for one example).

Agreed.  That's why I've been saying all along that once the parent has
been moved to dpm_off, we should either block or fail child
registrations.  Drivers trying to register a child at such times are 
clearly buggy anyway.

What we are really trying to agree on is how the PM core should handle 
child registrations just before and while the parent is suspending.  
Drivers trying to register a child at such times need not be buggy at 
all; they may simply have lost a race.

I agree that the core needs to protect itself, but I also think that
drivers should need minimal changes -- preferably none.  If the core
becomes moderately more complicated as a tradeoff for keeping drivers a
little simpler, then IMO it's a win since there are lots and lots of
drivers but only one PM core.

> I think that the rule "the driver must not register new children after
> ->suspend() has run" is not a good one, because in fact we don't want
> ->suspend() to be called while new children are being registered.

But you do agree that "drivers must not register new children after 
->suspend() has run" is correct, right?  You just don't think it goes 
far enough.

>  IMO, we
> should make the rule that "device registration may fail if it's carried out
> concurrently with the parent's ->suspend() method".  At least, that will tell
> the drivers what to do or avoid.

In doing this you are putting a tremendous extra burden on drivers.  
You force _them_ to handle registration failure caused by an impending
suspend, something the driver has no way to know about beforehand!

In effect, you are trying to take the extra complication my patch adds
to the PM core and instead add that complication to _every_
hotpluggable driver.  This is not a good approach.

> I agree it's not a good idea to hold the locks throughout the entire cycle,
> but that can be overcome if we use an additional variable under
> dev_pm_info (see patch below).

The new patch is no better.  If a driver tries to create a new child
just before its suspend method is called, the registration will fail
with -EBUSY for no reason the driver is aware of.  So now the driver
has to detect the failure (which many drivers don't do!) and figure out
how to retry it later on.

> In fact, drivers _should_ check for device_add() failures and if they don't,
> it's a plain bug.

Of course they should check.  But they shouldn't have to deal with 
failures that need to be retried for no good reason.

In the long run, I still believe the best approach is to tell drivers
beforehand they should stop registering children.  That will make both
of us happy: The PM core can fail all later registration attempts with
no qualms, and drivers won't have to worry about unexpected failures.  

How many subsystems register new children at arbitrary times?  The
earlier we can fix them up, the better.

> Well, I think it's not correct to allow the parent to suspend with active (not
> suspended) children.

And I think it's a bad idea to make drivers responsible for recovering 
from these failures.  Especially since the effort writing that recovery 
code would be better spent in writing "prevent_new_children" and 
"allow_new_children" methods.

>  However, if we make the rule that device_add() may fail
> if it's run concurrently with the parent's ->suspend(), the changes of the
> drivers need not be substantial (they should check for the failures of
> device_add() anyway).

But this is different.  The failures you want to add are things which 
_should_ succeed -- in fact they would succeed if they were delayed 
until after the system wakes back up.

I admit these failures will be very rare, since they depend on a race
with a small window.  Here's a compromise: I'll agree to let these
registrations fail if you'll agree to add "prevent_new_children" and
"allow_new_children" methods along with the new pm_ops patch you and
Alex have prepared.  Then drivers and subsystems can implement the
methods later on, after which they won't have to worry about spurious
registration failures.

The prevent_new_children methods should be called in a separate initial
forward pass through the dpm_active list -- rather like the reverted
lock_all_devices() routine.  Similarly for the allow_new_children 
methods (a final backward pass like unlock_all_devices()).

The PM notifier messages can serve as a "prevent new children" 
announcement to prevent registration of devices with no parent.

> > There must some strange interactions going on.  For instance, what if a
> > device sends a remote wakeup request before the system is fully asleep?
> 
> On the systems I'm talking about there are some devices referred to by the
> ACPI _PTS method, so they must be on line whey this method is being executed.
> Since we don't know a priori what devices they are, we must put all devices on
> line (into the full power state) before executing _PTS.

Um.  Nobody has mentioned this before.  Are you saying that a disk 
drive (for example) which has been spun down and put in a low-power 
runtime-PM state must be spun up again before the system can suspend?

> Below is the current version of the patch for handling device registrations
> in the PM core.  In this version, the new registrations are failed if done too
> late (or too early) and the locks are not held during the entire suspend/resume
> cycle.

Actually you can simplify the whole thing by getting rid of 
dev->power.lock entirely.  Protect the "sleeping" flag by dpm_list_mtx.

You could even change the flag from bool to an enum, with a special
"GONE" state for devices that were unregistered during a system sleep
transition.  Once you do that, the whole thing starts to look a lot
like a simplified version of my patch.

How does this sound?

Alan Stern

