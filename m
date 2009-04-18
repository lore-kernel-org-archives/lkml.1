Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZDRJRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZDRJRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 05:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZDRJRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 05:17:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbZDRJRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 05:17:32 -0400
Date: Sat, 18 Apr 2009 11:17:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86/pci: fix -1 calling to e820_all_mapped with
	mmconfig
Message-ID: <20090418091720.GO7678@elte.hu>
References: <49E992C2.4010707@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E992C2.4010707@kernel.org>
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

> e820_all_mapped need end is (addr + size) instead of (addr + size - 1)
> 
> [Impact: fix -1 offset calling]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/pci/mmconfig-shared.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
> @@ -375,7 +375,7 @@ static acpi_status __init check_mcfg_res
>  		if (!fixmem32)
>  			return AE_OK;
>  		if ((mcfg_res->start >= fixmem32->address) &&
> -		    (mcfg_res->end < (fixmem32->address +
> +		    (mcfg_res->end <= (fixmem32->address +
>  				      fixmem32->address_length))) {
>  			mcfg_res->flags = 1;
>  			return AE_CTRL_TERMINATE;
> @@ -392,7 +392,7 @@ static acpi_status __init check_mcfg_res
>  		return AE_OK;
>  
>  	if ((mcfg_res->start >= address.minimum) &&
> -	    (mcfg_res->end < (address.minimum + address.address_length))) {
> +	    (mcfg_res->end <= (address.minimum + address.address_length))) {
>  		mcfg_res->flags = 1;
>  		return AE_CTRL_TERMINATE;
>  	}
> @@ -439,7 +439,7 @@ static int __init is_mmconf_reserved(che
>  	u64 old_size = size;
>  	int valid = 0;
>  
> -	while (!is_reserved(addr, addr + size - 1, E820_RESERVED)) {
> +	while (!is_reserved(addr, addr + size, E820_RESERVED)) {
>  		size >>= 1;
>  		if (size < (16UL<<20))
>  			break;

good catch. Probably also needed for -stable.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
