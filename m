Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbXGENwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbXGENwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbXGENwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:52:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbXGENwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:52:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 15:59:57 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>, benh@kernel.crashing.org,
       mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707051535.46196.rjw@sisk.pl> <200707052336.27585.nigel@nigel.suspend2.net>
In-Reply-To: <200707052336.27585.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051559.58479.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, 5 July 2007 15:36, Nigel Cunningham wrote:
> Hi.
> 
> On Thursday 05 July 2007 23:35:45 Rafael J. Wysocki wrote:
> > On Thursday, 5 July 2007 14:38, Nigel Cunningham wrote:
> > > On Thursday 05 July 2007 22:25:06 Rafael J. Wysocki wrote:
> > > > On Thursday, 5 July 2007 01:45, Pavel Machek wrote:
> > > > > On Tue 2007-07-03 21:32:20, Oliver Neukum wrote:
> > > > > > Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > > > > > > > And a further question. The freezer is not atomic. What do you 
> do
> > > > > > > > if a task not yet frozen calls sys_sync(), but fuse is already 
> > > frozen?
> > > > > > > 
> > > > > > > What do you do if a task not yet frozen writes to a pipe, on the 
> other
> > > > > > > end of which is a task already frozen?
> > > > > 
> > > > > There's some difference between uninterruptible and interruptible
> > > > > sleep I'd say.
> > > > > 
> > > > > > > It doesn't matter.  The only thing that should matter during 
> suspend
> > > > > > > (not hibernate) is saving the state of devices to ram, and putting 
> the
> > > > > > > devices to sleep.
> > > > > > 
> > > > > > Well, but you did remove sys_sync() from the freezer, which is
> > > > > > and must be called in the hibernate path.
> > > > > 
> > > > > Not "must". In fact, hibernation should be safe without sys_sync(). It
> > > > > is just user un-friendly.
> > > > 
> > > > In fact, I'd like to remove the sys_sync() from the freezer entirely, 
> > > because
> > > > it just doesn't belong in there.
> > > > 
> > > > The only advantege of having sys_sync() in freeze_processes() is that we
> > > > have a chance to write out everything when applications cannot produce 
> more
> > > > data to write, but there are filesystems which don't do that anyway (eg. 
> > > XFS),
> > > > so generally there's no reason to bother.
> > > 
> > > Shouldn't XFS - and fuse - be considered to be broken? Sync should sync 
> data 
> > > and if XFS isn't doing that, it's wrong.
> > > 
> > > In the case of fuse, we should have a mechanism by which fuse processes 
> can be 
> > > made to sync if they do have any pending I/O, and by which they can be 
> frozen 
> > > later than other userspace processes.
> > > 
> > > I'd like to see the sync stay, because it improves reliability and data 
> > > integrity in the fail-to-resume case. Calling scripts would probably 
> invoke 
> > > sync themselves if they don't already, but that's racy. As it is at the 
> > > moment, we know userspace is stopped, so syncing isn't racy.
> > 
> > I'd like to move the sync out of the freezer, but to call it from the
> > suspend/hibernation code, so that we do
> > 
> > sys_sync();
> > error = freeze_processes();
> 
> Yeah, I understand that. The problem then is that you're racing against 
> userspace. That's not usually a problem, but that doesn't mean it's never a 
> problem. Try running the stress suite while testing hibernating and you'll 
> see what I mean. If something is submitting lots of I/O when you try to 
> suspend, your sync call will race against that process if it's not yet 
> frozen, and its continued activity will make your sync pointless (there'll be 
> more unsynced data when you sys_sync call finishes). Stopping userspace 
> before syncing removes that race.

Yes, that will make the suspend/hibernation less reliable in case the resume
fails (some data, written after the sync, may be lost).  However, the sync done
from within the freezer doesn't guarantee that there are no data lost anyway,
so we don't lose much by not doing it.

Now, there's a question how much data may be lost, potentially, if we do the
sync before the freezer and I don't think that's a lot.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
