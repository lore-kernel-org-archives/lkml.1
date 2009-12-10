Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbZLJNIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbZLJNIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758181AbZLJNIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:08:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757906AbZLJNID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:08:03 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: tglx@linutronix.de, damm@igel.co.jp, hsweeten@visionengravers.com,
       akpm@linux-foundation.org, venkatesh.pallipadi@intel.com
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH 1/4] clockevents: use list_for_each_entry_safe
Date: Thu, 10 Dec 2009 21:07:36 +0800
Message-Id: <1260450459-18072-2-git-send-email-dfeng@redhat.com>
In-Reply-To: <1260450459-18072-1-git-send-email-dfeng@redhat.com>
References: <1260450459-18072-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iterating behaviour is same as before, but later patches will
get benifit from this convert.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 kernel/time/clockevents.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 20a8920..1896d9d 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -163,11 +163,9 @@ static void clockevents_do_notify(unsigned long reason, void *dev)
  */
 static void clockevents_notify_released(void)
 {
-	struct clock_event_device *dev;
+	struct clock_event_device *dev, *tmp;
 
-	while (!list_empty(&clockevents_released)) {
-		dev = list_entry(clockevents_released.next,
-				 struct clock_event_device, list);
+	list_for_each_entry_safe(dev, tmp, &clockevents_released, list) {
 		list_del(&dev->list);
 		list_add(&dev->list, &clockevent_devices);
 		clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
@@ -238,7 +236,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
  */
 void clockevents_notify(unsigned long reason, void *arg)
 {
-	struct list_head *node, *tmp;
+	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
 
 	spin_lock_irqsave(&clockevents_lock, flags);
@@ -250,8 +248,8 @@ void clockevents_notify(unsigned long reason, void *arg)
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
-		list_for_each_safe(node, tmp, &clockevents_released)
-			list_del(node);
+		list_for_each_entry_safe(dev, tmp, &clockevents_released, list)
+			list_del(&dev->list);
 		break;
 	default:
 		break;
-- 
1.6.5.2

