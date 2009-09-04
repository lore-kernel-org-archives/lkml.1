Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbZIDG6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbZIDG6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZIDG6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:58:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695AbZIDG6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:37 -0400
Message-Id: <20090904065142.114706411@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 04 Sep 2009 16:51:41 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/33] my current vfs scalability patch queue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Had a bit of time to work on my vfs scalability patches. Since last time: made
some bugfixes, scaled mntget/mntput with per-cpu counter and vfsmount brlock,
and worked on inode cache scalability. This last one is the most interesting...
with my last posting I had got as far as breaking the locks into constituent
parts, but they remained mostly global locks.

- I have now made per-bucket hash lock like the dcache (it still needs to be
  made into bitlocks to avoid any bloat, but using spinlocks for now helps eg
  with lockdep).

- Made the inode unused lru list into a lazy list like the dcache. This reduces
  acquisitions of the lru/writeback list lock.

- Made inode rcu freed. This can enable further optimisations. But it is quite
  a big change on its own worth noting.

- RCU freed inode enables the sb_inode_list_lock to be avoided in list walkers,
  and therefore allows it to nest within i_lock. This significantly simplifies
  the locking and reduces acquisitions of sb_inode_list_lock.

Some remaining obvious issues:

- Not all filesystems are completely audited, especially when it comes to
  looking at inode/dentry callbacks now done with locks lifted.

- Global dcache_lru lock. This can be made per-zone which will improve
  scalability and enable more efficient targetted reclaim. Needs some of
  my old per-zone reclaim shrinker patches.

- inode sb list lock is limiting global rate of inode creation, inode wb
  list lock is limiting global rate of inode dirtying and writeback.

- Inode writeback list lock tied with inode lru list lock (they use the same
  list head). Could turn them into 2 locks. Then the lru lock can be made
  per-zone. The writeback lock I will wait on Jens' writeback work.

- sb_inode_list_lock can be made per-sb. This is a reasonable step, but not
  good for single-sb scalability. Could perhaps add some per-cpu magazines or
  laziness to reduce some of this locking. Most walkers of this list are
  slowpaths, so it could be split into percpu lists or something.

- inode lru lock could also be made per-zone.

- dentries and inodes are now rcu freed, some (most?) nested trylock loops
  could be removed in favour of taking the correct lock order and then
  re-checking that things haven't changed.

The reason I have had to go on with more changes to locking rather than trying
to get things merged is because it has been difficult to show improvements in
some cases, like for example in the inode cache lock breaking, it first
resulted in actually more global locks for different things so scalability
could be worse in some cases when multiple global locks need to be taken.

But it is now getting to the point where I will need to get some agreement with
the approach.


