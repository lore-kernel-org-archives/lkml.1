Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752385AbYLRH1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbYLRH1I (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYLRH0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:26:54 -0500
Received: from viefep14-int.chello.at ([62.179.121.34]:8676 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750753AbYLRH0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:26:53 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
 configfs_depend_item()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Louis Rilling <louis.rilling@kerlabs.com>, Joel.Becker@oracle.com,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        swhiteho@redhat.com
In-Reply-To: <20081217134020.42da55fc.akpm@linux-foundation.org>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com>
	 <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
	 <20081217134020.42da55fc.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 08:26:48 +0100
Message-Id: <1229585208.9487.112.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 13:40 -0800, Andrew Morton wrote:
> On Fri, 12 Dec 2008 16:29:11 +0100
> Louis Rilling <louis.rilling@kerlabs.com> wrote:
> 
> > When attaching default groups (subdirs) of a new group (in mkdir() or
> > in configfs_register()), configfs recursively takes inode's mutexes
> > along the path from the parent of the new group to the default
> > subdirs. This is needed to ensure that the VFS will not race with
> > operations on these sub-dirs. This is safe for the following reasons:
> > 
> > - the VFS allows one to lock first an inode and second one of its
> >   children (The lock subclasses for this pattern are respectively
> >   I_MUTEX_PARENT and I_MUTEX_CHILD);
> > - from this rule any inode path can be recursively locked in
> >   descending order as long as it stays under a single mountpoint and
> >   does not follow symlinks.
> > 
> > Unfortunately lockdep does not know (yet?) how to handle such
> > recursion.
> > 
> > I've tried to use Peter Zijlstra's lock_set_subclass() helper to
> > upgrade i_mutexes from I_MUTEX_CHILD to I_MUTEX_PARENT when we know
> > that we might recursively lock some of their descendant, but this
> > usage does not seem to fit the purpose of lock_set_subclass() because
> > it leads to several i_mutex locked with subclass I_MUTEX_PARENT by
> > the same task.
> > 
> > >From inside configfs it is not possible to serialize those recursive
> > locking with a top-level one, because mkdir() and rmdir() are already
> > called with inodes locked by the VFS. So using some
> > mutex_lock_nest_lock() is not an option.
> > 
> > I am proposing two solutions:
> > 1) one that wraps recursive mutex_lock()s with
> >    lockdep_off()/lockdep_on().
> > 2) (as suggested earlier by Peter Zijlstra) one that puts the
> >    i_mutexes recursively locked in different classes based on their
> >    depth from the top-level config_group created. This
> >    induces an arbitrary limit (MAX_LOCK_DEPTH - 2 == 46) on the
> >    nesting of configfs default groups whenever lockdep is activated
> >    but this limit looks reasonably high. Unfortunately, this alos
> >    isolates VFS operations on configfs default groups from the others
> >    and thus lowers the chances to detect locking issues.
> > 
> > This patch implements solution 1).
> > 
> > Solution 2) looks better from lockdep's point of view, but fails with
> > configfs_depend_item(). This needs to rework the locking
> > scheme of configfs_depend_item() by removing the variable lock recursion
> > depth, and I think that it's doable thanks to the configfs_dirent_lock.
> > For now, let's stick to solution 1).
> > 
> > Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
> > ---
> >  fs/configfs/dir.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 59 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> > index 8e93341..9c23583 100644
> > --- a/fs/configfs/dir.c
> > +++ b/fs/configfs/dir.c
> > @@ -553,12 +553,24 @@ static void detach_groups(struct config_group *group)
> >  
> >  		child = sd->s_dentry;
> >  
> > +		/*
> > +		 * Note: we hide this from lockdep since we have no way
> > +		 * to teach lockdep about recursive
> > +		 * I_MUTEX_PARENT -> I_MUTEX_CHILD patterns along a path
> > +		 * in an inode tree, which are valid as soon as
> > +		 * I_MUTEX_PARENT -> I_MUTEX_CHILD is valid from a
> > +		 * parent inode to one of its children.
> > +		 */
> > +		lockdep_off();
> >  		mutex_lock(&child->d_inode->i_mutex);
> > +		lockdep_on();
> >
> > [etc]
> >
> 
> Oh dear, what an unpleasant patch.
> 
> Peter, can this be saved?

I'm still not sure why configfs is the only virtual filesystem that
suffers this - something in its design is weird (and not so wonderfull).

Also, while I usually applaud fine grained locking, is configfs really
in need of that?, I mean, its not like its meant to create and remove
directories all day every day at breakneck speed, right? AFAIK you just
stomp some data in to configure some kernel stuff and then let it sit
for the duration of whatever that kernel thing does while it does it.

See I'm not even clear on what configfs is.. and why its better than
sysfs for example.. - /me goes read configfs.txt

Right, so basically we avoid syscalls by making vfs ops do stuff..
lovely - still not seeing it though - regular filesystems seems to cope
just fine and they get to create arbitrary tree structures too.

Yes lockdep has 2 major weaknesses - 1) it doesn't support arbitrary
lock depths (and I've tried, twice, to fix that, but its a _hard_
problem) and 2) it can't deal with arbitrary recursion.

The thing is, in practise it turns out that reworking code to not run
into these issues often makes the code better - if only for the fact
that taking locks is expensive and doing less is better, and holding
locks stifles concurrency, so holding less it better (yes, I said
_often_, there likely are counter cases but I don't believe configfs is
one of them).

Anyway - I'm against just turning lockdep off, that will make folks
complacent and let the stuff rot to bits inside - and I for one will
refuse to run anything using it (but since that only seems to be
dlm/ocfs and I'm of the believe that centralized cluster stuff sucks
rocks anyway that won't be a problem).

