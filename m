Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYD3KVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYD3KVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYD3KVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:21:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49955 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYD3KVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:21:04 -0400
Date: Wed, 30 Apr 2008 04:21:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080430102103.GJ14976@parisc-linux.org>
References: <20080425170021.GH14990@parisc-linux.org> <20080428051040.GH103491721@sgi.com> <20080428122004.GT14990@parisc-linux.org> <20080429000929.GF108924158@sgi.com> <20080429023520.GD14990@parisc-linux.org> <20080429035659.GM108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429035659.GM108924158@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 01:56:59PM +1000, David Chinner wrote:
> On Mon, Apr 28, 2008 at 08:35:20PM -0600, Matthew Wilcox wrote:
> > Perhaps you can suggest a better one?  Our thought was that you have ...
> > 
> > struct xfs_inode {
> > 	struct kcounter_t i_flock
> > };
> > 
> > struct foo {
> > 	... other stuff you need for the io ...
> > 	kcounter_cookie_t kct;
> > }
> 
> You mean:
> 
> struct kcounter_sem {
> 	struct kcounter		cnt;
> 	kcounter_cookie_t	cookie;
> };
> 
> #define down(s)	kcounter_claim(&s->cnt, &s->cookie);
> #define up(s)	kcounter_release(&s->cnt, &s->cookie);
> 
> I can't see how this fixes the semaphore abuse problem at all
> because you can trivially roll your own. We know where that
> leads (i.e. everyone does it their own unique way)...

That would actually work -- if you use it in a mutex way.  It would then
have slightly sloppier semantics than mutexes -- ie you could unlock from
a different context than the one which locked.  But it would whinge if
you try to use it as a completion.

> > 	int err = kcounter_claim(&ino->i_flock, &foo->kct);
> > ...
> > 	kcounter_release(&ino->i_flock, &foo->kct);
> 
> Is there the possibility of errors when taking a counter reference
> in this api? i.e. can the equivalent of "down()" return an error?

My current thinking was not to support an equivalent to down(), only to
down_killable().  On further thought, that may not be wise.

> > If you're always using trylock semantics on it, then it's not really a
> > semaphore, is it?
> 
> I should have been more precise with my description - we use trylock
> semantics on them when we need to gain them in different orders to
> the normal heirachy (which is quite often) or we are operating in
> non-blocking conditions (again quite often). Otherwise we do normal
> sleeping down() calls.

OK.

> > > > Possibly XFS should be using constructs like wait_on_bit instead of
> > > > semaphores.  See the implementation of wait_on_buffer for an example.
> > > 
> > > That sounds to me like you are saying is "semaphores are going away so
> > > implement your own semaphore-like thingy using some other construct".
> > > Right?
> > 
> > I don't want to say that.  People (and I'm *not* referring to XFS here)
> > manage to abuse semaphores in the most hideous ways.
> 
> Yes, I've been following the argume^W discussions wating for an outcome.
> 
> > If we tell them to
> > use lower-level constructs, they'll make a mess of using those too.
> 
> See above ;)
> 
> > I
> > think we need to look for patterns in the semaphore users which don't
> > fit the mutex pattern or the completion pattern and figure out how to
> > satisfy those users.
> 
> Ok, so here's a user that says they need a semaphore-like construct that
> behaves the same way the current semaphores do.  What is the solution?

I think it's kcounters.  The trick is creating an API that's
lockdep-friendly and works for the users.

> > I don't think there are any plans to get rid of rwsems, though the RT
> > people probably hate rwsems even more than they hate regular semaphores.
> 
> Fmeh.
> 
> > The mmap rwsem is a compelling argument ;-)
> 
> It's an argument for a different lock type for that particular case, not
> an argument for removing the lock type completely.

Ah, I meant it's a compelling argument for keeping rwsems.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
