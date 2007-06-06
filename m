Return-Path: <linux-kernel-owner+w=401wt.eu-S934294AbXFFAtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294AbXFFAtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933337AbXFFAtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:49:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28085 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772AbXFFAtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:49:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=FG/tWSbwfein0+R3oo6v02reyJsTb4eG6HaPV8xFWMBxSiiN0QVSq5soGrsDrjz1M
	E7GPn5IKWHOf1KcwThsbg==
Message-ID: <65dd6fd50706051748y2e7791c3q41722f0d7d536312@mail.gmail.com>
Date: Tue, 5 Jun 2007 17:48:54 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] mm: variable length argument support
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
In-Reply-To: <20070605163925.bfc417ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070605150523.786600000@chello.nl>
	 <20070605151203.790585000@chello.nl>
	 <20070605163925.bfc417ca.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK.  It sounds like a healthy dose of comments is in order.  I'll
clean things up and send out a new patch sometime tonight or tomorrow.

Additional comments inline below:

> > -             len = strnlen_user((void __user *)p, PAGE_SIZE*MAX_ARG_PAGES);
> > -             if (!len || len > PAGE_SIZE*MAX_ARG_PAGES)
> > +             len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
> > +             if (!len || len > MAX_ARG_STRLEN)
>
> strnlen_user() is a scary function.  Please do remember that if the memory
> we just strlen'ed is writeable by any user thread then that thread can at
> any time invalidate the number which the kernel now holds.

At this point, we've already called setup_arg_pages(), so the user
memory is our own private copy.  No other threads can access it.

> > -                     !(len = strnlen_user(compat_ptr(str), bprm->p))) {
> > +                 !(len = strnlen_user(compat_ptr(str), MAX_ARG_STRLEN))) {
> >                       ret = -EFAULT;
> >                       goto out;
> >               }
> >
> > -             if (bprm->p < len)  {
> > +             if (MAX_ARG_STRLEN < len) {
> >                       ret = -E2BIG;
> >                       goto out;
> >               }
>
> Do we have an off-by-one here?  Should it be <=?

No, strnlen_user() returns N+1 (where N==MAX_ARG_STRLEN) if the string
is too large.

> If not, then this code is relying upon the string's terminating \0 coming
> from userspace?  If so, that's buggy: userspace can overwrite the \0 after
> we ran the strnlen_user(), perhaps, and confound the kernel?

If that's the case, then we will fail to copy the null terminator, and
the string will munge into the following string.  Since we always
access this data via the various userspace access routines, we will
either return an error on a later operation, or the new process will
segfault shortly upon starting.

> > +             vma_adjust(vma, new_start, old_end,
> > +                        vma->vm_pgoff - (-shift >> PAGE_SHIFT), NULL);
>
> hm, a right-shift of a negated unsigned value.  That's pretty unusual.  I
> hope you know what you're doing ;)

This is correct.  In this case, shift is already populated with a
negative, wrapped unsigned value.  The -shift is needed to make it
positive before the bitwise shift.

> >  #define EXTRA_STACK_VM_PAGES 20      /* random */
> >
> > +/* Finalizes the stack vm_area_struct.  The flags and permissions are updated,
> > + * the stack is optionally relocated, and some extra space is added.
> > + */
>
> That's better.
>
> But what extra space is added, and why?

We add EXTRA_STACK_VM_PAGES.  To be honest, I think neither of us know
why this is done.  It's just what the old code did, so we preserved
it.

Ollie
