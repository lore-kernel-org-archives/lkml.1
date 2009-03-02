Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZCBKSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZCBKSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZCBKSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:18:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55705 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbZCBKSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:18:44 -0500
Date: Mon, 2 Mar 2009 11:18:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Kevin O'Connor" <kevin@koconnor.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org
Subject: Re: [PATCH] x86: ioremap mptable -v2
Message-ID: <20090302101823.GJ20897@elte.hu>
References: <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu> <49A23EE0.8000102@kernel.org> <20090228234127.GA29964@morn.localdomain> <49A9FC9A.2030707@kernel.org> <20090301180420.GA27040@morn.localdomain> <49AB511E.9010507@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AB511E.9010507@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix boot with mptable above max_low_mapped
> 
> try to use early_ioremap it.
> 
> v2: also get the exact size for reserve_bootmem in case we got big size than 4k
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Reported-and-tested-by: Kevin O'Connor <kevin@koconnor.net>
> 
> ---
>  arch/x86/kernel/mpparse.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/mpparse.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> +++ linux-2.6/arch/x86/kernel/mpparse.c
> @@ -611,12 +611,20 @@ static void __init __get_smp_config(unsi
>  		construct_default_ISA_mptable(mpf->feature1);
>  
>  	} else if (mpf->physptr) {
> +		struct mpc_table *mpc;
> +		unsigned long size;
>  
> +		mpc = early_ioremap(mpf->physptr, PAGE_SIZE);
> +		size = mpc->length;
> +		apic_printk(APIC_VERBOSE, "  mpc: %lx-%lx\n", (unsigned long)mpf->physptr,
> +			 mpf->physptr + size);
> +		early_iounmap(mpc, PAGE_SIZE);
> +		mpc = early_ioremap(mpf->physptr, size);

no objections, but this bit of __get_smp_config() needs to be 
done cleaner - the whole mpf->physptr != 0 bit should probably 
go into a helper function.

	Ingo
