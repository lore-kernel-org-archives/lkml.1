Return-Path: <linux-kernel-owner+w=401wt.eu-S935257AbYBBUpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935257AbYBBUpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935205AbYBBUp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:45:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40504 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935192AbYBBUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:45:26 -0500
Date: Sat, 2 Feb 2008 20:45:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mhalcrow@us.ibm.com
Subject: Re: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2)
Message-ID: <20080202204513.GO27894@ZenIV.linux.org.uk>
References: <20080126084532.GG27894@ZenIV.linux.org.uk> <200802021845.m12IjF8o014001@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802021845.m12IjF8o014001@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 01:45:15PM -0500, Erez Zadok wrote:
> > You are thinking about non-interesting case.  _Files_ are not much
> > of a problem.  Directory tree is.  The real problems with all unionfs and
> > stacking implementations I've seen so far, all way back to Heidemann et.al.
> > start when topology of the underlying layer changes.
> 
> OK, so if I understand you, your concerns center around the fact that lower
> directories can be moved around (i.e., topology changes), what happens then
> for operations that go through the stackable f/s, and what should users
> expect to see.

Correct.
 
> > If you have clear
> > semantics for unionfs behaviour in presence of such things, by all means,
> > publish it - as far as I know *nobody* had done that; not even on the
> > "what should we see when..." level, nevermind the implementation.
> 
> Since stacking and NFS have some similarities, I first checked w/ the NFS
> people to see what are their semantics in a similar scenario: an NFS client
> could be validating a directory, then issue, say, a ->create; but in
> between, the server could have moved the directory that was validated.  In
> NFS, the ->create operation succeeds, and creates the file in the new
> location of the directory which was validated.
>
> Unionfs's behavior is similar: the newly created file will be successfully
> created in the moved directory.  The only exception is that if a lower
> branch is marked readonly by unionfs, a copyup will take place.

Er...  For unionfs it's a much more monumental problem.  Look - you have
a mapping between the directory trees of layers; everything else is
defined in terms of that mapping ("this files shadows that file", etc.).

If you allow a mix of old and new mappings, you can easily run into the
situations when at some moment X1 covers Y1, X2 covers Y2, X2 is a descendent
of X1 and Y1 is a descendent of Y2.  You *really* don't want to go there -
if nothing else, defining behaviour of copyup in face of that insanity
will be very painful.

What's more, and what makes NFS a bad model, NFS client doesn't lock
directories of NFS server.  unionfs *does* locking of directories in
underlying layers, which means that you have an entirely new set of
constraints - you can deadlock easily.  As the matter of fact, your
current code suffers from that problem - it violates the locking rules
in operations on covered layers.
 
> This had not been a problem for unionfs users to date.  The main reason is
> that when unionfs users modify lower files, they often do so while there's
> little to no activity going through the union itself.  And while it doesn't
> prevent directories from being moved around, this common usage mode does
> reduce the frequency in which topology changes can be an issue for unionfs
> users.

Ugh...  "Currently unionfs users tend to use it ways that do not trigger
fs corruption" is nice, but doesn't really address the "current unionfs
implementation contains races leadint to fs corruption"...

> > around, changing parents, etc.  Cross-directory rename() certainly rates
> > very high on the list of "WTF had they been smoking in UCB?" misfeatures,
> > but it's there and it has to be dealt with.
> 
> Well, it was UCB, UCLA, and Sun.  I don't think back in the early 90s they
> were too concerned about topology changes; f/s stacking was a new idea and
> they wanted to explore what can be done with it conceptually, not produce
> commercial-grade software (still, remind me to tell you the first-hand story
> I've learned about of how full-blown stacking _almost_ made it into Solaris
> 2.0 :-)
 
> The only known reference to try and address this coherency problem was
> Heidemann's SOSP'95 paper titled "Performance of cache coherence in
> stackable filing."  The paper advocated changing the whole VFS and the
> caches (page cache + dnlc) to create a "unified cache manager" that was
> aware of complex layering topologies (including fan-out and fan-in).  It was
> even able to handle compression layers, where file data offsets change b/t
> the layers (a nasty problem).  Code for this unified cache manager was never
> released AFAIK.  I think Heidemann's approach was elegant, but I don't think
> it was practical as it required radical VFS/VM surgery.  Ironically, MS
> Windows has a single I/O cache manager that all storage and filesystem
> modules talk to directly (they're not allowed to pass IRPs directly b/t
> layers): so Windows can handle such coherency better than most Unix systems
> can today.
 
Different problem.  IIRC, that paper implicitly assumed that mapping between
vnodes in different layers would _not_ be subject to massive surgeries from
operations involved.

> However, for this "view" idea to work, I'll need a way to lock-out or hide
> the lower directories from the namespace, so no one can access them in r-w
> mode any longer (if at all).  Moreover, even if such a method was available,
> one would have to decide what to do with any open files on the lower branch
> (killing such processes or closing the descriptors seems somewhat harsh --
> maybe there'd be a way to "promote" them up the stack?)

Keep in mind that the same directory can be seen elsewhere in the same
namespace (let alone the different ones).  The same fs can be seen in
any number of places...
 
> > BTW, and that's a completely unrelated story, I'd rather see whiteouts
> > done directly by filesystems involved - it would simplify the life big
> > way.  How about adding a dir->i_op->whiteout(dir, dentry) and seeing if
> > your variant could be turned into such a method to be used by really
> > piss-poor filesystems?  All UFS-related ones (including ext*) can trivially
> > support whiteouts without any PITA; adding them to tmpfs is also not a big
> > deal and anything that caches inode type in directory entries should be
> > easy to extend in the same way as ext*/ufs...
> 
> I agree that WH is really needed and would certainly help.  I've always felt
> that WH support wasn't technically very challenging, but logistically it was
> going to be a nightmare -- having to coordinate with many
> subsystem/filesystem maintainers over a lengthy period of time, no?  Yo
> talk in more detail about it in person, I wouldn't mind taking a stab at
> this.

For ext* and tmpfs it's a matter of trivial kernel patches (I can do the
entire bunch easily) + coordination with Ted to get feature flag for
ext*/teach e2fsck not to throw up on directory entries with type "whiteout".

> BTW, before such WH support can be useful enough for unionfs, it'll have to
> be supported in ext*, tmpfs, _and_ nfs* (those are the most popular ones in
> use).

NFS is more interesting ;-/  There the fallback to your scheme might be the
best available variant, if it can be converted into nfs_whiteout(dir, dentry)
+ modifications to existing methods...
