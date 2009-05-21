Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZEURnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZEURnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 13:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZEURno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 13:43:44 -0400
Received: from claw.goop.org ([74.207.240.146]:60284 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbZEURnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 13:43:43 -0400
Message-ID: <4A1592CF.8000208@goop.org>
Date: Thu, 21 May 2009 10:43:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org> <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org> <20090519142656T.fujita.tomonori@lab.ntt.co.jp> <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org>
In-Reply-To: <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Becky Bruce wrote:
>>
>>
>> If we have something like in arch/{x86|ia64|powerpc}/dma-mapping.h:
>>
>> static inline int is_buffer_dma_capable(struct device *dev, 
>> dma_addr_t addr, size_t size)
>>
>> then we don't need two checking functions, address_needs_mapping and
>> range_needs_mapping.
>
> It's never been clear to me *why* we had both in the first place - if 
> you can explain this, I'd be grateful :)

I was about to ask the same thing.  It seems that range_needs_mapping 
should be able to do both jobs.

I think range_needs_mapping came from the Xen swiotlb changes, and 
address_needs_mapping came from your powerpc changes.   Many of the 
changes were exact overlaps; I think this was one of the few instances 
where there was a difference.

We need a range check in Xen (rather than iterating over individual 
pages) because we want to check that the underlying pages are machine 
contiguous, but I think that's also sufficient to do whatever checks you 
need to do.

The other difference is that is_buffer_dma_capable operates on a 
dma_addr_t, which presumes that you can generate a dma address and then 
test for its validity.  For Xen, it doesn't make much sense to talk 
about the dma_addr_t for memory which isn't actually dma-capable; we 
need the test to be in terms of phys_addr_t.  Given that the two 
functions are always called from the same place, that doesn't seem to 
pose a problem.

So I think the unified function would be something like:

    int range_needs_mapping(struct device *hwdev, phys_addr_t addr,
    size_t size);

which would be defined somewhere under asm/*.h.  Would that work for 
powerpc?

    J
