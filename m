Return-Path: <linux-kernel-owner+w=401wt.eu-S935831AbXJSSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935831AbXJSSBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764000AbXJSSBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:01:05 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:10117 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763442AbXJSSBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:01:04 -0400
Message-ID: <4718F0DE.3050207@ct.jp.nec.com>
Date: Fri, 19 Oct 2007 11:01:02 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] i386: fix TSC clock source calibration error [part 2]
References: <18196.53154.100115.92459@zeus.sw.starentnetworks.com>	<20071018085713.GA11022@elte.hu> <18200.59017.358372.378373@zeus.sw.starentnetworks.com>
In-Reply-To: <18200.59017.358372.378373@zeus.sw.starentnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Johnson wrote:
> From: Dave Johnson <djohnson@sw.starentnetworks.com>
> 
> The previous patch wasn't correctly handling the 'count' variable.  If
> a CPU gave bad results on the 1st or 2nd run but good results on the
> 3rd, it wouldn't do the correct thing.  No idea if any such CPU
> exists, but the patch below handles that case by discarding the bad
> runs.
> 
> If a bad result (too quick, or too slow) occurs on any of the 3 runs
> it will be discarded.
> 
> Also updated some comments to explain what's going on.
> 
> Signed-off-by: Dave Johnson <djohnson@sw.starentnetworks.com>
> 
> ---
> 
> Should be applied after my previous patch.
> 
> ===== arch/i386/kernel/tsc.c 1.28 vs edited =====
> --- 1.28/arch/i386/kernel/tsc.c	2007-10-19 11:07:36 -04:00
> +++ edited/arch/i386/kernel/tsc.c	2007-10-19 11:07:44 -04:00
> @@ -128,29 +128,35 @@
>  
>  	local_irq_save(flags);
>  
> -	/* run 3 times to ensure the cache is warm */
> +	/* run 3 times to ensure the cache is warm and to get an accurate reading */
>  	for (i = 0; i < 3; i++) {
>  		mach_prepare_counter();

It's a really rare case, but if SMI interrupt takes CPU here, just after
prepare and before rdtscll, it makes delta64 shorter than expected one.
Is it possible? And how about moving rdtscll before mach_prepare_counter()?

>  		rdtscll(start);

Thanks
Hiroshi Shimamoto
