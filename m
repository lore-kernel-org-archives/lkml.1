Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbXK2Hva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbXK2Hva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXK2HvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:51:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:60006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbXK2HvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:51:19 -0500
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20071129060821.GF26327@kroah.com>
References: <20071127230252.GB10038@kroah.com>
	 <20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
	 <1196252582.3242.28.camel@lov.site>
	 <20071128164842.70caa396@gondolin.boeblingen.de.ibm.com>
	 <1196265468.3242.60.camel@lov.site>
	 <20071128171238.1ef5d076@gondolin.boeblingen.de.ibm.com>
	 <1196267789.3242.87.camel@lov.site>
	 <20071128175108.5a370684@gondolin.boeblingen.de.ibm.com>
	 <1196269227.3242.93.camel@lov.site>  <20071129060821.GF26327@kroah.com>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 08:50:31 +0100
Message-Id: <1196322631.3242.198.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18x2f8rdmSlPT23RWFfUauerdnOwIzCjGQVE9l
 mzHJn+N9HsLy0sTKntmmnoAE3aDYTLGuT005VRICoFrYTE+EzI
 xbm4yosKAiSu7gThLUDH3CzXuJZYtqA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 22:08 -0800, Greg KH wrote:
> On Wed, Nov 28, 2007 at 06:00:27PM +0100, Kay Sievers wrote:
> > On Wed, 2007-11-28 at 17:51 +0100, Cornelia Huck wrote:
> > > On Wed, 28 Nov 2007 17:36:29 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > > On Wed, 2007-11-28 at 17:12 +0100, Cornelia Huck wrote:
> > > > > On Wed, 28 Nov 2007 16:57:48 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > > > > On Wed, 2007-11-28 at 16:48 +0100, Cornelia Huck wrote:
> > > > > > > On Wed, 28 Nov 2007 13:23:02 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > > > > > > On Wed, 2007-11-28 at 12:45 +0100, Cornelia Huck wrote:
> > > > > > > > > On Tue, 27 Nov 2007 15:02:52 -0800, Greg KH <greg@kroah.com> wrote:
> > > > > > 
> > > > > > > > > > The uevent function will be called when the uevent is about to be sent to
> > > > > > > > > > userspace to allow more environment variables to be added to the uevent.
> > > > > > > > > 
> > > > > > > > > It may be helpful to mention which uevents are by default created by
> > > > > > > > > the kobject core (KOBJ_ADD, KOBJ_DEL, KOBJ_MOVE).
> > > > > > > > 
> > > > > > > > I think, we should remove all these default events from the kobject
> > > > > > > > core. We will not be able to manage the timing issues and "raw" kobject
> > > > > > > > users should request the events on their own, when they are finished
> > > > > > > > adding stuff to the kobject. I see currently no way to solve the
> > > > > > > > "attributes created after the event" problem. The new
> > > > > > > > *_create_and_register functions do not allow default attributes to be
> > > > > > > > created, which will just lead to serious trouble when someone wants to
> > > > > > > > use udev to set defaults and such things. We may just want to require an
> > > > > > > > explicit call to send the event?
> > > > > > > 
> > > > > > > There will always be attributes that will show up later (for example,
> > > > > > > after a device is activated). Probably the best approach is to keep the
> > > > > > > default uevents, but have the attribute-adder send another uevent when
> > > > > > > they are done?
> > > > > > 
> > > > > > Uh, that's more an exception where we can't give guarantees because of
> > > > > > very specific hardware setups, and it would be an additional "change"
> > > > > > event. There are valid cases for this, but only a _very_ few.
> > > > > > 
> > > > > > There is absolutely no reason not to do it right with the "add" event,
> > > > > > just because we are too lazy to solve it proper the current code. It's
> > > > > > just so broken by design, what we are doing today. :)
> > > > > 
> > > > > I'm worrying a bit about changes that impact the whole code tree in
> > > > > lots of places. I'd be fine with the device layer doing its uevent
> > > > > manually in device_add() at the very end, though. (This would allow
> > > > > drivers to add attributes in their probe function before the uevent,
> > > > > for example.)
> > > 
> > > <Looks at device_add() again: It already throws the uevent manually...>
> > 
> > I think I still remember what I did 2.5 years ago :)
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e57cd73e2e844a3da25cc6b420674c81bbe1b387
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=18c3d5271b472c096adfc856e107c79f6fd30d7d
> > 
> > > > The driver core does use the split already in most places, I did that
> > > > long ago. There are not too many (~20) users of kobject_register(), and
> > > > it's a pretty straight-forward change to change that to _init, _add,
> > > > _uevent, and get rid of that totally useless "convenience api".
> > > > 
> > > > I think there is no longer any excuse to keep that broken code around,
> > > > and even require to document that it's broken. The whole purpose of the
> > > > uevent is userspace consumption, which just doesn't work correctly with
> > > > the code we offer. The fix is trivial, and should be done now, and we no
> > > > longer need to fiddle around timing issues, just because we are too
> > > > lazy.
> > > > 
> > > > I propose the removal of _all_ funtions that have *register* in their
> > > > name, and always require the following sequence:
> > > >   _init()
> > > >   _add()
> > > >   _uevent(_ADD)
> > > > 
> > > >   _uevent(_REMOVE)
> > > >   _del()
> > > >   _put()
> > > > 
> > > > The _create_and_register() functions would become  _create_ and_add()
> > > > and will need an additional _uevent() call after they populated the
> > > > object.
> > > 
> > > I'm absolutely fine with doing that at the kobject level (after all,
> > > it's a quite contained change, and the uevent function explicitely
> > > works on a kobject).
> > > 
> > > For the other _register()/_unregister() functions, it's a different
> > > piece of cake. They are:
> > > - distributed through lot of different code
> > > - at a higher level than kobjects, and kobject_uevent() acts on the
> > > kobject
> > > - usually encapsulating a sequence that wants to be used by almost all
> > > callers, and that includes a uevent
> > > 
> > > I don't think we want people registering a higher level object and then
> > > wondering why udev doesn't seem to take notice of it.
> > 
> > Oh, I'm just talking about lib/kobject.c. And the new kobj/kset stuff we
> > added which is currently in the -mm tree.
> > 
> > It suffers from the same old problem, and even gets documentend as
> > "broken" now. I really think that should be fixed proper instead, and
> > it's the right time to do it now.
> 
> Ok, how should it be fixed?

