Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYBNQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYBNQia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYBNQiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:38:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46352 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbYBNQiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:38:22 -0500
Date: Thu, 14 Feb 2008 18:14:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Fix direct mapping correctly in ioremap
Message-ID: <20080214171402.GB16255@one.firstfloor.org>
References: <20080214115905.GA18573@basil.nowhere.org> <20080214160322.GA27530@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214160322.GA27530@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 05:03:23PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > -	if (ioremap_change_attr(vaddr, size, mode) < 0) {
> > +	/* Fix up the direct mapping for the new cache attributes */
> > +	err = ioremap_change_attr((unsigned long)__va(phys_addr),
> > +				size + offset, mode);
> 
> Ugh. This would break the 32-bit kernel - if any phys_addr larger than 
> 1GB is passed in (which is the common case on 32-bit) then we'll start 
> changing the attributes of random (most likely user-space) pages!
> That is because on 32-bit __va() does this:
> 
>   #define __va(x)                  ((void *)((unsigned long)(x)+PAGE_OFFSET))
> 
> where on 32-bit 3GB:1GB split PAGE_OFFSET is defined to 0xc0000000.
> 
> So if a driver passes in the physical address of a PCI device with a BAR 
> at 0xe1000000 somewhere in the PCI aperture, we'll get 
> 0xe1000000+0xc0000000 == 0x91000000 - right in the middle of user-space.
> 
> Changing attributes there is very wrong. (it could even crash the kernel 
> in certain circumstances.)

True. It needs a end_pfn_map check.  I'll revise.

> Have you tried to boot this patch on 32-bit? There are a couple of new 

Yes, it booted on several machines.  Don't think I saw CPA messages,
but i might have missed them.

> safety nets in the cpa code that would/should trigger very visibly - 
> such as the warning here:
> 
>                 if (!pte_val(old_pte)) {
>                         printk(KERN_WARNING "CPA: called for zero pte. "
>                                "vaddr = %lx cpa->vaddr = %lx\n", address,
>                                 cpa->vaddr);
>                         WARN_ON(1);
>                         return -EINVAL;
>                 }
> 
> (these are already there in -git)
> 
> Please have a look at how we solved the "secondary alias" 64-bit problem 
> in x86.git#mm and please resend against x86.git#mm if you still think 
> something is missing. Thanks,

I want this regression fixed in .25, so #mm is not an option for this.

-Andi

