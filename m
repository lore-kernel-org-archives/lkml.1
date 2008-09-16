Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbYIPRDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbYIPRDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYIPRDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:03:09 -0400
Received: from www.tglx.de ([62.245.132.106]:59523 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbYIPRDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:03:08 -0400
Date: Tue, 16 Sep 2008 10:02:51 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
In-Reply-To: <alpine.LFD.1.10.0809160715120.3606@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809161000410.3875@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de> <20080914100913.GB7909@elf.ucw.cz> <20080914101406.GA1625@elf.ucw.cz> <20080914173536.GA1687@elf.ucw.cz> <alpine.LFD.1.10.0809141049570.5283@apollo.tec.linutronix.de>
 <20080914181228.GA18934@elf.ucw.cz> <alpine.LFD.1.10.0809141214110.5283@apollo.tec.linutronix.de> <20080915091925.GB1787@elf.ucw.cz> <alpine.LFD.1.10.0809150704420.5283@apollo.tec.linutronix.de> <20080915192600.GA1627@elf.ucw.cz> <20080915195951.GA1651@elf.ucw.cz>
 <alpine.LFD.1.10.0809160715120.3606@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008, Thomas Gleixner wrote:
> On Mon, 15 Sep 2008, Pavel Machek wrote:
> > > cg-seek here, and problem is back. Good. I can get the

Does the patch below fix it ?

Thanks,

	tglx
----
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 1876b52..eb8736f 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -69,6 +69,9 @@ void clockevents_set_mode(struct clock_event_device *dev,
 		dev->set_mode(mode, dev);
 		dev->mode = mode;
 	}
+
+	if (mode == CLOCK_EVT_MODE_SHUTDOWN)
+		dev->next_event.tv64 = KTIME_MAX;
 }
 
 /**
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 2f5a382..6b0b230 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -434,6 +434,19 @@ again:
 }
 
 /*
+ * We shutdown the device which will stop anyway, but we keep the
+ * next_event untouched as it carries the information when we
+ * broadcast.
+ */
+static void tick_broadcast_shutdown_device(struct clock_event_device *dev)
+{
+	if (dev->mode != CLOCK_EVT_MODE_SHUTDOWN) {
+		dev->set_mode(CLOCK_EVT_MODE_SHUTDOWN, dev);
+		dev->mode = CLOCK_EVT_MODE_SHUTDOWN;
+	}
+}
+
+/*
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
  */
@@ -464,7 +477,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
 			cpu_set(cpu, tick_broadcast_oneshot_mask);
-			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
+			tick_broadcast_shutdown_device(dev);
 			if (dev->next_event.tv64 < bc->next_event.tv64)
 				tick_broadcast_set_event(dev->next_event, 1);
 		}
