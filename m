Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007Ab0ANW2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0ANW2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047Ab0ANW2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:37 -0500
Received: from kroah.org ([198.145.64.141]:60570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0ANW2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Len Brown <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/52] drivers/cpuidle/governors/menu.c: fix undefined reference to `__udivdi3'
Date: Thu, 14 Jan 2010 14:27:00 -0800
Message-Id: <1263508051-7868-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-20-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>

commit 5787536edf18e33d06e2bf038bfd0910f4def213 upstream.

menu: use proper 64 bit math

The new menu governor is incorrectly doing a 64 bit divide.  Compile
tested only

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/cpuidle/governors/menu.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 6810443..73655ae 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -18,6 +18,7 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 #include <linux/sched.h>
+#include <linux/math64.h>
 
 #define BUCKETS 12
 #define RESOLUTION 1024
@@ -169,6 +170,12 @@ static DEFINE_PER_CPU(struct menu_device, menu_devices);
 
 static void menu_update(struct cpuidle_device *dev);
 
+/* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
+static u64 div_round64(u64 dividend, u32 divisor)
+{
+	return div_u64(dividend + (divisor / 2), divisor);
+}
+
 /**
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
@@ -209,9 +216,8 @@ static int menu_select(struct cpuidle_device *dev)
 		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
 
 	/* Make sure to round up for half microseconds */
-	data->predicted_us = DIV_ROUND_CLOSEST(
-		data->expected_us * data->correction_factor[data->bucket],
-		RESOLUTION * DECAY);
+	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
+					 RESOLUTION * DECAY);
 
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
-- 
1.6.6

