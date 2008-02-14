Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYBNQDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYBNQDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYBNQDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:03:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37698 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbYBNQDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:03:40 -0500
Date: Thu, 14 Feb 2008 17:03:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Fix direct mapping correctly in ioremap
Message-ID: <20080214160322.GA27530@elte.hu>
References: <20080214115905.GA18573@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214115905.GA18573@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> -	if (ioremap_change_attr(vaddr, size, mode) < 0) {
> +	/* Fix up the direct mapping for the new cache attributes */
> +	err = ioremap_change_attr((unsigned long)__va(phys_addr),
> +				size + offset, mode);

Ugh. This would break the 32-bit kernel - if any phys_addr larger than 
1GB is passed in (which is the common case on 32-bit) then we'll start 
changing the attributes of random (most likely user-space) pages!

That is because on 32-bit __va() does this:

  #define __va(x)                  ((void *)((unsigned long)(x)+PAGE_OFFSET))

where on 32-bit 3GB:1GB split PAGE_OFFSET is defined to 0xc0000000.

So if a driver passes in the physical address of a PCI device with a BAR 
at 0xe1000000 somewhere in the PCI aperture, we'll get 
0xe1000000+0xc0000000 == 0x91000000 - right in the middle of user-space.

Changing attributes there is very wrong. (it could even crash the kernel 
in certain circumstances.)

Have you tried to boot this patch on 32-bit? There are a couple of new 
safety nets in the cpa code that would/should trigger very visibly - 
such as the warning here:

                if (!pte_val(old_pte)) {
                        printk(KERN_WARNING "CPA: called for zero pte. "
                               "vaddr = %lx cpa->vaddr = %lx\n", address,
                                cpa->vaddr);
                        WARN_ON(1);
                        return -EINVAL;
                }

(these are already there in -git)

Please have a look at how we solved the "secondary alias" 64-bit problem 
in x86.git#mm and please resend against x86.git#mm if you still think 
something is missing. Thanks,

	Ingo
