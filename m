Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZBQVYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZBQVYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZBQVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:24:30 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34905 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbZBQVY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:24:29 -0500
Subject: Re: [tip:x86/headers] x86: truncate ISA addresses to unsigned int
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
       linux-kernel@vger.kernel.org
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-a7eb518998529c08cc53fef17756d9fe433b0c23@kernel.org>
References: <tip-a7eb518998529c08cc53fef17756d9fe433b0c23@kernel.org>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 15:24:25 -0600
Message-Id: <1234905865.23466.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 21:12 +0000, H. Peter Anvin wrote:
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Tue, 17 Feb 2009 13:01:51 -0800
> Commit:     H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 17 Feb 2009 13:01:51 -0800
> 
> x86: truncate ISA addresses to unsigned int
> 
> Impact: Cleanup; fix inappropriate macro use
> 
> ISA addresses on x86 are mapped 1:1 with the physical address space.
> Since the ISA address space is only 24 bits (32 for VLB or LPC) it
> will always fit in an unsigned int, and at least in the aha1542 driver
> using a wider type would cause an undesirable promotion.  Hence
> explicitly cast the ISA bus addresses to unsigned int.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> 
> 
> ---
>  arch/x86/include/asm/io.h |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index 4f8e820..683d0b4 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -124,10 +124,15 @@ static inline void *phys_to_virt(phys_addr_t address)
>  
>  /*
>   * ISA I/O bus memory addresses are 1:1 with the physical address.
> + * However, we truncate the address to unsigned int to avoid undesirable
> + * promitions in legacy drivers.
>   */
> -#define isa_virt_to_bus (unsigned long)virt_to_phys
> -#define isa_page_to_bus page_to_phys
> -#define isa_bus_to_virt phys_to_virt
> +static inline unsigned int isa_virt_to_bus(volatile void *address)

The rest looks fine, but why is the address volatile?  The macro below
never actually dereferences it.

> +{
> +	return (unsigned int)virt_to_phys(address);
> +}
> +#define isa_page_to_bus(page)	((unsigned int)page_to_phys(page))
> +#define isa_bus_to_virt		phys_to_virt
>  
>  /*
>   * However PCI ones are not necessarily 1:1 and therefore these interfaces

James


