Return-Path: <linux-kernel-owner+w=401wt.eu-S934922AbZJNQeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934922AbZJNQeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934912AbZJNQeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:34:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934911AbZJNQeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:34:19 -0400
Date: Wed, 14 Oct 2009 16:33:12 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20091014141848.GC11048@sgi.com>
References: <20091014141848.GC11048@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86: UV RTC: Add clocksource only boot option
Message-ID: <tip-8c28de4d011f37b2893ecfcec9a985c0e9bd786f@git.kernel.org>
Git-Commit-ID: 8c28de4d011f37b2893ecfcec9a985c0e9bd786f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 16:33:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c28de4d011f37b2893ecfcec9a985c0e9bd786f
Gitweb:     http://git.kernel.org/tip/8c28de4d011f37b2893ecfcec9a985c0e9bd786f
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Wed, 14 Oct 2009 09:18:48 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 18:27:10 +0200

x86: UV RTC: Add clocksource only boot option

Add clocksource only boot option for UV RTC.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
LKML-Reference: <20091014141848.GC11048@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/uv_time.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index ec14889..c6324ad 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -75,6 +75,7 @@ struct uv_rtc_timer_head {
 static struct uv_rtc_timer_head		**blade_info __read_mostly;
 
 static int				uv_rtc_enable;
+static int				uv_rtc_evt_enable;
 
 /*
  * Hardware interface routines
@@ -342,6 +343,14 @@ static int __init uv_enable_rtc(char *str)
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
@@ -358,16 +367,20 @@ static __init int uv_rtc_setup_clock(void)
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
