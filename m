Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZJSXlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZJSXlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZJSXlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:41:03 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:47537 "EHLO cmpxchg.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757838AbZJSXlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:41:02 -0400
Date: Tue, 20 Oct 2009 01:40:46 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Earl Chew <earl_chew@agilent.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Arithmetic overflow in may_expand_vm()
Message-ID: <20091019234046.GA9307@cmpxchg.org>
References: <4AD75AE3.80803@agilent.com> <20091019075350.GA1769@cmpxchg.org> <4ADC7AF5.2020707@agilent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADC7AF5.2020707@agilent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 07:43:01AM -0700, Earl Chew wrote:
> Johannes Weiner wrote:
> >>If npages is stupendously large, the failure predicate may
> >>return a false negative due to (cur + npages) overflowing and
> >>wrapping.
> >
> >Can this really happen?
> >
> >npages always originates in a value of byte granularity, giving a
> >theoretical maximum of ~0UL >> PAGE_SHIFT (checking for more than the
> >number of addressable bytes just makes no sense).
> 
> I think you're saying that there are no (external facing)
> interfaces that ask for pages -- they always ask for octets.

Yes.

> You may well be right. I don't know the kernel code base well
> enough to say for sure one way or another.
> 
> >And mm->total_vm is always PAGE_SIZE times smaller than total user
> >address space (which in turn is always less than ~0UL).
> >
> >So I can not see this overflow being possible with PAGE_SHIFT > 0.
> 
> A very reasonable argument to be sure.
> 
> I can think of two counter-arguments:
> 
> a. The fewer assumptions made by may_expand_vm() (or any other
>    function for that matter) about its callers, the more robust
>    the function, and the more resilient the system.
> 
>    I think it would be good practice for may_expand_vm() to
>    do the right thing for all possible input values. Especially
>    in this case where the cost of doing the right thing is either
>    very small or zero.

But implicitely defending against something we do not expect to happen
is misleading.

If you expect overflows to be possible (when validating user input
e.g.), check for them.  But please don't make the code suggest they
could appear in any sane condition when they in fact do not.

I think that has better chances of making semantics and misuse more
obvious.

> b. There are other examples in the code base that use the more
>    robust approach. For instance see kernel/filemap.c:
> 
>         unsigned long limit =
>            current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
> 
>            ... snip ...
> 
>                 if (limit != RLIM_INFINITY) {
>                         if (*pos >= limit) {
>                                 send_sig(SIGXFSZ, current, 0);
>                                 return -EFBIG;
>                         }
>                         if (*count > limit - (typeof(limit))*pos) {
>                                 *count = limit - (typeof(limit))*pos;
>                         }
>                 }

And it is misleading.  That function (generic_write_checks) can not
cope with overflows anyway and callsites should have sorted that out
long before.  But some of those checks suggest otherwise.
