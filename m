Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbXJSRRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbXJSRRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762965AbXJSRRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:17:32 -0400
Received: from [12.38.223.190] ([12.38.223.190]:12842 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763451AbXJSRRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:17:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18200.59017.358372.378373@zeus.sw.starentnetworks.com>
Date: Fri, 19 Oct 2007 13:16:57 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Greg KH <gregkh@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] i386: fix TSC clock source calibration error [part 2]
In-Reply-To: <20071018085713.GA11022@elte.hu>
References: <18196.53154.100115.92459@zeus.sw.starentnetworks.com>
	<20071018085713.GA11022@elte.hu>
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Johnson <djohnson@sw.starentnetworks.com>

The previous patch wasn't correctly handling the 'count' variable.  If
a CPU gave bad results on the 1st or 2nd run but good results on the
3rd, it wouldn't do the correct thing.  No idea if any such CPU
exists, but the patch below handles that case by discarding the bad
runs.

If a bad result (too quick, or too slow) occurs on any of the 3 runs
it will be discarded.

Also updated some comments to explain what's going on.

Signed-off-by: Dave Johnson <djohnson@sw.starentnetworks.com>

---

Should be applied after my previous patch.

===== arch/i386/kernel/tsc.c 1.28 vs edited =====
--- 1.28/arch/i386/kernel/tsc.c	2007-10-19 11:07:36 -04:00
+++ edited/arch/i386/kernel/tsc.c	2007-10-19 11:07:44 -04:00
@@ -128,29 +128,35 @@
 
 	local_irq_save(flags);
 
-	/* run 3 times to ensure the cache is warm */
+	/* run 3 times to ensure the cache is warm and to get an accurate reading */
 	for (i = 0; i < 3; i++) {
 		mach_prepare_counter();
 		rdtscll(start);
 		mach_countup(&count);
 		rdtscll(end);
+
+		/*
+		 * Error: ECTCNEVERSET
+		 * The CTC wasn't reliable: we got a hit on the very first read,
+		 * or the CPU was so fast/slow that the quotient wouldn't fit in
+		 * 32 bits..
+		 */
+		if (count <= 1)
+			continue;
+
+		/* cpu freq too slow: */
+		if ((end - start) <= CALIBRATE_TIME_MSEC)
+			continue;
+
+		/*
+		 * We want the minimum time of all runs in case one of them
+		 * is inaccurate due to SMI or other delay
+		 */
 		delta64 = min(delta64, (end - start));
 	}
-	/*
-	 * Error: ECTCNEVERSET
-	 * The CTC wasn't reliable: we got a hit on the very first read,
-	 * or the CPU was so fast/slow that the quotient wouldn't fit in
-	 * 32 bits..
-	 */
-	if (count <= 1)
-		goto err;
 
-	/* cpu freq too fast: */
+	/* cpu freq too fast (or every run was bad): */
 	if (delta64 > (1ULL<<32))
-		goto err;
-
-	/* cpu freq too slow: */
-	if (delta64 <= CALIBRATE_TIME_MSEC)
 		goto err;
 
 	delta64 += CALIBRATE_TIME_MSEC/2; /* round for do_div */

