Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYGXVcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYGXVcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYGXVcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:32:33 -0400
Received: from saeurebad.de ([85.214.36.134]:45714 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYGXVcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:32:32 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, lomp0101@gmx.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 11046] New: Kernel bug in mm/bootmem.c on Sparc machines
References: <20080706132049.4019e09f.akpm@linux-foundation.org>
	<20080723.202533.114601491.davem@davemloft.net>
	<20080723203836.e0c14568.akpm@linux-foundation.org>
	<20080723.204247.114065226.davem@davemloft.net>
Date: Thu, 24 Jul 2008 23:32:06 +0200
In-Reply-To: <20080723.204247.114065226.davem@davemloft.net> (David Miller's
	message of "Wed, 23 Jul 2008 20:42:47 -0700 (PDT)")
Message-ID: <873alz55pl.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Miller <davem@davemloft.net> writes:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Wed, 23 Jul 2008 20:38:36 -0700
>
>> So if we're going to change it in 2.6.26, we'll need a separate patch.
>
> Here is the 2.6.26 version:
>
> bootmem: Allow zero length reserve and free.
>
> It's either this or all the call sites explicitly check
> when such a case is possible and sometimes expected.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 8d9f60e..e540f7a 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -153,7 +153,8 @@ static void __init reserve_bootmem_core(bootmem_data_t *bdata,
>  	unsigned long sidx, eidx;
>  	unsigned long i;
>  
> -	BUG_ON(!size);
> +	if (!size)
> +		return;
>  
>  	/* out of range */
>  	if (addr + size < bdata->node_boot_start ||
> @@ -187,7 +188,8 @@ static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
>  	unsigned long sidx, eidx;
>  	unsigned long i;
>  
> -	BUG_ON(!size);
> +	if (!size)
> +		return;
>  
>  	/* out range */
>  	if (addr + size < bdata->node_boot_start ||

Sorry, Dave, I missed that before: there is still the BUG_ON() in
can_reserve_bootmem_core(), which should just return 0 instead.

Other than that, yes, Andrew, this introduces the same behaviour the
bootmem rewrite.

	Hannes
