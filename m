Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbXBXCm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbXBXCm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 21:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933352AbXBXCm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 21:42:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:45409 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933345AbXBXCm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 21:42:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,213,1170662400"; 
   d="scan'208"; a="50112429:sNHT19897371"
Date: Fri, 23 Feb 2007 18:06:55 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 14/14] genirq: Mask irqs when migrating them.
Message-ID: <20070223180655.B2120@unix-os.sc.intel.com>
References: <m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com> <m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com> <m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com> <m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com> <m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com> <m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com> <m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com> <m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com> <m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com> <m1hctdt7ub.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <m1hctdt7ub.fsf_-_@ebiederm.dsl.xmission.com>; from ebiederm@xmission.com on Fri, Feb 23, 2007 at 04:46:20AM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, This is a bug fix and must go in before 2.6.21.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

On Fri, Feb 23, 2007 at 04:46:20AM -0700, Eric W. Biederman wrote:
> 
> move_native_irqs tries to do the right thing when migrating irqs
> by disabling them.  However disabling them is a software logical
> thing, not a hardware thing.  This has always been a little flaky
> and after Ingo's latest round of changes it is guaranteed to not
> mask the apic.
> 
> So this patch fixes move_native_irq to directly call the mask and
> unmask chip methods to guarantee that we mask the irq when we
> are migrating it.  We must do this as it is required by
> all code that call into the path.
> 
> Since we don't know the masked status when IRQ_DISABLED is
> set so we will not be able to restore it.   The patch makes the code
> just give up and trying again the next time this routing is called.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  kernel/irq/migration.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
> index 4baa3bb..77b7acc 100644
> --- a/kernel/irq/migration.c
> +++ b/kernel/irq/migration.c
> @@ -65,12 +65,11 @@ void move_native_irq(int irq)
>  	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
>  		return;
>  
> -	if (likely(!(desc->status & IRQ_DISABLED)))
> -		desc->chip->disable(irq);
> +	if (unlikely(desc->status & IRQ_DISABLED))
> +		return;
>  
> +	desc->chip->mask(irq);
>  	move_masked_irq(irq);
> -
> -	if (likely(!(desc->status & IRQ_DISABLED)))
> -		desc->chip->enable(irq);
> +	desc->chip->unmask(irq);
>  }
>  
> -- 
> 1.5.0.g53756
