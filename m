Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYAPSj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYAPSj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYAPSjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:39:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701AbYAPSjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:39:17 -0500
Date: Wed, 16 Jan 2008 10:39:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
In-Reply-To: <87lk6pvii0.fsf@saeurebad.de>
Message-ID: <alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org>
References: <87lk6pvii0.fsf@saeurebad.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Johannes Weiner wrote:
> 
> is there any reason why kfree() takes a const pointer just to degrade it
> with the call to slab_free()/__cache_free() again?  The promise that the
> pointee is not modified is just bogus in this case, anyway, isn't it?

"const" has *never* been about the thing not being modified. Forget all 
that claptrap. C does not have such a notion.

"const" is a pointer type issue, and is meant to make certain mis-uses 
more visible at compile time. It has *no* other meaning, and anybody who 
thinks it has is just setting himself up for problems.

In the particular case of kfree(), the pointer argument *should* be const, 
and the fact that the C library gets this wrong is not the kernels 
problem, it's a problem with the C library.

Why?

 - From a very obvious and very *real* caller perspective, "free()" really 
   doesn't change the thing the pointer points to. It does something 
   totally different: it makes the *pointer* itself invalid.

   In other words, if you think that "kfree()" changed the thing you 
   free'd, you're simply wrong. It did no such thing. The memory is 100% 
   the same, it's just that you cannot access it any more, and if you try, 
   you'll get somebody elses memory.

   In other words, "kfree()" can be const.

 - Anything that *can* take a const pointer should always do so.

   Why? Because we want the types to be as tight as possible, and normal 
   code should need as few casts as possible.

   Here's a question for you: let's say that you have a structure that 
   has a member that is never changed. To make that obvious, and to allow 
   the compiler to warn about mis-use of a pointer, the structure should 
   look something like

		struct mystruct {
			const char *name;
			..

   and let's look at what happens if the allocation of that const thing is 
   dynamic.

   The *correct* way to do that is:

		char *name = kmalloc(...)
		/* Fill it in */
		snprintf(name, ...)
		mystruct->name = name;

   and there are no casts anywhere, and you get exactly the semantics you 
   want: "name" itself isn't constant (it's obviously modified), but at 
   the same time the type system makes it very clear that trying to change 
   it through that mystruct member pointer is wrong.

   How do you free it?

   That's right, you do:

		kfree(mystruct->name);

   and this is why "kfree()" should take a const pointer. If it doesn't, 
   you have to add an *incorrect* and totally useless cast to code that 
   was correct.

So never believe that "const" is some guarantee that the memory under the 
pointer doesn't change.  That is *never* true. It has never been true in 
C, since there can be arbitrary pointer aliases to that memory that aren't 
actually const. If you think "const *p" means that the memory behind "p" 
is immutable, you're simply wrong.

Anybody who thinks that kfree() cannot (or should not) be const doesn't 
understand the C type system.

			Linus
