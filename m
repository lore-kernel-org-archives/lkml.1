Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbXIAQIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbXIAQIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 12:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXIAQIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 12:08:45 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4977 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754813AbXIAQIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 12:08:44 -0400
Message-Id: <20070901155140.972420930@mvista.com>
User-Agent: quilt/0.46-1
Date: Sat, 01 Sep 2007 08:51:40 -0700
From: Daniel Walker <dwalker@mvista.com>
To: torvalds@linux-foundation.org
Cc: Bob Picco <bob.picco@hp.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.23-rc5] driver/char/hpet.c: remove clocksource warning on !IA64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The warnings,

drivers/char/hpet.c:72: warning: 'clocksource_hpet' defined but not used
drivers/char/hpet.c:81: warning: 'hpet_clocksource' defined but not used

from,

commit 3b2b64fd311c92f2137eb7cee7025794cd854057
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Fri Aug 31 20:13:57 2007 -0700


This patch eliminates the warnings when the clocksoure isn't used.
It also removes some other unused stuff that goes along with the
clocksource ..

I don't have access to an ia64 machine, or even a compiler .. So this
one is untested for that. I'm hoping one of the ia64 guys can help
test this?

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/char/hpet.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

Index: linux-2.6.22/drivers/char/hpet.c
===================================================================
--- linux-2.6.22.orig/drivers/char/hpet.c
+++ linux-2.6.22/drivers/char/hpet.c
@@ -62,6 +62,7 @@
 
 static u32 hpet_nhpet, hpet_max_freq = HPET_USER_FREQ;
 
+#ifdef CONFIG_IA64
 static void __iomem *hpet_mctr;
 
 static cycle_t read_hpet(void)
@@ -80,6 +81,23 @@ static struct clocksource clocksource_hp
 };
 static struct clocksource *hpet_clocksource;
 
+/* This clocksource driver currently only works on ia64 */
+static inline void ia64_clocksource_register(void)
+{
+	if (!hpet_clocksource) {
+		hpet_mctr = (void __iomem *)&hpetp->hp_hpet->hpet_mc;
+		CLKSRC_FSYS_MMIO_SET(clocksource_hpet.fsys_mmio, hpet_mctr);
+		clocksource_hpet.mult = clocksource_hz2mult(hpetp->hp_tick_freq,
+						clocksource_hpet.shift);
+		clocksource_register(&clocksource_hpet);
+		hpetp->hp_clocksource = &clocksource_hpet;
+		hpet_clocksource = &clocksource_hpet;
+	}
+}
+#else
+static inline void ia64_clocksource_register(void) { }
+#endif
+
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);
 /* A lock for concurrent intermodule access to hpet and isr hpet activity. */
@@ -909,18 +927,8 @@ int hpet_alloc(struct hpet_data *hdp)
 
 	hpetp->hp_delta = hpet_calibrate(hpetp);
 
-/* This clocksource driver currently only works on ia64 */
-#ifdef CONFIG_IA64
-	if (!hpet_clocksource) {
-		hpet_mctr = (void __iomem *)&hpetp->hp_hpet->hpet_mc;
-		CLKSRC_FSYS_MMIO_SET(clocksource_hpet.fsys_mmio, hpet_mctr);
-		clocksource_hpet.mult = clocksource_hz2mult(hpetp->hp_tick_freq,
-						clocksource_hpet.shift);
-		clocksource_register(&clocksource_hpet);
-		hpetp->hp_clocksource = &clocksource_hpet;
-		hpet_clocksource = &clocksource_hpet;
-	}
-#endif
+	ia64_clocksource_register();
+
 
 	return 0;
 }
-- 

-- 
