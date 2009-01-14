Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZANTRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZANTRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZANTQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:16:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54989 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbZANTQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:16:46 -0500
Date: Wed, 14 Jan 2009 20:16:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, pat: fix free_memtype() for legacy 1MB range
Message-ID: <20090114191632.GA17766@elte.hu>
References: <20090114184834.GC1290@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114184834.GC1290@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> -	is_range_ram = pagerange_is_ram(start, end);
> -	if (is_range_ram == 1)
> -		return free_ram_pages_type(start, end);
> -	else if (is_range_ram < 0)
> -		return -EINVAL;
> +	/*
> +	 * For legacy reasons, some parts of the physical address range in the
> +	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
> +	 * the e820 tables).  So we will track the memory attributes of this
> +	 * legacy 1MB region using the linear memtype_list always.
> +	 */
> +	if (end >= ISA_END_ADDRESS) {
> +		is_range_ram = pagerange_is_ram(start, end);
> +		if (is_range_ram == 1)
> +			return free_ram_pages_type(start, end);
> +		else if (is_range_ram < 0)
> +			return -EINVAL;
> +	}

this logic is now repeated in an open-coded way in two places in pat.c. 
Could you please send another delta patch that consolidates them into a 
single helper function, which is used both in free_memtype() and 
reserve_memtype()?

Thanks,

	Ingo
