Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbYEEROg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbYEEROg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYEERO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:14:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50785 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYEERO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:14:27 -0400
Date: Mon, 5 May 2008 18:14:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: weigelt@metux.de, linux-kernel@vger.kernel.org
Subject: Re: VFS + path walktrough
Message-ID: <20080505171425.GO5882@ZenIV.linux.org.uk>
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 06:43:57PM +0200, Miklos Szeredi wrote:

> One way this could be done cleanly, is to pass the rest of the path
> (as hint) to the filesystem in its lookup function.  Most filesystems
> would just ignore it, but those which have the capabilities can use it
> to do the lookup in one go, and internally cache the result.  The VFS
> doesn't need to know _anything_ about all this.  If there are
> mountpoints, they are already cached, so ->lookup() wouldn't be called
> at all, only ->d_revalidate(), which is a different issue.

This is still wrong.  We not just pass the pathname to filesystem (note
that you still need to deal with symlinks), but we make that filesystem
to populate dentry tree.  Take a look at 9P walk - it does *not* give
you anything resembling stat, you just get qids of intermediates.  Which
is bloody useful when you want to do intelligent revalidation (do local
cached walk, then issue a single protocol request that will both do
bulk revalidate *and* tell you where in the path you've got the first
invalid one - just compare qids with what you've got stored locally).
However, it's just about useless for cutting corners in cold-cache
lookup.

It _is_ a useful thing, no arguments about that.  However, to use it
a sane way we need to massage the pathname resolution loop, taking
the "simple pass without symlinks or mountpoints" part into a new
helper, turning the current __link_path_walk() into a loop calling that
one and then folding it into callers.  Would also allow to kill the
last remnants of recursion in symlink handling for normal fs case...

_Then_ we can do saner logics for revalidate, allowing it on such segments.
Which, BTW, would deal with -ESTALE in a saner way, rather than "repeat
full pathname resolution from the very beginning".  And that's where
9P multi-step walk(5) would do very nicely, indeed.

And fuck the "hints" of all kinds, pardon the rudeness.  We already have
more than enough of that crap and it already makes cleaning the logics
up bloody painful.
