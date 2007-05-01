Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbXEALss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbXEALss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXEALsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:48:47 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:20356 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754718AbXEALsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:48:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=P+QXG5cFQXnl7k6RkadHrFiy0wRnshlTQiKaeHsjGcjFrCzDWQrA8b+RZ6A/yOv1Pvqi1vhqDCDiUr2Y5dYvPXIZK9H9Bzhyw1yVrBiJ8mIRTHWYzeDZCAdEqBcO7fGlEI7UH06K0WGGBcjGRf8+BOiKamjJEWIjEqbmxXfCDxs=  ;
X-YMail-OSG: bupgmVYVM1l1PXPvo_br6n4tSp.VTMy_xCsc1cV.EB1YtS3_2a9tKuzQeQ3ZeP6ReZopRUWO.A--
Message-ID: <463728EB.8030308@yahoo.com.au>
Date: Tue, 01 May 2007 21:47:55 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rohit Seth <rohitseth@google.com>
CC: "'Hugh Dickins'" <hugh@veritas.com>,
       "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <200704281830.l3SIUqOo004230@smtp.corp.google.com>
In-Reply-To: <200704281830.l3SIUqOo004230@smtp.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit Seth wrote:
> Hi Nick, 
> 
> -----Original Message-----
> From: Nick Piggin [mailto:nickpiggin@yahoo.com.au] 
> Sent: Friday, April 27, 2007 11:03 PM
> To: Hugh Dickins
> Cc: rohitseth@google.com; Mike Stroyan; Andrew Morton; Luck, Tony;
> linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
> 
> Hugh Dickins wrote:
> 
>>On Sat, 28 Apr 2007, Nick Piggin wrote:
>>
>>
>>>OIC, you need a virtual address to evict the icache, so you can't 
>>>flush at flush_dcache time? Or does ia64 have an instruction to flush 
>>>the whole icache? (it would be worth testing, to see how much 
>>>performance suffers).
>>
>>
>>I'm puzzled by that remark: the ia64 flush_icache_range always has a 
>>virtual address, it uses the kernel virtual address; it takes no 
>>interest in whether there's a user virtual address.
> 
> 
>>I _think_ what it is doing is actually flushing dcache lines dirtied 
>>via the kernel virtual address (yes, I think flush_icache
>>in lazy_mmu_prot_update is actually just flushing the dcache, but 
>>I could be wrong? [*]).
> 
> 
> It is invalidating any entries (containing same physical address) in both I
> and D caches.  Any dirty lines in D cache are written back to memory before
> getting invalidated (ofcourse).

OK. (should it be issuing both fc and fc.i to be robust in case a
new implementation doesn't flush the dcache with fc.i?)


>>There are supposedly no icache lines at that point[**]:
> 
> 
> For this bug to trigger there has to be a (stale) entry in icache containing
> the old contents of a page that just got updated by kernel as explicit
> copying of data (DMAs are coherent on ia64, meaning if a device were to
> write to memory then architecture guarnatees that both I and D caches are
> invalidated).

So if we have a dirty dcache line for a given physical address,
it will _always_ be the case that a subsequent icache load will
find that dirty data?

... thanks for bearing with me ;)

-- 
SUSE Labs, Novell Inc.
