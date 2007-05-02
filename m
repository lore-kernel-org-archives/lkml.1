Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXEBB5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXEBB5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 21:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXEBB5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 21:57:52 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:23665 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752330AbXEBB5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 21:57:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=xW0s4g+mOKyHJRvWGq2c1eY+qNUTdfIik0GiZ2QgJooOSfIc6P5BP8+yBaiC1ebEaXrHzd2/0JR6NGrL9RNwg74dGDWt/CgsjQXp7jFTUXEluQ0JiXuNJFwjTX+PHkVWyOTcSbypRxcEmILRrDTFLwauzZpGKfVUtF3S9M1q2nI=  ;
X-YMail-OSG: rUhueyIVM1kMv7DmSI2poTKZaBYa9I8xuJyyhrp3T7TwmMB7Zsb0t2m_UXT2JmAkOz5dTRmKPg--
Message-ID: <4637F014.7080409@yahoo.com.au>
Date: Wed, 02 May 2007 11:57:40 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: rohitseth@google.com
CC: "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Hugh Dickins'" <hugh@veritas.com>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <200704281757.l3SHvUrs026921@smtp.corp.google.com>	 <46372706.5030609@yahoo.com.au> <1178066178.19466.67.camel@galaxy.corp.google.com>
In-Reply-To: <1178066178.19466.67.camel@galaxy.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit Seth wrote:
> On Tue, 2007-05-01 at 21:39 +1000, Nick Piggin wrote:
> 
>>Rohit Seth wrote:
> 
> 
>>>If a user is requesting kernel to do (for example) write on a page that is
>>>already mapped with execute and write permissions then it should be treated
>>>as if the user space is doing modifications to that page.  There is no
>>>change in protections so lazy_prot_mmu_update shouldn't be called even
>>>though PG_arch_1 is (I think) set.  Does it answer your concern?
>>
>>I'm not sure that I would agree. For direct modifications of memory via
>>a passed in user virtual address, perhaps. For operations on pagecache,
>>we may not even have a handle to issue the flush cache instruction on (ie.
>>a user virtual address), let alone know whether anyone else is mapping
>>the page.
>>
> 
> 
> Can you please describe the page cache scenario in more detail?  IMO, if
> a page is user mapped with at least one execute and write permission
> then the responsibility of update caches lies with user.

What if a different user write(2)s the underlying page?


>>>>What if you were to say remove all the PG_arch_1 code, and do 
>>>>something really simple like flush icache in 
>>>>flush_dcache_page? Would performance suffer horribly?
>>>
>>>
>>>On Itanium, I think it will have some performance penalty (horrible or not I
>>>don't know) as you will be invalidating the caches more often.  And they
>>>alsways look for last 0.1% performance that they can get.
>>
>>Sure, but if we _only_ flushed when page_mapcount was raised,
> 
> 
> You will need this every time there is change in protection (e.g.
> mprotect) not only when page_mapcount is raised.

Yeah, you would retain the flush on fault, I meant you would
introduce a flush in flush_dcache_page for when mapcount is raised.

-- 
SUSE Labs, Novell Inc.
