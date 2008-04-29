Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbYD2Cfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbYD2Cfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 22:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYD2Cfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 22:35:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56535 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYD2Cfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 22:35:37 -0400
Date: Mon, 28 Apr 2008 20:35:20 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080429023520.GD14990@parisc-linux.org>
References: <20080425170021.GH14990@parisc-linux.org> <20080428051040.GH103491721@sgi.com> <20080428122004.GT14990@parisc-linux.org> <20080429000929.GF108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429000929.GF108924158@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:09:30AM +1000, David Chinner wrote:
> On Mon, Apr 28, 2008 at 06:20:04AM -0600, Matthew Wilcox wrote:
> > Arjan, Ingo and I have been batting around something called a kcounter.
> > I appear to have misplaced the patch right now, but the basic idea is
> > that it returns you a cookie when you down(), which you then have to
> > pass to the up()-equivalent.  This gives you at least some of the
> > assurances you get from mutexes.
> 
> <sigh>
> 
> back to the days of cookies being required for locks. We only just
> removed all the remaining lock cruft left over from Irix that used
> cookies like this. i.e.:
> 
> 	DECL_LOCK_COOKIE(cookie);
> 
> 	cookie = spin_lock(&lock);
> 	.....
> 	spin_unlock(&lock, cookie);
> 
> it's an ugly, ugly API....

Perhaps you can suggest a better one?  Our thought was that you have ...

struct xfs_inode {
	struct kcounter_t i_flock
};

struct foo {
	... other stuff you need for the io ...
	kcounter_cookie_t kct;
}

	int err = kcounter_claim(&ino->i_flock, &foo->kct);
...
	kcounter_release(&ino->i_flock, &foo->kct);

> > Though ... looking at XFS, you have 5 counting semaphores currently:
> > 
> > 1. i_flock
> > 
> > This one seems to be a mutex. 
> 
> No, it's a semaphore. It is the inode flush lock and is held over
> I/O on the inode. It is released in a different context to the
> process that holds it. We use trylock semantics on it all the time
> to determine if we can write the inode to disk.

If you're always using trylock semantics on it, then it's not really a
semaphore, is it?

> > 2. l_flushsema
> > 
> > This seems to be a completion.  ie you're using it to wait for the log
> > to be flushed.
> 
> Yes, that could probably be a completion. I'm assuming that a completion
> can handle several thousand waiting processes, right?

Up to 2 billion.

> > 3. q_flock
> > 
> > Ow.  ow.  My brain hurts.  What are these semantics?
> 
> Same semantics as the i_flock - it's held while flushing the dquot
> to disk and is released by a different thread. Trylocks are used on
> this as well...

... but not just trylocks, right?  There's a sleeping aspect to them
too.

> > 4. b_iodonesema
> > 
> > This should be a completion.  It's used to wait for the io to be
> > complete.
> 
> Yup, that could be done.
> 
> > 5. b_sema
> > 
> > This looks like a mutex, but I think it's released in a different
> > context from the one which acquires it.
> 
> Yup. held across I/O and typically released by a different thread.
> Trylock semantics used as well.

OK.

> > Possibly XFS should be using constructs like wait_on_bit instead of
> > semaphores.  See the implementation of wait_on_buffer for an example.
> 
> That sounds to me like you are saying is "semaphores are going away so
> implement your own semaphore-like thingy using some other construct".
> Right?

I don't want to say that.  People (and I'm *not* referring to XFS here)
manage to abuse semaphores in the most hideous ways.  If we tell them to
use lower-level constructs, they'll make a mess of using those too.  I
think we need to look for patterns in the semaphore users which don't
fit the mutex pattern or the completion pattern and figure out how to
satisfy those users.

> If that's the case, then AFAICT changing to completions and then
> s/semaphore/rw_semaphore/ and using only {down,up}_write() for
> the rest should work, right? Or are rwsem's going to go away, too?

I don't think there are any plans to get rid of rwsems, though the RT
people probably hate rwsems even more than they hate regular semaphores.
The mmap rwsem is a compelling argument ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
