Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYEERdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYEERdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYEERdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:33:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52259 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYEERdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:33:11 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, weigelt@metux.de, linux-kernel@vger.kernel.org
In-reply-to: <20080505171425.GO5882@ZenIV.linux.org.uk> (message from Al Viro
	on Mon, 5 May 2008 18:14:25 +0100)
Subject: Re: VFS + path walktrough
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk>
Message-Id: <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 05 May 2008 19:33:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One way this could be done cleanly, is to pass the rest of the path
> > (as hint) to the filesystem in its lookup function.  Most filesystems
> > would just ignore it, but those which have the capabilities can use it
> > to do the lookup in one go, and internally cache the result.  The VFS
> > doesn't need to know _anything_ about all this.  If there are
> > mountpoints, they are already cached, so ->lookup() wouldn't be called
> > at all, only ->d_revalidate(), which is a different issue.
> 
> This is still wrong.  We not just pass the pathname to filesystem (note
> that you still need to deal with symlinks),

Symlinks are easy: filesystem just needs to *stop* the resolution the
moment it finds one.

> but we make that filesystem to populate dentry tree.

Doesn't sound hard: d_alloc() + d_instantiate().

>  Take a look at 9P walk - it does *not* give
> you anything resembling stat, you just get qids of intermediates.

Which is exactly what's needed to populate the dentry tree, no?

>  Which
> is bloody useful when you want to do intelligent revalidation (do local
> cached walk, then issue a single protocol request that will both do
> bulk revalidate *and* tell you where in the path you've got the first
> invalid one - just compare qids with what you've got stored locally).
> However, it's just about useless for cutting corners in cold-cache
> lookup.

Sure, it's useful for that as well.

> It _is_ a useful thing, no arguments about that.  However, to use it
> a sane way we need to massage the pathname resolution loop, taking
> the "simple pass without symlinks or mountpoints" part into a new
> helper, turning the current __link_path_walk() into a loop calling that
> one and then folding it into callers.  Would also allow to kill the
> last remnants of recursion in symlink handling for normal fs case...
> 
> _Then_ we can do saner logics for revalidate, allowing it on such segments.
> Which, BTW, would deal with -ESTALE in a saner way, rather than "repeat
> full pathname resolution from the very beginning".  And that's where
> 9P multi-step walk(5) would do very nicely, indeed.

Sounds wonderful.  Really.

> And fuck the "hints" of all kinds, pardon the rudeness.

Don't mind at all.  In fact I usually enjoy it.

>  We already have more than enough of that crap and it already makes
> cleaning the logics up bloody painful.

Separate i_op for it is fine by me as well.

Not that I care very much.  I have plans for such a bulk lookup
interface in fuse, but that's far in the future.

Miklos

