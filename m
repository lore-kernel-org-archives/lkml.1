Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbYCZMK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbYCZMK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYCZMKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:10:19 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:59922 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYCZMKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:10:17 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: sparc64 BUG: using smp_processor_id() in preemptible
Date: Wed, 26 Mar 2008 13:10:12 +0100
User-Agent: KMail/1.9.7
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
References: <20080326.041626.224135350.davem@davemloft.net> <200803261246.53770.m.kozlowski@tuxland.pl> <20080326.045143.218956952.davem@davemloft.net>
In-Reply-To: <20080326.045143.218956952.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803261310.12556.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Date: Wed, 26 Mar 2008 12:46:53 +0100
> 
> > Ok it worked. Now I get a bunch of these:
> > 
> > BUG: using smp_processor_id() in preemptible [00000000] code: pidof/2471
> > caller is flush_ptrace_access+0xc0/0x1a0
> 
> Here ya go:
> 
> commit f6a843d939ade435e060d580f5c56d958464f8a5
> Author: David S. Miller <davem@davemloft.net>
> Date:   Wed Mar 26 04:51:12 2008 -0700
> 
>     [SPARC64]: flush_ptrace_access() needs preemption disable.
>     
>     Based upon a report by Mariusz Kozlowski.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/arch/sparc64/kernel/ptrace.c b/arch/sparc64/kernel/ptrace.c
> index bcf58ec..aaae865 100644
> --- a/arch/sparc64/kernel/ptrace.c
> +++ b/arch/sparc64/kernel/ptrace.c
> @@ -70,6 +70,8 @@ void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
>  	if (tlb_type == hypervisor)
>  		return;
>  
> +	preempt_disable();
> +
>  #ifdef DCACHE_ALIASING_POSSIBLE
>  	/* If bit 13 of the kernel address we used to access the
>  	 * user page is the same as the virtual address that page
> @@ -108,6 +110,8 @@ void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
>  		for (; start < end; start += icache_line_size)
>  			flushi(start);
>  	}
> +
> +	preempt_enable();
>  }
>  
>  enum sparc_regset {

And this one also worked. Now I have a nice clean dmesg :)

Thanks,

	Mariusz
