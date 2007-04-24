Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXDXBP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXDXBP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXDXBP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:15:57 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:42597 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753289AbXDXBP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:15:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=kQB9AIDN0YjJcO776w5GR3pPxeWJp71mFwaf+OfI5KHEuxVyPYFGXMxNWgUvwa/4v/eMvAUKvN62lQfEAIS6XZ5wlYu3AID6YEiwpxhcHlv6cOsIm5RrpEBR9bkHWpIRE/vXvqjAXc9JhxcaH77NMVrfWmpSv3bjWuHSwcDDV90=  ;
Message-ID: <462D5A2E.5060908@yahoo.com.au>
Date: Tue, 24 Apr 2007 11:15:26 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com> <462BFAF3.4040509@yahoo.com.au> <462C2DC7.5070709@redhat.com> <462C2F33.8090508@redhat.com> <462C7A6F.9030905@redhat.com> <462C88B1.8080906@yahoo.com.au> <462C8B0A.8060801@redhat.com> <462C8BFF.2050405@yahoo.com.au> <462C8E1D.8000706@redhat.com>
In-Reply-To: <462C8E1D.8000706@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Use TLB batching for MADV_FREE.  Adds another 10-15% extra performance
> to the MySQL sysbench results on my quad core system.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> 
> Nick Piggin wrote:
> 
>>> 3) because of this, we can treat any such accesses as
>>>    happening simultaneously with the MADV_FREE and
>>>    as illegal, aka undefined behaviour territory and
>>>    we do not need to worry about them
>>
>>
>> Yes, but I'm wondering if it is legal in all architectures.
> 
> 
> It's similar to trying to access memory during an munmap.
> 
> You may be able to for a short time, but it'll come back to
> haunt you.

The question is whether the architecture specific tlb
flushing code will break or not.


>>> 4) because we flush the tlb before releasing the page
>>>    table lock, other CPUs cannot remove this page from
>>>    the address space - they will block on the page
>>>    table lock before looking at this pte
>>
>>
>> We don't when the ptl is split.
> 
> 
> Even then we do.  Each invocation of zap_pte_range() only touches
> one page table page, and it flushes the TLB before releasing the
> page table lock.

What kernel are you looking at? -rc7 and rc6-mm1 don't, AFAIKS.

-- 
SUSE Labs, Novell Inc.
