Return-Path: <linux-kernel-owner+w=401wt.eu-S937195AbYD2AJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937195AbYD2AJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbYD2AJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:09:50 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41107 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753854AbYD2AJt (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:09:49 -0400
Date: Tue, 29 Apr 2008 10:09:30 +1000
From: David Chinner <dgc@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080429000929.GF108924158@sgi.com>
References: <20080425170021.GH14990@parisc-linux.org> <20080428051040.GH103491721@sgi.com> <20080428122004.GT14990@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428122004.GT14990@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 06:20:04AM -0600, Matthew Wilcox wrote:
> On Mon, Apr 28, 2008 at 03:10:40PM +1000, David Chinner wrote:
> > On Fri, Apr 25, 2008 at 11:00:21AM -0600, Matthew Wilcox wrote:
> > > 
> > > It's been a Good Idea for a while to use mutexes instead of
> > > semaphores where possible.  Additional debuggability, better optimised,
> > > better-enforced semantics, etc.
> > > 
> > > Obviously, there are some places that can't be converted to mutexes.
> > > I'm not proposing blind changes. 
> > 
> > Matthew, what's the plan for code using semaphores that cannot be
> > easily converted to something else? e.g. XFS?
> 
> I'm glad you asked!
> 
> Arjan, Ingo and I have been batting around something called a kcounter.
> I appear to have misplaced the patch right now, but the basic idea is
> that it returns you a cookie when you down(), which you then have to
> pass to the up()-equivalent.  This gives you at least some of the
> assurances you get from mutexes.

<sigh>

back to the days of cookies being required for locks. We only just
removed all the remaining lock cruft left over from Irix that used
cookies like this. i.e.:

	DECL_LOCK_COOKIE(cookie);

	cookie = spin_lock(&lock);
	.....
	spin_unlock(&lock, cookie);

it's an ugly, ugly API....

> Though ... looking at XFS, you have 5 counting semaphores currently:
> 
> 1. i_flock
> 
> This one seems to be a mutex. 

No, it's a semaphore. It is the inode flush lock and is held over
I/O on the inode. It is released in a different context to the
process that holds it. We use trylock semantics on it all the time
to determine if we can write the inode to disk.

> 2. l_flushsema
> 
> This seems to be a completion.  ie you're using it to wait for the log
> to be flushed.

Yes, that could probably be a completion. I'm assuming that a completion
can handle several thousand waiting processes, right?

> 3. q_flock
> 
> Ow.  ow.  My brain hurts.  What are these semantics?

Same semantics as the i_flock - it's held while flushing the dquot
to disk and is released by a different thread. Trylocks are used on
this as well...

> 4. b_iodonesema
> 
> This should be a completion.  It's used to wait for the io to be
> complete.

Yup, that could be done.

> 5. b_sema
> 
> This looks like a mutex, but I think it's released in a different
> context from the one which acquires it.

Yup. held across I/O and typically released by a different thread.
Trylock semantics used as well.

> Possibly XFS should be using constructs like wait_on_bit instead of
> semaphores.  See the implementation of wait_on_buffer for an example.

That sounds to me like you are saying is "semaphores are going away so
implement your own semaphore-like thingy using some other construct".
Right?

If that's the case, then AFAICT changing to completions and then
s/semaphore/rw_semaphore/ and using only {down,up}_write() for
the rest should work, right? Or are rwsem's going to go away, too?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
