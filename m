Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZFED3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZFED3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZFED3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:29:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:58834 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbZFED3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:29:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,308,1241420400"; 
   d="scan'208,223";a="150927217"
Date: Fri, 5 Jun 2009 11:27:11 +0800
From: Feng Tang <feng.tang@intel.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] tick: add check for the existence of broadcast clock event
 device
Message-ID: <20090605112711.67e7d5cb@feng-desktop>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2f076e1867c8bbb145b74d289358174644d9fed8 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Fri, 5 Jun 2009 10:36:15 +0800
Subject: [PATCH] tick: add check for the existence of broadcast clock event device

Some platform may have no broadcast clock event device, as it use always-on
external timers for per-cpu timer and has no extra one for broadcast device.
This check will secure the access to bc device when system get some boradcast
on/off and enter/exit message

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 kernel/time/tick-broadcast.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 118a3b3..110e0bc 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -214,10 +214,13 @@ static void tick_do_broadcast_on_off(void *why)
 
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
+	bc = tick_broadcast_device.evtdev;
+	if (!bc)
+		goto out;
+
 	cpu = smp_processor_id();
 	td = &per_cpu(tick_cpu_device, cpu);
 	dev = td->evtdev;
-	bc = tick_broadcast_device.evtdev;
 
 	/*
 	 * Is the device not affected by the powerstate ?
@@ -468,6 +471,9 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 		goto out;
 
 	bc = tick_broadcast_device.evtdev;
+	if (!bc)
+		goto out;
+
 	cpu = smp_processor_id();
 	td = &per_cpu(tick_cpu_device, cpu);
 	dev = td->evtdev;
-- 
1.5.6.3
