Return-Path: <linux-kernel-owner+w=401wt.eu-S933650AbYBNAXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650AbYBNAXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765919AbYBNAV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:21:57 -0500
Received: from www.tglx.de ([62.245.132.106]:57768 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763992AbYBNAVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:21:55 -0500
Date: Thu, 14 Feb 2008 01:20:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frans Pop <elendil@planet.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [stable 2.6.24] WARNING: at kernel/time/clockevents.c
In-Reply-To: <200802132240.04357.elendil@planet.nl>
Message-ID: <alpine.LFD.1.00.0802140029550.12988@apollo.tec.linutronix.de>
References: <200802101440.22118.elendil@planet.nl> <200802130947.10781.elendil@planet.nl> <alpine.LFD.1.00.0802131004460.12988@apollo.tec.linutronix.de> <200802132240.04357.elendil@planet.nl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Frans Pop wrote:

> On Wednesday 13 February 2008, Thomas Gleixner wrote:
> > can you please apply the following patch ? I really should have
> > thought about that, when I fixed the above one.
> 
> I still get the bug with this patch. At least I'm now certain it happens 
> during glibc compilation and that I can reproduce it.
> 
> I applied your patch on top of 2.6.24.2 (applied with only minor offsets) 
> because I also saw the issue with that kernel and I don't yet completely 
> trust 2.6.25.
> 
> Here's the error from this run:
> WARNING: at kernel/time/clockevents.c:82 clockevents_program_event()
> Pid: 27638, comm: ld-linux.so.2 Not tainted 2.6.24.2-test1 #39
> 
> Call Trace:
>  [<ffffffff8024afaf>] ktime_get+0xc/0x41
>  [<ffffffff8024ea59>] clockevents_program_event+0x3b/0x94
>  [<ffffffff8024f8c8>] tick_program_event+0x31/0x4d
>  [<ffffffff8024a2fd>] hrtimer_reprogram+0x3b/0x51
>  [<ffffffff8024a478>] enqueue_hrtimer+0x66/0x102
>  [<ffffffff8024ad38>] hrtimer_start+0x102/0x125
>  [<ffffffff8819f403>] :ext3:__ext3_journal_stop+0x1f/0x3d
>  [<ffffffff803f8dcc>] rt_mutex_slowlock+0x90/0x53a
>  [<ffffffff802667e8>] find_lock_page+0x29/0x8d
>  [<ffffffff80277a78>] find_extend_vma+0x16/0x59
>  [<ffffffff802509b2>] get_futex_key+0x82/0x14e
>  [<ffffffff80251ac5>] futex_lock_pi+0x60f/0x90d

futex_lock_pi is called with an absolute timeout, which is based on
CLOCK_REALTIME. Nothing wrong with that, but the clockevents WARN_ON
might trap over a false positive, when the expiry value is less than
base->offset. This was intentional before we put the WARN_ON into the
clockevents code.

The patch below should fix this issue.

Thanks,

	tglx

Subject: hrtimer-fix-abs-clock-realtime.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 14 Feb 2008 00:58:36 +0100

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -425,6 +425,8 @@ static int hrtimer_reprogram(struct hrti
 	ktime_t expires = ktime_sub(timer->expires, base->offset);
 	int res;
 
+	WARN_ON_ONCE(timer->expires.tv64 < 0);
+
 	/*
 	 * When the callback is running, we do not reprogram the clock event
 	 * device. The timer callback is either running on a different CPU or
@@ -435,6 +437,15 @@ static int hrtimer_reprogram(struct hrti
 	if (hrtimer_callback_running(timer))
 		return 0;
 
+	/*
+	 * CLOCK_REALTIME timer might be requested with an absolute
+	 * expiry time which is less than base->offset. Nothing wrong
+	 * about that, just avoid to call into the tick code, which
+	 * has now objections against negative expiry values.
+	 */
+	if (expires.tv64 < 0)
+		return -ETIME;
+
 	if (expires.tv64 >= expires_next->tv64)
 		return 0;
 
