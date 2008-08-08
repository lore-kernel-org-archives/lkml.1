Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYHHUvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYHHUvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYHHUuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:50:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33750 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbYHHUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:50:53 -0400
Date: Fri, 8 Aug 2008 14:50:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make kthread_stop() not oops when passed a bad pointer
Message-ID: <20080808205036.GH8618@parisc-linux.org>
References: <20080805135559.GQ26461@parisc-linux.org> <200808061122.59584.rusty@rustcorp.com.au> <20080806120704.GF2055@parisc-linux.org> <200808070648.06298.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808070648.06298.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 06:48:05AM +1000, Rusty Russell wrote:
> On Wednesday 06 August 2008 22:07:04 Matthew Wilcox wrote:
> > On Wed, Aug 06, 2008 at 11:22:58AM +1000, Rusty Russell wrote:
> > > How about a more ambitious "we've oopsed so break a mutex every 30
> > > seconds of waiting" patch?
> >
> > I was considering something more along the lines of "we've oopsed so
> > find every mutex we own and release it".
> 
> Hmm, I don't think that's possible in general is it?

Maybe not.  I've not looked carefully.  Though I just had a really good
idea that might have the same effect.  If you have CONFIG_DEBUG_MUTEXES
on, then there's an owner field.  So if we don't free the thread_info
for an oopsed task, we can tell that it's currently owned by a dead
task, and usurp the ownership.

> > > 1) There's no reason that kthread_stop is uniquely difficult to use.  Why
> > > pick on that one?
> >
> > It was the one I hit.
> 
> Yes, I got that :)  But if we're not about to sprinkle "if check_ptr(arg)" all 
> through the kernel wherever someone can misuse a function.

We are starting to move checks from the callers into the callees -- at
least as much for code size improvements as anything else.  I'm not sure
why the line should be between kthread_stop and kfree rather than on the
other side of kthread_stop.

> > > 2) I know that kfree() handles NULL, but kthread_create/kthread_run never
> > > return NULL, unlike kmalloc().
> >
> > I'd kzalloc'd the memory structure, then rearranged the order of calls
> > initialising it without rearranging the destructor.
> 
> And if you hadn't used kzalloc you'll still blow up.  I dislike zeroing allocs 
> myself because I have dreams of valgrinding the kernel.  gcc would warn about 
> this for a stack var, it'd be nice if it did the same here.

It's too complex for gcc to be able to see this one, IMO.  Valgrind
would catch it.  I'm not a huge fan of kzalloc either.

> Good point.  I assumed passing through the value would be useful, but as it's 
> not been after a couple of years, we should make the callback return void.  
> It'd be a painful transition, but I like the simplicity.

Cool.

> > > 4) After a successful kthread_run(), kthread_stop() will always return
> > > the value from the threadfn callback.  ie. kthread_stop() doesn't ever
> > > fail.  A simple semantic, which this patch breaks.
> >
> > Now I'm confused.  kthread_stop isn't failing.  It preserves the
> > invariant that when it returns, the thread is no longer running.
> 
> No, all we know is that they passed the wrong thing into kthread_stop().  So 
> we really don't know if their thread is stopped; maybe it never existed (as 
> in your case), maybe it's still running.

Ah, good point, I hadn't considered the possibility of passing the wrong
pointer in.

> > > 5) Covering up programmer errors is not good policy.  I dislike WARN_ON()
> > > because an oops is much harder to miss.  Painful for you, but The System
> > > Works.
> >
> > I don't understand why we wouldn't want to be more robust here.
> 
> Because the OOPS made you fix the bug the way silently sucking it up wouldn't 
> have.

I made doing what I did no longer a bug ;-)

But, look, I'm perfectly happy with:

+	BUG_ON(!k || ERR_PTR(k));

as long as it happens before we take the mutex.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
