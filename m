Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbXEDEQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbXEDEQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 00:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXEDEQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 00:16:16 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:46325 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754563AbXEDEQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 00:16:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=BlMLqRqxC9huDmUV8qqDcxjRve1gOzrBxo/vjVndmAb3KSCsgGh+nIOvd5E94TBbZCDtU74ybul4MVGj8dUMMjTcLkXCQfdCwYsCgKemFAXMwzk8tXdei06NauDHnX5v65vprKYWttvRxD6R3ZRavVZSlEhg42mMRBR6/wt41f4=  ;
X-YMail-OSG: Tz41Je8VM1mGRt7ZuesnIS4Frh5yqFfHWUPlGOa9XfSZ..Hs
Message-ID: <463AB381.2030909@yahoo.com.au>
Date: Fri, 04 May 2007 14:16:01 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
References: <20070430162007.ad46e153.akpm@linux-foundation.org>	<4636FDD7.9080401@yahoo.com.au>	<Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com>	<4638009E.3070408@yahoo.com.au>	<Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com>	<46393BA7.6030106@yahoo.com.au> <20070503095224.77e89dbf.akpm@linux-foundation.org>
In-Reply-To: <20070503095224.77e89dbf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 03 May 2007 11:32:23 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>> void fastcall unlock_page(struct page *page)
>> {
>>+	VM_BUG_ON(!PageLocked(page));
>> 	smp_mb__before_clear_bit();
>>-	if (!TestClearPageLocked(page))
>>-		BUG();
>>-	smp_mb__after_clear_bit(); 
>>-	wake_up_page(page, PG_locked);
>>+	ClearPageLocked(page);
>>+	if (unlikely(test_bit(PG_waiters, &page->flags))) {
>>+		clear_bit(PG_waiters, &page->flags);
>>+		wake_up_page(page, PG_locked);
>>+	}
>> }
> 
> 
> Why is that significantly faster than plain old wake_up_page(), which
> tests waitqueue_active()?

Because it needs fewer barriers and doesn't touch random a random hash
cacheline in the fastpath.

-- 
SUSE Labs, Novell Inc.
