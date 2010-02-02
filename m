Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0BBBGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:06:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54502 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab0BBBGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:06:54 -0500
Date: Tue, 2 Feb 2010 01:06:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100202010653.GD12882@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
 <20100201231847.GC12882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201231847.GC12882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:18:47PM +0000, Al Viro wrote:

> Ehh...  RCU will save you from stepping on freed memory, but it still will
> leave the joy of half-updated string with length out of sync with it, etc.
> We probably can get away with that, but we'll have to be a lot more careful
> with the order of updating these suckers in d_move_locked et.al.
> 
> I don't know...  Note that if we end up adding something extra to struct
> dentry, we might as well just add *another* spinlock, taken only under
> ->d_lock and only in two places in dcache.c that change d_name.  That kind
> of thing is trivial to enforce (just grep over the tree once in a while)
> and if it shares the cacheline with d_lock, we shouldn't get any real overhead
> in d_move()/d_materialise_unique().  I'm not particulary fond of that variant,
> but it's at least guaranteed to be devoid of subtleties.
> 
> If RCU folks can come up with a sane suggestions that would be robust and
> wouldn't bloat dentry - sure, I'm all for it.  If not...

As the matter of fact, there's just *one* place that has any business [*]
changing ->d_name contents of dentry that might be visible to somebody
else.  fs/dcache.c::switch_names().

So a very brute-force approach would be to add a new spinlock to dentry and
have switch_names() grab it on dentry and target and drop when we are done,
dname_string() grab it around the call of string() and pull the guts out
through the nose to anyone who as much as mentions that lock outside of
fs/dcache.c:switch_names() and lib/vsprintf.c:dname_string().

Again, I'd love to see something more elegant; this variant won't add any
contention and if we place the lock next to d_lock we won't get any cacheline
bouncing either (we'd just taken ->d_lock on both dentries), but it's
rather ugly way to deal with the problem.  I mean, a spinlock just for the
needs of debugging printks?  Yuck.

BTW, speaking of ->d_lock, dget_parent() is abused in a bunch of places.
I'm going through review of ->d_parent and ->d_name uses; will post
the results when it's done...

[*] there's also !@$#!@#!@# {ncp,smb}_fill_cache() that does change of
letters' case in ->d_name; no locking whatsoever in there, luckily for
that crap the callers hold i_mutex on parent, so they get exclusion with
potential callers of d_move().  Bad Idea All Around(tm), but irrelevant
for our purposes.
