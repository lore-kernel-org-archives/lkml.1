Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZHKL7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZHKL7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZHKL7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:59:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:35438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZHKL7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:37 -0400
Date: Tue, 11 Aug 2009 07:57:59 GMT
From: tip-bot for Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dmitry.torokhov@gmail.com, dtor@mail.ru, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, dtor@mail.ru, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090810051513.0558F526EC9@mailhub.coreip.homeip.net>
References: <20090810051513.0558F526EC9@mailhub.coreip.homeip.net>
Subject: [tip:x86/urgent] x86, mce: therm_throt - change when we print messages
Message-ID: <tip-0d01f31439c1e4d602bf9fdc924ab66f407f5e38@git.kernel.org>
Git-Commit-ID: 0d01f31439c1e4d602bf9fdc924ab66f407f5e38
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 11 Aug 2009 07:58:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d01f31439c1e4d602bf9fdc924ab66f407f5e38
Gitweb:     http://git.kernel.org/tip/0d01f31439c1e4d602bf9fdc924ab66f407f5e38
Author:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
AuthorDate: Sun, 9 Aug 2009 21:44:49 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 Aug 2009 09:54:17 +0200

x86, mce: therm_throt - change when we print messages

My Latitude d630 seems to be handling thermal events in SMI by
lowering the max frequency of the CPU till it cools down but
still leaks the "everything is normal" events.

This spams the console and with high priority printks.

Adjust therm_throt driver to only print messages about the fact
that temperatire returned back to normal when leaving the
throttling state.

Also lower the severity of "back to normal" message from
KERN_CRIT to KERN_INFO.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Acked-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <20090810051513.0558F526EC9@mailhub.coreip.homeip.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
