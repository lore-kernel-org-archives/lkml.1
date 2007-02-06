Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbXBFJfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbXBFJfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXBFJfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:35:19 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:21460 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751892AbXBFJfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:35:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=MwIcM0lJ2WKA1K49lkU34BGQap4CHAapqDFzcFToAxjrdudpkfOOz6haP8M8LmlgPXt8iDJVne0GIOA5AB3Ht0nlKndIZ9yo8DINMamMCQYtmkKT8WuF2h0pYOl5nBwcClgwh71gUT21usze2XNFZviDg6tItr2ghEVyb5tzYqk=  ;
X-YMail-OSG: xl9GkwwVM1mQUGASlQxxWO5KFDIfODFouFrjziwN.0LCkeY3cy3rY4pNtLyojR5mmVqdD.On4C8dTNst6Lw.n1PusifPPF15DYxefGojI_kp5anUgBm1nb_62vpzIQSo5WuO1mw_nVqnzEI-
Message-ID: <45C841A5.20702@yahoo.com.au>
Date: Tue, 06 Feb 2007 19:51:49 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: Re: [patch 1/3] mm: fix PageUptodate memorder
References: <20070206054925.21042.50546.sendpatchset@linux.site>	<20070206054935.21042.13541.sendpatchset@linux.site> <20070206002512.4e0bbbad.akpm@linux-foundation.org>
In-Reply-To: <20070206002512.4e0bbbad.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue,  6 Feb 2007 09:02:11 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:
> 
> 
>>+static inline void __SetPageUptodate(struct page *page)
>>+{
>>+#ifdef CONFIG_S390
>> 	if (!test_and_set_bit(PG_uptodate, &page->flags))
>> 		page_test_and_clear_dirty(page);
>>-}
>> #else
>>-#define SetPageUptodate(page)	set_bit(PG_uptodate, &(page)->flags)
>>+	/*
>>+	 * Memory barrier must be issued before setting the PG_uptodate bit,
>>+	 * so all previous writes that served to bring the page uptodate are
>>+	 * visible before PageUptodate becomes true.
>>+	 *
>>+	 * S390 is guaranteed to have a barrier in the test_and_set operation
>>+	 * (see Documentation/atomic_ops.txt).
>>+	 *
>>+	 * XXX: does this memory barrier need to be anything special to
>>+	 * handle things like DMA writes into the page?
>>+	 */
>>+	smp_wmb();
>>+	set_bit(PG_uptodate, &(page)->flags);
>> #endif
>>+}
>>+
>>+static inline void SetPageUptodate(struct page *page)
>>+{
>>+	WARN_ON(!PageLocked(page));
>>+	__SetPageUptodate(page);
>>+}
>>+
>>+static inline void SetNewPageUptodate(struct page *page)
>>+{
>>+	__SetPageUptodate(page);
>>+}
> 
> 
> I was panicing for a minute when I saw that __SetPageUptodate() in there.
> 
> Conventionally the __SetPageFoo namespace is for nonatomic updates to
> page->flags.  Can we call this something different?

Duh, of course, sorry.

> What a fugly patchset :(

Fugly problem. One could fix it by always locking the page, but I was
worried about Hugh flaming me if I tried that ;)

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
