Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab0AOByR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569Ab0AOBxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:53:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:51387 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab0AOBxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="587306570"
Message-Id: <20100115014209.992004000@intel.com>
References: <20100115013957.027452000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jan 2010 17:39:59 -0800
From: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Len Brown" <lenb@kernel.org>,
        "Mark Hounschell" <markh@compro.net>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Alain Knaff" <alain@knaff.lu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: [patch 2/4] x86: Do not use hpet MSI as clockevent broadcast device
Content-Disposition: inline; filename=0003-x86-Do-not-use-hpet-MSI-as-clockevent-broadcast-dev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel uses hpet MSI interrupts as both percpu clockevent device
and also as clockevent broadcast device in place of IRQ0 timer.
There seems to be issues with HPET MSI usage on some platforms. So,
restrict it to be only used as a percpu clockevent device.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/kernel/hpet.c       |    2 +-
 include/linux/clockchips.h   |    2 ++
 kernel/time/tick-broadcast.c |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ba6e658..dd9370b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -556,7 +556,7 @@ static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
 	evt->irq = hdev->irq;
 
 	evt->rating = 110;
-	evt->features = CLOCK_EVT_FEAT_ONESHOT;
+	evt->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_NO_BROADCAST;
 	if (hdev->flags & HPET_DEV_PERI_CAP)
 		evt->features |= CLOCK_EVT_FEAT_PERIODIC;
 
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 0cf725b..5352187 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -50,9 +50,11 @@ enum clock_event_nofitiers {
  *
  * - Clockevent source stops in C3 State and needs broadcast support.
  * - Local APIC timer is used as a dummy device.
+ * - Do not use this device as a broadcast device.
  */
 #define CLOCK_EVT_FEAT_C3STOP		0x000004
 #define CLOCK_EVT_FEAT_DUMMY		0x000008
+#define CLOCK_EVT_FEAT_NO_BROADCAST	0x000010
 
 /**
  * struct clock_event_device - clock event device descriptor
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index b3bafd5..113f954 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -69,7 +69,8 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 {
 	if ((tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
-	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
+	     dev->features & CLOCK_EVT_FEAT_C3STOP ||
+	     dev->features & CLOCK_EVT_FEAT_NO_BROADCAST)
 		return 0;
 
 	clockevents_exchange_device(NULL, dev);
-- 
1.6.0.6

-- 

