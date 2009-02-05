Return-Path: <linux-kernel-owner+w=401wt.eu-S1763074AbZBETtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763074AbZBETtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZBETtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:49:33 -0500
Received: from mail.candelatech.com ([208.74.158.172]:40486 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbZBETtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:49:32 -0500
Message-ID: <498B42C5.7010905@candelatech.com>
Date: Thu, 05 Feb 2009 11:49:25 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: rusty@rustcorp.com.au
Subject: PATCH:  Allow user to force 'tsc' to be treated as stable.
Content-Type: multipart/mixed;
 boundary="------------060905070805060007060801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060905070805060007060801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Allow user to force TSC as stable clock-source.
Works around BIOS issues in the FWA-7304 (Via CN700 chipset)
system, and possibly others.

This is against 2.6.29-rc3.

Signed-Off-By:  Ben Greear<greearb@candelatech.com>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------060905070805060007060801
Content-Type: text/x-patch;
 name="patch0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch0.patch"

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ca89e15..0578fcb 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -54,6 +54,7 @@ static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
 static int finished_booting;
+static int force_tsc_stable;
 
 /* clocksource_done_booting - Called near the end of core bootup
  *
@@ -82,6 +83,14 @@ static unsigned long watchdog_resumed;
 #define WATCHDOG_INTERVAL (HZ >> 1)
 #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
+static int __init parse_force_tsc_stable(char *arg)
+{
+	force_tsc_stable = 1;
+	return 0;
+}
+early_param("force_tsc_stable", parse_force_tsc_stable);
+
+
 static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
 {
 	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
@@ -89,9 +98,16 @@ static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
 
 	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
 	       cs->name, delta);
-	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
-	clocksource_change_rating(cs, 0);
-	list_del(&cs->wd_list);
+	if (force_tsc_stable && (strcmp(cs->name, "tsc") == 0))
+		printk(KERN_WARNING "Forcing tsc to be treated as stable due to force_tsc_stable=1\n");
+	else {
+		printk(KERN_WARNING "  This clock is no longer valid for WATCHDOG or HIGH-RES.\n");
+		if (strcmp(cs->name, "tsc") == 0)
+			printk(KERN_WARNING "  Use force_tsc_stable=1 to override.\n");
+		cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
+		clocksource_change_rating(cs, 0);
+		list_del(&cs->wd_list);
+	}
 }
 
 static void clocksource_watchdog(unsigned long data)

--------------060905070805060007060801--
