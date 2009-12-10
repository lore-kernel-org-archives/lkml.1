Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbZLJNII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbZLJNII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZLJNIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZLJNIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:08:00 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: tglx@linutronix.de, damm@igel.co.jp, hsweeten@visionengravers.com,
       akpm@linux-foundation.org, venkatesh.pallipadi@intel.com
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH 3/4] clockevents: add device to clockevent_devices list if notify ADD success
Date: Thu, 10 Dec 2009 21:07:38 +0800
Message-Id: <1260450459-18072-4-git-send-email-dfeng@redhat.com>
In-Reply-To: <1260450459-18072-3-git-send-email-dfeng@redhat.com>
References: <1260450459-18072-1-git-send-email-dfeng@redhat.com>
 <1260450459-18072-2-git-send-email-dfeng@redhat.com>
 <1260450459-18072-3-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we register new clock_event_device, CLOCK_EVT_NOTIFY_ADD was notified,
but tick_check_new_device may fail to use new device, we should only add
device to clockevent_devices list when tick_check_new_device success.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 kernel/time/clockevents.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 980c2c0..69d6c58 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -164,11 +164,14 @@ static int clockevents_do_notify(unsigned long reason, void *dev)
 static void clockevents_notify_released(void)
 {
 	struct clock_event_device *dev, *tmp;
+	int ret;
 
 	list_for_each_entry_safe(dev, tmp, &clockevents_released, list) {
-		list_del(&dev->list);
-		list_add(&dev->list, &clockevent_devices);
-		clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
+		ret = clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
+		if (ret == NOTIFY_STOP) {
+			list_del(&dev->list);
+			list_add(&dev->list, &clockevent_devices);
+		}
 	}
 }
 
@@ -179,15 +182,19 @@ static void clockevents_notify_released(void)
 void clockevents_register_device(struct clock_event_device *dev)
 {
 	unsigned long flags;
+	int ret;
 
 	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 	BUG_ON(!dev->cpumask);
 
 	spin_lock_irqsave(&clockevents_lock, flags);
 
-	list_add(&dev->list, &clockevent_devices);
-	clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
-	clockevents_notify_released();
+	ret = clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
+	if (ret == NOTIFY_STOP) {
+		list_add(&dev->list, &clockevent_devices);
+		clockevents_notify_released();
+	} else
+		list_add(&dev->list, &clockevents_released);
 
 	spin_unlock_irqrestore(&clockevents_lock, flags);
 }
