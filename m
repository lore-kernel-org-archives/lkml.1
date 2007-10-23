Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbXJWP6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbXJWP6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXJWP57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:57:59 -0400
Received: from ns2.mountaincable.net ([24.215.0.12]:37491 "EHLO
	ns2.mountaincable.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbXJWP57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:57:59 -0400
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
From: Ryan Lortie <desrt@desrt.ca>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Zephaniah E. Hull" <warp@aehallh.com>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
In-Reply-To: <d120d5000710230621j3913384cn37dbab1a764de31c@mail.gmail.com>
References: <20070609084800.GR6362@aehallh.com>
	 <200706120120.00494.dtor@insightbb.com> <20070612052316.GX6362@aehallh.com>
	 <200706120135.06428.dtor@insightbb.com> <20070612054031.GY6362@aehallh.com>
	 <20070702152044.GA24665@suse.cz> <20070703164555.GA20370@aehallh.com>
	 <1191035147.7025.28.camel@moonpix.desrt.ca>
	 <d120d5000710230621j3913384cn37dbab1a764de31c@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 11:57:38 -0400
Message-Id: <1193155059.15426.15.camel@moonpix.desrt.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-23-10 at 09:21 -0400, Dmitry Torokhov wrote:
> Priority/filter idea is different matter. I don't think it is a giood
> solution. There will always be an "arms race", new applications would
> like to get in front of the queue all the time and it will be hard to
> manage. X should just keep console open in raw mode and simply ignore
> all events coming from it while using evdev driver. I understand that
> X's hotplug support is getting there so you should be able to switch
> to pure evdev setup pretty easy.

The only reason that I don't like the numeric priority system is that I
believe it is arbitrary and a bit kludgy.  I don't think an arms race
will be a problem.  We don't have a lot of closed source applications
running as root on Linux and open source projects either choose sane
values or get patched (by users, distributions, etc) or don't get used.

I do believe there needs to be some concept of filtering events in such
a way that they reach some clients but not others -- that's half of the
purpose of this thread.  rfkill wants to be able to see keypresses while
they are kept away from X.  I'd be open to another way of handling this
but I think any other way will necessarily be more complex to use.

As for X using evdev, it still puts you in a position of two pieces of
software being required to know what events have been (conceptually)
"filtered" by various filters running on the system.  ie: the filter
itself needs to know, and also X needs to know so that it can remove
those key events from normal delivery.

So while I agree that the priority numbering is a bit kludgy (and have
no particular affinity to it) I do think that some prioritising system
is required and that pointing out the 'arms race' isn't a good reason to
write the whole idea off.  I'd gladly accept another method.

Note, of course, that the priorities mean nothing unless you actively
switch on filtering.

> >
> >  - how should we decide what gets what priority level?
> >
> 
> Exactly. You can't predict all future uses. There will always be
> someone wanting to get in front of the line.

Two proposals here:

1) Modules like rfkill could have parameters to set priority level.
Presumably, programs hooking in via evdev could also have their priority
configurable.  Leave it up to distributions (or users installing their
own software) to make sure everything is sane.

2) For matters like this, an unsigned int is a large place.  We could
easily use numbers like 10, 100, 1000 while still leaving plenty of room
between them and possibility for expansion on either side.

> Input core now has prper locking. You may take device's event_lock to
> stop event propagation.

noted.

Thanks for the review

Cheers