Accept that the kobject API is that low-level, that we can't have a
proper convenience API - it just does the wrong thing.
Do the same for all other in-kernel users what we did 2.5 years ago for
the driver core, and no longer use the kobject/kset_register()
functions, and let the caller send the events manually when the object
is ready, or removed.

We have ~20 callers of kobject_(un)register(), convert them to
kobject_init() + kobject_add() + kobject_uevent(), and just delete the
broken kobject_(un)register() functions from the kobject code.

Rename the new kobject/kset_create_and_register() to _create_and_add()
and also require the uevent to be sent manually when the caller is ready
with the object.

That way we get rid of a broken API which causes far more problems than
it solves. And we will no longer need to carry this in the example code:
/*
 * Note, these files will be created _after_ the kobject above
 * created.  This can cause userspace to be looking around in sysfs
 * for these files before they are really created.  If you are
 * worried about something like this, perhaps you really need to
 * create your own kset and have a default attribute group for your
 * kobject.
 */

We just get one single API, and we document that the caller needs to
send an event when it has finished populating the object, or deletes the
object.
If we are worrying about users who might forget to send events - I
really prefer missing uevents, which we can simply add, over ones with
the broken timing the current API causes, and failing userspace where
nobody understands what's going wrong at event time. :)

Thanks,
Kay

