Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYAYOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYAYOWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYAYOWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:22:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57526 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbYAYOWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:22:07 -0500
Date: Fri, 25 Jan 2008 15:21:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
Message-ID: <20080125142150.GA27767@elte.hu>
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801250042.53074.yinghai.lu@sun.com>
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

> -static __init int amd_special_default_mtrr(unsigned long end_pfn)
> +static __init int amd_special_default_mtrr(void)
>  {
>  	u32 l, h;
>  
> -	/* Doesn't apply to memory < 4GB */
> -	if (end_pfn <= (0xffffffff >> PAGE_SHIFT))
> -		return 0;
>  	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
>  		return 0;

The logic we ideally would like to have is something like this:

find _any_ RAM that is not mapped via any MTRRs (be that special MTRR 
extensions like Tom2) and clear that from the e820 maps.

not just 'end of RAM'.

And in that sense the amd_special_default_mtrr() check is wrong, because 
it just checks that Tom2 is set and then does no other checking. And the 
original MTRR check is wrong too because it just finds the highest 
cacheable MTRR-covered address and compares that to the kernel-known end 
of RAM.

what we should probably do instead is to have a filter function:

   new_end = trim_range_to_mtrr_cached(start, end);

and then we could iterate through every e820 map entry that is marked as 
usable RAM, and send it through this filter. If the filter returns the 
same value that got passed in, we keep the e820 entry unchanged. If the 
filter returns a new "end" value, we use that in the e820 map.

that way, the current Tom2 hack is just a natural extension to the 
filter function: it would (on AMD CPUs) recognize (within 
trim_range_to_mtrr_cached filter) that all memory addresses above 4GB 
are marked as cacheable via Tom2.

Or something like this. Hm?

	Ingo
