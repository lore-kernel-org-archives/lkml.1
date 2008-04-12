Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYDLONT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYDLONT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 10:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYDLONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 10:13:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37189 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYDLONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 10:13:08 -0400
Date: Sat, 12 Apr 2008 08:12:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [DOC PATCH] semaphore documentation
Message-ID: <20080412141250.GK11962@parisc-linux.org>
References: <20080410143403.c03757e5.akpm@linux-foundation.org> <20080410220816.GY11962@parisc-linux.org> <20080410151907.91f11c74.akpm@linux-foundation.org> <20080411192153.GH11962@parisc-linux.org> <20080411132754.b1c1fd8f.randy.dunlap@oracle.com> <20080411220911.3e7ab3e4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411220911.3e7ab3e4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 10:09:11PM -0700, Andrew Morton wrote:
> On Fri, 11 Apr 2008 13:27:54 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > Looks good to me.  Thanks.
> 
> Yup, most excellent.

Thanks for the review.

> btw, down() and friends should have might_sleep() checks in them, shouldn't
> they?  They don't seem to be in there, nor in mainline
> lib/semaphore-sleepers.c.  Confused.

Mmm.  Ingo gets annoyed when I add additional checks to semaphores -- he
wants them to maintain their current semantics and to get better checking
by migrating more users to mutexes.  I've already exposed at least one
problem (in aacraid) by adding the __must_check to down_interruptible().

As I wrote in one of the comments, we have places in the kernel which
know that even though they're in a non-sleeping context, there is at
least one more token left in the semaphore.  One place this bit me was
in start_kernel().  We disable interrupts and then call lock_kernel()
which calls down().  Since we're in start_kernel(), we know there's
nothing else running and this is perfectly safe.  But a might_sleep()
would warn bogusly.

I'd be open to putting a might_sleep() in __down().  We definitely are
going to sleep at that point, so getting a warning out of it would
be good.  I thought that schedule() would warn itself in that case,
but I can't see the code that would do that now I check.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
