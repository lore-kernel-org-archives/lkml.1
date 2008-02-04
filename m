Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYBDBKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYBDBKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 20:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYBDBKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 20:10:33 -0500
Received: from simmts5.bellnexxia.net ([206.47.199.163]:59284 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbYBDBKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 20:10:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAPL0pUecIvlD/2dsb2JhbAAIqnc
Message-ID: <47A66602.1040907@gmail.com>
Date: Sun, 03 Feb 2008 21:10:26 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest -git ioremap error
References: <47A606B5.7090001@gmail.com> <47A608F8.5080206@gmail.com> <20080203213353.GB27737@elte.hu>
In-Reply-To: <20080203213353.GB27737@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
>>>     x86: fix ioremap RAM check
>>>
>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Lucky first try - reverting this commit fixes the problem for me.  Any 
>> ideas?
> 
> Could you check the patch below - does that too fix the problem for you?
> 

Yes, the patch below fixes the problem.  I guess that makes it a:

Tested-by: Kevin Winchester <kjwinchester@gmail.com>


> 	Ingo
> 
> ----------------->
> Subject: x86: relax RAM check in ioremap()
> From: Ingo Molnar <mingo@elte.hu>
> 
> Kevin Winchester reported the loss of direct rendering, due to:
> 
> [    0.588184] agpgart: Detected AGP bridge 0
> [    0.588184] agpgart: unable to get memory for graphics translation table.
> [    0.588184] agpgart: agp_backend_initialize() failed.
> [    0.588207] agpgart-amd64: probe of 0000:00:00.0 failed with error -12
> 
> and bisected it down to:
> 
>> commit 266b9f8727976769e2ed2dad77ac9295f37e321e
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Wed Jan 30 13:34:06 2008 +0100
>>
>>     x86: fix ioremap RAM check
> 
> this check was too strict and caused an ioremap() failure.
> 
> the problem is due to the somewhat unclean way of how the GART code
> reserves a memory range for its aperture, and how it utilizes it
> later on.
> 
> Allow RAM pages to be ioremap()-ed too, as long as they are reserved.
> 
> Bisected-by: Kevin Winchester <kjwinchester@gmail.com>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/ioremap.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-x86.q/arch/x86/mm/ioremap.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/mm/ioremap.c
> +++ linux-x86.q/arch/x86/mm/ioremap.c
> @@ -116,7 +116,7 @@ static void __iomem *__ioremap(unsigned 
>  {
>  	void __iomem *addr;
>  	struct vm_struct *area;
> -	unsigned long offset, last_addr;
> +	unsigned long pfn, offset, last_addr;
>  	pgprot_t prot;
>  
>  	/* Don't allow wraparound or zero size */
> @@ -133,9 +133,9 @@ static void __iomem *__ioremap(unsigned 
>  	/*
>  	 * Don't allow anybody to remap normal RAM that we're using..
>  	 */
> -	for (offset = phys_addr >> PAGE_SHIFT; offset < max_pfn_mapped &&
> -	     (offset << PAGE_SHIFT) < last_addr; offset++) {
> -		if (page_is_ram(offset))
> +	for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
> +	     (pfn << PAGE_SHIFT) < last_addr; pfn++) {
> +		if (pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
>  			return NULL;
>  	}
>  
