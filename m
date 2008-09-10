Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYIJS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYIJS3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYIJS3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:29:39 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:42022 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYIJS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:29:38 -0400
Message-ID: <48C811C5.9000102@cs.columbia.edu>
Date: Wed, 10 Sep 2008 14:28:21 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, jeremy@goop.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v4][PATCH 4/9] Memory management (dump)
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu>	 <1220946154-15174-5-git-send-email-orenl@cs.columbia.edu> <1221065728.6781.19.camel@nimitz>
In-Reply-To: <1221065728.6781.19.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Tue, 2008-09-09 at 03:42 -0400, Oren Laadan wrote:
>> +       while (addr < end) {
>> +               struct page *page;
>> +
>> +               /*
>> +                * simplified version of get_user_pages(): already have vma,
>> +                * only need FOLL_TOUCH, and (for now) ignore fault stats.
>> +                *
>> +                * FIXME: consolidate with get_user_pages()
>> +                */
>> +
>> +               cond_resched();
>> +               while (!(page = follow_page(vma, addr, FOLL_TOUCH))) {
>> +                       ret = handle_mm_fault(vma->vm_mm, vma, addr, 0);
>> +                       if (ret & VM_FAULT_ERROR) {
>> +                               if (ret & VM_FAULT_OOM)
>> +                                       ret = -ENOMEM;
>> +                               else if (ret & VM_FAULT_SIGBUS)
>> +                                       ret = -EFAULT;
>> +                               else
>> +                                       BUG();
>> +                               break;
>> +                       }
>> +                       cond_resched();
>> +                       ret = 0;
>> +               }
> 
> get_user_pages() is really the wrong thing to use here.  It makes pages
> *present* so that we can do things like hand them off to a driver.  For
> checkpointing, we really don't care about that.  It's a waste of time,
> for instance to perform faults to fill the mappings up with zero pages
> and page tables.  Just think of what will happen the first time we touch
> a very large, very sparse anonymous area.  We'll probably kill the
> system just allocating page tables.  Take a look at the comment in
> follow_page().  This is a similar operation to core dumping, and we need
> to be careful.
> 
> This might be fine for a proof of concept, but it needs to be thought
> out much more thoroughly before getting merged.  I guess I'm
> volunteering to go do that.

The intention is not to allocate unallocated pages, but to get the page
pointer and bring in swapped out pages if necessary. (Avoiding swap-in
is possible, but left for future optimization).

Indeed, follow_page() does the work just fine; Of course, it should be
called with FOLL_ANON instead of FOLL_TOUCH. Thanks for pointing out.

Oren.
