Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZLUUVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZLUUVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZLUUVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:21:54 -0500
Received: from mail.vyatta.com ([76.74.103.46]:52640 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZLUUVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:21:54 -0500
Date: Mon, 21 Dec 2009 12:21:21 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mike Garrison <mcgarr@umich.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Len Brown <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32.2: undefined reference to `__udivdi3'
Message-ID: <20091221122121.6853d68c@nehalam>
In-Reply-To: <61FF0336-4E17-4EE5-9471-01360A6F7D29@umich.edu>
References: <61FF0336-4E17-4EE5-9471-01360A6F7D29@umich.edu>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new menu governor driver is written by Intel folks who never use 32-bit
anymore it seems :-)
---------------------------------------------------------
Subject: [PATCH] menu: use proper 64 bit math

The new menu governor is incorrectly doing a 64 bit divide.
Compile tested only

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/cpuidle/governors/menu.c	2009-12-21 12:02:25.840083589 -0800
+++ b/drivers/cpuidle/governors/menu.c	2009-12-21 12:16:42.418834255 -0800
@@ -18,6 +18,7 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 #include <linux/sched.h>
+#include <linux/math64.h>
 
 #define BUCKETS 12
 #define RESOLUTION 1024
@@ -169,6 +170,12 @@ static DEFINE_PER_CPU(struct menu_device
 
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
@@ -209,9 +216,8 @@ static int menu_select(struct cpuidle_de
 		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
 
 	/* Make sure to round up for half microseconds */
-	data->predicted_us = DIV_ROUND_CLOSEST(
-		data->expected_us * data->correction_factor[data->bucket],
-		RESOLUTION * DECAY);
+	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
+					 RESOLUTION * DECAY);
 
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
