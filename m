Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbYAPWfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbYAPWfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758743AbYAPWdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:33:51 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63962 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbYAPWdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:33:49 -0500
Date: Wed, 16 Jan 2008 17:33:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080116223323.GI30532@goodmis.org>
References: <87lk6pvii0.fsf@saeurebad.de> <alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 10:39:00AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 16 Jan 2008, Johannes Weiner wrote:
> > 
> > is there any reason why kfree() takes a const pointer just to degrade it
> > with the call to slab_free()/__cache_free() again?  The promise that the
> > pointee is not modified is just bogus in this case, anyway, isn't it?
> 
> "const" has *never* been about the thing not being modified. Forget all 
> that claptrap. C does not have such a notion.
> 
> "const" is a pointer type issue, and is meant to make certain mis-uses 
> more visible at compile time. It has *no* other meaning, and anybody who 
> thinks it has is just setting himself up for problems.

I totally agree with the above.

> 
> In the particular case of kfree(), the pointer argument *should* be const, 
> and the fact that the C library gets this wrong is not the kernels 
> problem, it's a problem with the C library.

Here, I'm not so sure.

> 
> Why?
> 
>  - From a very obvious and very *real* caller perspective, "free()" really 
>    doesn't change the thing the pointer points to. It does something 
>    totally different: it makes the *pointer* itself invalid.

I'm OK with this.

> 
>    In other words, if you think that "kfree()" changed the thing you 
>    free'd, you're simply wrong. It did no such thing. The memory is 100% 
>    the same, it's just that you cannot access it any more, and if you try, 
>    you'll get somebody elses memory.

This too.

> 
>    In other words, "kfree()" can be const.

Err, not sure.

> 
>  - Anything that *can* take a const pointer should always do so.
> 
>    Why? Because we want the types to be as tight as possible, and normal 
>    code should need as few casts as possible.

OK

> 
>    Here's a question for you: let's say that you have a structure that 
>    has a member that is never changed. To make that obvious, and to allow 
>    the compiler to warn about mis-use of a pointer, the structure should 
>    look something like
> 
> 		struct mystruct {
> 			const char *name;
> 			..
> 
>    and let's look at what happens if the allocation of that const thing is 
>    dynamic.
> 
>    The *correct* way to do that is:
> 
> 		char *name = kmalloc(...)
> 		/* Fill it in */
> 		snprintf(name, ...)
> 		mystruct->name = name;
> 
>    and there are no casts anywhere, and you get exactly the semantics you 
>    want: "name" itself isn't constant (it's obviously modified), but at 
>    the same time the type system makes it very clear that trying to change 
>    it through that mystruct member pointer is wrong.
> 
>    How do you free it?
> 
>    That's right, you do:
> 
> 		kfree(mystruct->name);

This is where I disagree. If a struct has a constant pointer to it, then
the usage of that pointer by the struct should never modify it. If I
need to allocate memory for a name to a struct, I would not expect that
struct to ever free it.

Let's use your example. I'll assume that the struct was created by some
constructor and the destructor freed it. I'd argue the correct way would
be to have the kfree with a typecast.

Why?

  - const pointers (especially strings) should be able to point to
    static data. One thing that we would like to avoid is:

    mystruct->name = "myobj";
	...
    kfree(mystruct->name);

  - really, kfree should match kmalloc for types. What kmalloc returns
    should be what kfree accepts.  Passing in a const pointer to kfree
    *should* be a red flag that something might not be right.

> 
>    and this is why "kfree()" should take a const pointer. If it doesn't, 
>    you have to add an *incorrect* and totally useless cast to code that 
>    was correct.

    char *name = kmalloc(...);
	...
    mystruct->name = name; /* this is an implicit cast */

    So adding a cast to kfree isn't incorrect. C automatically casts
    name to a const pointer, which means if we want to free it, then
    we should cast it back.

> 
> So never believe that "const" is some guarantee that the memory under the 
> pointer doesn't change.  That is *never* true. It has never been true in 
> C, since there can be arbitrary pointer aliases to that memory that aren't 
> actually const. If you think "const *p" means that the memory behind "p" 
> is immutable, you're simply wrong.

Again, I totally agree with the above.

> 
> Anybody who thinks that kfree() cannot (or should not) be const doesn't 
> understand the C type system.

OK, I think that kfree should not be const, but not because of the
explanation that you gave, but because of the C type system in general.

kfree should match the kmalloc type. We don't declare

  const void *kmalloc(...)

so we shouldn't do the same with kfree. If you assign a const pointer to
something from kmalloc, C implicitly does the cast. This doesn't mean
that we should ignore doing the cast back in kfree. Especially since
this could help us avoid the kfree("mystring") issue.

Just my $0.02

-- Steve

