Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbXIFMWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbXIFMWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbXIFMWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:22:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49127 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbXIFMWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:22:12 -0400
Date: Thu, 6 Sep 2007 18:05:24 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Michael Stiller <ms@2scale.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING native_smp_call_function mask 2.6.22.6 SMP on Single
 CPU System
In-Reply-To: <1189076403.3595.17.camel@blackberry>
Message-ID: <alpine.LFD.0.999.0709061803030.3781@enigma.security.iitk.ac.in>
References: <1189076403.3595.17.camel@blackberry>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Sep 2007, Michael Stiller wrote:

> Hi,
> 
> i get the following warning if i call vfree some memory allocated by
> vmalloc on a single cpu machine running 2.6.22.6 SMP:
> 
> WARNING: at arch/i386/kernel/smp.c:559 native_smp_call_function_mask()
>  [<c010e77c>] native_smp_call_function_mask+0x145/0x14a
>  [<c01cb32d>] idr_remove+0x102/0x163
>  [<c010e43f>] do_flush_tlb_all+0x0/0x59
>  [<c010e43f>] do_flush_tlb_all+0x0/0x59
>  [<c010ea33>] smp_call_function+0x1c/0x29
>  [<c0120922>] on_each_cpu+0x18/0x29
>  [<c010e2e9>] flush_tlb_all+0x1b/0x1f
>  [<c0155227>] remove_vm_area+0x4c/0x59
>  [<c0155252>] __vunmap+0x1e/0xe5
>  [<c011ccb7>] printk+0x1b/0x1f
>  [<e0b15f21>] ring_release+0x1f7/0x28a [ring]

There's no ring_release() in 2.6.22 -- at least doesn't show up in a grep.

>  [<c0247305>] sock_fasync+0x99/0x146
>  [<c024826b>] sock_release+0x14/0x66
>  [<c02486a8>] sock_close+0x1e/0x38
>  [<c01600ee>] __fput+0x99/0x166
>  [<c015db9f>] filp_close+0x3e/0x62
>  [<c015ebf0>] sys_close+0x5f/0x9e
>  [<c0103dba>] syscall_call+0x7/0xb
>  =======================
> 
> I use the rvmalloc / rvfree functions copied from usbvideo.c:
> 
> static void rvfree(void *mem, unsigned long size)
> {
>         unsigned long adr;
>         unsigned long pages = 0;
> 
> #if defined(RING_DEBUG)
>         printk("RING: rvfree: %lu bytes\n", size);
> #endif
> 
>         if (!mem)
>                 return;
> 
>         adr = (unsigned long) mem;
>         while ((long) size > 0) {
>                 ClearPageReserved(vmalloc_to_page((void *)adr));
>                 pages++;
>                 adr += PAGE_SIZE;
>                 size -= PAGE_SIZE;
>         }
> #if defined(RING_DEBUG)
>         printk("RING: rvfree: %lu pages\n", pages);
>         printk("RING: rvfree: calling vfree....\n");
> #endif
>         vfree(mem);   // WARNING occurs here
>         printk("RING: rvfree: after vfree....\n");
> }
> 
> 
> Any clues? 

You can't call vfree() with irqs disabled. Looks like you called
ring_release() / rvfree() that way ...
