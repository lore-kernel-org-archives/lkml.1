Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYHFMHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYHFMHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbYHFMHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:07:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55343 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbYHFMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:07:40 -0400
Date: Wed, 6 Aug 2008 06:07:04 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make kthread_stop() not oops when passed a bad pointer
Message-ID: <20080806120704.GF2055@parisc-linux.org>
References: <20080805135559.GQ26461@parisc-linux.org> <200808061122.59584.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808061122.59584.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 11:22:58AM +1000, Rusty Russell wrote:
> I really do sympathize with your problem; but the quest is to figure out how 
> to identify it before the code is run, not to put a non-orthogonal bandaid 
> here which can hurt other cases.
> 
> How about a more ambitious "we've oopsed so break a mutex every 30 seconds of 
> waiting" patch?

I was considering something more along the lines of "we've oopsed so
find every mutex we own and release it".

> > +?????if (!k || IS_ERR(k))
> > +?????????????return -EINVAL;
> 
> 1) There's no reason that kthread_stop is uniquely difficult to use.  Why pick 
> on that one?

It was the one I hit.

> 2) I know that kfree() handles NULL, but kthread_create/kthread_run never 
> return NULL, unlike kmalloc().

I'd kzalloc'd the memory structure, then rearranged the order of calls
initialising it without rearranging the destructor.

> 3) If we really want to pass a failed kthread_create() through kthread_stop(), 
> we should return PTR_ERR(k) here.  But that should only be done if it made it 
> harder for the callers to screw up, which I don't think it does.

I'm actually really dubious about kthread_stop() returning a value at
all.  To me, returning an error implies that the function failed to do
its job, ie the thread is still running.  But that's not true; if it
returns -EINVAL, it means the thread never ran.  And why should the
caller care?  Only three callers of kthread_stop do anything with the
return value.  Two of them just put the value in a debug message, and
the third one goes to the effort of passing the return value through
three layers of function pointer calls only to have all the callers
discard it.

> 4) After a successful kthread_run(), kthread_stop() will always return the 
> value from the threadfn callback.  ie. kthread_stop() doesn't ever fail.  A 
> simple semantic, which this patch breaks.

Now I'm confused.  kthread_stop isn't failing.  It preserves the
invariant that when it returns, the thread is no longer running.

> 5) Covering up programmer errors is not good policy.  I dislike WARN_ON() 
> because an oops is much harder to miss.  Painful for you, but The System 
> Works.

I don't understand why we wouldn't want to be more robust here.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
