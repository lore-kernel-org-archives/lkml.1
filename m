Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbXGCUWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbXGCUWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXGCUVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:21:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41665 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757054AbXGCUVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:21:54 -0400
Date: Tue, 3 Jul 2007 16:21:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Berg <johannes@sipsolutions.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <1183474748.3722.33.camel@johannes.berg>
Message-ID: <Pine.LNX.4.44L0.0707031609070.7671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Johannes Berg wrote:

> > Runtime suspend isn't a problem.  Only STR.
> 
> Ah but for all those character devices people were saying are the
> problem we haven't even solved runtime suspend as far as I can tell from
> the discussion.

The technique used by USB for runtime PM should work fine with other
devices.  They may not have implemented it yet, but I consider the
matter more-or-less solved.


> > As you can see, this is a very difficult problem to solve.
> 
> Indeed. Actually, one could argue that it's impossible to solve the
> problem as long as we try to call out to userspace during suspend and
> need to wait until that's finished, like in the case of sys_sync() and
> fuse filesystems, and probably other cases. Maybe we should make *those*
> calls return a failure so that the suspend isn't transparent inside the
> kernel but is transparent to userspace.

I disagree.  The problem isn't the kernel calling userspace; it's
userspace trying to do I/O at a time when everything is supposed to be
quiescing.  Detecting that and blocking it in drivers is hard and
error-prone; preventing it by freezing userspace is easy and cheap.

The reasons why the PPC people dislike the whole idea aren't clear to
me.  If it were necessary to have some user task running in order to
carry out the STR then their objection would make sense -- obviously
that task couldn't do its job if it were frozen.  But it isn't
necessary, or at least it should not be.

Userspace will be effectively "frozen" while the system as a whole is 
suspended.  So what's wrong with freezing it a little early?  Despite 
Ben's comments, it seems to me that the freezer doesn't hide problems 
-- it prevents them.

Now people may claim that the freezer implementation itself is buggy.  
I wouldn't dispute it.  But the bugs should be fixable; nobody has 
pointed out anything fundamentally wrong with the idea AFAICT.

Alan Stern

