Return-Path: <linux-kernel-owner+w=401wt.eu-S966667AbZLHW37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966667AbZLHW37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966200AbZLHW34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:29:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49618 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345AbZLHW3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:29:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Date: Tue, 8 Dec 2009 23:30:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912081643290.3046-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912081643290.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912082330.24843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 December 2009, Alan Stern wrote:
> On Tue, 8 Dec 2009, Linus Torvalds wrote:
> 
> > On Tue, 8 Dec 2009, Alan Stern wrote:
> > > 
> > > That's not the way it should be done.  Linus had children taking their
> > > parents' locks during suspend, which is simple but leads to
> > > difficulties.
> > 
> > No it doesn't. Name them.
> 
> Well, one difficulty.  It arises only because we are contemplating
> having the PM core fire up the async tasks, rather than having the
> drivers' suspend routines launch them (the way your original proposal
> did -- the difficulty does not arise there).
> 
> Suppose A and B are unrelated devices and we need to impose the
> off-tree constraint that A suspends after B.  With children taking
> their parent's lock, the way to prevent A from suspending too soon is
> by having B's suspend routine acquire A's lock.
> 
> But B's suspend routine runs entirely in an async task, because that
> task is started by the PM core and it does the method call.  Hence by
> the time B's suspend routine is called, A may already have begun
> suspending -- it's too late to take A's lock.  To make the locking
> work, B would have to acquire A's lock _before_ B's async task starts.  
> Since the PM core is unaware of the off-tree dependency, there's no
> simple way to make it work.

Do not set async_suspend for B and instead start your own async thread
from its suspend callback.  The parent-children synchronization is done by the
core anyway (at least I'd do it that way), so the only thing you need to worry
about is the extra dependency.
 
> > That just complicates things. Compare to my simple locking scheme I've 
> > quoted several times. 
> 
> It is a little more complicated in that it involves explicitly 
> iterating over children.  But it is simpler in that it can use 
> completions instead of rwsems and it avoids the off-tree dependency 
> problem described above.

I would be slightly more comfortable using completions, but the rwsem-based
approach is fine with me as well.

Rafael
