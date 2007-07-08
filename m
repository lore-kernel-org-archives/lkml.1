Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXGHWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXGHWyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXGHWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 18:54:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37473 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbXGHWyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 18:54:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: hibernation/snapshot design [was Re: [PATCH] Remove process freezer from suspend to RAM pathway]
Date: Mon, 9 Jul 2007 01:01:27 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org> <1183931688.3388.316.camel@localhost.localdomain> <20070708221315.GF5401@elf.ucw.cz>
In-Reply-To: <20070708221315.GF5401@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707090101.28832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 9 July 2007 00:13, Pavel Machek wrote:
> Hi!
> 
> > > Actaully, I'm perfectly fine with that, as long as each task blocked by the
> > > driver due to suspend has PF_FROZEN (or something similar) set.  Then, at
> > > least theoretically, we'll be able to drop the freezer from the suspend code
> > > path and move it after device_suspend() (or the hibernation-specific
> > > equivalent) for hibernation (in that case there shouldn't be a problem with
> > > any task waiting on I/O while the freezer is running ;-)).
> > 
> > I don't see the need for a freezer for snapshot but that's a different
> > issue. (stop_machine looks good enough to me).
> 
> Freezer is not needed for snapshot -- it is needed so that we can
> write out the snapshot to disk without the need for special
> drivers/block/simple-ide-for-suspend.c. (We are doing snapshot, then
> write to disk from userland code in uswsusp).

Yes.

BTW, this patch:

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc7/patches/15-freezer-make-kernel-threads-nonfreezable-by-default.patch

that's queued up in -mm contains a freezer documentation update, in which the
reasons of using it, as well as its limitations, are described.

To summarize what was previously said in this thread:

* Apparently, we agree that the freezer is _generally_ not needed for suspend
  (ie. any transition to a system sleep state other than hibernation), but some
  of us (eg. me) think that it wouldn't be reasonable to drop the freezer from
  the suspend code path _right_ _now_ .

* Some of us, including you, Nigel and me, think that the freezer is needed
  for hibernation (please see the document in the patch above for details).
  In the (very) long run this might be avoided too, but (IMO) certainly not at
  this point.

* We seem to agree that in order to remove the freezer from the suspend code
  path some work needs to be done on device drivers, driver midlayers and the
  PM core.  We also need to do some work on the PM core in order to introduce
  a separate hibernation framework and IMO it would be reasonable to
  synchronize these efforts.

* We are now to decide what to do so that the freezer can be safely removed
  from the suspend code path and how to integrate that change with the
  hibernation code path (if possible and reasonable).

* The freezer vs FUSE issue that started this thread remains unresolved, so
  it would be desirable to provide a short-term fix (need not be very nice).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
