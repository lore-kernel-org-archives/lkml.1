Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZLJNI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZLJNI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZLJNII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:08:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbZLJNID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:08:03 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: tglx@linutronix.de, damm@igel.co.jp, hsweeten@visionengravers.com,
       akpm@linux-foundation.org, venkatesh.pallipadi@intel.com
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH 4/4] clockevents: remove related device from clockevents_released list when cpu is DEAD
Date: Thu, 10 Dec 2009 21:07:39 +0800
Message-Id: <1260450459-18072-5-git-send-email-dfeng@redhat.com>
In-Reply-To: <1260450459-18072-4-git-send-email-dfeng@redhat.com>
References: <1260450459-18072-1-git-send-email-dfeng@redhat.com>
 <1260450459-18072-2-git-send-email-dfeng@redhat.com>
 <1260450459-18072-3-git-send-email-dfeng@redhat.com>
 <1260450459-18072-4-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have converted clockevent_devices to store all active devices, and
clockevents_released to store all fail-to-add/replace-out devices. So
at cpu offline stage, we should clear the clockevents related with the
offline cpu.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 kernel/time/clockevents.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index babcb30..d27fcba 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -246,6 +246,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 {
 	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
+	int *cpup;
 
 	spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
@@ -256,8 +257,10 @@ void clockevents_notify(unsigned long reason, void *arg)
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
 		 */
+		cpup = (int *)arg;
 		list_for_each_entry_safe(dev, tmp, &clockevents_released, list)
-			list_del(&dev->list);
+			if (cpumask_test_cpu(*cpup, dev->cpumask))
+				list_del(&dev->list);
 		break;
 	default:
 		break;
-- 
1.6.5.2

