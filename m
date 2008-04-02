Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbYDBVMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbYDBVMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYDBVMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:12:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44503 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbYDBVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:12:24 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080402205450.GO9785@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 2 Apr 2008 21:54:50 +0100)
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
References: <20080402201247.358430231@szeredi.hu> <20080402201321.062856131@szeredi.hu> <20080402205450.GO9785@ZenIV.linux.org.uk>
Message-Id: <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Apr 2008 23:11:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > R/o bind mounts require operations which modify the filesystem to be
> > wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
> > this, so callers won't need to bother, and more importantly, cannot
> > forget!  Call these path_*, analogous to vfs_*.  Where there are no
> > callers of vfs_* left, make them static.
> >
> > This series is a cleanup, as well as fixing several places (mostly in
> > nfsd) where mnt_{want,drop}_write() were missing.
> > 
> > It will also help with merging You Know What(*) security module, which
> > needs to know the path within the namespace, and not just within the
> > filesystem.  These helpers will allow the security hooks to be in a
> > common place, and need not be repeated in all callers.
> 
> Rot.
> 
> Places in nfsd must be fixed, LSM hooks *moved* *to* *callers*.  And
> really, by that point I absolutely do not give a damn for these clowns.
> "Help with merging" implies that they can't be arsed to do _anything_
> with their code.  Just as they could not be arsed to react to any
> comments (including civil ones) in any manner except "wait for a month
> and repost without changes".  Sod them.

Al, calm down.  I've been asked to help with merging this code, and if
there are concerns with it, I'll help fix them.  If you had bad
experience with it in the past, I'm sorry.  But let that not make this
any harder that in need to be.

> And no, "make static where all (two of) current callers have vfsmount"
> is non-starter.  path_...() is (at most) a convenience helper, not a
> fundamental interface - simply because new callers should not be
> forced into inventing a fake vfsmount just to use that.

It is an interface with at least 3 callers at the moment: syscalls,
nfsd and ecryptfs and unionfs in the future. It is an interface
because all external accesses to the filesystem *are* done through the
namespace and not directly on filesystem internals.

Such direct access would be conceivable, but I don't think we should
base the design on theoretically possible uses.  If those uses appear,
we can change the interface to fit that.

This "move everything to callers" thing is wrong because it just
results in bloat and bugs, none of which is desirable in the kernel.

Miklos
