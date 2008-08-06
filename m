Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYHHGUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYHHGUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYHHGTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:19:47 -0400
Received: from ozlabs.org ([203.10.76.45]:48343 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYHHGTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:19:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Make kthread_stop() not oops when passed a bad pointer
Date: Thu, 7 Aug 2008 06:48:05 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
References: <20080805135559.GQ26461@parisc-linux.org> <200808061122.59584.rusty@rustcorp.com.au> <20080806120704.GF2055@parisc-linux.org>
In-Reply-To: <20080806120704.GF2055@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070648.06298.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 22:07:04 Matthew Wilcox wrote:
> On Wed, Aug 06, 2008 at 11:22:58AM +1000, Rusty Russell wrote:
> > How about a more ambitious "we've oopsed so break a mutex every 30
> > seconds of waiting" patch?
>
> I was considering something more along the lines of "we've oopsed so
> find every mutex we own and release it".

Hmm, I don't think that's possible in general is it?

> > 1) There's no reason that kthread_stop is uniquely difficult to use.  Why
> > pick on that one?
>
> It was the one I hit.

Yes, I got that :)  But if we're not about to sprinkle "if check_ptr(arg)" all 
through the kernel wherever someone can misuse a function.

> > 2) I know that kfree() handles NULL, but kthread_create/kthread_run never
> > return NULL, unlike kmalloc().
>
> I'd kzalloc'd the memory structure, then rearranged the order of calls
> initialising it without rearranging the destructor.

And if you hadn't used kzalloc you'll still blow up.  I dislike zeroing allocs 
myself because I have dreams of valgrinding the kernel.  gcc would warn about 
this for a stack var, it'd be nice if it did the same here.

> > 3) If we really want to pass a failed kthread_create() through
> > kthread_stop(), we should return PTR_ERR(k) here.  But that should only
> > be done if it made it harder for the callers to screw up, which I don't
> > think it does.
>
> I'm actually really dubious about kthread_stop() returning a value at
> all.  To me, returning an error implies that the function failed to do
> its job, ie the thread is still running.  But that's not true; if it
> returns -EINVAL, it means the thread never ran.

You mean -EINTR?  Yes, it should probably be left undefined: the caller 
presumably knows it didn't start the thread.

> And why should the 
> caller care?  Only three callers of kthread_stop do anything with the
> return value.  Two of them just put the value in a debug message, and
> the third one goes to the effort of passing the return value through
> three layers of function pointer calls only to have all the callers
> discard it.

Good point.  I assumed passing through the value would be useful, but as it's 
not been after a couple of years, we should make the callback return void.  
It'd be a painful transition, but I like the simplicity.

> > 4) After a successful kthread_run(), kthread_stop() will always return
> > the value from the threadfn callback.  ie. kthread_stop() doesn't ever
> > fail.  A simple semantic, which this patch breaks.
>
> Now I'm confused.  kthread_stop isn't failing.  It preserves the
> invariant that when it returns, the thread is no longer running.

No, all we know is that they passed the wrong thing into kthread_stop().  So 
we really don't know if their thread is stopped; maybe it never existed (as 
in your case), maybe it's still running.

> > 5) Covering up programmer errors is not good policy.  I dislike WARN_ON()
> > because an oops is much harder to miss.  Painful for you, but The System
> > Works.
>
> I don't understand why we wouldn't want to be more robust here.

Because the OOPS made you fix the bug the way silently sucking it up wouldn't 
have.

Rusty.
