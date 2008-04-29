Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYD2D5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYD2D5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYD2D5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:57:23 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35825 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752723AbYD2D5X (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:57:23 -0400
Date: Tue, 29 Apr 2008 13:56:59 +1000
From: David Chinner <dgc@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080429035659.GM108924158@sgi.com>
References: <20080425170021.GH14990@parisc-linux.org> <20080428051040.GH103491721@sgi.com> <20080428122004.GT14990@parisc-linux.org> <20080429000929.GF108924158@sgi.com> <20080429023520.GD14990@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429023520.GD14990@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 08:35:20PM -0600, Matthew Wilcox wrote:
> On Tue, Apr 29, 2008 at 10:09:30AM +1000, David Chinner wrote:
> > On Mon, Apr 28, 2008 at 06:20:04AM -0600, Matthew Wilcox wrote:
> > > Arjan, Ingo and I have been batting around something called a kcounter.
> > > I appear to have misplaced the patch right now, but the basic idea is
> > > that it returns you a cookie when you down(), which you then have to
> > > pass to the up()-equivalent.  This gives you at least some of the
> > > assurances you get from mutexes.
> > 
> > <sigh>
> > 
> > back to the days of cookies being required for locks. We only just
> > removed all the remaining lock cruft left over from Irix that used
> > cookies like this. i.e.:
> > 
> > 	DECL_LOCK_COOKIE(cookie);
> > 
> > 	cookie = spin_lock(&lock);
> > 	.....
> > 	spin_unlock(&lock, cookie);
> > 
> > it's an ugly, ugly API....
> 
> Perhaps you can suggest a better one?  Our thought was that you have ...
> 
> struct xfs_inode {
> 	struct kcounter_t i_flock
> };
> 
> struct foo {
> 	... other stuff you need for the io ...
> 	kcounter_cookie_t kct;
> }

You mean:

struct kcounter_sem {
	struct kcounter		cnt;
	kcounter_cookie_t	cookie;
};

#define down(s)	kcounter_claim(&s->cnt, &s->cookie);
#define up(s)	kcounter_release(&s->cnt, &s->cookie);

I can't see how this fixes the semaphore abuse problem at all
because you can trivially roll your own. We know where that
leads (i.e. everyone does it their own unique way)...

> 	int err = kcounter_claim(&ino->i_flock, &foo->kct);
> ...
> 	kcounter_release(&ino->i_flock, &foo->kct);

Is there the possibility of errors when taking a counter reference
in this api? i.e. can the equivalent of "down()" return an error?

> > > Though ... looking at XFS, you have 5 counting semaphores currently:
> > > 
> > > 1. i_flock
> > > 
> > > This one seems to be a mutex. 
> > 
> > No, it's a semaphore. It is the inode flush lock and is held over
> > I/O on the inode. It is released in a different context to the
> > process that holds it. We use trylock semantics on it all the time
> > to determine if we can write the inode to disk.
> 
> If you're always using trylock semantics on it, then it's not really a
> semaphore, is it?

I should have been more precise with my description - we use trylock
semantics on them when we need to gain them in different orders to
the normal heirachy (which is quite often) or we are operating in
non-blocking conditions (again quite often). Otherwise we do normal
sleeping down() calls.

> > > 3. q_flock
> > > 
> > > Ow.  ow.  My brain hurts.  What are these semantics?
> > 
> > Same semantics as the i_flock - it's held while flushing the dquot
> > to disk and is released by a different thread. Trylocks are used on
> > this as well...
> 
> ... but not just trylocks, right?  There's a sleeping aspect to them
> too.

*nod*

> > > Possibly XFS should be using constructs like wait_on_bit instead of
> > > semaphores.  See the implementation of wait_on_buffer for an example.
> > 
> > That sounds to me like you are saying is "semaphores are going away so
> > implement your own semaphore-like thingy using some other construct".
> > Right?
> 
> I don't want to say that.  People (and I'm *not* referring to XFS here)
> manage to abuse semaphores in the most hideous ways.

Yes, I've been following the argume^W discussions wating for an outcome.

> If we tell them to
> use lower-level constructs, they'll make a mess of using those too.

See above ;)

> I
> think we need to look for patterns in the semaphore users which don't
> fit the mutex pattern or the completion pattern and figure out how to
> satisfy those users.

Ok, so here's a user that says they need a semaphore-like construct that
behaves the same way the current semaphores do.  What is the solution?

> > If that's the case, then AFAICT changing to completions and then
> > s/semaphore/rw_semaphore/ and using only {down,up}_write() for
> > the rest should work, right? Or are rwsem's going to go away, too?
> 
> I don't think there are any plans to get rid of rwsems, though the RT
> people probably hate rwsems even more than they hate regular semaphores.

Fmeh.

> The mmap rwsem is a compelling argument ;-)

It's an argument for a different lock type for that particular case, not
an argument for removing the lock type completely.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
