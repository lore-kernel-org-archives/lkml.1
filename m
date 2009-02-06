Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZBFS3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZBFS3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZBFS3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:29:34 -0500
Received: from mail.candelatech.com ([208.74.158.172]:39079 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZBFS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:29:33 -0500
Message-ID: <498C817F.8070306@candelatech.com>
Date: Fri, 06 Feb 2009 10:29:19 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Subject: PATCH:  (v2) Allow user to force 'tsc' to be treated as stable.
Content-Type: multipart/mixed;
 boundary="------------040805090605030200020702"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040805090605030200020702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Allow user to force TSC to be treated as a stable clock-source.
On some systems, with ACPI disabled in the BIOS, the
kernel determines that the TSC is unstable, when it fact
it appears to be fine.  This patch allows one to force
the kernel to treat the tsc as stable.

This is against 2.6.29-rc3.

Signed-Off-By:  Ben Greear<greearb@candelatech.com>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------040805090605030200020702
Content-Type: text/plain;
 name="tsc_patch.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tsc_patch.txt"

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d8362cf..e150946 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -473,6 +473,14 @@ and is between 256 and 4096 characters. It is defined in the file
 			[SPARC64] tick
 			[X86-64] hpet,tsc
 
+	force_tsc_stable=1
+			Force the TSC to be treated as a stable clocksource,
+			even if the rate-watchdog code would otherwise treat
+			it as unstable.  If you see
+			'Clocksource tsc unstable (delta = [num])' in your logs
+			but have reason to think your TSC is OK, then you may
+			want to try this option.
+
 	clearcpuid=BITNUM [X86]
 			Disable CPUID feature X for the kernel. See
 			arch/x86/include/asm/cpufeature.h for the valid bit
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ca89e15..4788727 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -54,6 +54,7 @@ static LIST_HEAD(clocksource_list);
 static DEFINE_SPINLOCK(clocksource_lock);
 static char override_name[32];
 static int finished_booting;
+static int force_tsc_stable;
 
 /* clocksource_done_booting - Called near the end of core bootup
  *
@@ -82,16 +83,29 @@ static unsigned long watchdog_resumed;
 #define WATCHDOG_INTERVAL (HZ >> 1)
 #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
+static int __init parse_force_tsc_stable(char *arg)
+{
+	force_tsc_stable = 1;
+	return 0;
+}
+early_param("force_tsc_stable", parse_force_tsc_stable);
+
+
 static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
 {
 	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
 		return;
 
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-	       cs->name, delta);
-	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
-	clocksource_change_rating(cs, 0);
-	list_del(&cs->wd_list);
+	if (force_tsc_stable && (strcmp(cs->name, "tsc") == 0))
+		printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns).  Ignoring instability.\n",
+		       cs->name, delta);
+	else {
+		printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
+		       cs->name, delta);
+		cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
+		clocksource_change_rating(cs, 0);
+		list_del(&cs->wd_list);
+	}
 }
 
 static void clocksource_watchdog(unsigned long data)

--------------040805090605030200020702--
