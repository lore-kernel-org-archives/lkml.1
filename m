Return-Path: <linux-kernel-owner+w=401wt.eu-S1161006AbXDMX0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006AbXDMX0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161020AbXDMX0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:26:12 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:34760 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161006AbXDMX0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:26:10 -0400
Date: Fri, 13 Apr 2007 16:28:20 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andi Kleen <ak@suse.de>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       john stultz <johnstul@us.ibm.com>, shai@scalex86.org,
       benzi@scalex86.org, discuss@x86-64.org
Subject: [patch 2.6.21-rc6] failsafe mechanism to HPET clock calibration
Message-ID: <20070413232820.GA9496@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a failsafe mechanism to avoid kernel spinning for ever at read_hpet_tsc
during early kernel bootup.

This failsafe mechanism was introduced in 21-rc,
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2f7a2a79c3ebb44f8b1b7d9b4fd3a650eb69e544

But looks like the hpet split from time.c lost the commit.

This patch reintroduces the failsafe mechanism

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Cc: Jack Steiner <steiner@sgi.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>

Index: linux-2.6.21-rc5/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/hpet.c	2007-04-11 16:03:05.000000000 -0700
+++ linux-2.6.21-rc5/arch/x86_64/kernel/hpet.c	2007-04-11 18:49:36.000000000 -0700
@@ -191,6 +191,7 @@ int hpet_reenable(void)
 
 #define TICK_COUNT 100000000
 #define TICK_MIN   5000
+#define MAX_TRIES  5
 
 /*
  * Some platforms take periodic SMI interrupts with 5ms duration. Make sure none
@@ -198,13 +199,15 @@ int hpet_reenable(void)
  */
 static void __init read_hpet_tsc(int *hpet, int *tsc)
 {
-	int tsc1, tsc2, hpet1;
+	int tsc1, tsc2, hpet1, i;
 
-	do {
+	for (i = 0; i < MAX_TRIES; i++) {
 		tsc1 = get_cycles_sync();
 		hpet1 = hpet_readl(HPET_COUNTER);
 		tsc2 = get_cycles_sync();
-	} while (tsc2 - tsc1 > TICK_MIN);
+		if (tsc2 - tsc1 > TICK_MIN)
+			break;
+	}
 	*hpet = hpet1;
 	*tsc = tsc2;
 }
