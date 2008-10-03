Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYJCSMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYJCSMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 14:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYJCSLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 14:11:52 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:36044 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYJCSLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 14:11:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EZOGfbXNqmGLQMG3gyy87fAijD3tREbE5rQBLULj25EeYN8aq8KbGES2XZGS4CKI6q
         ttksUhe5ob++pYV5IAT3UXNbA1v25bWhc+HqGsgizzhaT49AKKPnoz9cqGkWfKVe6bz4
         wKC8RWU17OZgfcLM1JBFqBdI/bpEhN0pc41us=
Message-ID: <48E6604F.8000404@gmail.com>
Date: Fri, 03 Oct 2008 20:11:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
 (try 2)
References: <20081003155425.GA6112@localhost.localdomain>
In-Reply-To: <20081003155425.GA6112@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum napsal(a):
> Is this what you had in mind? If not, then I don't know how to do it :-)

Yeah, something like that, but I am not the one you need ACK from ;).

Few notes below.

> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 835e062..b20389d 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -45,6 +45,28 @@ unsigned long __phys_addr(unsigned long x)
>  }
>  EXPORT_SYMBOL(__phys_addr);
>  
> +bool __virt_addr_valid(unsigned long x)
> +{
> +	if (x >= __START_KERNEL_map) {
> +		x -= __START_KERNEL_map;
> +		if (x >= KERNEL_IMAGE_SIZE)
> +			return false;
> +		x += phys_base;
> +	} else {
> +		if (x < PAGE_OFFSET)
> +			return false;
> +		x -= PAGE_OFFSET;
> +		if (system_state == SYSTEM_BOOTING
> +			? x > MAXMEM : !phys_addr_valid(x))
> +		{
> +			return false;
> +		}
> +	}
> +
> +	return pfn_valid(x >> PAGE_SHIFT);
> +}
> +EXPORT_SYMBOL(__virt_addr_valid);

Just an implementation note. Still don't expect address for which
__virt_addr_valid() returns true to not cause a page fault. If it is called
e.g. for address between __START_KERNEL_map and
__START_KERNEL_map+KERNEL_IMAGE_SIZE and its pte entry has present bit
unset, it will crash when dereferenced -- unused pages above kernel image
are unmapped during boot.

> +
>  #else
[...]
> +bool __virt_addr_valid(unsigned long x)
> +{
> +	if (x < PAGE_OFFSET)
> +		return false;
> +	if (system_state != SYSTEM_BOOTING && is_vmalloc_addr((void *) x))
> +		return false;
> +	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
> +}

Here too, the mappings at the top are probably returned as true? Absolutely
not sure about this (what returns pfn_valid on those corresponding physical
addresses).

>  #endif
>  
>  int page_is_ram(unsigned long pagenr)
