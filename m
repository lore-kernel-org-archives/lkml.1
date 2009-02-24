Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZBXJrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZBXJrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 04:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZBXJrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 04:47:06 -0500
Received: from kuber.nabble.com ([216.139.236.158]:39341 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZBXJrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 04:47:05 -0500
Message-ID: <22178976.post@talk.nabble.com>
Date: Tue, 24 Feb 2009 01:47:02 -0800 (PST)
From: sidc7 <siddhartha.chhabra@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Copy on write and page initialization
In-Reply-To: <200902242017.46605.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: siddhartha.chhabra@gmail.com
References: <22175803.post@talk.nabble.com> <200902242017.46605.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I figured why it was not breaking, cow_user_page is inlined hence it wont
break there

For the initialization, do you think, instrumenting at __alloc_pages using
jprobes and checking the gfp_flags to have GFP_ZERO will work? I did this,
and I could see a bunch of page initializations

Thanks once again
SC



Nick Piggin wrote:
> 
> On Tuesday 24 February 2009 15:50:05 sidc7 wrote:
>> Hi,
>>
>> As far as I understand, Linux uses the COW optimization so parent and
>> child
>> process share the same address space, till one of them writes to it, at
> 
> The "address space" is not shared. Ie. the logical memory space is
> separate, but it happens that the actual virtual->physical mappings
> can be shared due to COW, yes.
> 
> 
>> which point the kernel creates a copy of the page written to. This is
>> done
>> through the function do_wp_page which in turn calls cow_user_page.
> 
> Yes.
> 
> 
>> I created a simple program, where the child and parent process write to a
>> variable differently. I have instrumented the kernel at cow_user_page. On
>> inserting the kprobe module and running the fork program, I do not get a
>> call to cow_user_page. I had several questions:
>> 1. Does this mean that the kernel is not doing COW optimization?
> 
> It means it is not breaking COW where you expect.
> 
> 
>> 2. Is COW enabled by default, if not, how do we turn it on?
> 
> It is.
> 
> 
>> 3. Any other point in the kernel, where cow is done, other than
>> cow_user_page?
> 
> If one process exits before the other writes to it, that condition
> will be noticed in do_wp_fault and a copy can be avoided. The kernel
> would still be doing the COW optimisation without ever actually
> making a copy.
> 
> 
>> Regarding page initialization, if I understand it correctly, the kernel
>> calls get_zeroed_page when it has to allocated a zeroed page, once again
>> in
>> my kernel module, I have probes the kernel at get_zeroed_page, but get no
>> calls, even on running the system for a long time, any other place where
>> the kernel gets zeroed pages to return the applications ?
> 
> No, it doesn't look like it calls get_zeroed_page for userspace memory
> allocation. Try alloc_zeroed_user_highpage_movable, alloc_page_vma etc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
View this message in context: http://www.nabble.com/Copy-on-write-and-page-initialization-tp22175803p22178976.html
Sent from the linux-kernel mailing list archive at Nabble.com.

