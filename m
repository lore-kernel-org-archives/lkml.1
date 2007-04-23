Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbXDWKcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbXDWKcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbXDWKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:32:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbXDWKb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:31:59 -0400
Message-ID: <462C8B0A.8060801@redhat.com>
Date: Mon, 23 Apr 2007 06:31:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com> <462BFAF3.4040509@yahoo.com.au> <462C2DC7.5070709@redhat.com> <462C2F33.8090508@redhat.com> <462C7A6F.9030905@redhat.com> <462C88B1.8080906@yahoo.com.au>
In-Reply-To: <462C88B1.8080906@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

>> It looks like the tlb flushes (and IPIs) from zap_pte_range()
>> could have been the problem.  They're gone now.
> 
> I guess it is a good idea to batch these things. But can you
> do that on all architectures? What happens if your tlb flush
> happens after another thread already accesses it again, or
> after it subsequently gets removed from the address space via
> another CPU?

I have thought about this a lot tonight, and have come to the conclusion
that they are ok.

The reason is simple:

1) we do the TLB flush before we return from the
    madvise(MADV_FREE) syscall.

2) anything that accessess the pages between the start
    and end of the MADV_FREE procedure does not know in
    which order we go through the pages, so it could hit
    a page either before or after we get to processing
    it

3) because of this, we can treat any such accesses as
    happening simultaneously with the MADV_FREE and
    as illegal, aka undefined behaviour territory and
    we do not need to worry about them

4) because we flush the tlb before releasing the page
    table lock, other CPUs cannot remove this page from
    the address space - they will block on the page
    table lock before looking at this pte

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
