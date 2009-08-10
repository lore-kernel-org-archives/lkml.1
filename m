Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbZHJEoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbZHJEoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 00:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbZHJEox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 00:44:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:61606 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZHJEow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 00:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:mime-version:content-type
         :content-disposition:user-agent:message-id;
        b=e6rbBLz8N73ohLcxHKofhwkOCd24cmJpTscI0HPlho9eXjLVizT6lmgOVnMlS8wRIt
         Bbwwjf2SGtxprHQP9WNS7KYuGse6Uhg7vqXRv0WvECsexl9u/V6S4QRj6I5CmBZsu465
         1nGQ5Xh9PtQvWkkI9pRBo/FJ0jb/fsodpChIQ=
Date: Sun, 9 Aug 2009 21:44:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86, mce: therm_throt - change when we print messages
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090810051513.0558F526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Latitude d630 seems to be handling thermal events in SMI by lowering
the max frequency of the CPU till it cools down but still leaks the
"everything is normal" events. Adjust therm_throt driver to only print
messages about the fact that temperatire returned back to normal when
leaving the throttling state.

Also lower the severity of "back to normal" message from KERN_CRIT to
KERN_INFO.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 arch/x86/kernel/cpu/mcheck/therm_throt.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)


diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index bff8dd1..8bc64cf 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -36,6 +36,7 @@
 
 static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
 static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
+static DEFINE_PER_CPU(bool, thermal_throttle_active);
 
 static atomic_t therm_throt_en		= ATOMIC_INIT(0);
 
@@ -96,24 +97,27 @@ static int therm_throt_process(int curr)
 {
 	unsigned int cpu = smp_processor_id();
 	__u64 tmp_jiffs = get_jiffies_64();
+	bool was_throttled = __get_cpu_var(thermal_throttle_active);
+	bool is_throttled = __get_cpu_var(thermal_throttle_active) = curr;
 
-	if (curr)
+	if (is_throttled)
 		__get_cpu_var(thermal_throttle_count)++;
 
-	if (time_before64(tmp_jiffs, __get_cpu_var(next_check)))
+	if (!(was_throttled ^ is_throttled) &&
+	    time_before64(tmp_jiffs, __get_cpu_var(next_check)))
 		return 0;
 
 	__get_cpu_var(next_check) = tmp_jiffs + CHECK_INTERVAL;
 
 	/* if we just entered the thermal event */
-	if (curr) {
+	if (is_throttled) {
 		printk(KERN_CRIT "CPU%d: Temperature above threshold, "
-		       "cpu clock throttled (total events = %lu)\n", cpu,
-		       __get_cpu_var(thermal_throttle_count));
+		       "cpu clock throttled (total events = %lu)\n",
+		       cpu, __get_cpu_var(thermal_throttle_count));
 
 		add_taint(TAINT_MACHINE_CHECK);
-	} else {
-		printk(KERN_CRIT "CPU%d: Temperature/speed normal\n", cpu);
+	} else if (was_throttled) {
+		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", cpu);
 	}
 
 	return 1;
-- 
Dmitry
