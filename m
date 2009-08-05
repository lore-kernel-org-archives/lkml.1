Return-Path: <linux-kernel-owner+w=401wt.eu-S934376AbZHENr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376AbZHENr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933655AbZHENr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:47:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51782 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933555AbZHENrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:47:25 -0400
Date: Wed, 5 Aug 2009 09:46:51 -0400
From: Neil Horman <nhorman@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 4/7] ia64: implement crashkernel=auto
Message-ID: <20090805134651.GF7259@hmsreliant.think-freely.org>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain> <20090805112201.6552.13193.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805112201.6552.13193.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 07:19:41AM -0400, Amerigo Wang wrote:
> 
> Since in patch 2/7 we already implement the generic part, this will
> add the rest part for ia64.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> Index: linux-2.6/arch/ia64/include/asm/kexec.h
> ===================================================================
> --- linux-2.6.orig/arch/ia64/include/asm/kexec.h
> +++ linux-2.6/arch/ia64/include/asm/kexec.h
> @@ -19,6 +19,29 @@
>                  flush_icache_range(page_addr, page_addr + PAGE_SIZE); \
>          } while(0)
>  
> +#ifdef CONFIG_KEXEC_AUTO_RESERVE
> +#ifndef KEXEC_AUTO_RESERVED_SIZE
> +#define KEXEC_AUTO_RESERVED_SIZE 1ULL<<28 /* 256M */
> +#endif
> +#ifndef KEXEC_AUTO_THRESHOLD
> +#define KEXEC_AUTO_THRESHOLD 1ULL<<32 /* 4G */
> +#endif
> +static inline
> +unsigned long long arch_default_crash_size(unsigned long long total_size)
> +{
> +	if (total_size < KEXEC_AUTO_THRESHOLD)
> +		return 0;
> +	else
> +		return KEXEC_AUTO_RESERVED_SIZE;
> +}
> +static inline
> +unsigned long long arch_default_crash_base(void)
> +{
> +	/* On ia64, 0 means find the base address automatically. */
> +	return 0;
> +}
> +#endif
> +
>  extern struct kimage *ia64_kimage;
>  extern const unsigned int relocate_new_kernel_size;
>  extern void relocate_new_kernel(unsigned long, unsigned long,


Scratch my previous comment about the other arches, I see you're doing them in
individual patches here.  You should probably re-organize the set so that these
definitions are in place prior to the addition of the call sites though (just to
avoid inadvertent build breaks if someone tries to turn AUTO_RESERE on in the
middle of this commit series.  And I still think making this a definition in
asm-generic might be worth while, since it seems to be the same or simmilar for
all arches.

Neil

