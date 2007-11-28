Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbXK1Qvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbXK1Qvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 11:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759835AbXK1Qvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 11:51:47 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:62479 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbXK1Qvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 11:51:45 -0500
Date: Wed, 28 Nov 2007 17:51:08 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071128175108.5a370684@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1196267789.3242.87.camel@lov.site>
References: <20071127230252.GB10038@kroah.com>
	<20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
	<1196252582.3242.28.camel@lov.site>
	<20071128164842.70caa396@gondolin.boeblingen.de.ibm.com>
	<1196265468.3242.60.camel@lov.site>
	<20071128171238.1ef5d076@gondolin.boeblingen.de.ibm.com>
	<1196267789.3242.87.camel@lov.site>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 17:36:29 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> 
> On Wed, 2007-11-28 at 17:12 +0100, Cornelia Huck wrote:
> > On Wed, 28 Nov 2007 16:57:48 +0100,
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> > 
> > > On Wed, 2007-11-28 at 16:48 +0100, Cornelia Huck wrote:
> > > > On Wed, 28 Nov 2007 13:23:02 +0100,
> > > > Kay Sievers <kay.sievers@vrfy.org> wrote:
> > > > > On Wed, 2007-11-28 at 12:45 +0100, Cornelia Huck wrote:
> > > > > > On Tue, 27 Nov 2007 15:02:52 -0800, Greg KH <greg@kroah.com> wrote:
> > > 
> > > > > > > The uevent function will be called when the uevent is about to be sent to
> > > > > > > userspace to allow more environment variables to be added to the uevent.
> > > > > > 
> > > > > > It may be helpful to mention which uevents are by default created by
> > > > > > the kobject core (KOBJ_ADD, KOBJ_DEL, KOBJ_MOVE).
> > > > > 
> > > > > I think, we should remove all these default events from the kobject
> > > > > core. We will not be able to manage the timing issues and "raw" kobject
> > > > > users should request the events on their own, when they are finished
> > > > > adding stuff to the kobject. I see currently no way to solve the
> > > > > "attributes created after the event" problem. The new
> > > > > *_create_and_register functions do not allow default attributes to be
> > > > > created, which will just lead to serious trouble when someone wants to
> > > > > use udev to set defaults and such things. We may just want to require an
> > > > > explicit call to send the event?
> > > > 
> > > > There will always be attributes that will show up later (for example,
> > > > after a device is activated). Probably the best approach is to keep the
> > > > default uevents, but have the attribute-adder send another uevent when
> > > > they are done?
> > > 
> > > Uh, that's more an exception where we can't give guarantees because of
> > > very specific hardware setups, and it would be an additional "change"
> > > event. There are valid cases for this, but only a _very_ few.
> > > 
> > > There is absolutely no reason not to do it right with the "add" event,
> > > just because we are too lazy to solve it proper the current code. It's
> > > just so broken by design, what we are doing today. :)
> > 
> > I'm worrying a bit about changes that impact the whole code tree in
> > lots of places. I'd be fine with the device layer doing its uevent
> > manually in device_add() at the very end, though. (This would allow
> > drivers to add attributes in their probe function before the uevent,
> > for example.)

<Looks at device_add() again: It already throws the uevent manually...>

> 
> The driver core does use the split already in most places, I did that
> long ago. There are not too many (~20) users of kobject_register(), and
> it's a pretty straight-forward change to change that to _init, _add,
> _uevent, and get rid of that totally useless "convenience api".
> 
> I think there is no longer any excuse to keep that broken code around,
> and even require to document that it's broken. The whole purpose of the
> uevent is userspace consumption, which just doesn't work correctly with
> the code we offer. The fix is trivial, and should be done now, and we no
> longer need to fiddle around timing issues, just because we are too
> lazy.
> 
> I propose the removal of _all_ funtions that have *register* in their
> name, and always require the following sequence:
>   _init()
>   _add()
>   _uevent(_ADD)
> 
>   _uevent(_REMOVE)
>   _del()
>   _put()
> 
> The _create_and_register() functions would become  _create_ and_add()
> and will need an additional _uevent() call after they populated the
> object.

I'm absolutely fine with doing that at the kobject level (after all,
it's a quite contained change, and the uevent function explicitely
works on a kobject).

For the other _register()/_unregister() functions, it's a different
piece of cake. They are:
- distributed through lot of different code
- at a higher level than kobjects, and kobject_uevent() acts on the
kobject
- usually encapsulating a sequence that wants to be used by almost all
callers, and that includes a uevent

I don't think we want people registering a higher level object and then
wondering why udev doesn't seem to take notice of it.
