Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbXEWOd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbXEWOd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbXEWOdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:33:17 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:59859 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbXEWOdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:33:16 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070523135140.GW4095@ftp.linux.org.uk> (message from Al Viro on
	Wed, 23 May 2007 14:51:40 +0100)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk> <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu> <20070523102437.GS4095@ftp.linux.org.uk> <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu> <20070523113925.GT4095@ftp.linux.org.uk> <20070523121620.GU4095@ftp.linux.org.uk> <E1HqqTC-00023W-00@dorka.pomaz.szeredi.hu> <20070523135140.GW4095@ftp.linux.org.uk>
Message-Id: <E1HqrtF-0002Fb-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 16:32:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 	* invalidation on unlink is still an open problem.
> > > 	* locking in final mntput() doesn't look nice; we probably need
> > > a new refcounting scheme for vfsmounts to make that work.  I have a variant
> > > that might work here (and make life much easier for expiry logics in
> > > automount/shared trees, which is what it had been initially proposed for),
> > 
> > Which variant?  We had that "detached subtrees" thing, is that it?
> 
> Umm...  It is related to detached subtrees, but I'm not sure if it is what
> you are thinking about.

I was thinking of a similar one by Mike Waychison.  It had the problem
of requiring a spinlock for mntget/mntput.  It was also different in
that it did not gradually dissolve detached trees, but kept them as
whole blobs until the last ref went away.

> Short version of the story: new counter (mnt_busy) that would be defined
> in the following way: the number of external references (not due to the
> vfsmount tree structure or from namespace to root) + the number of
> children that have non-zero ->mnt_busy.  And a per-vfsmount flag ("goner").
> 
> The rules for handling ->mnt_busy:
> 	* duplicating external reference: increment m->mnt_busy
> 	* getting from m to child: increment child->mnt_busy, if it went
> from 0 to non-zero - increment m->mnt_busy as well (that's done under
> vfsmount_lock, so we can safely check for zero here).
> 	* getting from m to parent: increment parent->mnt_busy.
> 	* dropping external reference: decrement m->mnt_busy; if it's still
> non-zero, we are done.  If it's zero, we are in for some work (and had
> acquired vfsmount_lock by atomic_dec_and_lock()).  Here's what we do:
> 		* go through ancestors, decrementing ->mnt_busy, until we
> 		  hit the root or get to one with ->mnt_busy staying
> 		  non-zero.
> 		* find the most remote ancestor that has zero ->mnt_busy
> 		  and is marked as goner (might be m itself).
> 		* if no such beast exists, we are done.
> 		* otherwise, detach the subtree rooted in that ancestor
> 		  from its parent (if any) and unhash its root (if hashed).

How will this work with copy_tree() and namespace duplication, which
currently walk the tree with only namespace_sem held?

> 		  Now there is no external references to any vfsmount in that
> 		  subtree.
> 		* now we can kill all vfsmounts in that subtree.
> 	* detaching m from parent: nothing; we trade a busy child of parent
> for new external reference to parent.
> 	* lazy umount: in addition to detaching everything from parents
> and dropping resulting external references to parents, mark everything
> in the subtree as goners.
> 	* normal umount: check ->mnt_busy *and* lack of children, detach,
> mark as goner, drop resulting external reference to parent.
> 	* fun new stuff - umount of intact subtree: detach the subtree from
> parent, do *not* dissolve it, mark everything in subtree as goners.  If
> something we mark as goner is not busy, we can kill it and all its descendents.
> The subtree will be shrinking as its pieces lose external references.
> 	* check for expirability: "we hold an external reference to m and
> m->mnt_busy is 1".  No need to look into children, etc.
> 	* your vfsmounts: simply mark them goners from the very beginning.
>  
> > > but it still doesn't kill the need to deal with invalidation.  And
> > > yes, NFS still needs it (and so do all network filesystems, really).
> > > The question of caching is related to that.
> > 
> > So what's so special about invalidation?  Why not just treat
> > dir-on-file mounts the same as any other ref on the dentry?
> 
> Because of the case of having something mounted in that subtree.  The
> current code doesn't even try to evict such stuff.  NFS *does*, but
> it's not in position to do that decently (not NFS fault, it's just that
> we don't have the data needed for it).
> 
> Note that one problem we used to have back then is gone - namely, per-namespace
> semaphores.  It's a global semaphore now, so we *can* do cross-namespace
> rogering of mount trees without that kind of locking horrors.
> 
> What we really need is "go through dentry subtree, try to evict everything
> we can, for anything that has stuff mounted on it go through all such
> vfsmounts and kick them and all their descendents out".  That's what should
> happen on invalidation.  From generic code, so that NFS wouldn't have to
> bother.
> 
> And _that_ is what we could call from ->unlink() on your inode - would take
> care of submounts.

OK, I'll digest this info.

Miklos
