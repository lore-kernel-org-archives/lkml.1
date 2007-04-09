Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXDINBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXDINBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXDINBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:01:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45448 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753152AbXDINBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:01:49 -0400
Date: Mon, 9 Apr 2007 15:01:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Johannes Bauer <JohannesBauer@gmx.de>,
       linux-kernel@vger.kernel.org, schwab@suse.de,
       Stable Kernel Team <stable@kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
Message-ID: <20070409130155.GF3582@stusta.de>
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com> <1173817985.13341.120.camel@localhost.localdomain> <1173866413.13341.154.camel@localhost.localdomain> <20070404211159.GT27660@stusta.de> <1175722249.28263.343.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1175722249.28263.343.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 11:30:48PM +0200, Thomas Gleixner wrote:
> On Wed, 2007-04-04 at 23:11 +0200, Adrian Bunk wrote:
> > On Wed, Mar 14, 2007 at 11:00:12AM +0100, Thomas Gleixner wrote:
> > > hrtimer_forward() does not check for the possible overflow of
> > > timer->expires. This can happen on 64 bit machines with large interval
> > > values and results currently in an endless loop in the softirq because
> > > the expiry value becomes negative and therefor the timer is expired all
> > > the time.
> > > 
> > > Check for this condition and set the expiry value to the max. expiry
> > > time in the future.
> > > 
> > > The fix should be applied to stable kernel series as well.
> > 
> > 
> > Is this relevant for 2.6.16?
> > 
> > I'm asking since KTIME_SEC_MAX is not used in 2.6.16, and therefore the 
> > check in ktime_set() is also missing.
> 
> KTIME_SEC_MAX was introduced with commit
> 96dd7421a06a5bc6eb731323b95efcb2fd864854
> 
> to fix a conversion problem on 64 bit machines, which is also present in
> 2.6.16 AFAICT.
> 
> The patch just makes use of this constant. So you need to pull it as
> well.

Thanks, below is what I applied.

> 	tglx

cu
Adrian


Thomas Gleixner (3):
      prevent timespec/timeval to ktime_t overflow
      fix MTIME_SEC_MAX on 32-bit
      hrtimer: prevent overrun DoS in hrtimer_forward()


diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index f3dec45..4548ddb 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -56,7 +56,12 @@ typedef union {
 #endif
 } ktime_t;
 
-#define KTIME_MAX			(~((u64)1 << 63))
+#define KTIME_MAX			((s64)~((u64)1 << 63))
+#if (BITS_PER_LONG == 64)
+# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#else
+# define KTIME_SEC_MAX			LONG_MAX
+#endif
 
 /*
  * ktime_t definitions when using the 64-bit scalar representation:
@@ -77,6 +82,10 @@ typedef union {
  */
 static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
 {
+#if (BITS_PER_LONG == 64)
+	if (unlikely(secs >= KTIME_SEC_MAX))
+		return (ktime_t){ .tv64 = KTIME_MAX };
+#endif
 	return (ktime_t) { .tv64 = (s64)secs * NSEC_PER_SEC + (s64)nsecs };
 }
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 14bc9cf..a29ceb0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -316,6 +316,12 @@ hrtimer_forward(struct hrtimer *timer, ktime_t interval)
 		orun++;
 	}
 	timer->expires = ktime_add(timer->expires, interval);
+	/*
+	 * Make sure, that the result did not wrap with a very large
+	 * interval.
+	 */
+	if (timer->expires.tv64 < 0)
+		timer->expires = ktime_set(KTIME_SEC_MAX, 0);
 
 	return orun;
 }

