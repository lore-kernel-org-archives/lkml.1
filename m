Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0BDGCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 01:02:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51392 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab0BDGCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 01:02:41 -0500
Date: Thu, 4 Feb 2010 06:02:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100204060237.GD30031@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
 <20100201231847.GC12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002012018400.3664@localhost.localdomain>
 <20100202050037.GE12882@ZenIV.linux.org.uk>
 <20100202063631.GB6175@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202063631.GB6175@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 05:36:31PM +1100, Nick Piggin wrote:

> I ended up having to use a seqlock to do name comparison without locks
> (and without holding references for that matter, just RCU).  However
> name comparison is obviously a lot more critical because you can't
> ignore races, so you might be able to do something simpler.

Umm...  Your ->d_seq, you mean?  IIRC, that stuff landed too close to
do_filp_open() queue back then *and* had potential headache from hell
with vfsmount side of that business.

I've reread it now.  Comments:
	* mntput() is blocking.  When refcount goes to 0, we get
dput() on root, possibly followed by actual fs shutdown.  Very
much not an RCU fodder, even though most of the calls will be OK.
We can do a variant that would do atomic_dec_and_bail() instead ;-)
I.e. decrement atomically if greater than 1, bail out otherwise.
	* why do you bail out on LOOKUP_PARENT?  For that matter, why
do you do that so late?
	* how does that interact with d_materialise_unique()?  Sure,
you bail out on NFS anyway, but it's still not nice to leave relying just
on that.
	* why can we access dentry->d_inode->i_op contents?  Or dentry->d_op
one, for that matter...

BTW, I'd love to take the entire "last component" part of link_path_walk()
out into a separate function and away from link_path_walk(), leaving
basically just the LOOKUP_PARENT case in there.  Price: trailing symlinks
need to be handled by an iterative loop in do_follow_link().  And
that actually ends up an improvement both in stack depth and in overall
code cleanup.  Nothing like the horrors in do_filp_open(), TYVM (said
horrors had mostly gone away in #untested, BTW, and I'm going to move
that series to for-next shortly).  However, we are still several prereqs
away from link_path_walk() split, so that'll have to wait a bit.  In
any case, LOOKUP_PARENT is very much worth the first-class treatment...
