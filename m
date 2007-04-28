Return-Path: <linux-kernel-owner+w=401wt.eu-S1163487AbXD1SbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163487AbXD1SbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163490AbXD1SbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:31:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:41833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163487AbXD1SbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:31:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:from:message-id:to:cc:subject:date:mime-version:
	content-type:content-transfer-encoding:x-mailer:in-reply-to:x-mimeole:thread-index;
	b=gIjLyu5gkHEtvaklzK3VHEaWCia48Uc1bWZrLg5Gq08Ndjuw+aL2khwtHCBjNUsxw
	xsnSciMSUiyYxcxt3/i+w==
From: Rohit Seth <rohitseth@google.com>
Message-Id: <200704281830.l3SIUqOo004230@smtp.corp.google.com>
To: "'Nick Piggin'" <nickpiggin@yahoo.com.au>,
       "'Hugh Dickins'" <hugh@veritas.com>
Cc: "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Fw: [PATCH] ia64: race flushing icache in do_no_page path
Date: Sat, 28 Apr 2007 11:30:40 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.6353
In-Reply-To: <4632E3B0.6050101@yahoo.com.au>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AceJWwJ7OfGpU9drRvC+mKpMTBDgKwAZrNNA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick, 

-----Original Message-----
From: Nick Piggin [mailto:nickpiggin@yahoo.com.au] 
Sent: Friday, April 27, 2007 11:03 PM
To: Hugh Dickins
Cc: rohitseth@google.com; Mike Stroyan; Andrew Morton; Luck, Tony;
linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path

Hugh Dickins wrote:
> On Sat, 28 Apr 2007, Nick Piggin wrote:
> 
>>OIC, you need a virtual address to evict the icache, so you can't 
>>flush at flush_dcache time? Or does ia64 have an instruction to flush 
>>the whole icache? (it would be worth testing, to see how much 
>>performance suffers).
> 
> 
> I'm puzzled by that remark: the ia64 flush_icache_range always has a 
> virtual address, it uses the kernel virtual address; it takes no 
> interest in whether there's a user virtual address.

>I _think_ what it is doing is actually flushing dcache lines dirtied 
>via the kernel virtual address (yes, I think flush_icache
> in lazy_mmu_prot_update is actually just flushing the dcache, but 
>I could be wrong? [*]).

It is invalidating any entries (containing same physical address) in both I
and D caches.  Any dirty lines in D cache are written back to memory before
getting invalidated (ofcourse).

> There are supposedly no icache lines at that point[**]:

For this bug to trigger there has to be a (stale) entry in icache containing
the old contents of a page that just got updated by kernel as explicit
copying of data (DMAs are coherent on ia64, meaning if a device were to
write to memory then architecture guarnatees that both I and D caches are
invalidated).

> the bug fix at the start of this thread 
>is due to icache lines becoming present before the flush.

For this mail thread, the old contents were not flushed out of icache when
the old mapping was removed.  And they were still present when the free page
got mapped again.

Cheers,
-rohit

