Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXC0VL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXC0VL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965440AbXC0VL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:11:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:49755 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965426AbXC0VL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:11:56 -0400
Date: Wed, 28 Mar 2007 01:11:45 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] Add support for deferrable timers (respun)
Message-ID: <20070327211145.GB216@tv-sign.ru>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru> <20070327204344.GA21529@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327204344.GA21529@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Venki Pallipadi wrote:
>
>  	for (;;) {
> -		base = timer->base;
> +		tvec_base_t *prelock_base = timer->base;
> +		base = timer_get_base(timer);
>  		if (likely(base != NULL)) {
>  			spin_lock_irqsave(&base->lock, *flags);
> -			if (likely(base == timer->base))
> +			if (likely(prelock_base == timer->base))
>  				return base;

I don't think this is correct, at least in theory.

Suppose that

	tvec_base_t *prelock_base = timer->base;
	base = timer_get_base(timer);

are re-ordered (the second LOAD happens after the first one), and the timer
changes its base in between. Now, we lock the old base, and return it because
"prelock_base == timer->base" == true.

Oleg.

