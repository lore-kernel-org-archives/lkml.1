Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326Ab0A2XlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0A2XlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645Ab0A2XlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:41:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60477 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0A2XlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:41:05 -0500
Date: Fri, 29 Jan 2010 23:41:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 06/10] affs: Convert semaphores to mutexes
Message-ID: <20100129234101.GC31305@ZenIV.linux.org.uk>
References: <20100129203549.526478432@linutronix.de>
 <20100129203613.591137914@linutronix.de>
 <20100129223627.GB18752@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129223627.GB18752@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 05:36:27PM -0500, Christoph Hellwig wrote:
> On Fri, Jan 29, 2010 at 08:38:55PM -0000, Thomas Gleixner wrote:
> > These semaphores are plain mutexes. Convert them to struct mutex.
> 
> Looks good.
> 
> > Map affs_[un]lock_dir() to affs_[un]lock_ext() instead of the "#define
> > i_hash_lock i_ext_lock" magic.
> 
> I'm not sure which of the remapping tricks is the worth one..
> 
> Btw, if we don't want lockdep to complain we'll need annotations on
> affs_lock_dir as it's taken both on parent and child.

OK, I've recalled what's going on in there.

AFFS has really crappy layout.  What happens:
	* each file and each directory have on-disk entry that acts more
or less like an inode.
	* when file has N links, there are N-1 additional on-disk entries
with a linked list going through them and primary.
	* directory has a bunch of linked lists going through entries of
directory elements (primaries or add-ons).  Choice of list depends on
entry name (i.e. it's a hash).
	* there's even worse mess we fortunately do not support at all
(hardlinks to directories, years after everyone knew that it can't work).

Now imagine what has to happen on e.g. overwriting cross-directory rename()
when victim happens to be primary with several more links.  Draw the objects
and pointers involved, then draw the changes needed.  No, really - do that.

The worst part of PITA comes from the need to change unrelated (and
unpredictable) directory.  Primary _must_ remain linked from some directory.
So if some links are still around, we must choose some add-on, transplant
the primary in its place in whatever directory list it's on and then free
the orphaned add-on.

So we have two kinds of locks in addition to normal VFS one (i_mutex).
One protects the list of add-ons ("link" lock), another - directory
lists ("hash" lock).  Link lock is taken outside of any hash locks.

lookup and readdir take hash lock on directory.

create, symlink, mkdir and link are identical wrt locking - they take
link lock on object being added to directory, then hash lock on directory
itself.  Only link(2) needs both locks, obviously, but it's really not
worth complicating the common helper.

rmdir and unlink use the same helper; it
	* takes link lock on victim
	* takes hash lock on parent
	* if it's a directory
		* take hash lock on victim
		* check that it's empty
		* drop hash lock on victim
	* evicts the victim from the directory list
	* unlocks parent
	* if the victim is primary and there are extra links
		* grab hash lock on parent of another link [*]
		* transplant the victim into the directory list that used
		  to hold an alias, evicting the alias from it
		* drop hash lock
	* evict victim (or substitute victim) from the link list
	* drop link lock.

rename... is interesting.  First of all, if the target exist, it's killed
off a-la unlink().  Error recovery?  What error recovery?  Then we grab
hash lock on old parent, remove the object from directory list, unlock old
parent, grab hash lock on new parent, put the object into directory list in
new place and unlock new parent.  No error recovery again.  Trying to add
aforementioned error recovery would make locking even more interesting,
of course.

Trying to make the thing reasonably robust in case of a crash... forget
about it.

The bottom line: it is safe to convert to mutex, so ACK on that patch.
As for the lockdep, it should treat emptiness check in affs_remove_header()
as "nested, known to be safe" since we already hold i_mutex on both and
no other operation holds hash lock on more than one inode.

[*] Yes, it does mean bringing it in-core if it hadn't been there already.
Essentially with iget().  Isn't life wonderful?  Good thing we don't have
NFS exports for that wonder of software engineering...
