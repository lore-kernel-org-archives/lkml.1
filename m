Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbXD0LzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbXD0LzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbXD0LzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:55:19 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:36202 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755659AbXD0LzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:55:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0cuqfYKbPMUEnIBoULYtwnNNgHURxQkDMbC2CVuvnE3EuI00CaXoD4fP5mDMCVtd1WANzYD1HFTrymKKV0FazzeUX52Im/MSDVnno2qAMjaD15nZNQ07sdB6y6HPBRK12Rk0er+KWGR+OBZAHANCj0STvZIVyMXZNjl1MbsXnx8=  ;
X-YMail-OSG: zN8Fn84VM1lsw3DYu0.Z8vlNTPHkQBLIpj__yocvSI.Lju6RG.EdEQWFxQUmZ616SCYCpUVuIg--
Message-ID: <4631E49C.2030501@yahoo.com.au>
Date: Fri, 27 Apr 2007 21:55:08 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mike Stroyan <mike.stroyan@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       "Luck, Tony" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <20070425205548.fd51b301.akpm@linux-foundation.org> <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com>
In-Reply-To: <20070426173544.GA30744@ldl.fc.hp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Stroyan wrote:
> On Thu, Apr 26, 2007 at 05:53:49PM +1000, Nick Piggin wrote:
> 
>>I had a couple of questions which I'm hoping someone would be kind
>>enough to explain :)
> 
> ...
> 
>>I wonder how this is different to all the other code which calls
>>lazy_mmu_prot_update() after set_pte_at(). do_swap_page, for example,
>>_could_ fault in executable code, couldn't it?
> 
> 
>   The do_swap_page code does look suspect.  It seems to be working on
> ia64 because a DMA transfer of data from swap to the allocated page
> is removing old lines from the icache.  If code on an anonymous page
> was swapping in without direct DMA to the page then the same problem
> could occur.  I can't think of a reasonable situation that would cause
> swapping in to not use DMA.  Swapping to/from NFS does not seem reasonable
> to me anyway.

But that's because of ia64's cache coherency implementation. I don't really
follow the documentation to know whether it should be one way or the other,
but surely it should be done either before or after the set_pte_at, not both.

Anyway, how about fremap or mprotect, for example?

>>It is because do_swap_page uses flush_icache_page()? So why doesn't
>>the flush_icache_page() work in do_no_page as well? (It seems to look
>>like a superset of lazy_mmu_prot_update on ia64?!?).
> 
> 
> flush_icache_page() on ia64 is provided by include/asm-ia64/cacheflush.h.
> It doesn't have any effect at all.
> 
> #define flush_icache_page(vma,page)             do { } while (0)

You're right, sorry I was mistakenly looking at the flush_range. That was
my only immediate concern with your patch... So, for finding and fixing
that bug you have my admiration :)

OK, I'm still not sure that I understand why lazy_mmu_prot_update should be
used rather than flush_icache_page (in concept, not ia64 implementation).
Sure, flush_icache_page isn't given the pte, but let's assume we can change
that.

>   lazy_mmu_prot_update() is supposed to get icache flushes done when they
> need to be.  And it is supposed to avoid unneeded flushes when the icache
> is known to be clean for a page.

That's the theory. However, I'd still like to know how the arch code can
make the assertion that icache is known to be at all times other than at
the time of a fault?

Ie. what if an operation which causes incoherency is carried out _after_
an executable mapping is installed for that page.

-- 
SUSE Labs, Novell Inc.
