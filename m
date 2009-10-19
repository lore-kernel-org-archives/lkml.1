Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZJSOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZJSOnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbZJSOnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:43:39 -0400
Received: from aglcosbs03.cos.agilent.com ([192.25.218.43]:45279 "EHLO
	aglcosbs03.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961AbZJSOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:43:39 -0400
Message-ID: <4ADC7AF5.2020707@agilent.com>
Date: Mon, 19 Oct 2009 07:43:01 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Arithmetic overflow in may_expand_vm()
References: <4AD75AE3.80803@agilent.com> <20091019075350.GA1769@cmpxchg.org>
In-Reply-To: <20091019075350.GA1769@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 14:43:04.0835 (UTC) FILETIME=[7748B530:01CA50CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
>> If npages is stupendously large, the failure predicate may
>> return a false negative due to (cur + npages) overflowing and
>> wrapping.
> 
> Can this really happen?
> 
> npages always originates in a value of byte granularity, giving a
> theoretical maximum of ~0UL >> PAGE_SHIFT (checking for more than the
> number of addressable bytes just makes no sense).

I think you're saying that there are no (external facing)
interfaces that ask for pages -- they always ask for octets.

You may well be right. I don't know the kernel code base well
enough to say for sure one way or another.

> And mm->total_vm is always PAGE_SIZE times smaller than total user
> address space (which in turn is always less than ~0UL).
> 
> So I can not see this overflow being possible with PAGE_SHIFT > 0.

A very reasonable argument to be sure.

I can think of two counter-arguments:

a. The fewer assumptions made by may_expand_vm() (or any other
    function for that matter) about its callers, the more robust
    the function, and the more resilient the system.

    I think it would be good practice for may_expand_vm() to
    do the right thing for all possible input values. Especially
    in this case where the cost of doing the right thing is either
    very small or zero.

b. There are other examples in the code base that use the more
    robust approach. For instance see kernel/filemap.c:

         unsigned long limit =
            current->signal->rlim[RLIMIT_FSIZE].rlim_cur;

            ... snip ...

                 if (limit != RLIM_INFINITY) {
                         if (*pos >= limit) {
                                 send_sig(SIGXFSZ, current, 0);
                                 return -EFBIG;
                         }
                         if (*count > limit - (typeof(limit))*pos) {
                                 *count = limit - (typeof(limit))*pos;
                         }
                 }


Earl



