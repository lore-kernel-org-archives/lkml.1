Return-Path: <linux-kernel-owner+w=401wt.eu-S937311AbYD1Uau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937311AbYD1Uau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934305AbYD1Uaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:30:39 -0400
Received: from www.tglx.de ([62.245.132.106]:55157 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765866AbYD1Uai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:30:38 -0400
Date: Mon, 28 Apr 2008 22:30:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] ARCH: Fix 32-bit x86 MSI-X allocation leakage
In-Reply-To: <20080426005850.7098.77479.stgit@scrappy.jf.intel.com>
Message-ID: <alpine.LFD.1.10.0804282216570.3261@apollo.tec.linutronix.de>
References: <20080426005850.7098.77479.stgit@scrappy.jf.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008, PJ Waskiewicz wrote:
> This bug was introduced in the 2.6.24 i386/x86_64 tree merge, where

Can you please explain what exactly caused the bug. Definitely not the
move from arch/i386 to arch/x86 as the code there was not changed at
all and has not be changed since then.

CC'ed Eric as well.

Thanks
	tglx


> MSI-X vector allocation will eventually fail.  The cause is the new
> bit array tracking used vectors is not getting cleared properly on
> IRQ destruction on the 32-bit APIC code.
> 
> This can be seen easily using the ixgbe 10 GbE driver on multi-core
> systems by simply loading and unloading the driver a few times.
> Depending on the number of available vectors on the host system, the
> MSI-X allocation will eventually fail, and the driver will only be
> able to use legacy interrupts.
> 
> I am generating the same patch for both stable trees for 2.6.24 and
> 2.6.25.
> 
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> ---
> 
>  arch/x86/kernel/io_apic_32.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
> index 2e2f420..77798b1 100644
> --- a/arch/x86/kernel/io_apic_32.c
> +++ b/arch/x86/kernel/io_apic_32.c
> @@ -2444,6 +2444,7 @@ void destroy_irq(unsigned int irq)
>  	dynamic_irq_cleanup(irq);
>  
>  	spin_lock_irqsave(&vector_lock, flags);
> +	clear_bit(irq_vector[irq], used_vectors);
>  	irq_vector[irq] = 0;
>  	spin_unlock_irqrestore(&vector_lock, flags);
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
