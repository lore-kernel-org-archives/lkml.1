Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZC3Ped@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZC3Ped (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZC3PeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:34:21 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:37126 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZC3PeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:34:20 -0400
Date: Mon, 30 Mar 2009 15:32:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
 sometimes doesn't)
In-Reply-To: <20090330123101.GQ28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0903301506310.11454@blonde.anvils>
References: <20090329055513.GH28946@ZenIV.linux.org.uk>
 <20090329060118.GI28946@ZenIV.linux.org.uk> <20090329213635.GA21820@redhat.com>
 <20090329222022.GJ28946@ZenIV.linux.org.uk> <20090329235639.GA32199@redhat.com>
 <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk>
 <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com>
 <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Al Viro wrote:
> On Mon, Mar 30, 2009 at 03:40:40AM +0200, Oleg Nesterov wrote:

Well done, Oleg, for finding this: I wish I'd Cc'ed you earlier.
Shortly before posting my patches, I got very worried by n_fs in
check_unsafe_exec; then fooled myself into thinking it was okay.

> 
> > > We can't proceed. If that another exec() fails, it will clear "under exec" at
> > > the end of do_execve(), before we kill other threads.
> > 
> > Or we need a counter to mark/unmark.
> 
> Nah, easier to have check_unsafe_exec() return -EAGAIN in cases we care
> about.
> 
> Anyway, completely untested patchset is in
> git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ execve-mess
> (the last 9 changesets of it).
> 
> WARNING: that's *NOT* for merge at the moment; this is not a pull request.
> 
> Review (and testing) would be welcome.
> 
> Shortlog of execve-related part:
> Al Viro (6):
>       Take fs_struct handling to new file (fs/fs_struct.c), sanitize chroot_fs_refs()
>       New helper - current_umask()
>       Get rid of indirect include of fs_struct.h
>       Kill unsharing fs_struct in __set_personality()
>       New locking/refcounting for fs_struct
>       check_unsafe_exec() doesn't care about signal handlers sharing
> 
> Hugh Dickins (3):
>       Don't bump fs_struct refcount for procfs accesses
>       compat_do_execve should unshare_files
>       fix setuid sometimes doesn't - files_struct

I'm looking now.  Your description of what you intended sounded good.

First impression is that there's lots of good cleanup in there, but
it's all too mixed up and misordered at present - though we have friends
who insist upon doing the cleanup first (and I usually like to work that
way too), it's going to be tiresome when backporting to 2.6.29.stable
(luckily not needed earlier, unless you've uncovered more on the way).

Note that Linus put the four patches I posted straight into his tree,
so I think you'll want to be working on top of those, whereas you've
currently got them mixed in and modified in your tree.

So, setting aside what's already in, and what's just cleanup, I think
it's just 8c6934e2603283d028ac2292fe8d2812f52f23d3 I should be looking
at, New locking/refcounting for fs_struct - it'd be good for stable if
you worked on just that one to go in on top of Linus's current tree.

One of the cleanups, the one which introduces fs/fs_struct.c,
includes a good-looking but significant change to chroot_fs_refs().
Better make that a separate patch, I couldn't quite tell if it was
something I'd seriously missed from the "setuid sometimes doesn't"
set or not (my belief: yes, I missed it, and it's a good addition;
but frankly, we don't much care what happens if setuid sometimes
gets turned off if a parallel thread about to be killed happens
to be chrooting at the time - that's a much less worrying issue
than what can happen via /proc).

I think your new chroot_fs_refs() should have a path_get(new_root)
just before each path_put(old_root)?

Hugh
