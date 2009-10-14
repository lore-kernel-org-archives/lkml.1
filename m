Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbZJNQea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbZJNQea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761996AbZJNQe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:34:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:42414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbZJNQe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:34:27 -0400
Date: Wed, 14 Oct 2009 16:33:27 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20091014142103.GD11048@sgi.com>
References: <20091014142103.GD11048@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86: UV RTC: Clean up error handling
Message-ID: <tip-d5991ff297ad2f7e2698eefcd8269df5ecec150f@git.kernel.org>
Git-Commit-ID: d5991ff297ad2f7e2698eefcd8269df5ecec150f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 16:33:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5991ff297ad2f7e2698eefcd8269df5ecec150f
Gitweb:     http://git.kernel.org/tip/d5991ff297ad2f7e2698eefcd8269df5ecec150f
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Wed, 14 Oct 2009 09:21:03 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 18:27:10 +0200

x86: UV RTC: Clean up error handling

Cleanup error handling in uv_rtc_setup_clock.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
LKML-Reference: <20091014142103.GD11048@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/uv_time.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index c6324ad..2556450 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -380,15 +380,12 @@ static __init int uv_rtc_setup_clock(void)
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
@@ -401,11 +398,19 @@ static __init int uv_rtc_setup_clock(void)
 
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
