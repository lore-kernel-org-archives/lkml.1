Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbXGCHUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbXGCHUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbXGCHUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:20:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:46020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbXGCHUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:20:09 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <200707031608.06348.nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031454.42078.nigel@nigel.suspend2.net>
	 <1183441706.10386.73.camel@localhost.localdomain>
	 <200707031608.06348.nigel@nigel.suspend2.net>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 17:19:44 +1000
Message-Id: <1183447184.10386.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 16:08 +1000, Nigel Cunningham wrote:
> 
> > So I think Matthew is totally right. In fact, the presence of the
> > freezer is the main reason why Paulus so far NACKed Johannes attempts at
> > merging the PPC PM code with the generic code in kernel/power.c
> > 
> > We've been doing fine without it so far and intend to continue to do so.
> 
> Fuse depends on !PPC?

No, that's not what I'm saying. I'm saying we've been doing STR without
the freezer and that's the way to go imho.

> > As for suspend-to-disk, I refer you to the discussions we had in the
> > past with Linus, where he explains I think quite clearly how wrong the
> > current implementation of STR is :-)
> 
> I assume you mean STD.

Oops, yeah, sorry.

> The problem there is that Linus doesn't care about STD. 
> If he did, I dare say he'd think through the issues more thoroughly than he 
> apparently has.

Heh, that might be the case :-)
 
> > Thing is, if you're going to do snapshots, you should probably not sync
> > after you have "frozen" anyway.
> 
> Fully agree. But how do you stop things syncing while you're writing the image 
> if you don't have a freezer or equivalent? (scheduler based, kexec.. they're 
> all workarounds for this issue).

Well, I was saying that in the context of the -current- snapshotting
mechanism which is based on the freezer, then you should not
sys_sync(). 

Some random user or kernel thread doing a sync is not a problem. It will
stop in the middle of sync and resume on wakeup.

The problem is currently because STD -itself- attempts to sync after it
has frozen things.

I think that should be changed. If you want to sync for whatever reason,
(mostly save RAM ?) do it before the freeze. That means you may get new
dirty data in memory that isn't written out by the sync before you
freeze, but that's allright, that data will be in the suspend image
anyway. If you fail to wakeup, that's akin to a normal crash, the user
will only lose the last data written at the time of the suspend and
journaling fs'es should take care of fs metadata integrity.

So to summarize, the plan that makes things work with fuse is:

 - For STR, don't do the freezer thing.

 - For STD, don't sys_sync() after you froze

There might be -other- issues, but that should get you through some of
them at least. Of course, you'll be in trouble if you try to do things
like STD-to-a-file which sits on a fuse FS but there's a limit to
insanity :-)

Cheers,
Ben.

