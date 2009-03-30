Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZC3BLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZC3BLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZC3BLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:11:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51065 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZC3BLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:11:08 -0400
Date: Mon, 30 Mar 2009 02:08:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>,
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
Message-ID: <20090330010843.GM28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0903282319270.15432@blonde.anvils> <20090329005343.GA12139@redhat.com> <20090329041022.GF28946@ZenIV.linux.org.uk> <20090329045206.GA15519@redhat.com> <20090329055513.GH28946@ZenIV.linux.org.uk> <20090329060118.GI28946@ZenIV.linux.org.uk> <20090329213635.GA21820@redhat.com> <20090329222022.GJ28946@ZenIV.linux.org.uk> <20090329235639.GA32199@redhat.com> <20090330000338.GB32199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330000338.GB32199@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:03:38AM +0200, Oleg Nesterov wrote:
> On 03/30, Oleg Nesterov wrote:
> >
> > On 03/29, Al Viro wrote:
> > >
> > > On Sun, Mar 29, 2009 at 11:36:35PM +0200, Oleg Nesterov wrote:
> > > > > ... or just do that to fs_struct.  After finding that there's no outside
> > > > > users.  Commenst?
> > > >
> > > > This is even worse. Not only we race with our sub-threads, we race
> > > > with CLONE_FS processes.
> > > >
> > > > We can't mark fs_struct after finding that there's no outside users
> > > > lockless. Because we can't know whether this is "after" or not, we
> > > > can't trust "atomic_read(fs->count) <= n_fs".
> > >
> > > We can lock fs_struct in question, go through the threads, then mark
> > > or bail out.  With cloning a reference to fs_struct protected by the
> > > same lock.
> >
> > Yes, this is what I meant, copy_fs() needs this lock too,
> >
> > > FWIW, I'm not at all sure that we want atomic_t for refcount in that
> > > case...
> >
> > I think you are right, because exit_fs() should take fs->lock as well.
> >
> > But, again. What whould we do when check_unsafe_exec() takes fs->lock
> > and sees that this ->fs is already marked?
> 
> Ah, I am stupid. There is no another process if this flag is set.

So...
	* one can always dereference current->fs
	* nobody can change task->fs for seen-by-scheduler task other than
current (we can, of course, do that for a task we'd just allocated in clone
before anyone else has seen it)
	* all changes of current->fs happen under task_lock *and* excl ->lock
of old value of current->fs.
	* anybody can dereference task->fs while holding task_lock(task)
	* ->lock nests inside task_lock
	* freeing happens only when the last reference is gone *and* all
tasks that used to hold such references has already gone through task_unlock
	* all refcount changes happen under excl ->lock
	* changes of ->root and ->pwd happen under excl ->lock
	* read access to ->root and ->pwd should be done under shared ->lock;
to use the contents past the unlock you need to grab references to path in
question while holding lock
	* cloning a reference is done while holding ->lock shared, fails with
-EAGAIN if fs_struct is marked "under exec"
	* mark in question is set and cleared with ->lock excl.
	* check_unsafe_exec() locks current->fs shared, goes through all
threads comparing their ->fs with our, if the number doesn't match - bail
out.  Otherwise we mark it "under exec".
	* in the end of execve() (failure or success) we clear the mark.
	* all reassignments of task->fs are either to NULL or to new instance
(never seen by anybody) or to &init_fs.
	* task with ->fs == &init_fs may not call execve(); those are kernel
threads and they must get ->fs unshared before they can do anything of that
kind (otherwise we'd have no end of trouble with chdir() done by exec'ed
binary affecting hell knows what else).

Does anybody see any holes in the above?
