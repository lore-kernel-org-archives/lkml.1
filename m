Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbZJNOUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbZJNOUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757987AbZJNOUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:20:38 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43331 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754149AbZJNOUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:20:37 -0400
Date: Wed, 14 Oct 2009 09:18:48 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/4 v2] X86: UV RTC add clocksource only boot option
Message-ID: <20091014141848.GC11048@sgi.com>
References: <20091009134727.GB3218@sgi.com> <20091012162317.GC1272@elte.hu> <20091012175233.GA8129@sgi.com> <20091012175920.GB17138@elte.hu> <20091014141438.GA11048@sgi.com> <20091014141630.GB11048@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014141630.GB11048@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clocksource only boot option for UV RTC.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/uv_time.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2009-10-13 08:50:46.000000000 -0500
+++ linux/arch/x86/kernel/uv_time.c	2009-10-13 08:55:23.000000000 -0500
@@ -75,6 +75,7 @@ struct uv_rtc_timer_head {
 static struct uv_rtc_timer_head		**blade_info __read_mostly;
 
 static int				uv_rtc_enable;
+static int				uv_rtc_evt_enable;
 
 /*
  * Hardware interface routines
@@ -342,6 +343,14 @@ static int __init uv_enable_rtc(char *st
 }
 __setup("uvrtc", uv_enable_rtc);
 
+static int __init uv_enable_evt_rtc(char *str)
+{
+	uv_rtc_evt_enable = 1;
+
+	return 1;
+}
+__setup("uvrtcevt", uv_enable_evt_rtc);
+
 static __init void uv_rtc_register_clockevents(struct work_struct *dummy)
 {
 	struct clock_event_device *ced = &__get_cpu_var(cpu_ced);
@@ -358,16 +367,20 @@ static __init int uv_rtc_setup_clock(voi
 	if (!uv_rtc_enable || !is_uv_system() || generic_interrupt_extension)
 		return -ENODEV;
 
-	generic_interrupt_extension = uv_rtc_interrupt;
-
 	clocksource_uv.mult = clocksource_hz2mult(sn_rtc_cycles_per_second,
 				clocksource_uv.shift);
 
 	rc = clocksource_register(&clocksource_uv);
-	if (rc) {
-		generic_interrupt_extension = NULL;
+	if (rc)
+		printk(KERN_INFO "UV RTC clocksource failed rc %d\n", rc);
+	else
+		printk(KERN_INFO "UV RTC clocksource registered freq %lu MHz\n",
+			sn_rtc_cycles_per_second/(unsigned long)1E6);
+
+	if (rc || !uv_rtc_evt_enable)
 		return rc;
-	}
+
+	generic_interrupt_extension = uv_rtc_interrupt;
 
 	/* Setup and register clockevents */
 	rc = uv_rtc_allocate_timers();
