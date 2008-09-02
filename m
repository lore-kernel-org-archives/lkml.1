Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYIBDg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYIBDg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 23:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbYIBDgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 23:36:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbYIBDgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 23:36:17 -0400
Date: Mon, 1 Sep 2008 20:35:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Sep 2008, Linus Torvalds wrote:
> 
> Well, the biggest problem is actually _detection_.
> 
> We have three different timers, and they all have their own problems. How 
> do you reliably detect which one to use? The PM_TIMER clearly is _not_ 
> always the answer here, but the code just assumes it is!

On the machine you have trouble with the PIT on, does this thing trigger?

If it does, that could be a simple way to say whether you prefer PM_TIMER 
over PIT.

For me, even on a modern machine, I get a pit_count of 46321, which 
matches the "about one microsecond for an ISA/LPC read" timing pretty 
well. What do you get? 

		Linus

---
 arch/x86/kernel/tsc.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 8e786b0..7cf7543 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -131,6 +131,7 @@ unsigned long native_calibrate_tsc(void)
 	u64 tsc1, tsc2, tr1, tr2, delta, pm1, pm2, hpet1, hpet2;
 	int hpet = is_hpet_enabled();
 	unsigned int tsc_khz_val = 0;
+	unsigned int pit_count;
 
 	local_irq_save(flags);
 
@@ -142,7 +143,9 @@ unsigned long native_calibrate_tsc(void)
 	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
 	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
 	tr1 = get_cycles();
-	while ((inb(0x61) & 0x20) == 0);
+	pit_count = 0;
+	while ((inb(0x61) & 0x20) == 0)
+		pit_count++;
 	tr2 = get_cycles();
 
 	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
@@ -150,6 +153,18 @@ unsigned long native_calibrate_tsc(void)
 	local_irq_restore(flags);
 
 	/*
+	 * We should have waited for about 50ms, and a real hardware
+	 * PIT access _should_ take about a microsecond even if it's
+	 * over an ISA bus (or something that tries to emulate timings).
+	 *
+	 * So pit_count should be 50,000+. If it's a lot lower, that
+	 * implies it might be some emulated device rather than real
+	 * hardware..
+	 */
+	if (pit_count < 25000)
+		printk("Slow PIT device (%u) - emulated using SMI?\n", pit_count);
+
+	/*
 	 * Preset the result with the raw and inaccurate PIT
 	 * calibration value
 	 */
