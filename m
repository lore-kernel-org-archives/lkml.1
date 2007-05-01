Return-Path: <linux-kernel-owner+w=401wt.eu-S1031161AbXEALkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031161AbXEALkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXEALkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:40:10 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:41913 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754389AbXEALj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:39:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ZGnuK3vOVkUH/qXUSro2rXswrl7I1aWrt+yvt1mQEEDMwUJyeAXGVHzFCr9gpkirBJoJ16rHB9Yvu71B7z8+aHra7zXQhbOdvwwbAg5XO7YTZIy6emFsk/9HEdITHNSosB8m/DXViArHkJp4jsDbRhaBjtksrJZKIDPC+ua7l8M=  ;
X-YMail-OSG: OXz1LsYVM1lvVsXDkQJgdLXnd4vPIwCmiyhIc3HX3b6uFm5xLJLHWGR9A4Q8aswf5HH8Gh8MCw--
Message-ID: <46372706.5030609@yahoo.com.au>
Date: Tue, 01 May 2007 21:39:50 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rohit Seth <rohitseth@google.com>
CC: "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Hugh Dickins'" <hugh@veritas.com>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <200704281757.l3SHvUrs026921@smtp.corp.google.com>
In-Reply-To: <200704281757.l3SHvUrs026921@smtp.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit Seth wrote:
>  
> 
> -----Original Message-----
> From: Nick Piggin [mailto:nickpiggin@yahoo.com.au] 
> Sent: Friday, April 27, 2007 7:00 PM
> To: rohitseth@google.com
> Cc: Mike Stroyan; Andrew Morton; Hugh Dickins; Luck, Tony;
> linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
> 
> Rohit Seth wrote:
> 
>>
>>>You mean by user space? If so, then it is user space responsibility to 
>>>do the appropriate operations (like flush icache in this case).
> 
> 
>>No, I mean places that set PG_arch_1. flush_dcache_page. This can happen 
>>for mapped pages in write, splice, install_arg_page looks questionable,
> 
> direct IO...
> 
> 
> If a user is requesting kernel to do (for example) write on a page that is
> already mapped with execute and write permissions then it should be treated
> as if the user space is doing modifications to that page.  There is no
> change in protections so lazy_prot_mmu_update shouldn't be called even
> though PG_arch_1 is (I think) set.  Does it answer your concern?

I'm not sure that I would agree. For direct modifications of memory via
a passed in user virtual address, perhaps. For operations on pagecache,
we may not even have a handle to issue the flush cache instruction on (ie.
a user virtual address), let alone know whether anyone else is mapping
the page.

>>What if you were to say remove all the PG_arch_1 code, and do 
>>something really simple like flush icache in 
>>flush_dcache_page? Would performance suffer horribly?
> 
> 
> On Itanium, I think it will have some performance penalty (horrible or not I
> don't know) as you will be invalidating the caches more often.  And they
> alsways look for last 0.1% performance that they can get.

Sure, but if we _only_ flushed when page_mapcount was raised, then we
should have most of the benefits of lazy flushing, and the main places
were we do extra flushes are those where aliases could potentially occur
under the old scheme.

-- 
SUSE Labs, Novell Inc.
