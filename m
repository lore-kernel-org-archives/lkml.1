Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbYB0Xof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbYB0Xof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYB0XoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:44:20 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761466AbYB0XoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:44:19 -0500
Date: Wed, 27 Feb 2008 15:43:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, segher@kernel.crashing.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] Prevent the loop in timespec_add_ns() to be optimised
 away
Message-Id: <20080227154341.824efe3c.akpm@linux-foundation.org>
In-Reply-To: <6a95d77ad55b29ff2d856c9e1f7dd79682370300.1203715782.git.segher@kernel.crashing.org>
References: <6a95d77ad55b29ff2d856c9e1f7dd79682370300.1203715782.git.segher@kernel.crashing.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 22:40:45 +0100
Segher Boessenkool <segher@kernel.crashing.org> wrote:

> ...since some architectures don't support __udivdi3() (and
> we don't want to use that, anyway).
> 
> Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
> ---
>  include/linux/time.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 2091a19..d32ef0a 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -174,6 +174,10 @@ static inline void timespec_add_ns(struct timespec *a, u64 ns)
>  {
>  	ns += a->tv_nsec;
>  	while(unlikely(ns >= NSEC_PER_SEC)) {
> +		/* The following asm() prevents the compiler from
> +		 * optimising this loop into a modulo operation.  */
> +		asm("" : "+r"(ns));
> +
>  		ns -= NSEC_PER_SEC;
>  		a->tv_sec++;
>  	}

It's pretty sad that we need to turn this into a loop just because of the
__udivdi3() thing.

otoh, it's rarely occurring, and it could be that the number of times it
loops is usually 1 (if it wasn't zero), so perhaps a loop is faster than a
divide anyway.

This code is probably too large to be inlined.

I queued this patch as needed-in-2.6.25, to-be-merged-via-Thomas.
