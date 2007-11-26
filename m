Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbXKZVCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbXKZVCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbXKZVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:02:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40248 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbXKZVCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:02:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: freeze vs freezer
Date: Mon, 26 Nov 2007 22:20:16 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4744FD87.7010301@goop.org> <200711240047.21624.rjw@sisk.pl> <474B1404.8020800@goop.org>
In-Reply-To: <474B1404.8020800@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200711262220.16941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 of November 2007, Jeremy Fitzhardinge wrote:
> Rafael J. Wysocki wrote:
> > On Thursday, 22 of November 2007, Jeremy Fitzhardinge wrote:
> >   
> >> It seems that a process blocked in a write to an xfs filesystem due to
> >> xfs_freeze cannot be frozen by the freezer.
> >>     
> >
> > The freezer doesn't handle tasks in TASK_UNINTERRUPTIBLE and I don't know how
> > to make it handle them without at least partially defeating its purpose.
> >   
> 
> Well, I guess the question is whether an xfs-frozen writer really needs
> to be UNINTERRUPTIBLE from the freezer's perspective (clearly it does
> from usermode's perspective - filesystem writes just don't return EINTR).
> 
> From a quick poke around, it looks to me like freezing is actually
> implemented in the VFS layer rather than in XFS itself: is that right? 

I don't know the details.

> Could vfs_check_frozen() be changed to something that is freezer-compatible?

That seems doable in principle.  I'll have a closer look at it.

> >> I see this if I suspend my laptop while doing something xfs-filesystem
> >> intensive, like a kernel build.  My suspend scripts freeze the XFS
> >> filesystem (as Dave said I should), which presumably blocks some writer,
> >> and then the freezer times out and fails to complete.
> >>
> >> Here's part of the process dump the freezer does when it times out:
> >>
> >> cc1           D 00000000     0 18138  18137
> >>        dd5f1e24 00200082 00000002 00000000 ecdeeb00 ecdeec64 c200f280 00000001 
> >>        009c09a0 dd5f1e0c dd5f1e0c 0000000f 00000000 00000000 00000000 dd5f1e74 
> >>        c7beb480 dd5f1e88 dd5f1ea8 c0228d97 e8889540 dd5f1e38 c015b75d dd5f1e44 
> >> Call Trace:
> >>  [<c0228d97>] xfs_write+0xf4/0x6d9
> >>  [<c0226038>] xfs_file_aio_write+0x53/0x5b
> >>  [<c0171c15>] do_sync_write+0xae/0xec
> >>  [<c0172343>] vfs_write+0xa4/0x120
> >>  [<c01728d7>] sys_write+0x3b/0x60
> >>  [<c0106fae>] sysenter_past_esp+0x6b/0xa1
> >>  =======================
> >>
> >>
> >> I haven't looked at how to fix this yet.  I only just worked out why I
> >> was getting suspend failures.
> >>     
> >
> > Well, you can add freezer_do_not_count()/freezer_count() annotations to
> > xfs_write() (and whatever else is blocked as a result of the XFS being frozen).
> >   
> 
> What would be the implications of that?  Would that just prevent
> freezing while there's something blocked there?

The freezer will not wait for this particular task.  Still, the task will have
TIF_FREEZE set, so it will freeze as soon as freezer_count() is reached,
unless the thawing of tasks is carried out first.

If used in the right place, it's reasonably safe, but we need to know what
the right place is.  [That's how we handle vfork(), BTW.]
 
> > Generally, that would be risky without the freezing of XFS, however, because it
> > might leak us filesystem data to a storage device after creating a hibernation
> > image which would result in the filesystem corruption after the resume.
> >
> > Still, if you only suspend to RAM, that should be safe.
> >   
> 
> I specifically added it because I was getting data loss due to crashes
> during suspend/resume problems.  It's been pretty stable lately, but I
> may as well remove the xfs_freeze from my suspend scripts if this is the
> solution.

Not exactly. :-)

> I think the broader issue is that there's no reason in principle why
> something blocked due to xfs-freezing (or vfs freezing) should prevent
> the freezer from completing.

Agreed, but the only way to tell the freezer "don't wait for this task", if the
task in question is in TASK_UNINTERRUPTIBLE, is to annotate it.

Greetings,
Rafael
