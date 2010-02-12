Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0BLWUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:20:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041Ab0BLWUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:20:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com
Subject: [PATCH 3/4] nmi_watchdog: fallback to software events when no hardware pmu detected
Date: Fri, 12 Feb 2010 17:19:20 -0500
Message-Id: <1266013161-31197-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all arches have a PMU or have perf_event support for their PMU.  The
nmi_watchdog will fail in those cases.  Fallback to using software events to
generate nmi_watchdog traffic with local apic interrupts.

Tested on a Pentium4 and it worked as expected, excepting for detecting cpu
lockups.

The problem with using software events as a cpu lock up detector is the
nmi_watchdog uses the logic that if local apic interrupts stop incrementing
then the cpu is probably locked up.  But with software events we use the
local apic to trigger the nmi_watchdog callback to see if local apic
interrupts are still firing, which obviously they are otherwise we wouldn't
have been triggered.

The algorithm to detect cpu lock ups is the same as the old nmi_watchdog.
Perhaps we need to find a better way to detect lock ups?

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/nmi_watchdog.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
index 73c1954..4f23505 100644
--- a/kernel/nmi_watchdog.c
+++ b/kernel/nmi_watchdog.c
@@ -166,8 +166,12 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		wd_attr.sample_period = hw_nmi_get_sample_period();
 		event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
 		if (IS_ERR(event)) {
-			printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", hotcpu, event);
-			return NOTIFY_BAD;
+			wd_attr.type = PERF_TYPE_SOFTWARE;
+			event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
+			if (IS_ERR(event)) {
+				printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", hotcpu, event);
+				return NOTIFY_BAD;
+			}
 		}
 		per_cpu(nmi_watchdog_ev, hotcpu) = event;
 		perf_event_enable(per_cpu(nmi_watchdog_ev, hotcpu));
-- 
1.6.6.83.gc9a2

