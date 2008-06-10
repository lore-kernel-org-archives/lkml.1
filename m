Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYFJGnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYFJGnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 02:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYFJGnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 02:43:41 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38854 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbYFJGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 02:43:39 -0400
X-Sasl-enc: blhu6D8bD1mFSt4Q1TvxdxLUYPdTIWsduj1F3aS+uHye 1213080217
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <484E1F20.4060804@krogh.cc>
References: <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <1212513189.3025.101.camel@raven.themaw.net>
	 <20080603173029.GD28946@ZenIV.linux.org.uk>
	 <x49ej7ejtry.fsf@segfault.boston.devel.redhat.com>
	 <20080603191859.GG28946@ZenIV.linux.org.uk>
	 <x49abi2jnwf.fsf@segfault.boston.devel.redhat.com>
	 <20080603230026.GH28946@ZenIV.linux.org.uk>
	 <1212547323.3146.45.camel@raven.themaw.net>
	 <1213073861.3024.34.camel@raven.themaw.net>  <484E1F20.4060804@krogh.cc>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 14:40:10 +0800
Message-Id: <1213080010.3024.42.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-10 at 08:28 +0200, Jesper Krogh wrote:
> Ian Kent wrote:
> > On Wed, 2008-06-04 at 10:42 +0800, Ian Kent wrote:
> >> On Wed, 2008-06-04 at 00:00 +0100, Al Viro wrote:
> >>> On Tue, Jun 03, 2008 at 03:53:36PM -0400, Jeff Moyer wrote:
> >>>
> >>>> autofs4_lookup is called on behalf a process trying to walk into an
> >>>> automounted directory.  That dentry's d_flags is set to
> >>>> DCACHE_AUTOFS_PENDING but not hashed.  A waitqueue entry is created,
> >>>> indexed off of the name of the dentry.  A callout is made to the
> >>>> automount daemon (via autofs4_wait).
> >>>>
> >>>> The daemon looks up the directory name in its configuration.  If it
> >>>> finds a valid map entry, it will then create the directory using
> >>>> sys_mkdir.  The autofs4_lookup call on behalf of the daemon (oz_mode ==
> >>>> 1) will return NULL, and then the mkdir call will be made.  The
> >>>> autofs4_mkdir function then instantiates the dentry which, by the way,
> >>>> is different from the original dentry passed to autofs4_lookup.  (This
> >>>> dentry also does not get the PENDING flag set, which is a bug addressed
> >>>> by a patch set that Ian and I have been working on;  specifically, the
> >>>> idea is to reuse the dentry from the original lookup, but I digress).
> >>>>
> >>>> The daemon then mounts the share on the given directory and issues an
> >>>> ioctl to wakeup the waiter.  When awakened, the waiter clears the
> >>>> DCACHE_AUTOFS_PENDING flag, does another lookup of the name in the
> >>>> dcache and returns that dentry if found.
> >>>> Later, the dentry gets expired via another ioctl.  That path sets
> >>>> the AUTOFS_INF_EXPIRING flag in the d_fsdata associated with the dentry.
> >>>> It then calls out to the daemon to perform the unmount and rmdir.  The
> >>>> rmdir unhashes the dentry (and places it on the rehash list).
> >>>>
> >>>> The dentry is removed from the rehash list if there was a racing expire
> >>>> and mount or if the dentry is released.
> >>>>
> >>>> This description is valid for the tree as it stands today.  Ian and I
> >>>> have been working on fixing some other race conditions which will change
> >>>> the dentry life cycle (for the better, I hope).
> >>> So what happens if new lookup hits between umount and rmdir?
> >> It will wait for the expire to complete and then wait for a mount
> >> request to the daemon.
> > 
> > Actually, that explanation is a bit simple minded.
> > 
> > It should wait for the expire in ->revalidate().
> > Following the expire completion d_invalidate() should return 0, since
> > the dentry is now unhashed, which causes ->revalidate() to return 0.
> > do_lookup() should see this and call a ->lookup().
> > 
> > But maybe I've missed something as I'm seeing a problem now.
> 
> Ok. Ive been running on the patch for a few days now .. and didn't see
> any problems. But that being said, I also turned off the --ghost option
> to autofs so if it actually is the patch or the different codepaths
> being used, I dont know. Since this is a production system, I'm a bit
> reluctant to just change a working setup to test it out.

No need to change anything.

My comment above relates to difficulties I'm having with patches that
I'm working on that follow this one and the specific question that Al
Viro asked "what happens if new lookup hits between umount and rmdir".

But, clearly we need to know if I (autofs4) caused the specific problem
you reported and if the patch resolves it. And that sounds promising
from what you've seen so far.

Ian


