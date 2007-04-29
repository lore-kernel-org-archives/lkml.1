Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbXD2JSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbXD2JSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbXD2JSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:18:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36462 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbXD2JSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 05:18:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Back to the future.
Date: Sun, 29 Apr 2007 11:22:15 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org> <20070429082313.GA1900@elf.ucw.cz>
In-Reply-To: <20070429082313.GA1900@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291122.16616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 10:23, Pavel Machek wrote:
> Hi!
> 
> > > > The freezer has *caused* those deadlocks (eg by stopping threads that were 
> > > > needed for the suspend writeouts to succeed!), not solved them.
> > > 
> > > I can't remember anything like this, but I believe you have a specific test
> > > case in mind.
> > 
> > Ehh.. Why do you thik we _have_ that PF_NOFREEZE thing in the first place?
> > 
> > Rafael, you really don't know what you're talking about, do you?
> > 
> > Just _look_ at them. It's the IO threads etc that shouldn't be frozen, 
> > exactly *because* they do IO. You claim that kernel threads shouldn't do 
> > IO, but that's the point: if you cannot do IO when snapshotting to disk, 
> > here's a damn big clue for you: how do you think that snapshot is going to 
> > get written?
> > 
> > I *guarantee* you that we've had a lot more problems with threads that 
> > should *not* have been frozen than with those hypothetical threads that 
> > you think should have been frozen.
> 
> Well, we had nasty corruption on XFS, caused by thread that was not
> frozen and should be. (While the other case leads "only" to deadlocks,
> so it is easier to debug.)
> 
> The locking point.. when I added freezing to swsusp, I knew very
> little about kernel locking, so I "simply" decided to avoid the
> problem altogether... using the freezer.
> 
> You may be right that locks are not a big problem for the hibernation
> after all; I just do not know.

Still, I think, if a kernel thread is a part of a device driver, then _in_
_principle_ it needs _some_ synchronization with the driver's suspend/freeze
and resume/thaw callbacks.  For example, it's reasonable to assume that the
thread should be quiet between suspend/freeze and resume/thaw.

With the freezing of kernel threads we provide a simple means of such
synchronization: use try_to_freeze() in a suitable place of your kernel thread
and you're done.  [Well, there should be a second part for making the thread
die if the thaw callback doesn't find the device, but that's in the works.]

Without it, there may be race conditions that we are not even aware of and that
may trigger in, say, 1 in 10 suspends or so and I wish you good luck with
debugging such things.

Greetings,
Rafael
