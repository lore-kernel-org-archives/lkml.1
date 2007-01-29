Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXA2Cwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXA2Cwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 21:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933109AbXA2Cwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 21:52:30 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:30200 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933113AbXA2Cw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 21:52:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=FUmmGHRzG0yLPKtQLmULxv9jhlDehYhtjg3SIugBsiA7Tac3r6V1eKtCLMgLtIWyjDEIwqS5RLWR7yeYXkONeDdXPmVNKPc/J+woHn7kxBD3B4ONwQ78R7Dmdi5+RQd9ypDBoiTyArOE9oYAoOU8iYMoTkKt26++X51nyM2hFeA=  ;
X-YMail-OSG: zedW8bcVM1mtu.47shl_owjyHnyBOeaMQJmt3M_aaDKeBpEE4U9YbCKFJrlg1UnPHWkqwcbdkbTt3IWpKB7IUuLGqC8XK0fyi1N2x.3MqhBM5JLbHVs-
Message-ID: <45BD6160.10608@yahoo.com.au>
Date: Mon, 29 Jan 2007 13:52:16 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
References: <1169993494.10987.23.camel@lappy> <20070128142925.df2f4dce.akpm@osdl.org>
In-Reply-To: <20070128142925.df2f4dce.akpm@osdl.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 28 Jan 2007 15:11:34 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

>>+static inline int set_page_address(struct page *page, void *address)
>>+{
>>+	if (address)
>>+		return cmpxchg(&page->virtual, NULL, address) == NULL;
>>+	else {
>>+		/*
>>+		 * cmpxchg is a bit abused because it is not guaranteed
>>+		 * safe wrt direct assignment on all platforms.
>>+		 */
>>+		void *virt = page->virtual;
>>+		return cmpxchg(&page->vitrual, virt, NULL) == virt;
>>+	}
>>+}
> 
> 
> Have you verified that all architectures which can implement
> WANT_PAGE_VIRTUAL also implement cmpxchg?

Simple: we should not implement cmpxchg in generic code. We should
be able to use atomic_long_cmpxchg for this -- it will work perfectly
regardless of what anybody else tells you.

cmpxchg is only required for when that memory location may get modified
by some other means than under your control (eg. userspace, in the case
of drm, or hardware MMU in the case of Christoph's old page fault
scalability patches).

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
