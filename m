Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbXGCUrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbXGCUrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbXGCUrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:47:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46306 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbXGCUrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:47:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 22:54:19 +0200
User-Agent: KMail/1.9.5
Cc: johannes@sipsolutions.net, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org, paulus@samba.org
References: <Pine.LNX.4.44L0.0707031026260.3720-100000@iolanthe.rowland.org> <200707031722.13165.rjw@sisk.pl> <E1I5mKv-0004TM-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I5mKv-0004TM-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032254.20874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 19:38, Miklos Szeredi wrote:
> > > Indeed. Actually, one could argue that it's impossible to solve the
> > > problem as long as we try to call out to userspace during suspend and
> > > need to wait until that's finished, like in the case of sys_sync() and
> > > fuse filesystems, and probably other cases. Maybe we should make *those*
> > > calls return a failure so that the suspend isn't transparent inside the
> > > kernel but is transparent to userspace.
> > 
> > Well, it generally needs more consideration. :-)
> > 
> > I think that we should introduce mechanisms that will allow us to notify all
> > kernel subsystems, including FUSE and similar, that the system is going to
> > enter a sleep state (one of those is the notifier chain introduced recently).
> 
> Ugh, please no.
> 
> Believe me, fuse is doing _nothing_ out of the ordinary, and should
> not need special treatment during suspend/resume.  If suspend itself
> is doing something that triggers fuse activity, then that's a bug,
> such as the sync() thing that started this thread.

Apart from the sync, it shouldn't trigger any fs activity.  Still, some other
task running concurrently with the suspend code may do that and _if_
we are going to allow that to happen (and we do, if we remove the freezer
from the suspend code path), we will have to take that into consideration.

> > Then, they may react to such a notification by entering a "suspend" mode
> > of operation in which they will return errors from some callbacks that
> > otherwise should have succeeded etc.  That depends on the subsystem in
> > question.
> 
> Sounds horrible.
> 
> Why do we need to deal with subsystem interdependencies during
> suspend?  Isn't it about saving device state to ram?

No.  In addition, the devices should be prevented from generating interrupts
or initiating DMA transfers and put into low power states before we actually
suspend the system (platform).  This is a bit difficult to do while all user
space is running.

> That definitely _should not_ need to trigger anything that touches
> filesystems or other subsystems.

Right, but the subsystems may do something that affects devices.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
