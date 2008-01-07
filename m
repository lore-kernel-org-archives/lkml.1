Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYAGXhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYAGXhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbYAGXhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:37:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755738AbYAGXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:37:07 -0500
Date: Mon, 7 Jan 2008 15:36:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Fries <david@fries.net>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] system timer: fix crash in <100Hz system timer
Message-Id: <20080107153650.0cb85eeb.akpm@linux-foundation.org>
In-Reply-To: <20080105221653.GA10065@spacedout.fries.net>
References: <20080105221653.GA10065@spacedout.fries.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 16:16:55 -0600
David Fries <david@fries.net> wrote:

> The kernel has a divide by zero crash when trying to run the system
> timer less than 100Hz.  The problem is x/(HZ/USER_HZ) and related.
> Now x*(USER_HZ/HZ) will be used if HZ<USER_HZ.
> 
> I'm running the Linux kernel under qemu and went to run a slower
> system timer to take less CPU (and battery) on the host.  I found that
> the kernel paniced under emulation because of a divide by zero in
> three places.  Here is the patch.  The base git was updated today
> 01-05-2008.  I went for a 20Hz system time by adding config HZ_20 etc
> to kernel/Kconfig.hz.  With this patch I verified the system timer by
> looking at /proc/interrupts.
> 
> Signed-off-by: David Fries <david@fries.net>
> 
> -- 
> David Fries <david@fries.net>
> http://fries.net/~david/ (PGP encryption key available)
> 
> 
> diff --git a/include/linux/acct.h b/include/linux/acct.h
> index 302eb72..86b848d 100644
> --- a/include/linux/acct.h
> +++ b/include/linux/acct.h
> @@ -173,7 +173,11 @@ typedef struct acct acct_t;
>  static inline u32 jiffies_to_AHZ(unsigned long x)
>  {
>  #if (TICK_NSEC % (NSEC_PER_SEC / AHZ)) == 0
> -	return x / (HZ / AHZ);
> +	#if HZ < AHZ
> +		return x * (AHZ / HZ);
> +	#else
> +		return x / (HZ / AHZ);
> +	#endif
>  #else
>          u64 tmp = (u64)x * TICK_NSEC;
>          do_div(tmp, (NSEC_PER_SEC / AHZ));
> diff --git a/kernel/time.c b/kernel/time.c
> index 09d3c45..23af26f 100644
> --- a/kernel/time.c
> +++ b/kernel/time.c
> @@ -565,7 +565,11 @@ EXPORT_SYMBOL(jiffies_to_timeval);
>  clock_t jiffies_to_clock_t(long x)
>  {
>  #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
> +	#if HZ < USER_HZ
> +	return x * (USER_HZ / HZ);
> +	#else
>  	return x / (HZ / USER_HZ);
> +	#endif
>  #else
>  	u64 tmp = (u64)x * TICK_NSEC;
>  	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
> @@ -598,7 +602,12 @@ EXPORT_SYMBOL(clock_t_to_jiffies);
>  u64 jiffies_64_to_clock_t(u64 x)
>  {
>  #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
> -	do_div(x, HZ / USER_HZ);
> +	#if HZ < USER_HZ
> +		x *= USER_HZ;
> +		do_div(x, HZ);
> +	#else
> +		do_div(x, HZ / USER_HZ);
> +	#endif
>  #else
>  	/*
>  	 * There are better ways that don't overflow early,

Alas, I get 100% rejects due to conflicting changes from Peter's
avoid-overflows-in-kernel-timec.patch.

Peter, did that patch propagate this failure, or might it have happily
fixed it?

