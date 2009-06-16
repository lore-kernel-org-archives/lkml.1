Return-Path: <linux-kernel-owner+w=401wt.eu-S1764797AbZFPUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764797AbZFPUqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764383AbZFPUnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:43:49 -0400
Received: from bar.sig21.net ([80.81.252.164]:36656 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764103AbZFPUnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:43:47 -0400
Date: Tue, 16 Jun 2009 22:44:02 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "davej@redhat.com" <davej@redhat.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Message-ID: <20090616204402.GB13399@sig21.net>
References: <20090615232709.GA6059@sig21.net> <200906160216.29537.rjw@sisk.pl> <20090616142217.GA5548@sig21.net> <20090616115540.ceb67a30.akpm@linux-foundation.org> <20090616195750.GA12814@sig21.net> <20090616202558.GA5423@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616202558.GA5423@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-21-Score: -3.5 (---)
X-Spam-21-Report: No, score=-3.5 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.851,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 01:25:58PM -0700, Pallipadi, Venkatesh wrote:
> 
> diff --git a/kernel/up.c b/kernel/up.c
> index 1ff27a2..a4318ff 100644
> --- a/kernel/up.c
> +++ b/kernel/up.c
> @@ -10,11 +10,15 @@
>  int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>  				int wait)
>  {
> +	unsigned long flags;
> +
>  	WARN_ON(cpu != 0);
>  
> -	local_irq_disable();
> +	WARN_ON(irqs_disabled());
> +
> +	local_irq_save(flags);
>  	(func)(info);
> -	local_irq_enable();
> +	local_irq_restore(flags);
>  
>  	return 0;
>  }
> 

PS: It seems like a good idea to apply this patch with
the warning even if the root cause of the hibernate problem
is elsewhere, for better debuggability of such issues?


Johannes
