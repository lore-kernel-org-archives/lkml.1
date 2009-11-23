Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZKWS5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZKWS5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZKWS5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:57:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:42488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbZKWS47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:56:59 -0500
Date: Mon, 23 Nov 2009 18:55:05 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20091120214826.GA20016@sgi.com>
References: <20091120214826.GA20016@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86: UV RTC: Always enable RTC clocksource
Message-ID: <tip-581f202bcd60acbc3af1f5faa429e570c512f8a3@git.kernel.org>
Git-Commit-ID: 581f202bcd60acbc3af1f5faa429e570c512f8a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  581f202bcd60acbc3af1f5faa429e570c512f8a3
Gitweb:     http://git.kernel.org/tip/581f202bcd60acbc3af1f5faa429e570c512f8a3
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Fri, 20 Nov 2009 15:48:26 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 19:41:30 +0100

x86: UV RTC: Always enable RTC clocksource

Always enable the RTC clocksource on UV systems.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
LKML-Reference: <20091120214826.GA20016@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/uv_time.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 3da7b1d..3c84aa0 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
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
@@ -364,12 +355,16 @@ static __init int uv_rtc_setup_clock(void)
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
@@ -377,7 +372,7 @@ static __init int uv_rtc_setup_clock(void)
 		printk(KERN_INFO "UV RTC clocksource registered freq %lu MHz\n",
 			sn_rtc_cycles_per_second/(unsigned long)1E6);
 
-	if (rc || !uv_rtc_evt_enable)
+	if (rc || !uv_rtc_evt_enable || x86_platform_ipi_callback)
 		return rc;
 
 	/* Setup and register clockevents */
