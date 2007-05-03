Return-Path: <linux-kernel-owner+w=401wt.eu-S1031324AbXECMpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031324AbXECMpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031321AbXECMpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:45:18 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:35872 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031318AbXECMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:45:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=L0y6KtTNoa1im10why/UR2krP8ZeP3xBYNNxcr6fBtecKECCPWB7J/A8U52cDQpyo5/5c1XXj0gFfXhS3A4CAcrF079XQ+Gk9mfw1x+gssxgqlFVCH+DE7i3fVRs1lawXgWmUiLY9HUNfymHoTvsvdMNpQZdXKVzTRXeY5yGqJo=  ;
X-YMail-OSG: .K41F2YVM1n9aHhdvQVoLACx_rCwoXV3T0PBDtYN3dTxBZJU
Message-ID: <4639D8E8.2090608@yahoo.com.au>
Date: Thu, 03 May 2007 22:43:20 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com> <4638009E.3070408@yahoo.com.au> <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com> <46393BA7.6030106@yahoo.com.au> <Pine.LNX.4.64.0705031306300.24945@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705031306300.24945@blonde.wat.veritas.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 3 May 2007, Nick Piggin wrote:
> 
>>The problem is that lock/unlock_page is expensive on powerpc, and
>>if we improve that, we improve more than just the fault handler...
>>
>>The attached patch gets performance up a bit by avoiding some
>>barriers and some cachelines:
> 
> 
> There's a strong whiff of raciness about this...
> but I could very easily be wrong.
> 
> 
>>Index: linux-2.6/mm/filemap.c
>>===================================================================
>>--- linux-2.6.orig/mm/filemap.c	2007-05-02 15:00:26.000000000 +1000
>>+++ linux-2.6/mm/filemap.c	2007-05-03 08:34:32.000000000 +1000
>>@@ -532,11 +532,13 @@
>>  */
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
>> EXPORT_SYMBOL(unlock_page);
>> 
>>@@ -568,6 +570,11 @@ __lock_page (diff -p would tell us!)
>> {
>> 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
>> 
>>+	set_bit(PG_waiters, &page->flags);
>>+	if (unlikely(!TestSetPageLocked(page))) {
> 
> 
> What happens if another cpu is coming through __lock_page at the
> same time, did its set_bit, now finds PageLocked, and so proceeds
> to the __wait_on_bit_lock?  But this cpu now clears PG_waiters,
> so this task's unlock_page won't wake the other?

You're right, we can't clear the bit here. Doubt it mattered much anyway?

BTW. I also forgot an smp_mb__after_clear_bit() before the wake_up_page
above... that barrier is in the slow path as well though, so it shouldn't
matter either.

> 
> 
>>+		clear_bit(PG_waiters, &page->flags);
>>+		return;
>>+	}
>> 	__wait_on_bit_lock(page_waitqueue(page), &wait, sync_page,
>> 							TASK_UNINTERRUPTIBLE);
>> }
> 
> 


-- 
SUSE Labs, Novell Inc.
