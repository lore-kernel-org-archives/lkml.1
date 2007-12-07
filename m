Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbXLGBXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbXLGBXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 20:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXLGBXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 20:23:31 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:35836 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751737AbXLGBXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 20:23:30 -0500
Date: Fri, 7 Dec 2007 02:19:52 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Ingo Molnar <mingo@elte.hu>, Robert Love <rml@tech9.net>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207021952.6f0ac922@morte>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.12.6.170402
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __C230066_P5 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a regression introduced by:

commit bb29ab26863c022743143f27956cc0ca362f258c
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jul 9 18:51:59 2007 +0200

This caused the jiffies counter to leap back and forth on cpufreq changes
on my x86 box. I'd say that we can't always assume that TSC does "small
errors" only, when marked unstable. On cpufreq changes these errors can be
huge.

The original bug report can be found here:
http://bugzilla.kernel.org/show_bug.cgi?id=9475


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 9ebc0da..d29cd9c 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -98,13 +98,8 @@ unsigned long long native_sched_clock(void)
 
 	/*
 	 * Fall back to jiffies if there's no TSC available:
-	 * ( But note that we still use it if the TSC is marked
-	 *   unstable. We do this because unlike Time Of Day,
-	 *   the scheduler clock tolerates small errors and it's
-	 *   very important for it to be as fast as the platform
-	 *   can achive it. )
 	 */
-	if (unlikely(!tsc_enabled && !tsc_unstable))
+	if (unlikely(!tsc_enabled))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 

-- 
Ciao
Stefano
