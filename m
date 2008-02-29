Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbYB2Sj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbYB2Sj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbYB2SjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:39:11 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:50488 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbYB2SjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:39:09 -0500
Date: Fri, 29 Feb 2008 19:38:12 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many devices today are of a less than stellar quality, and singing
transistors are a common problem. A high-pitch noise is created, caused
by power fluctuations as the processor enters and leaves deep sleep at
a high frequency.

Instead of just disabling the deep sleep (which wastes power). This
patch merely reduces the number of times it is entered so that the
frequency doesn't exceed 500 Hz. That should make sure the problem is
inaudible.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
--

The basic idea is above, but the implementation doesn't quite work. It seems jiffies is not a good time source in this scenario. The time spent in C3 takes a much bigger hit than I expect. The fact that powertop says that it has an average residency of 200 ms in C2 tells me that those should have been spent in C3.

So, pointers on what else to do?

(Patch also needs an on/off switch, but that's a later problem)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 78d77c5..171d838 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -16,6 +16,12 @@
 
 #define BREAK_FUZZ     4       /* 4 us */
 
+/*
+ * The minimum number of ticks needed to not oscillate faster than
+ * 500 Hz.
+ */
+#define MIN_DEEP_INTERVAL (HZ / 500)
+
 struct menu_device {
        int             last_state_idx;
 
@@ -23,6 +29,8 @@ struct menu_device {
        unsigned int    predicted_us;
        unsigned int    last_measured_us;
        unsigned int    elapsed_us;
+
+       unsigned long   last_deep_jif;
 };
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
@@ -50,9 +58,16 @@ static int menu_select(struct cpuidle_device *dev)
                        break;
                if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))
                        break;
+               if ((dev->states[i].flags & CPUIDLE_FLAG_DEEP) &&
+                       time_before_eq(jiffies, data->last_deep_jif + MIN_DEEP_INTERVAL))
+                       break;
        }
 
        data->last_state_idx = i - 1;
+
+       if (dev->states[i - 1].flags & CPUIDLE_FLAG_DEEP)
+               data->last_deep_jif = jiffies;
+
        return i - 1;
 }
 


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
