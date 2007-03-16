Return-Path: <linux-kernel-owner+w=401wt.eu-S965973AbXCPVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965973AbXCPVrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965971AbXCPVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:47:20 -0400
Received: from www.osadl.org ([213.239.205.134]:54020 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965973AbXCPVrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:47:19 -0400
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Johannes Bauer <JohannesBauer@gmx.de>,
       linux-kernel@vger.kernel.org, schwab@suse.de,
       Stable Kernel Team <stable@kernel.org>, Greg KH <greg@kroah.com>,
       Adrian Bunk <bunk@stusta.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070316124313.9f0afc05.akpm@linux-foundation.org>
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com>
	 <1173817985.13341.120.camel@localhost.localdomain>
	 <1173866413.13341.154.camel@localhost.localdomain>
	 <20070316124313.9f0afc05.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 22:05:20 +0100
Message-Id: <1174079120.13341.286.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 12:43 -0800, Andrew Morton wrote:
> On Wed, 14 Mar 2007 11:00:12 +0100 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > rtimer_forward() does not check for the possible overflow of
> > timer->expires. This can happen on 64 bit machines with large interval
> > values and results currently in an endless loop in the softirq because
> > the expiry value becomes negative and therefor the timer is expired all
> > the time.
> > 
> > Check for this condition and set the expiry value to the max. expiry
> > time in the future.
> > 
> > The fix should be applied to stable kernel series as well.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix,de>
> > 
> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > index ec4cb9f..5e7122d 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -644,6 +644,12 @@ hrtimer_forward(struct hrtimer *timer, k
> >  		orun++;
> >  	}
> >  	timer->expires = ktime_add(timer->expires, interval);
> > +	/*
> > +	 * Make sure, that the result did not wrap with a very large
> > +	 * interval.
> > +	 */
> > +	if (timer->expires.tv64 < 0)
> > +		timer->expires = ktime_set(KTIME_SEC_MAX, 0);
> >  
> >  	return orun;
> >  }
> 
> kernel/hrtimer.c: In function 'hrtimer_forward':
> kernel/hrtimer.c:652: warning: overflow in implicit constant conversion
> 
> problem is, KTIME_SEC_MAX is 9,223,372,036 and ktime_set() takes a `long'.

Stupid me :(

> This?
> 
> --- a/include/linux/ktime.h~ktime_set-fix-arg-type
> +++ a/include/linux/ktime.h
> @@ -72,13 +72,13 @@ typedef union {
>   *
>   * Return the ktime_t representation of the value
>   */
> -static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
> +static inline ktime_t ktime_set(const s64 secs, const unsigned long nsecs)
>  {
>  #if (BITS_PER_LONG == 64)
>  	if (unlikely(secs >= KTIME_SEC_MAX))
>  		return (ktime_t){ .tv64 = KTIME_MAX };
>  #endif
> -	return (ktime_t) { .tv64 = (s64)secs * NSEC_PER_SEC + (s64)nsecs };
> +	return (ktime_t) { .tv64 = secs * NSEC_PER_SEC + (s64)nsecs };
>  }
>  
>  /* Subtract two ktime_t variables. rem = lhs -rhs: */
> _
> 
> I worry about that `secs >= KTIME_SEC_MAX' comparison in there, too.  Both
> operands are signed.

I'd prefer this one: The maximum seconds value we can handle on 32bit is
LONG_MAX.

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index c68c7ac..248305b 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -57,7 +57,11 @@ typedef union {
 } ktime_t;
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
-#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#if (BITS_PER_LONG == 64)
+# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#else
+# define KTIME_SEC_MAX			LONG_MAX
+#endif
 
 /*
  * ktime_t definitions when using the 64-bit scalar representation:


