Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbXCMLaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbXCMLaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbXCMLaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:30:24 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:42233 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753237AbXCMLaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:30:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=d7/QDH/W05xbfzszGiL+joavZK3h7oRMqgo0W3RAnvVx8BFF7IIx0BE5F6BaCA1zhCwHa7/c9RxAvUEugOVIdPP37RBCZEKby3DXThN+/ZncL3CBeoKepgZDm8QIZ0/yEzOMrI/BBe8wQ27cDOeTodUzoB5xuGpJC8H77Bt87wo=  ;
X-YMail-OSG: B6GozW8VM1lCTbbuUAze3.T.C9rF0ACTlIEonIjd6FJ.7yKulaARX0axtREYDjq3HQebeLFoOj_972s0W9G.KvIK_85aqXCLUKalhIpGAvdci9qVyibwy8lsii7xooCS0XAz2GaB6fseT3Xo9X6i8mxnKQ--
Message-ID: <45F68B4B.9020200@yahoo.com.au>
Date: Tue, 13 Mar 2007 22:30:19 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>	<20070313005334.853559ca.akpm@linux-foundation.org>	<45F65ADA.9010501@yahoo.com.au>	<20070313035250.f908a50e.akpm@linux-foundation.org>	<45F685C6.8070806@yahoo.com.au> <20070313041551.565891b5.akpm@linux-foundation.org>
In-Reply-To: <20070313041551.565891b5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>On Tue, 13 Mar 2007 22:06:46 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>>Andrew Morton wrote:
>>
>>>>On Tue, 13 Mar 2007 19:03:38 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>>
>>...
>>
>>
>>>>Page allocator still requires interrupts to be disabled, which this doesn't.
> 
> 
>>>>it is worthwhile.
>>>
>>>
>>>If you want a zeroed page for pagecache and someone has just stuffed a
>>>known-zero, cache-hot page into the pagetable quicklists, you have good
>>>reason to be upset.
>>
>>The thing is, pagetable pages are the one really good exception to the
>>rule that we should keep cache hot and initialise-on-demand. They
>>typically are fairly sparsely populated and sparsely accessed. Even
>>for last level page tables, I think it is reasonable to assume they will
>>usually be pretty cold.
> 
> 
> eh?  I'd have thought that a pte page which has just gone through
> zap_pte_range() will very often have a _lot_ of hot cachelines, and
> that's a common case.
> 
> Still.   It's pretty easy to test.

Well I guess that would be the case if you had just unmapped a 4MB
chunk that was pretty dense with pages.

My malloc seems to allocate and free in blocks of 128K, so that's
only going to give us 3% of the last level pte being cache hot when
it gets freed. Not sure what common mmap(file) access patterns
look like.

The majority of programs I run have a smattering of llpt pages
pretty sparsely populated, covering text, libraries, heap, stack,
vdso.

We don't actually have to zap_pte_range the entire page table in
order to free it (IIRC we used to have to, before the 4lpt patches).

But yeah let's see some tests. I would definitely want to avoid this
extra layer of complexity if it is just as good to return the pages
to the pcp lists.

>>>Maybe, dunno.  It was apparently a win on powerpc many years ago.  I had a
>>>fiddle with it 5-6 years ago on x86 using a cache-disabled mapping of the
>>>page.  But it needed too much support in core VM to bother.  Since then
>>>we've grown per-cpu page magazines and __GFP_ZERO.  Plus I'm not aware of
>>>anyone having tried doing it on x86 with non-temporal stores.
>>
>>You can win on specifically constructed benchmarks, easily.
>>
>>But considering all the other problems you're going to introduce, we'd need
>>a significant win on a significant something, IMO.
>>
>>You waste memory bandwidth. You also use more CPU and memory cycles
>>speculatively, ergo you waste more power.
> 
> 
> Yeah, prezeroing in idle is probably pointless.  But I'm not aware of
> anyone having tried it properly...

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
