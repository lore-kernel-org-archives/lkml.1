Return-Path: <linux-kernel-owner+w=401wt.eu-S934492AbXGQOY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbXGQOY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934074AbXGQOSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:18:48 -0400
Received: from gw.goop.org ([64.81.55.164]:46303 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934072AbXGQOSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:18:47 -0400
Message-ID: <469CCF8F.4010107@goop.org>
Date: Tue, 17 Jul 2007 07:17:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] softlockup watchdog: fix Xen bogosity
References: <20070717114453.GA8212@elte.hu>
In-Reply-To: <20070717114453.GA8212@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: softlockup: fix Xen bogosity
> From: Ingo Molnar <mingo@elte.hu>
>
> this Xen related commit:
>   

Well, not just Xen.  It relates to any virtual environment: kvm, lguest,
vmi, xen...  (Not that they all implement a measure of unstolen time.)

How about a more descriptive patch title, along the lines of "softlockup
watchdog: fix rate limiting"?

>    commit 966812dc98e6a7fcdf759cbfa0efab77500a8868
>    Author: Jeremy Fitzhardinge <jeremy@goop.org>
>    Date:   Tue May 8 00:28:02 2007 -0700
>
>        Ignore stolen time in the softlockup watchdog
>
> broke the softlockup watchdog to never report any lockups. (!)
>
> print_timestamp defaults to 0, this makes the following condition
> always true:
>
> 	if (print_timestamp < (touch_timestamp + 1) ||
>
> and we'll never report soft lockups.
>
> apparently the functionality of the soft lockup watchdog was never 
> actually tested with that patch applied ...
>
> [ this is -stable material too. ]
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/softlockup.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c
> +++ linux/kernel/softlockup.c
> @@ -79,10 +79,11 @@ void softlockup_tick(void)
>  	print_timestamp = per_cpu(print_timestamp, this_cpu);
>  
>  	/* report at most once a second */
> -	if (print_timestamp < (touch_timestamp + 1) ||
> -		did_panic ||
> -			!per_cpu(watchdog_task, this_cpu))
> +	if ((print_timestamp >= touch_timestamp &&
> +			print_timestamp < (touch_timestamp + 1)) ||
> +			did_panic || !per_cpu(watchdog_task, this_cpu)) {
>  		return;
> +	}
>   

OK, thanks.

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
