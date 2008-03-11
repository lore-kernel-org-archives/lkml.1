Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYCKHwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYCKHwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 03:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYCKHvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 03:51:52 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:35435 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYCKHvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 03:51:51 -0400
Date: Tue, 11 Mar 2008 08:51:45 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "LKML" <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Dave Jones" <davej@codemonkey.org.uk>, "Andi Kleen" <andi@firstfloor.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Adam Belay" <abelay@novell.com>, "Lee Revell" <rlrevell@joe-job.com>,
       "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080311085145.5fcf3186@mjolnir.drzeus.cx>
In-Reply-To: <20080309151659.63d54f38@mjolnir.drzeus.cx>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080303231033.GB15255@one.firstfloor.org>
	<20080304040048.GA31562@codemonkey.org.uk>
	<20080304071423.0e6b71c1@mjolnir.drzeus.cx>
	<20080304181924.70aaf8c1@mjolnir.drzeus.cx>
	<924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com>
	<20080305070201.0d16cd40@mjolnir.drzeus.cx>
	<20080305094023.6486ebdf@mjolnir.drzeus.cx>
	<20080306092730.4412d085@mjolnir.drzeus.cx>
	<20080309151659.63d54f38@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a sudden surge of inspiration and decided to follow up on this
one a bit: 

> 
> 5. Second core
> 
> Disabling the second core makes the noise go away. This might be a subset of 1., as I've been told that a stopped core enters C1.
> 

I have now found a very hacky workaround that is slightly better than
disabling C3 altogether; making C3 exclusive to one core at a time. It
seems to kill the noise and the system now spends 50% in C3, instead of
0%.

I read somewhere that the Intel Duo:s have an extra low power mode that
is entered if both cores are suspended at the same time (disabling the
shared cache or something like that I guess). So perhaps that mode is
the culprit. I'm hoping there's a way to disable just that feature. Do
any of you know a way? Venkatesh perhaps?

Here's the patch I'm currently running at least:

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 78d77c5..9a859fb 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -16,6 +16,8 @@
 
 #define BREAK_FUZZ     4       /* 4 us */
 
+static atomic_t cur_deep_cpu = ATOMIC_INIT(-1);
+
 struct menu_device {
        int             last_state_idx;
 
@@ -50,6 +52,13 @@ static int menu_select(struct cpuidle_device *dev)
                        break;
                if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))
                        break;
+
+               if (s->flags & CPUIDLE_FLAG_DEEP) {
+                       rmb();
+                       if (atomic_cmpxchg(&cur_deep_cpu, -1, dev->cpu) != -1)
+                               break;
+                       wmb();
+               }
        }
 
        data->last_state_idx = i - 1;
@@ -80,6 +89,11 @@ static void menu_reflect(struct cpuidle_device *dev)
        if (!(target->flags & CPUIDLE_FLAG_TIME_VALID))
                measured_us = USEC_PER_SEC / HZ;
 
+       if (atomic_read(&cur_deep_cpu) == dev->cpu) {
+               atomic_set(&cur_deep_cpu, -1);
+               wmb();
+       }
+
        /* Predict time remaining until next break event */
        if (measured_us + BREAK_FUZZ < data->expected_us - target->exit_latency) {
                data->predicted_us = max(measured_us, data->last_measured_us);


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
