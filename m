Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYLZBoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYLZBoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 20:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYLZBoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 20:44:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50808 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbYLZBoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 20:44:07 -0500
Date: Fri, 26 Dec 2008 01:44:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "C. Scott Ananian" <cscott@laptop.org>
Cc: Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -v4 00/14] fsnotify, dnotify, and inotify
Message-ID: <20081226014401.GT28946@ZenIV.linux.org.uk>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <c6d9bea0812181536p2a3aaeacmbd6af0474279b7b@mail.gmail.com> <1229916126.29604.47.camel@localhost.localdomain> <c6d9bea0812221159h30b0501dm8f48d93e0cb53bfa@mail.gmail.com> <20081222210410.GL28946@ZenIV.linux.org.uk> <c6d9bea0812221508n75f03ebdsff5bcbabe56eae56@mail.gmail.com> <20081222232125.GA25334@infradead.org> <c6d9bea0812251017u6a271fc0j5d26b8bbe3407877@mail.gmail.com> <20081225203302.GS28946@ZenIV.linux.org.uk> <c6d9bea0812251658o4710f761j113fbeec9e5e1c97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d9bea0812251658o4710f761j113fbeec9e5e1c97@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 07:58:23PM -0500, C. Scott Ananian wrote:
> > Indeed - explicit, persistent and wrong.  For current directory of a process
> > we store vfsmount and dentry.  And use those in getcwd() rather than playing
> > hopeless games with inodes.
> 
> Geez.  Please don't treat me as if I can't read source code.
> 
> I suggested a Mach-like iopen mechanism to address some inotify races.
>  In order to show that extreme VFS violence might not be necessary, I
> pointed out that *in some cases* you can derive *some paths* to the
> file from the inode number, using the iget()->i_dentry list.  But
> you've driven me far off-topic.

BTW, XFS open-by-inode implementation is severely broken - try using
it for directories and you'll get all kinds of hell breaking loose.
And that's the only attempt at iopen in Linux.

While we are at it, iget() is not a generic interface - it's strictly
up to specific filesystem whether that sucker will work at all.  Or
what kind of data will have to be required for it to work on given fs,
assuming it will work to start with.

> Let's get back to the problem at hand.   The most obvious problem with
> inotify is the race between mkdir/IN_CREATE and the userspace process

[snip]

> As far as I can tell, none of the existing Linux desktop search tools
> attempt to deal with these races.  (Beagle handles the 'mkdir' race,
> but not the other rename races.)  This is acceptable only if an
> unreliable file index is acceptable.

... and inotify is unreliable by design, or what passes for it anyway.

> Some possible improvements to the situtation (all bad, in various ways
> -- better suggestions wanted!):
> 
>   a) do nothing.  Most developers will ignore the races in inotify out
> of ignorance or complexity, and most applications which use inotify
> will be unreliable as a result.
> 
>   b) use inode numbers rather than path names uniformly, in both
> inotify and the userland search index, along with an iopen() syscall,
> as in Mach.  This decouples path maintenance from indexing.  This was
> discussed in (for example)
> http://www.coda.cs.cmu.edu/maillists/codalist/codalist-1998/0217.html
> by Peter J. Braam and Ted Ts'o, but Al Viro has been objecting to the
> idea here.  (If all you need to do is open found files after a search,
> you can skip path maintenance entirely.)

	For one thing, opened directory can be fchdir'ed to.  Or passed to
openat() et.al.  For another, go ahead, show me how to implement that
sucker for something like NFS.  Or CIFS.  Or FAT, while we are at it.
Or anything that does have stable numbers identifying fs objects, but where
those numbers are huge.
 
>  c) Pass file descriptors in the notification API from the kernel.
> This solves the races associated with renames before indexing.
> Userland still has to maintain its own copy of all the direntries for
> indexed content, but at least this task is decoupled.  (The proposed
> fanotify API passes file descriptors, but provides no mechanism (yet)
> for path maintenance.)
> 
> d) Do all indexing in the filesystem.  BeOS used this option; in
> Linux-land, this would probably be a thin FUSE shim which layered over
> an existing filesystem.  The shim could grab the appropriate locks to
> manage the races and ensure that the index's path information was
> consistent with the filesystem.

e) start with providing a higher-level description of what you want to
achieve.  While we are at it, is it supposed to be fs-agnostic?  What
kinds of filesystems could in principle be used with that?

So far you've mentioned use of blatantly inadequate tool and far too
low-level description of changes that might possibly make it more
tolerable for unspecified use you have in mind.  I'm sorry, but that's
exactly how a bunch of bad APIs (including inotify) got pushed into the
tree and I would rather not repeat the experience.

Interfaces must make sense.  And "we need <list of things> for our project,
nevermind what are they for, here's what we would like to see" is a recipe
for kludges.  Inotify, dnotify, F_SETLEASE, etc.  Sigh...
