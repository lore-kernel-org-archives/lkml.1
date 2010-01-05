Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377Ab0AEUPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0AEUPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607Ab0AEUPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:15:32 -0500
Received: from kroah.org ([198.145.64.141]:49939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab0AEUF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:05:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:02:59 2010
Message-Id: <20100105200259.383241783@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [04/39] clockevents: Prevent clockevent_devices list corruption on cpu hotplug
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -237,8 +237,9 @@ void clockevents_exchange_device(struct 
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
-	struct list_head *node, *tmp;
+	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
+	int cpu;
 
 	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
@@ -249,8 +250,19 @@ void clockevents_notify(unsigned long re
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


