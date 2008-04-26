Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbYDZUPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbYDZUPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbYDZUPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:15:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:38188 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759685AbYDZUPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CblfU+5tNPexZxW5XBuEHlJFIMfNE2PYDzKBz1kHuwG9+HsFYgAO3r1IhRudYVRL9HRbjaA2qTUMZxjesURhOxDZIZ4gJo5o5HKzV1OTKgV5T8Nru75Z0YoZPAjgdVubfCVOrt9gj81aXG8TaX+8UmPJzojuvOnjOVRvRzhLYqE=
Subject: Re: [git pull] x86 fix
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20080426194745.GA11557@elte.hu>
References: <20080426194745.GA11557@elte.hu>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 13:15:36 -0700
Message-Id: <1209240937.14173.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 21:47 +0200, Ingo Molnar wrote:
> Linus, please pull this x86 fix from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes2.git for-linus
> 
> Thanks,
> 
> 	Ingo
> 
> ------------------>
> Venki Pallipadi (1):
>       x86, PAT: disable /dev/mem mmap RAM with PAT
> 
>  arch/x86/mm/pat.c |   31 +++++++++++++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 9851265..e7ca7fc 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -16,6 +16,7 @@
>  #include <asm/msr.h>
>  #include <asm/tlbflush.h>
>  #include <asm/processor.h>
> +#include <asm/page.h>
>  #include <asm/pgtable.h>
>  #include <asm/pat.h>
>  #include <asm/e820.h>
> @@ -477,6 +478,33 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>  	return vma_prot;
>  }
>  
> +#ifdef CONFIG_NONPROMISC_DEVMEM
> +/* This check is done in drivers/char/mem.c in case of NONPROMISC_DEVMEM*/
> +static inline int range_is_allowed(unsigned long pfn, unsigned long size)
> +{
> +	return 1;
> +}
> +#else
> +static inline int range_is_allowed(unsigned long pfn, unsigned long size)

inline?  Seems a bit big to me.

> +{
> +	u64 from = ((u64)pfn) << PAGE_SHIFT;
> +	u64 to = from + size;
> +	u64 cursor = from;
> +
> +	while (cursor < to) {
> +		if (!devmem_is_allowed(pfn)) {
> +			printk(KERN_INFO
> +		"Program %s tried to access /dev/mem between %Lx->%Lx.\n",
> +				current->comm, from, to);
> +			return 0;
> +		}
> +		cursor += PAGE_SIZE;
> +		pfn++;
> +	}
> +	return 1;
> +}
> +#endif /* CONFIG_NONPROMISC_DEVMEM */
> +

Cheers,

Harvey

