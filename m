Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYIOH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYIOH5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 03:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYIOH5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 03:57:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbYIOH5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 03:57:07 -0400
Date: Mon, 15 Sep 2008 09:56:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: smpboot - check if we have ESR register in
	wakeup_secondary_cpu
Message-ID: <20080915075655.GC29585@elte.hu>
References: <20080914175849.GC3907@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914175849.GC3907@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> We should check if we have ESR register before writting to it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Please review!
> it seems the same nit in do_boot_cpu - checking now.
> 
> Index: linux-2.6.git/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-09-14 19:43:03.000000000 +0400
> +++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-09-14 21:49:36.000000000 +0400
> @@ -598,10 +598,12 @@ wakeup_secondary_cpu(int logical_apicid,
>  	 * Give the other CPU some time to accept the IPI.
>  	 */
>  	udelay(200);
> -	maxlvt = lapic_get_maxlvt();
> -	if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
> -		apic_write(APIC_ESR, 0);
> -	accept_status = (apic_read(APIC_ESR) & 0xEF);
> +	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
> +		maxlvt = lapic_get_maxlvt();
> +		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
> +			apic_write(APIC_ESR, 0);
> +		accept_status = (apic_read(APIC_ESR) & 0xEF);
> +	}
>  	pr_debug("NMI sent.\n");

hm, is there any non-integrated lapic that has more than 3 lvts? iirc 
lvts were introduced with the integrated lapic.

	Ingo
