Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbYAIHPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbYAIHPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYAIHPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:15:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38657 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867AbYAIHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:15:43 -0500
Date: Tue, 8 Jan 2008 23:15:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Fries <david@fries.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] system timer: fix crash in <100Hz system timer
Message-Id: <20080108231507.ff34862f.akpm@linux-foundation.org>
In-Reply-To: <20080105221653.GA10065@spacedout.fries.net>
References: <20080105221653.GA10065@spacedout.fries.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 16:16:55 -0600 David Fries <david@fries.net> wrote:

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

Somwhat off-topic:

I guess HZ=USER_HZ is a not-uncommon case, and it's pretty silly calling
do_div(x, 1) all the time.  How about we optimise that case?

Perhaps there are other places...


--- a/kernel/time.c~speed-up-jiffies-conversion-functions-if-hz==user_hz
+++ a/kernel/time.c
@@ -618,8 +618,10 @@ u64 jiffies_64_to_clock_t(u64 x)
 # if HZ < USER_HZ
 	x *= USER_HZ;
 	do_div(x, HZ);
-# else
+# elif HZ > USER_HZ
 	do_div(x, HZ / USER_HZ);
+# else
+	/* Nothing to do */
 # endif
 #else
 	/*
_

