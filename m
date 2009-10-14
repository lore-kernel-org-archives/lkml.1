Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbZJNOXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbZJNOXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbZJNOXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:23:03 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43421 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758461AbZJNOXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:23:02 -0400
Date: Wed, 14 Oct 2009 09:21:03 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/4 v2] X86: UV RTC cleanup error handling
Message-ID: <20091014142103.GD11048@sgi.com>
References: <20091009134727.GB3218@sgi.com> <20091012162317.GC1272@elte.hu> <20091012175233.GA8129@sgi.com> <20091012175920.GB17138@elte.hu> <20091014141438.GA11048@sgi.com> <20091014141630.GB11048@sgi.com> <20091014141848.GC11048@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014141848.GC11048@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup error handling in uv_rtc_setup_clock.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/uv_time.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2009-10-13 08:55:23.000000000 -0500
+++ linux/arch/x86/kernel/uv_time.c	2009-10-13 08:56:12.000000000 -0500
@@ -380,15 +380,12 @@ static __init int uv_rtc_setup_clock(voi
 	if (rc || !uv_rtc_evt_enable)
 		return rc;
 
-	generic_interrupt_extension = uv_rtc_interrupt;
-
 	/* Setup and register clockevents */
 	rc = uv_rtc_allocate_timers();
-	if (rc) {
-		clocksource_unregister(&clocksource_uv);
-		generic_interrupt_extension = NULL;
-		return rc;
-	}
+	if (rc)
+		goto error;
+
+	generic_interrupt_extension = uv_rtc_interrupt;
 
 	clock_event_device_uv.mult = div_sc(sn_rtc_cycles_per_second,
 				NSEC_PER_SEC, clock_event_device_uv.shift);
@@ -401,11 +398,19 @@ static __init int uv_rtc_setup_clock(voi
 
 	rc = schedule_on_each_cpu(uv_rtc_register_clockevents);
 	if (rc) {
-		clocksource_unregister(&clocksource_uv);
 		generic_interrupt_extension = NULL;
 		uv_rtc_deallocate_timers();
+		goto error;
 	}
 
+	printk(KERN_INFO "UV RTC clockevents registered\n");
+
+	return 0;
+
+error:
+	clocksource_unregister(&clocksource_uv);
+	printk(KERN_INFO "UV RTC clockevents failed rc %d\n", rc);
+
 	return rc;
 }
 arch_initcall(uv_rtc_setup_clock);
