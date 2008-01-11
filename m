Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYAKIP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYAKIP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYAKIPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:15:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50374 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbYAKIPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:15:17 -0500
Date: Fri, 11 Jan 2008 09:14:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, ebiederm@xmission.com,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART early v2
Message-ID: <20080111081446.GA6234@elte.hu>
References: <200801101914.47967.yinghai.lu@sun.com> <200801102354.46472.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801102354.46472.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -218,6 +218,73 @@ static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
>  	return 0;
>  }
>  
> +void __init early_gart_iommu_disable(void)
> +{
> +	/*
> +	 * disable it in case it is enabled before, esp for kexec/kdump,
> +	 * previous kernel already enable that. otherwise memset called
> +	 * by allocate_aperture/__alloc_bootmem_nopanic cause restart.
> +	 * or second kernel have different position for GART hole. and new
> +	 * kernel could use hole as RAM that is still used by GART set by
> +	 * first kernel
> +	 */

hm, i'm wondering, instead of modifying the GART, why dont we simply 
_detect_ whatever GART settings we have inherited, and propagate that 
into our e820 maps? I.e. if there's inconsistency, then punch that out 
from the memory maps and just dont use that memory.

that way it would not matter whether the GART settings came from a [old 
or crashing] Linux kernel that has not called gart_iommu_shutdown(), or 
whether it's a BIOS that has set up an aperture hole inconsistent with 
the memory map it passed. (or the memory map we _think_ i tried to pass 
us)

it would also be more robust to only read and do a memory map quirk 
based on that, than actively trying to change the GART so early in the 
bootup. Later on we have to re-enable the GART _anyway_ and have to 
punch a hole for it.

and as a bonus, we would have shored up our defenses against crappy 
BIOSes as well.

	Ingo
