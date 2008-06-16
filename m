Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbYFPI6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbYFPI6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760853AbYFPI57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:57:59 -0400
Received: from as1.cineca.com ([130.186.84.213]:50596 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760098AbYFPI55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:57:57 -0400
Message-ID: <485625D9.6040508@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       yamamoto@valinux.co.jp, menage@google.com, linux-kernel@vger.kernel.org,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm] PAGE_ALIGN(): correctly handle 64-bit values on 32-bit
 architectures (v2)
References: <1213543436-15254-1-git-send-email-righi.andrea@gmail.com> <18517.39513.867328.171299@cargo.ozlabs.ibm.com>
In-Reply-To: <18517.39513.867328.171299@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 10:35:37 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Andrea Righi writes:
> 
>> Also move the PAGE_ALIGN() definitions out of include/asm-*/page.h in
>> include/linux/mm.h.
> 
> I'd rather see it in some other place than this, because
> include/linux/mm.h is a large header that includes quite a lot of
> other stuff.  What's wrong with leaving it in each arch's page.h and
> only changing it on those archs that have both 32-bit and 64-bit
> variants?  Or perhaps there is some other, lower-level header in
> include/linux where it could go?

I think the only evident advantage of this is to have a single
implementation, instead of dealing with (potentially) N different
implementations.

Maybe a different place could be linux/mm_types.h, it's not so small,
but at least it's smaller than linux/mm.h. However, it's a bit ugly to
put a "function" in a file called mm_types.h.

Anyway, I've to say that fixing PAGE_ALIGN and leaving it in each page.h
for now would be surely a simpler solution and would introduce less
potential errors.

> 
>> diff --git a/arch/powerpc/boot/of.c b/arch/powerpc/boot/of.c
>> index 61d9899..6bc72b1 100644
>> --- a/arch/powerpc/boot/of.c
>> +++ b/arch/powerpc/boot/of.c
>> @@ -8,6 +8,7 @@
>>   */
>>  #include <stdarg.h>
>>  #include <stddef.h>
>> +#include <linux/mm.h>
>>  #include "types.h"
>>  #include "elf.h"
>>  #include "string.h"
>> diff --git a/arch/powerpc/boot/page.h b/arch/powerpc/boot/page.h
>> index 14eca30..aa42298 100644
>> --- a/arch/powerpc/boot/page.h
>> +++ b/arch/powerpc/boot/page.h
>> @@ -28,7 +28,4 @@
>>  /* align addr on a size boundary - adjust address up if needed */
>>  #define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
>>  
>> -/* to align the pointer to the (next) page boundary */
>> -#define PAGE_ALIGN(addr)	_ALIGN(addr, PAGE_SIZE)
>> -
>>  #endif				/* _PPC_BOOT_PAGE_H */
> 
> These parts are NAKed, because arch/powerpc/boot is a separate program
> that doesn't use the kernel include files.

OK, so we also shouldn't use the linux/kernel.h's ALIGN() here, but leave
the local _ALIGN() definition, right?

> 
>> diff --git a/include/asm-powerpc/page.h b/include/asm-powerpc/page.h
>> index cffdf0e..e088545 100644
>> --- a/include/asm-powerpc/page.h
>> +++ b/include/asm-powerpc/page.h
>> @@ -119,9 +119,6 @@ extern phys_addr_t kernstart_addr;
>>  /* align addr on a size boundary - adjust address up if needed */
>>  #define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
>>  
>> -/* to align the pointer to the (next) page boundary */
>> -#define PAGE_ALIGN(addr)	_ALIGN(addr, PAGE_SIZE)
>> -
>>  /*
>>   * Don't compare things with KERNELBASE or PAGE_OFFSET to test for
>>   * "kernelness", use is_kernel_addr() - it should do what you want.
> 
> We had already come across this issue on powerpc, and we fixed it by
> making sure that the type of PAGE_MASK was int, not unsigned int.
> However, I have no objection to using the ALIGN() macro from
> include/linux/kernel.h instead.

Thanks,
-Andrea
