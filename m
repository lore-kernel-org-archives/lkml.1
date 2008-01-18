Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbYARVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbYARVDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762664AbYARVDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:03:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:22501 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762133AbYARVDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:03:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=riJKEfJRUpdwWII8hkCqRirT1XOTIG1oT/HIsoA32LqmANtBqZt3kHfcYa1d0u0p8g6ptN//e9pqihsJsFY9xVkskcNEi7jeLYsRFzkM/9HUVVV77u9ZsOYb0cEo5fa3/29awAdcop/5goXDyG7XGdQKRXFnjxShqQy1aeLCB50=
Message-ID: <4df4ef0c0801181303o6656832g8b63d2a119a86a9c@mail.gmail.com>
Date: Sat, 19 Jan 2008 00:03:04 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped files
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, peterz@infradead.org,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <alpine.LFD.1.00.0801181214440.2957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org>
	 <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu>
	 <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org>
	 <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu>
	 <alpine.LFD.1.00.0801181106340.2957@woody.linux-foundation.org>
	 <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
	 <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
	 <4df4ef0c0801181158s3f783beaqead3d7049d4d3fa7@mail.gmail.com>
	 <alpine.LFD.1.00.0801181214440.2957@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/18, Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Fri, 18 Jan 2008, Anton Salikhmetov wrote:
> >
> > The current solution doesn't hit the performance at all when compared to
> > the competitor POSIX-compliant systems. It is faster and does even more
> > than the POSIX standard requires.
>
> Your current patches have two problems:
>  - they are simply unnecessarily invasive for a relatively simple issue
>  - all versions I've looked at closer are buggy too
>
> Example:
>
>         +               if (pte_dirty(*pte) && pte_write(*pte))
>         +                       *pte = pte_wrprotect(*pte);
>
> Uhhuh. Looks simple enough. Except it does a non-atomic pte access while
> other CPU's may be accessing it and updating it from their hw page table
> walkers. What will happen? Who knows? I can see lost access bits at a
> minimum.
>
> IOW, this isn't simple code. It's code that it is simple to screw up. In
> this case, you really need to use ptep_set_wrprotect(), for example.

Before using pte_wrprotect() the vma_wrprotect() routine uses the
pte_offset_map_lock() macro to get the PTE and to acquire the ptl
spinlock. Why did you say that this code was not SMP-safe? It should
be atomic, I think.


>
> So why not do it in many fewer lines with that simpler vma->dirty flag?

Neither the dirty flag you suggest, nor the AS_MCTIME flag I've
introduced in my previous solutions solve the following problem:

- mmap()
- a write reference
- msync() with MS_ASYNC
- a write reference
- msync() with MS_ASYNC

The POSIX standard requires the ctime and mtime stamps to be updated
not later than at the second call to msync() with the MS_ASYNC flag.

Some other POSIX-compliant operating system such as HP-UX and FreeBSD
satisfy this POSIX requirement. Linux does not.

>
>                 Linus
>
