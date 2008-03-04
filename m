Return-Path: <linux-kernel-owner+w=401wt.eu-S1764002AbYCDMIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764002AbYCDMIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYCDMIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:08:32 -0500
Received: from ozlabs.org ([203.10.76.45]:40505 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYCDMIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:08:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] x86: If we cannot calibrate the TSC, we panic.
Date: Tue, 4 Mar 2008 23:07:50 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       lguest@ozlabs.org, akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
References: <20080224155515.GA24831@ubuntu> <20080229003224.GA18821@ubuntu> <20080229195838.GB21494@elte.hu>
In-Reply-To: <20080229195838.GB21494@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042307.51645.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current tsc_init() clears the TSC feature bit if the TSC khz
cannot be calculated, causing us to panic in
arch/x86/kernel/cpu/bugs.c check_config().  We should simply mark it
unstable.

Frankly, someone should take an axe to this code.  mark_tsc_unstable()
not only marks it unstable, but sets tsc_enabled to 0, which seems
redundant but is actually important here because means it won't be
used by sched_clock() either.  Perhaps a tristate enum "UNUSABLE,
UNSTABLE, OK" would be clearer, and separate mark_tsc_unstable() and
mark_tsc_broken() functions?

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r f9a80502dc46 arch/x86/kernel/tsc_32.c
--- a/arch/x86/kernel/tsc_32.c	Tue Mar 04 21:06:41 2008 +1100
+++ b/arch/x86/kernel/tsc_32.c	Tue Mar 04 22:55:10 2008 +1100
@@ -394,13 +394,15 @@ void __init tsc_init(void)
 	int cpu;
 
 	if (!cpu_has_tsc)
-		goto out_no_tsc;
+		return;
 
 	cpu_khz = calculate_cpu_khz();
 	tsc_khz = cpu_khz;
 
-	if (!cpu_khz)
-		goto out_no_tsc;
+	if (!cpu_khz) {
+		mark_tsc_unstable("could not calculate TSC khz");
+		return;
+	}
 
 	printk("Detected %lu.%03lu MHz processor.\n",
 				(unsigned long)cpu_khz / 1000,
@@ -433,9 +435,4 @@ void __init tsc_init(void)
 		tsc_enabled = 1;
 
 	clocksource_register(&clocksource_tsc);
-
-	return;
-
-out_no_tsc:
-	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }
