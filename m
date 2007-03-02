Return-Path: <linux-kernel-owner+w=401wt.eu-S1422957AbXCBGYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422957AbXCBGYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 01:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422959AbXCBGYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 01:24:08 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:38663 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422957AbXCBGYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 01:24:07 -0500
Message-ID: <45E7C306.4080400@vmware.com>
Date: Thu, 01 Mar 2007 22:24:06 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Vmi fix highpte
References: <200703020254.l222smBB009668@zach-dev.vmware.com> <45E79529.9000305@goop.org> <45E79C72.4000806@goop.org>
In-Reply-To: <45E79C72.4000806@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Hm, I don't think this interface will work for Xen.  In Xen, whenever a
>> pagetable page gets mapped, it must be mapped RO.  map_pt_hook gets
>> called after the mapping has already been created, so its too late for Xen.
>>
>> I was planning on adding kmap_atomic_pte() for use in pte_offset_map*(),
>> which would be wired through to paravirt_ops to allow Xen to make this a
>> RO mapping.  Would this be sufficient for you to do your vmi thing?
>>   
>>     
>
> Something like this (compiled, untested).
>
>     J
>
> diff -r 972e84c265cf arch/i386/kernel/paravirt.c
> --- a/arch/i386/kernel/paravirt.c	Thu Mar 01 19:12:49 2007 -0800
> +++ b/arch/i386/kernel/paravirt.c	Thu Mar 01 19:38:42 2007 -0800
> @@ -32,6 +32,7 @@
>  #include <asm/fixmap.h>
>  #include <asm/apic.h>
>  #include <asm/tlbflush.h>
> +#include <asm/highmem.h>
>  
>  /* nop stub */
>  void _paravirt_nop(void)
> @@ -605,6 +606,8 @@ struct paravirt_ops paravirt_ops = {
>  
>  	.kpte_clear_flush = native_kpte_clear_flush,
>  
> +	.kmap_atomic_pte = native_kmap_atomic_pte,
> +
>   

That doesn't quite work, since we need to know which of the two - 
KM_PTE0 or KM_PTE1 is being mapped.  But it could be moved to before the 
mapping, as you need, and take this as a parameter.

Zach
