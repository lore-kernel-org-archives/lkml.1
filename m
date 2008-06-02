Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYFBTpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYFBTpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYFBTo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:44:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:50265 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYFBTo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=viEF7VBNGKdEtn2uToRFFdHGA15CYkZFT/PmRUJc4W8fsXTfb8GLmjkZmTmAvYqCoZ5FtciuG12nxaubrohUOQjqQ5RjkyUkHShHGNhlfUTHPg4GaRZIiaQbAcHYsk4Oe4CAwWN67SGBduESXiJQZJ/Wr26s0RACwVCzqcDwrWk=
Message-ID: <86802c440806021244u1c57f74dq9e581438f1365bbb@mail.gmail.com>
Date: Mon, 2 Jun 2008 12:44:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: More e820 unification?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <484448F6.9000403@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48441AFF.3020204@goop.org>
	 <86802c440806021114m51ba9148ge69d8ded228d888f@mail.gmail.com>
	 <484448F6.9000403@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 12:24 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> [PATCH] x86: cleanup max_pfn_mapped usage - 32bit
>> may need you update xen pv to specify max_pfn_mapped early stage...
>
> Ah, yes, I saw your mail.  What exactly does that value mean?  What should I
> set it to?

arch/x86/kernel/head_32.S doesn't know max_low_pfn yet, so it could
initialize initial_pg_table to cover much less of the max_low_pfn.
it will need paging_init/pagetable_init/kernel_phys... to initialize
mapping to max_low_pfn.
but that is too late. it said need to use alloc_bootmem_low_pages to
get bootmem, other wise even you can get it > mem_mapped, you can not
use.
two memory region must be get via find_e820_area even before bootmem is there.
bootmap for bootmem, and pgdat for node0 in numa_32. so it need to
take the really mapped as parameter for that func, instead of
max_low_pfn.

We can get the real max_pfn_mapped in head_32.S when finish the
initial page table.

for XEN PV, when you are preparing the init pg table in domain
builder, you should keep the max_pfn_mapped ...

64 bit doesn't need that, because it call init_memory_mapping very
earlier..., and it cover all memory.

YH
