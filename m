Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZCCSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZCCSTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZCCSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:19:31 -0500
Received: from smtp.nokia.com ([192.100.122.233]:22996 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZCCSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:19:30 -0500
Message-ID: <49AD74AB.9090304@nokia.com>
Date: Tue, 03 Mar 2009 20:19:23 +0200
From: Aaro Koskinen <aaro.koskinen@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: tlb_start_vma() / tlb_end_vma() inefficiency (was Re: [PATCH 1/1]
 [ARM] Always do the full MM flush when unmapping VMA)
References: <1236097435-861-1-git-send-email-Aaro.Koskinen@nokia.com> <20090303163212.GB11096@n2100.arm.linux.org.uk>
In-Reply-To: <20090303163212.GB11096@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2009 18:19:24.0736 (UTC) FILETIME=[94E5EC00:01C99C2C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Russell King - ARM Linux wrote:
> On Tue, Mar 03, 2009 at 06:23:55PM +0200, Aaro Koskinen wrote:
>> When unmapping N pages (e.g. shared memory) the amount of TLB flushes
>> done is (N*PAGE_SIZE/ZAP_BLOCK_SIZE)*N although it should be N at
>> maximum. With PREEMPT kernel ZAP_BLOCK_SIZE is 8 pages, so there is a
>> noticeable performance penalty and the system is spending its time in
>> flush_tlb_range().
>>
>> The problem is that tlb_end_vma() is passing always the full VMA
>> range. The subrange that needs to be flushed would be available in
>> tlb_finish_mmu(), but the VMA is not available anymore. So always do
>> the full MM flush.
> 
> NAK.  If we're only unmapping a small VMA, this will result in us knocking
> out all TLB entries.  That's far from desirable.
> 
> The better solution is to probably seek to change tlb_end_vma() so that
> it knows how much work to do, which does need a generic kernel change
> and therefore to be discussed on lkml.

Ok, fair enough, moving this to lkml.

So, there is a problem in the way tlb_start_vma() and tlb_end_vma() are 
currently used: unmap_page_range() can be called multiple times when 
unmapping a VMA, and each time it calls tlb_start_vma()/tlb_end_vma() 
with the full range, instead of the subrange it's actually unmapping.

On ARM, tlb_flush_range() is called from tlb_end_vma(), and so, every 
time it goes unnecessarily through the whole VMA range. If I unmap 2048 
pages with PREEMPT enabled, that's 256*2048 flushes. You don't even have 
to measure to see an application freeze when it's unmapping a large 
area. (On some architectures this problem is not visible at all since 
these routines can be NOP.)

The question is how to fix this. There is currently no good way to 
implement these routines for architectures that are doing range-specific 
TLB flushes. As suggested above by Russell, perhaps it could be 
reasonable to change tlb_{start,end}_end() API so that it would also 
pass on the range that is/was actually unmapped by unmap_page_range()?

A.
