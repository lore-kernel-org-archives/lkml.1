Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbXCPUsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbXCPUsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXCPUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:48:14 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35344 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbXCPUsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:48:13 -0400
Date: Fri, 16 Mar 2007 12:43:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: Chuck Ebbert <cebbert@redhat.com>, Johannes Bauer <JohannesBauer@gmx.de>,
       linux-kernel@vger.kernel.org, schwab@suse.de,
       Stable Kernel Team <stable@kernel.org>, Greg KH <greg@kroah.com>,
       Adrian Bunk <bunk@stusta.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
Message-Id: <20070316124313.9f0afc05.akpm@linux-foundation.org>
In-Reply-To: <1173866413.13341.154.camel@localhost.localdomain>
References: <45F6F3A6.9060405@gmx.de>
	<45F7033B.2030204@redhat.com>
	<1173817985.13341.120.camel@localhost.localdomain>
	<1173866413.13341.154.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007 11:00:12 +0100 Thomas Gleixner <tglx@linutronix.de> wrote:

> rtimer_forward() does not check for the possible overflow of
> timer->expires. This can happen on 64 bit machines with large interval
> values and results currently in an endless loop in the softirq because
> the expiry value becomes negative and therefor the timer is expired all
> the time.
> 
> Check for this condition and set the expiry value to the max. expiry
> time in the future.
> 
> The fix should be applied to stable kernel series as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix,de>
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index ec4cb9f..5e7122d 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -644,6 +644,12 @@ hrtimer_forward(struct hrtimer *timer, k
>  		orun++;
>  	}
>  	timer->expires = ktime_add(timer->expires, interval);
> +	/*
> +	 * Make sure, that the result did not wrap with a very large
> +	 * interval.
> +	 */
> +	if (timer->expires.tv64 < 0)
> +		timer->expires = ktime_set(KTIME_SEC_MAX, 0);
>  
>  	return orun;
>  }

kernel/hrtimer.c: In function 'hrtimer_forward':
kernel/hrtimer.c:652: warning: overflow in implicit constant conversion

problem is, KTIME_SEC_MAX is 9,223,372,036 and ktime_set() takes a `long'.


This?

--- a/include/linux/ktime.h~ktime_set-fix-arg-type
+++ a/include/linux/ktime.h
@@ -72,13 +72,13 @@ typedef union {
  *
  * Return the ktime_t representation of the value
  */
-static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
+static inline ktime_t ktime_set(const s64 secs, const unsigned long nsecs)
 {
 #if (BITS_PER_LONG == 64)
 	if (unlikely(secs >= KTIME_SEC_MAX))
 		return (ktime_t){ .tv64 = KTIME_MAX };
 #endif
-	return (ktime_t) { .tv64 = (s64)secs * NSEC_PER_SEC + (s64)nsecs };
+	return (ktime_t) { .tv64 = secs * NSEC_PER_SEC + (s64)nsecs };
 }
 
 /* Subtract two ktime_t variables. rem = lhs -rhs: */
_

I worry about that `secs >= KTIME_SEC_MAX' comparison in there, too.  Both
operands are signed.


