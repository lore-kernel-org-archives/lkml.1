Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZKTVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZKTVsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZKTVsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:48:22 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43198 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754841AbZKTVsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:48:21 -0500
Date: Fri, 20 Nov 2009 15:48:26 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: UV enable RTC clocksource
Message-ID: <20091120214826.GA20016@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always enable the RTC clocksource on UV systems.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/uv_time.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2009-11-20 14:57:31.000000000 -0600
+++ linux/arch/x86/kernel/uv_time.c	2009-11-20 15:41:32.000000000 -0600
@@ -74,7 +74,6 @@ struct uv_rtc_timer_head {
  */
 static struct uv_rtc_timer_head		**blade_info __read_mostly;
 
-static int				uv_rtc_enable;
 static int				uv_rtc_evt_enable;
 
 /*
@@ -335,14 +334,6 @@ static void uv_rtc_interrupt(void)
 	ced->event_handler(ced);
 }
 
-static int __init uv_enable_rtc(char *str)
-{
-	uv_rtc_enable = 1;
-
-	return 1;
-}
-__setup("uvrtc", uv_enable_rtc);
-
 static int __init uv_enable_evt_rtc(char *str)
 {
 	uv_rtc_evt_enable = 1;
@@ -364,12 +355,16 @@ static __init int uv_rtc_setup_clock(voi
 {
 	int rc;
 
-	if (!uv_rtc_enable || !is_uv_system() || x86_platform_ipi_callback)
+	if (!is_uv_system())
 		return -ENODEV;
 
 	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
 				clocksource_uv.shift);
 
+	/* If single blade, prefer tsc */
+	if (uv_num_possible_blades() == 1)
+		clocksource_uv.rating = 250;
+
 	rc = clocksource_register(&clocksource_uv);
 	if (rc)
 		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
@@ -377,7 +372,7 @@ static __init int uv_rtc_setup_clock(voi
 		printk(KERN_INFO "UV RTC clocksource registered freq %lu MHz\n",
 			sn_rtc_cycles_per_second/(unsigned long)1E6);
 
-	if (rc || !uv_rtc_evt_enable)
+	if (rc || !uv_rtc_evt_enable || x86_platform_ipi_callback)
 		return rc;
 
 	/* Setup and register clockevents */
