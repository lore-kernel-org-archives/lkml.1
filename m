Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYKZXwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYKZXwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYKZXw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:52:29 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47174 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYKZXw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:52:28 -0500
Subject: [PATCH] Enforce valid shift values in clocksource_register()
From: John Stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 15:46:36 -0800
Message-Id: <1227743196.18967.36.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas noted that some of the timekeeping core assumes 
clocksource shift values will be less then 32. However, 
we do nothing to enforce such limits.

This patch prints a warning if a clocksource with an invalid
shift value is attempted to be registered, and will refuse to
register the clocksource

I could not find any clocksources that use 32 or higher for a 
shift value, so this should be only a preventive warning for
future clocksource writers.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 9ed2eec..4a3bb13 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -318,7 +318,7 @@ static int clocksource_enqueue(struct clocksource *c)
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
  *
- * Returns -EBUSY if registration fails, zero otherwise.
+ * Returns -EBUSY or -EINVAL if registration fails, zero otherwise.
  */
 int clocksource_register(struct clocksource *c)
 {
@@ -327,7 +327,14 @@ int clocksource_register(struct clocksource *c)
 
 	/* save mult_orig on registration */
 	c->mult_orig = c->mult;
-
+	if (c->shift >= 32) {
+		printk(KERN_WARNING "===============================\n");
+		printk(KERN_WARNING "WARNING: Cannot register %s clocksource\n",
+					c->name);
+		printk(KERN_WARNING "The shift value must be less then 32\n");
+		printk(KERN_WARNING "===============================\n");
+		return -EINVAL;
+	}
 	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
 	if (!ret)


