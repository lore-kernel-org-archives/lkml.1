Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710Ab0ATIKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab0ATIKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634Ab0ATIKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:10:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab0ATIKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:10:32 -0500
Date: Wed, 20 Jan 2010 09:10:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de
Subject: Re: [PATCH] x86, UV: Fix RTC latency bug by reading replicated
 cachelines
Message-ID: <20100120081020.GG20621@elte.hu>
References: <20100112210904.GA24546@sgi.com>
 <20100113092433.GB6739@elte.hu>
 <20100114183422.GA12152@sgi.com>
 <20100119144137.GB22276@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119144137.GB22276@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.2
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.2 required=5.9 tests=FS_REPLICA autolearn=no SpamAssassin version=3.2.5
	1.2 FS_REPLICA             Subject says "replica"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> +++ linux/drivers/char/uv_mmtimer.c	2010-01-14 11:56:57.000000000 -0600
> @@ -89,12 +89,19 @@ static long uv_mmtimer_ioctl(struct file
>  	switch (cmd) {
>  	case MMTIMER_GETOFFSET:	/* offset of the counter */
>  		/*
> -		 * UV RTC register is on its own page
> +		 * Starting with HUB rev 2.0, the UV RTC register is
> +		 * replicated across all cachelines of it's own page.
> +		 * This allows faster simultaneous reads from a given socket.
> +		 *
> +		 * The offset returned is in 64 bit units.
>  		 */
> -		if (PAGE_SIZE <= (1 << 16))
> -			ret = ((UV_LOCAL_MMR_BASE | UVH_RTC) & (PAGE_SIZE-1))
> -				/ 8;
> -		else
> +		if (PAGE_SIZE <= (1 << 16)) {
> +			if (uv_get_min_hub_revision_id() == 1)
> +				ret = 0;
> +			else
> +				ret = ((uv_blade_processor_id() *
> +					L1_CACHE_BYTES) % PAGE_SIZE) / 8;
> +		} else

That 64K PAGE_SIZE check in the ioctl looks rather weird. What is the purpose 
of it?

	Ingo
