Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0BMUhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 15:37:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55127 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab0BMUhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 15:37:50 -0500
Date: Sat, 13 Feb 2010 21:37:48 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>
Subject: Re: [PATCH 02/10] ARM: ftrace: document mcount formats
Message-ID: <20100213203748.GC16528@pengutronix.de>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-3-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1266090518-31120-3-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Feb 14, 2010 at 01:18:30AM +0530, Rabin Vincent wrote:
> Add a comment describing the mcount variants and how the callsites look
> like.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/arm/kernel/entry-common.S |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 0b042bd..d412d7c 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -92,6 +92,38 @@ ENDPROC(ret_from_fork)
>  #define CALL(x) .long x
>  
>  #ifdef CONFIG_FUNCTION_TRACER
> +/*
> + * When compiling with -pg, gcc inserts a call to the mcount routine at the
> + * start of every function.  In mcount, apart from the function's address (in
> + * lr), we need to get hold of the function's caller's address.
> + *
> + * Older GCCs (pre-4.4) inserted a call to a routine called mcount like this:
> + *
> + *	bl	mcount
> + *
> + * These versions have the limitation that in order for the mcount routine to
> + * be able to determine the function's caller's address, an APCS-style frame
> + * pointer (which is set up with something like the code below) is required.
> + *
> + *	mov     ip, sp
> + *	push    {fp, ip, lr, pc}
> + *	sub     fp, ip, #4
> + *
> + * With EABI, these frame pointers are not available unless -mapcs-frame is
> + * specified, and if building as Thumb-2, not even then.
> + *
> + * Newer GCCs (4.4+) solve this problem by introducing a new version of mcount,
> + * with call sites like:
> + *
> + *	push	{lr}
> + *	bl	__gnu_mcount_nc
> + *
> + * With these compilers, frame pointers are not necessary.
> + *
> + * With both the mcount types, we need to restore the original lr before
> + * returning.  In the __gnu_mcount_nc, version we're allowed to clobber ip.
> + * No other registers should be clobbered.
> + */
Very nice.

Maybe make the last two sentences:

In the __gnu_mcount_nc case the ip register is clobbered which is OK as
the calling convention for ARM allow clobbering this value for
subroutines and it doesn't contain parameters.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
