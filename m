Return-Path: <linux-kernel-owner+w=401wt.eu-S1161908AbXECNJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161908AbXECNJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161895AbXECNJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:09:04 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:27970 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161908AbXECNJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:09:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=QBuYHE2w0So2K0L5KjBnQVtkCNznwx8NhRlsLpo/YkUUplDfUOt2XBGT9gkbjpoRDQhsB59mqs8DYu6uV3v7g+tuQ42szt+NL/oUsYmaOUkqe/ZMaZ616/Rlt4iOsxUDRN95Rq8KTxhOkKEugtjPP6aFNnQ+NkWjUxuVt6zdzbM=  ;
X-YMail-OSG: 9rEYDdwVM1lBXe4O58thMPQuIjoaoUipzUjxBRQbjcvFM._8WsZPlvsPMUhpFOFOaPUB2RccQA--
Message-ID: <4639DED0.2070507@yahoo.com.au>
Date: Thu, 03 May 2007 23:08:32 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com> <4638009E.3070408@yahoo.com.au> <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com> <46393BA7.6030106@yahoo.com.au> <Pine.LNX.4.64.0705031306300.24945@blonde.wat.veritas.com> <4639D8E8.2090608@yahoo.com.au> <Pine.LNX.4.64.0705031351180.29450@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705031351180.29450@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 3 May 2007, Nick Piggin wrote:
> 
>>>>@@ -568,6 +570,11 @@ __lock_page (diff -p would tell us!)
>>>>{
>>>> DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
>>>>
>>>>+	set_bit(PG_waiters, &page->flags);
>>>>+	if (unlikely(!TestSetPageLocked(page))) {
>>>
>>>What happens if another cpu is coming through __lock_page at the
>>>same time, did its set_bit, now finds PageLocked, and so proceeds
>>>to the __wait_on_bit_lock?  But this cpu now clears PG_waiters,
>>>so this task's unlock_page won't wake the other?
>>
>>You're right, we can't clear the bit here. Doubt it mattered much anyway?
> 
> 
> Ah yes, that's a good easy answer.  In fact, just remove this whole
> test and block (we already tried TestSetPageLocked outside just a
> short while ago, so this repeat won't often save anything).

Yeah, I was getting too clever for my own boots :)

I think the patch has merit though. Unfortunate that it uses another page
flag, however it seemed to have quite a bit speedup on unlock_page (probably
from both the barriers and an extra random cacheline load (from the hash)).

I guess it has to get good results from more benchmarks...


>>BTW. I also forgot an smp_mb__after_clear_bit() before the wake_up_page
>>above... that barrier is in the slow path as well though, so it shouldn't
>>matter either.
> 
> 
> I vaguely wondered how such barriers had managed to dissolve away,
> but cranking my brain up to think about barriers takes far too long.

That barrier was one too many :)

However I believe the fastpath barrier can go away because the PG_locked
operation is depending on the same cacheline as PG_waiters.

-- 
SUSE Labs, Novell Inc.
