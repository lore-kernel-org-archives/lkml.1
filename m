Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZLIPtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZLIPtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZLIPtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:49:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54929 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752989AbZLIPtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:49:49 -0500
Date: Wed, 9 Dec 2009 10:49:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
In-Reply-To: <20091209133829.GF9018@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.0912091044340.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Mark Brown wrote:

> On Tue, Dec 08, 2009 at 09:35:59PM -0500, Alan Stern wrote:
> > On Tue, 8 Dec 2009, Linus Torvalds wrote:
> 
> > > It's just that I think the "looping over children" is ugly, when I think 
> > > that by doing it the other way around you can make the code simpler and 
> > > only depend on the PM device list and a simple parent pointer access.
> 
> > I agree that it is uglier.  The only advantage is in handling
> > asynchronous non-tree suspend dependencies, of which we probably won't
> > have very many.  In fact, I don't know of _any_ offhand.
> 
> There's some potential for this in embedded audio - it wants to bring
> down the entire embedded audio subsystem at once before the individual
> devices (and their parents) get suspended since bringing them down out
> of sync can result in audible artifacts.  Depending on the system the
> suspend may take a noticable amount of time so it'd be nice to be able
> to run it asynchronously, though we don't currently do so.

For something like bringing down the entire embedded audio subsystem, 
which isn't directly tied to a single device, you would probably be 
better off doing it when the PM core broadcasts a suspend notification
(see register_pm_notifier() in include/linux/suspend.h).  This occurs 
before any devices are suspended, so synchronization isn't an issue.

> At the minute we get away with this mostly through not being able to
> represent the cases that are likely to actually trip up over it.
> 
> > Interestingly, this non-tree dependency problem does not affect resume.
> 
> Embedded audio does potentially - the resume needs all the individual
> devices in the subsystem and can take a substantial proportion of the
> overall resume time.  Currently we get away with a combination of
> assuming that all the drivers are live when we decide to start resuming
> them and using the ALSA userspace API to deal with bringing the resume
> out of line, but it's not ideal.

You can do the same thing with the resume notifier.

Alan Stern

