Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbXD0BDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbXD0BDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbXD0BDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:03:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:51430 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbXD0BDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:03:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=ZWHzmjuGdFGC7SKpzS3DfjCY78sSVp8aYYqabM6Au0brVZ5Vqvgl0MmfkIsEje1T8
	cs9W3AwoOaxVuUJArc/Kw==
Message-ID: <cc96a5040704261802v2bcb3a59k9d44da8d615a6779@mail.gmail.com>
Date: Thu, 26 Apr 2007 18:02:52 -0700
From: "Tim Hockin" <thockin@google.com>
To: ak@muc.de, vojtech@suse.cz
Subject: [PATCH] x86_64: dynamic MCE poll interval
Cc: linux-kernel@vger.kernel.org, akpm@google.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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
  tunable becomes the max polling interval.

Result:
  If you start to take a lot of correctable errors (not exceptions), you
  log them faster and more accurately (less chance of overflowing the MCA
  registers).  If you don't take a lot of errors, you will see no change.

Alternatives:
  I considered simply reducing the polling interval to 10 ms immediately
  and keeping it there as long as we continue to find errors.  This felt a
  bit heavy handed, but does perform significantly better for the default
  check_interval of 5 minutes (we're using a few seconds when testing for
  DRAM errors).

Patch:
  This patch is against 2.6.21-rc7.

Signed-Off-By: Tim Hockin <thockin@google.com>o

---

diff -pruN linux-2.6.20/arch/x86_64/kernel/mce.c
linux-2.6.20+th/arch/x86_64/kernel/mce.c
--- linux-2.6.20/arch/x86_64/kernel/mce.c	2007-04-24 23:36:04.000000000 -0700
+++ linux-2.6.20+th/arch/x86_64/kernel/mce.c	2007-04-26 10:40:29.000000000 -0700
@@ -327,6 +327,7 @@ void mce_log_therm_throt_event(unsigned
  */

 static int check_interval = 5 * 60; /* 5 minutes */
+static int next_interval; /* in jiffies */
 static void mcheck_timer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(mcheck_work, mcheck_timer);

@@ -339,7 +340,6 @@ static void mcheck_check_cpu(void *info)
 static void mcheck_timer(struct work_struct *work)
 {
 	on_each_cpu(mcheck_check_cpu, NULL, 1, 1);
-	schedule_delayed_work(&mcheck_work, check_interval * HZ);

 	/*
 	 * It's ok to read stale data here for notify_user and
@@ -349,17 +349,24 @@ static void mcheck_timer(struct work_str
 	 * writes.
 	 */
 	if (notify_user && console_logged) {
+		/* if we logged an MCE, reduce the polling interval */
+		next_interval = max(next_interval/2, HZ/100);
 		notify_user = 0;
 		clear_bit(0, &console_logged);
 		printk(KERN_INFO "Machine check events logged\n");
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
@@ -597,12 +604,13 @@ static int mce_resume(struct sys_device
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
