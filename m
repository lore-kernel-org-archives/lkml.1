Return-Path: <linux-kernel-owner+w=401wt.eu-S932941Ab0AGDXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab0AGDXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710Ab0AGDXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:23:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709Ab0AGDXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:23:21 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <damm@igel.co.jp>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH] clockevent: don't remove broadcast device when cpu is dead
Date: Thu,  7 Jan 2010 11:22:44 +0800
Message-Id: <1262834564-13033-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc reported BUG during shutdown, after debugging, kernel is trying
to remove a broadcast device which mode is CLOCK_EVT_MODE_ONESHOT.

The root cause for this bug is that in clockevents_notify,
"cpumask_weight(dev->cpumask) == 1" is always true even if dev is a
broadcast device. We need to use tick_is_broadcast_device to check
if it is a broadcast device.

Reported-by: Marc Dionne <marc.c.dionne@gmail.com>
Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 kernel/time/clockevents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 6f740d9..0223d83 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -259,7 +259,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 		cpu = *((int *)arg);
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
-			    cpumask_weight(dev->cpumask) == 1) {
+			    !tick_is_broadcast_device(dev)) {
 				BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
 				list_del(&dev->list);
 			}
-- 
1.6.5.2

