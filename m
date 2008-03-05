Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbYCEVOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbYCEVOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYCEVOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:14:43 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:23862 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756147AbYCEVOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:14:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jHbS5IGUzchtj2O/6ZCYW2mQ2s2Cz8ObhLBqK9cqS/eba3hIhSTLr8ssJqXeLjkJT/mGs4O2coVc8lQ34rR9tWqXjE83rlt9p1InAfoP5x9XOT21KGIBY/759AzQ6WDuzkLmLNavk70FogY1dWjJy2cJDIXN2D+UeUnG3yxDgiE=  ;
X-YMail-OSG: t2n.YG0VM1mkYnr0HUJ1P0nTDqJP.M1KVJzycHjW1w1Eg3cZomIWostoF81Ete14kd6U4ObhaA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] atmel_tc clocksource/clockevent code
Date: Wed, 5 Mar 2008 13:14:38 -0800
User-Agent: KMail/1.9.6
Cc: Remy Bohmer <linux@bohmer.net>, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>, john stultz <johnstul@us.ibm.com>
References: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com> <3efb10970803050317k68da7154w334561cc5efed637@mail.gmail.com> <alpine.LFD.1.00.0803051742190.3099@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803051742190.3099@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051314.39561.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008, Thomas Gleixner wrote:
> > So, hires timestamps -> really really welcome.
> > hires timers -> there should be a (configurable) minimal resolution
> > that fits the hardware to not overload the CPU.
> 
> clockevents let you set a minimum delta already. This can be set at
> runtime before registering the device.

But the overhead isn't specific to any given clockevent
device.  The same issue was reported on other ARMs.

The acceptable overhead is a function of system-specific
factors including load and CPU clock rate, not of a given
clockevent device.

I wouldn't think teaching multiple such drivers about such
issues could be better than having clockevents_program_event()
consider a system-specific lower bound ...

- Dave



==============
Add a "min_delta_ns" kernel parameter to help systems avoid excess
scheduling and timer overheads.  As with init_timer_deferrable(),
this batches timer IRQs to reduce those overheads.

For example, on one ARM9 platform the timer IRQ takes 2 usec, but the
system then needs over 150 usec to handle scheduler-related tasks.
On such a system, applications using many high resolution timers can
work better if min_delta_ns is used to avoid scheduling timer IRQs
so often that no other work gets done.

---
 Documentation/kernel-parameters.txt |    7 +++++++
 kernel/time/clockevents.c           |   15 +++++++++++++++
 2 files changed, 22 insertions(+)

--- a/Documentation/kernel-parameters.txt	2008-02-23 11:36:13.000000000 -0800
+++ b/Documentation/kernel-parameters.txt	2008-03-05 12:58:20.000000000 -0800
@@ -1146,6 +1146,13 @@ and is between 256 and 4096 characters. 
 
 	mga=		[HW,DRM]
 
+	min_delta_ns=n	[GENERIC_TIME] Defines the minimum amount of time
+			that oneshot clockevent sources will be asked to
+			sleep.  This is measured in nanoseconds, and may be
+			overridden by the clockevent device.  You probably
+			want this number to be more than your system's timer
+			IRQ overhead.
+
 	mousedev.tap_time=
 			[MOUSE] Maximum time between finger touching and
 			leaving touchpad surface for touch to be considered
--- a/kernel/time/clockevents.c	2008-02-10 15:48:29.000000000 -0800
+++ b/kernel/time/clockevents.c	2008-03-05 12:38:14.000000000 -0800
@@ -29,6 +29,18 @@ static RAW_NOTIFIER_HEAD(clockevents_cha
 /* Protection for the above */
 static DEFINE_SPINLOCK(clockevents_lock);
 
+/* This is the lower bound on oneshot timer intervals; setting its
+ * value too low can maintain HRT overhead at objectionable levels.
+ */
+static unsigned long min_delta_ns;
+
+static int __init set_min_delta_ns(char *str)
+{
+	simple_strtoul(str, NULL, 0);
+	return 1;
+}
+__setup("min_delta_ns", set_min_delta_ns);
+
 /**
  * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
  * @latch:	value to convert
@@ -98,6 +110,9 @@ int clockevents_program_event(struct clo
 	if (dev->mode == CLOCK_EVT_MODE_SHUTDOWN)
 		return 0;
 
+	if (delta < min_delta_ns)
+		delta = min_delta_ns;
+
 	if (delta > dev->max_delta_ns)
 		delta = dev->max_delta_ns;
 	if (delta < dev->min_delta_ns)
