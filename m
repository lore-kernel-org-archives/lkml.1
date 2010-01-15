Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0AOByf (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687Ab0AOBxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:53:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:24206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0AOBxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,278,1262592000"; 
   d="scan'208";a="764389679"
Message-Id: <20100115014210.137236000@intel.com>
References: <20100115013957.027452000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jan 2010 17:40:00 -0800
From: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Len Brown" <lenb@kernel.org>,
        "Mark Hounschell" <markh@compro.net>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Alain Knaff" <alain@knaff.lu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: [patch 3/4] clockevent: Add tick_check_fallback_timer to look for fallback timer
Content-Disposition: inline; filename=0004-clockevent-Add-tick_check_fallback_timer-to-look-fo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before switching to braodcast timer, in the event of C3 timer stoppage,
look for any other per cpu timer as a fallback.

This will be used in the following patch where we use HPET MSI as a
fallback timer for LAPIC timer, when C-states are supported.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 include/linux/clockchips.h  |    2 +
 kernel/time/clockevents.c   |   29 +++++++++++++++++++++++++++-
 kernel/time/tick-common.c   |   44 +++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-internal.h |    3 ++
 4 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 5352187..791952f 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -51,10 +51,12 @@ enum clock_event_nofitiers {
  * - Clockevent source stops in C3 State and needs broadcast support.
  * - Local APIC timer is used as a dummy device.
  * - Do not use this device as a broadcast device.
+ * - Rating has been reduced for this device as system is C3 capable.
  */
 #define CLOCK_EVT_FEAT_C3STOP		0x000004
 #define CLOCK_EVT_FEAT_DUMMY		0x000008
 #define CLOCK_EVT_FEAT_NO_BROADCAST	0x000010
+#define CLOCK_EVT_FEAT_RATING_REDUCED	0x000020
 
 /**
  * struct clock_event_device - clock event device descriptor
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 6f740d9..6641c97 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -161,7 +161,7 @@ static void clockevents_do_notify(unsigned long reason, void *dev)
  * Called after a notify add to make devices available which were
  * released from the notifier call.
  */
-static void clockevents_notify_released(void)
+void clockevents_notify_released(void)
 {
 	struct clock_event_device *dev;
 
@@ -203,6 +203,33 @@ void clockevents_handle_noop(struct clock_event_device *dev)
 }
 
 /**
+ * clockevents_lookup_newdev - lookup for a higher rated device on this cpu
+ * @cpu:	CPU that the call corresponds to
+ * @rating:	baseline rating (look for higher than this rating)
+ *
+ * Called from the notifier chain. clockevents_lock is held already
+ */
+struct clock_event_device *clockevents_lookup_newdev(int cpu, int rating)
+{
+	struct clock_event_device *dev, *tmp, *found_dev = NULL;
+	int found_rating = 0;
+
+	list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
+		if (cpumask_test_cpu(cpu, dev->cpumask) &&
+		    cpumask_weight(dev->cpumask) == 1 &&
+		    dev->rating > found_rating) {
+			found_rating = dev->rating;
+			found_dev = dev;
+		}
+	}
+
+	if (found_rating > rating)
+		return found_dev;
+
+	return NULL;
+}
+
+/**
  * clockevents_exchange_device - release and request clock devices
  * @old:	device to release (can be NULL)
  * @new:	device to request (can be NULL)
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b6b898d..e9626ad 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -284,6 +284,48 @@ out_bc:
 }
 
 /*
+ * Try to find an alternate timer which does not need broadcast.
+ */
+static void tick_check_fallback_timer(void)
+{
+	struct clock_event_device *curdev;
+	struct clock_event_device *newdev = NULL;
+	struct tick_device *td;
+	int cpu;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&tick_device_lock, flags);
+
+	cpu = smp_processor_id();
+
+	td = &per_cpu(tick_cpu_device, cpu);
+	curdev = td->evtdev;
+
+	/* Check whether current timer is affected by C3 */
+	if (!curdev || !cpumask_equal(curdev->cpumask, cpumask_of(cpu)) ||
+	    !(curdev->features & CLOCK_EVT_FEAT_C3STOP))
+		goto out;
+
+	/* Check if we have already reduced the rating of this device once */
+	if (curdev->features & CLOCK_EVT_FEAT_RATING_REDUCED)
+		goto out;
+
+	curdev->features |= CLOCK_EVT_FEAT_RATING_REDUCED;
+	curdev->rating -= 10;
+	newdev = clockevents_lookup_newdev(cpu, curdev->rating);
+
+out:
+	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
+
+	if (newdev) {
+		tick_check_new_device(newdev);
+		clockevents_notify_released();
+	}
+
+	return;
+}
+
+/*
  * Transfer the do_timer job away from a dying cpu.
  *
  * Called with interrupts disabled.
@@ -365,6 +407,8 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
 		return tick_check_new_device(dev);
 
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
+		tick_check_fallback_timer();
+		/* FALLTHRU */
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		tick_broadcast_on_off(reason, dev);
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 290eefb..c72703d 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -14,6 +14,9 @@ extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
+extern struct clock_event_device *clockevents_lookup_newdev(int cpu,
+							    int rating);
+extern void clockevents_notify_released(void);
 
 /*
  * NO_HZ / high resolution timer shared code
-- 
1.6.0.6

-- 

