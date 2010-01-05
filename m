Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179Ab0AEA4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0AEA4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472Ab0AEA4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:56:13 -0500
Received: from kroah.org ([198.145.64.141]:34105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0AEAem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/97] clockevents: Prevent clockevent_devices list corruption on cpu hotplug
Date: Mon,  4 Jan 2010 16:32:21 -0800
Message-Id: <1262651630-7354-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit bb6eddf7676e1c1f3e637aa93c5224488d99036f upstream.

Xiaotian Feng triggered a list corruption in the clock events list on
CPU hotplug and debugged the root cause.

If a CPU registers more than one per cpu clock event device, then only
the active clock event device is removed on CPU_DEAD. The unused
devices are kept in the clock events device list.

On CPU up the clock event devices are registered again, which means
that we list_add an already enqueued list_head. That results in list
corruption.

Resolve this by removing all devices which are associated to the dead
CPU on CPU_DEAD.

Reported-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/time/clockevents.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 620b58a..9484be4 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -237,8 +237,9 @@ void clockevents_exchange_device(struct clock_event_device *old,
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
-	struct list_head *node, *tmp;
+	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
+	int cpu;
 
 	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
@@ -249,8 +250,19 @@ void clockevents_notify(unsigned long reason, void *arg)
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
-		list_for_each_safe(node, tmp, &clockevents_released)
-			list_del(node);
+		list_for_each_entry_safe(dev, tmp, &clockevents_released, list)
+			list_del(&dev->list);
+		/*
+		 * Now check whether the CPU has left unused per cpu devices
+		 */
+		cpu = *((int *)arg);
+		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
+			if (cpumask_test_cpu(cpu, dev->cpumask) &&
+			    cpumask_weight(dev->cpumask) == 1) {
+				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
+				list_del(&dev->list);
+			}
+		}
 		break;
 	default:
 		break;
-- 
1.6.6

