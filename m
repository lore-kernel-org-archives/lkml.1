Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYCCUUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYCCUUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYCCUUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:20:10 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:52093 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbYCCUUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:08 -0500
Date: Mon, 3 Mar 2008 21:18:42 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, "Lee Revell" <rlrevell@joe-job.com>
Subject: [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080303211842.6f492782@mjolnir.drzeus.cx>
In-Reply-To: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many devices today are of a less than stellar quality, and singing
capacitors are a common problem. A high-pitch noise is created, caused
by power fluctuations as the processor enters and leaves deep sleep at
a high frequency.

Instead of just disabling the deep sleep (which wastes power). This
patch merely reduces the number of times it is entered so that the
frequency doesn't exceed 500 Hz. That should make sure the problem is
inaudible.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
--

I've been playing around with this for a bit, and the jiffies approach
just had too many gotchas. So I tried using the information that was
already present in the menu governor. This is what I came up with.

It solves the primary problem of getting rid of the noise. I've also
tried some crude power measurements and I couldn't get any difference
with and without the patch. Powertop also nicely shows that the CPU is
still spending almost all of its time in C3. Therefore, I'm letting the
effects of it be enabled by default.

So I'm taking the [RFC] off it. Please still test and see that it
solves the issue on other machines, and the it does not cause any big
power surges.

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 78d77c5..d9c43e3 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -16,6 +16,8 @@
 
 #define BREAK_FUZZ     4       /* 4 us */
 
+static unsigned int min_deep_sleep = 2000;
+
 struct menu_device {
        int             last_state_idx;
 
@@ -50,6 +52,19 @@ static int menu_select(struct cpuidle_device *dev)
                        break;
                if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))
                        break;
+
+               /*
+                * In order to avoid the problem of "singing capacitors",
+                * don't enter a deep sleep for short durations (by
+                * default, nothing shorter than 2 ms). This will,
+                * hopefully, keep the problem inaudible.
+                */
+               if (s->flags & CPUIDLE_FLAG_DEEP) {
+                       if (min_deep_sleep > data->expected_us)
+                               break;
+                       if (min_deep_sleep > data->predicted_us)
+                               break;
+               }
        }
 
        data->last_state_idx = i - 1;
@@ -132,6 +147,9 @@ static void __exit exit_menu(void)
        cpuidle_unregister_governor(&menu_governor);
 }
 
+module_param(min_deep_sleep, uint, 0644)
+MODULE_PARM_DESC(min_deep_sleep, "min time (us) to spend in deep sleep to avoid noise")
+
 MODULE_LICENSE("GPL");
 module_init(init_menu);
 module_exit(exit_menu);



-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
