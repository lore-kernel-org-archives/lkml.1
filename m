Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbXD0S3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbXD0S3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbXD0S3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:29:02 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985AbXD0S27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:28:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NPiRweFyW3d0M+t/kCBzMZ4bEqaZkIICiW/D1FQ1c6S2wwmOXvqCH81xpKNqYyEwk
	RZ4GzmO4ZC2YaaVwOy7RQ==
Message-ID: <cc96a5040704271128t60120aedvd439630b3b80b03@mail.gmail.com>
Date: Fri, 27 Apr 2007 11:28:43 -0700
From: "Tim Hockin" <thockin@google.com>
To: ak@muc.de, vojtech@suse.cz
Subject: Re: [PATCH] x86_64: dynamic MCE poll interval
Cc: linux-kernel@vger.kernel.org, akpm@google.com
In-Reply-To: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Hockin <thockin@google.com>

Background:
 We've found that MCEs (specifically DRAM SBEs) tend to come in bunches,
 especially when we are trying really hard to stress the system out.  The
 current MCE poller uses a static interval which does not care whether it
 has or has not found MCEs recently.

Description:
 This patch makes the MCE poller adjust the polling interval dynamically.
 If we find an MCE, poll 2x faster (down to 10 ms).  When we stop finding
 MCEs, poll 2x slower (up to check_interval seconds).  The check_interval
 tunable becomes the max polling interval.  The "Machine check events
 logged" printk() is rate limited to the check_interval, which should be
 identical behavior to the old functionality.

Result:
 If you start to take a lot of correctable errors (not exceptions), you
 log them faster and more accurately (less chance of overflowing the MCA
 registers).  If you don't take a lot of errors, you will see no change.

Alternatives:
 I considered simply reducing the polling interval to 10 ms immediately
 and keeping it there as long as we continue to find errors.  This felt a
 bit heavy handed, but does perform significantly better for the default
 check_interval of 5 minutes (we're using a few seconds when testing for
 DRAM errors).  I could be convinced to go with this, if anyone felt it
 was not too aggressive.

Testing:
 I used an error-injecting DIMM to create lots of correctable DRAM errors
 and verified that the polling interval accelerates.  The printk() only
 happens once per check_interval seconds.

Patch:
 This patch is against 2.6.21-rc7.

Signed-Off-By: Tim Hockin <thockin@google.com>

---

This is the second version of this patch.  The more I think about the
alternative described above, the more I like it, but I recognize that
it is heavy-handed.  If correctable errors matter that much to you,
you can start with a small check_interval, I suppose.


diff -pruN linux-2.6.20/Documentation/x86_64/machinecheck
linux-2.6.20+th/Documentation/x86_64/machinecheck
--- linux-2.6.20/Documentation/x86_64/machinecheck	2007-04-24
23:36:03.000000000 -0700
+++ linux-2.6.20+th/Documentation/x86_64/machinecheck	2007-04-27
10:11:10.000000000 -0700
@@ -36,7 +36,12 @@ between all CPUs.

 check_interval
 	How often to poll for corrected machine check errors, in seconds
-	(Note output is hexademical). Default 5 minutes.
+	(Note output is hexademical). Default 5 minutes.  When the poller
+	finds MCEs it triggers an exponential speedup (poll more often) on
+	the polling interval.  When the poller stops finding MCEs, it
+	triggers an exponential backoff (poll less often) on the polling
+	interval. The check_interval variable is both the initial and
+	maximum polling interval.

 tolerant
 	Tolerance level. When a machine check exception occurs for a non
diff -pruN linux-2.6.20/arch/x86_64/kernel/mce.c
linux-2.6.20+th/arch/x86_64/kernel/mce.c
--- linux-2.6.20/arch/x86_64/kernel/mce.c	2007-04-27 10:01:02.000000000 -0700
+++ linux-2.6.20+th/arch/x86_64/kernel/mce.c	2007-04-27 10:41:02.000000000 -0700
@@ -323,10 +323,13 @@ void mce_log_therm_throt_event(unsigned
 #endif /* CONFIG_X86_MCE_INTEL */

 /*
- * Periodic polling timer for "silent" machine check errors.
+ * Periodic polling timer for "silent" machine check errors.  If the
+ * poller finds an MCE, poll 2x faster.  When the poller finds no more
+ * errors, poll 2x slower (up to check_interval seconds).
  */

 static int check_interval = 5 * 60; /* 5 minutes */
+static int next_interval; /* in jiffies */
 static void mcheck_timer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(mcheck_work, mcheck_timer);

@@ -339,7 +342,6 @@ static void mcheck_check_cpu(void *info)
 static void mcheck_timer(struct work_struct *work)
 {
 	on_each_cpu(mcheck_check_cpu, NULL, 1, 1);
-	schedule_delayed_work(&mcheck_work, check_interval * HZ);

 	/*
 	 * It's ok to read stale data here for notify_user and
@@ -349,17 +351,30 @@ static void mcheck_timer(struct work_str
 	 * writes.
 	 */
 	if (notify_user && console_logged) {
+		static unsigned long last_print = 0;
+		unsigned long now = jiffies;
+
+		/* if we logged an MCE, reduce the polling interval */
+		next_interval = max(next_interval/2, HZ/100);
 		notify_user = 0;
 		clear_bit(0, &console_logged);
-		printk(KERN_INFO "Machine check events logged\n");
+		if ((now - last_print) >= check_interval*HZ) {
+			last_print = now;
+			printk(KERN_INFO "Machine check events logged\n");
+		}
+	} else {
+		next_interval = min(next_interval*2, check_interval*HZ);
 	}
+
+	schedule_delayed_work(&mcheck_work, next_interval);
 }


 static __init int periodic_mcheck_init(void)
 {
-	if (check_interval)
-		schedule_delayed_work(&mcheck_work, check_interval*HZ);
+	next_interval = check_interval * HZ;
+	if (next_interval)
+		schedule_delayed_work(&mcheck_work, next_interval);
 	return 0;
 }
 __initcall(periodic_mcheck_init);
@@ -597,12 +612,13 @@ static int mce_resume(struct sys_device
 /* Reinit MCEs after user configuration changes */
 static void mce_restart(void)
 {
-	if (check_interval)
+	if (next_interval)
 		cancel_delayed_work(&mcheck_work);
 	/* Timer race is harmless here */
 	on_each_cpu(mce_init, NULL, 1, 1);
-	if (check_interval)
-		schedule_delayed_work(&mcheck_work, check_interval*HZ);
+	next_interval = check_interval * HZ;
+	if (next_interval)
+		schedule_delayed_work(&mcheck_work, next_interval);
 }

 static struct sysdev_class mce_sysclass = {
