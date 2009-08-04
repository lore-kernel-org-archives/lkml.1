Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbZHDHXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbZHDHXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 03:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbZHDHXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 03:23:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932512AbZHDHXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:23:10 -0400
Date: Tue, 4 Aug 2009 00:22:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timers: fix oops in clock_nanosleep() with
 CLOCK_MONOTONIC_RAW
Message-Id: <20090804002226.2972cf47.akpm@linux-foundation.org>
In-Reply-To: <4A764FF3.50607@ct.jp.nec.com>
References: <4A764FF3.50607@ct.jp.nec.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Aug 2009 11:48:19 +0900 Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Prevent calling do_nanosleep() with clockid CLOCK_MONOTONIC_RAW, it may
> cause oops, such as NULL pointer dereference.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  kernel/posix-timers.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
> index 052ec4d..d089d05 100644
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -202,6 +202,12 @@ static int no_timer_create(struct k_itimer *new_timer)
>  	return -EOPNOTSUPP;
>  }
>  
> +static int no_nsleep(const clockid_t which_clock, int flags,
> +		     struct timespec *tsave, struct timespec __user *rmtp)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  /*
>   * Return nonzero if we know a priori this clockid_t value is bogus.
>   */
> @@ -254,6 +260,7 @@ static __init int init_posix_timers(void)
>  		.clock_get = posix_get_monotonic_raw,
>  		.clock_set = do_posix_clock_nosettime,
>  		.timer_create = no_timer_create,
> +		.nsleep = no_nsleep,
>  	};
>  
>  	register_posix_clock(CLOCK_REALTIME, &clock_realtime);

Under which circumstances will this oops trigger?

What userspace setup/actions will trigger the oops?

Thanks.



<spends 5 minutes trying to work out where k_clock.nsleep() even gets
called from>

OK, that CLOCK_DISPATCH() thing should be strangled and burnt...
