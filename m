Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbYBBSw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbYBBSw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYBBSwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:52:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35565 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYBBSws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:52:48 -0500
Date: Sat, 2 Feb 2008 13:45:15 -0500
Message-Id: <200802021845.m12IjF8o014001@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, hch@infradead.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mhalcrow@us.ibm.com
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2) 
In-reply-to: Your message of "Sat, 26 Jan 2008 08:45:32 GMT."
             <20080126084532.GG27894@ZenIV.linux.org.uk> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080126084532.GG27894@ZenIV.linux.org.uk>, Al Viro writes:
> On Sat, Jan 26, 2008 at 12:08:30AM -0500, Erez Zadok wrote:

[concerns about lower directories moving around...]

> You are thinking about non-interesting case.  _Files_ are not much
> of a problem.  Directory tree is.  The real problems with all unionfs and
> stacking implementations I've seen so far, all way back to Heidemann et.al.
> start when topology of the underlying layer changes.

OK, so if I understand you, your concerns center around the fact that lower
directories can be moved around (i.e., topology changes), what happens then
for operations that go through the stackable f/s, and what should users
expect to see.

> If you have clear
> semantics for unionfs behaviour in presence of such things, by all means,
> publish it - as far as I know *nobody* had done that; not even on the
> "what should we see when..." level, nevermind the implementation.

Since stacking and NFS have some similarities, I first checked w/ the NFS
people to see what are their semantics in a similar scenario: an NFS client
could be validating a directory, then issue, say, a ->create; but in
between, the server could have moved the directory that was validated.  In
NFS, the ->create operation succeeds, and creates the file in the new
location of the directory which was validated.

Unionfs's behavior is similar: the newly created file will be successfully
created in the moved directory.  The only exception is that if a lower
branch is marked readonly by unionfs, a copyup will take place.

This had not been a problem for unionfs users to date.  The main reason is
that when unionfs users modify lower files, they often do so while there's
little to no activity going through the union itself.  And while it doesn't
prevent directories from being moved around, this common usage mode does
reduce the frequency in which topology changes can be an issue for unionfs
users.

I'll submit a patch to document this behavior.

> > Perhaps this general topic is a good one to discuss at more length at LSF?
> > Suggestions are welcome.
> 
> It would; I honestly do not know if the problem is solvable with the
> (lack of) constraints you apparently want.  Again, the real PITA begins
> when you start dealing with pieces of underlying trees getting moved
> around, changing parents, etc.  Cross-directory rename() certainly rates
> very high on the list of "WTF had they been smoking in UCB?" misfeatures,
> but it's there and it has to be dealt with.

Well, it was UCB, UCLA, and Sun.  I don't think back in the early 90s they
were too concerned about topology changes; f/s stacking was a new idea and
they wanted to explore what can be done with it conceptually, not produce
commercial-grade software (still, remind me to tell you the first-hand story
I've learned about of how full-blown stacking _almost_ made it into Solaris
2.0 :-)

The only known reference to try and address this coherency problem was
Heidemann's SOSP'95 paper titled "Performance of cache coherence in
stackable filing."  The paper advocated changing the whole VFS and the
caches (page cache + dnlc) to create a "unified cache manager" that was
aware of complex layering topologies (including fan-out and fan-in).  It was
even able to handle compression layers, where file data offsets change b/t
the layers (a nasty problem).  Code for this unified cache manager was never
released AFAIK.  I think Heidemann's approach was elegant, but I don't think
it was practical as it required radical VFS/VM surgery.  Ironically, MS
Windows has a single I/O cache manager that all storage and filesystem
modules talk to directly (they're not allowed to pass IRPs directly b/t
layers): so Windows can handle such coherency better than most Unix systems
can today.

I've always thought of a different way to allow users to write to lower
branches -- through the union.  This is similar to what an old AT&T
unioning-like file system named "3DFS" did.  3DFS introduced a new directory
called "..." so if you cd to /mntpt/... then you got to the next level down
the stack (as if you popped the top one and now you see how the union looks
like without the top layer).  And if you "cd /mntpt/.../..." then you see
the view without the top two layers, etc.

So my idea is similar: to introduce virtual directory views that restrict
access to a single lower branch within the union.  So if someone does a "cd
/mnt/unionfs/.1" then they get access to branch 1; "cd /mnt/unionfs/.2" gets
access to branch 2; etc.  While this technique will waste a few names, it's
probably worth the savings in terms of cache-coherency pains (plus, the
actual virtual directory names can be configurable at mount time to allow
users to choose a non-conflicting dir name).  With this idea, users will be
actually accessing a one-branch union, but all ops and locks will have to go
through the union: no one would be able to modify lower files directly.

However, for this "view" idea to work, I'll need a way to lock-out or hide
the lower directories from the namespace, so no one can access them in r-w
mode any longer (if at all).  Moreover, even if such a method was available,
one would have to decide what to do with any open files on the lower branch
(killing such processes or closing the descriptors seems somewhat harsh --
maybe there'd be a way to "promote" them up the stack?)

> BTW, and that's a completely unrelated story, I'd rather see whiteouts
> done directly by filesystems involved - it would simplify the life big
> way.  How about adding a dir->i_op->whiteout(dir, dentry) and seeing if
> your variant could be turned into such a method to be used by really
> piss-poor filesystems?  All UFS-related ones (including ext*) can trivially
> support whiteouts without any PITA; adding them to tmpfs is also not a big
> deal and anything that caches inode type in directory entries should be
> easy to extend in the same way as ext*/ufs...

I agree that WH is really needed and would certainly help.  I've always felt
that WH support wasn't technically very challenging, but logistically it was
going to be a nightmare -- having to coordinate with many
subsystem/filesystem maintainers over a lengthy period of time, no?  You
seem to be more optimistic that it can be achieved more quickly.  If we can
talk in more detail about it in person, I wouldn't mind taking a stab at
this.

BTW, before such WH support can be useful enough for unionfs, it'll have to
be supported in ext*, tmpfs, _and_ nfs* (those are the most popular ones in
use).

Cheers,
Erez.
