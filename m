Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbYD1MUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbYD1MUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764572AbYD1MUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:20:07 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52397 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763424AbYD1MUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:20:06 -0400
Date: Mon, 28 Apr 2008 06:20:04 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080428122004.GT14990@parisc-linux.org>
References: <20080425170021.GH14990@parisc-linux.org> <20080428051040.GH103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428051040.GH103491721@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 03:10:40PM +1000, David Chinner wrote:
> On Fri, Apr 25, 2008 at 11:00:21AM -0600, Matthew Wilcox wrote:
> > 
> > It's been a Good Idea for a while to use mutexes instead of
> > semaphores where possible.  Additional debuggability, better optimised,
> > better-enforced semantics, etc.
> > 
> > Obviously, there are some places that can't be converted to mutexes.
> > I'm not proposing blind changes. 
> 
> Matthew, what's the plan for code using semaphores that cannot be
> easily converted to something else? e.g. XFS?

I'm glad you asked!

Arjan, Ingo and I have been batting around something called a kcounter.
I appear to have misplaced the patch right now, but the basic idea is
that it returns you a cookie when you down(), which you then have to
pass to the up()-equivalent.  This gives you at least some of the
assurances you get from mutexes.

Though ... looking at XFS, you have 5 counting semaphores currently:

1. i_flock

This one seems to be a mutex.  I'd need to immerse myself in XFS for a
couple of days to verify that though -- there's a lot of places that use
it, and it doesn't have obvious lock/unlock pairing.  Is it sometimes
unlocked from a different thread than the one which locked it?  If so,
kcounters might be the right thing to use here.

2. l_flushsema

This seems to be a completion.  ie you're using it to wait for the log
to be flushed.

3. q_flock

Ow.  ow.  My brain hurts.  What are these semantics?

4. b_iodonesema

This should be a completion.  It's used to wait for the io to be
complete.

5. b_sema

This looks like a mutex, but I think it's released in a different
context from the one which acquires it.

-----

Possibly XFS should be using constructs like wait_on_bit instead of
semaphores.  See the implementation of wait_on_buffer for an example.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
