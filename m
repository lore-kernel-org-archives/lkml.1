Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbZAPIQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbZAPIQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbZAPIQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:16:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:58594 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbZAPIQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=HY7kciboRTLnAUqCos3Bs+WepkSfSwHRk/+wEnUvc6SQmLwofTbJC4XZC1SIiGpZ0p
         piUU8LSvfVdvfQ/Nz+R3fbV8s0SOaqe5Jk6FhEFWHt1CpOCPw1m0LuHVxVKZm2tUmK5q
         xkddA9YZP58RMW9ePlQiUlLSNlEmW1fZXE5nQ=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, lethal@linux-sh.org,
       tglx@linutronix.de, Magnus Damm <magnus.damm@gmail.com>,
       mingo@redhat.com
Date: Fri, 16 Jan 2009 17:14:38 +0900
Message-Id: <20090116081438.12388.15130.sendpatchset@rx1.opensource.se>
Subject: [RESEND][PATCH] clockevent: let set_mode() setup delta information
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Allow the set_mode() clockevent callback to decide and fill in delta
details such as shift, mult, max_delta_ns and min_delta_ns.

With this change the clockevent can be registered without delta details
which allows us to keep the parent clock disabled until the clockevent
gets setup using set_mode().

Letting set_mode() fill in or update delta details allows us to save
power by disabling the parent clock while the clockevent is unused.
This may however make the parent clock rate change, so next time the
clockevent gets enabled we need let set_mode() to update the detla
details accordingly. Doing it at registration time is not enough.

Furthermore, the delta details seem unused in the case of periodic-only
clockevent drivers, so this change also allows registration of such
drivers without the delta details filled in.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 This patch was previously sent to linuxsh-dev 2008-12-01.

 kernel/time/clockevents.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- 0001/kernel/time/clockevents.c
+++ work/kernel/time/clockevents.c	2008-11-28 15:51:31.000000000 +0900
@@ -68,6 +68,17 @@ void clockevents_set_mode(struct clock_e
 	if (dev->mode != mode) {
 		dev->set_mode(mode, dev);
 		dev->mode = mode;
+
+		/*
+		 * A nsec2cyc multiplicator of 0 is invalid and we'd crash
+		 * on it, so fix it up and emit a warning:
+		 */
+		if (mode == CLOCK_EVT_MODE_ONESHOT) {
+			if (unlikely(!dev->mult)) {
+				dev->mult = 1;
+				WARN_ON(1);
+			}
+		}
 	}
 }
 
@@ -166,15 +177,6 @@ static void clockevents_notify_released(
 void clockevents_register_device(struct clock_event_device *dev)
 {
 	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
-	/*
-	 * A nsec2cyc multiplicator of 0 is invalid and we'd crash
-	 * on it, so fix it up and emit a warning:
-	 */
-	if (unlikely(!dev->mult)) {
-		dev->mult = 1;
-		WARN_ON(1);
-	}
-
 	spin_lock(&clockevents_lock);
 
 	list_add(&dev->list, &clockevent_devices);
