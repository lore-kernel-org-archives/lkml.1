Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYIBIWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYIBIWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 04:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYIBIW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 04:22:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:35739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYIBIWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:22:25 -0400
Subject: Re: [PATCH 13/13] hrtimer: make select() and poll() use the
	hrtimer range feature
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
In-Reply-To: <20080901161459.0990a16b@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
	 <20080901161459.0990a16b@infradead.org>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 10:22:20 +0200
Message-Id: <1220343740.8609.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 16:14 -0700, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] hrtimer: make select() and poll() use the hrtimer range feature
> 
> This patch makes the select() and poll() hrtimers use the new range
> feature and settings from the task struct.
> 
> In addition, this includes the estimate_accuracy() function that Linus
> posted to lkml (but with a few steps added based on experiments).
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  fs/select.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 66 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index f6dceb5..21bf77d 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -28,6 +28,62 @@
>  
>  #include <asm/uaccess.h>
>  
> +
> +/* Estimate expected accuracy in ns from a timeval */
> +
> +static unsigned long __estimate_accuracy(struct timespec *tv)
> +{
> +	/*
> +	 * Tens of ms if we're looking at seconds, even
> +	 * more for 10s+ sleeping
> +	 */
> +	if (tv->tv_sec) {
> +		/* 100 milliseconds for long sleeps */
> +		if (tv->tv_sec > 10)
> +			return 100 * NSEC_PER_MSEC;
> +
> +		/*
> +		 * Tens of ms for second-granularity sleeps. This,
> +		 * btw, is the historical Linux 100Hz timer range.
> +		 */
> +		return 10 * NSEC_PER_MSEC;
> +	}
> +
> +	/* 5 msec if we're looking at 100+ milliseconds */
> +	if (tv->tv_nsec > 100 * NSEC_PER_MSEC)
> +		return 5 * NSEC_PER_MSEC;
> +
> +	/* A msec if we're looking at 10+ milliseconds */
> +	if (tv->tv_nsec > 10 * NSEC_PER_MSEC)
> +		return NSEC_PER_MSEC;
> +
> +	/* half a msec if we're looking at milliseconds */
> +	if (tv->tv_nsec > NSEC_PER_MSEC)
> +		return NSEC_PER_MSEC/2;
> +
> +	/* Single usecs if we're looking at microseconds */
> +	if (tv->tv_nsec > NSEC_PER_USEC)
> +		return NSEC_PER_USEC;
> +
> +	/* Aim for tenths of nanosecs otherwise */
> +	return 10;
> +}

Why not use a simple logarithmic decay to drive this estimate?


