Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028Ab0AVSAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0AVSAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184Ab0AVSAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:00:07 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:53888 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0AVSAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:00:06 -0500
Date: Fri, 22 Jan 2010 19:00:02 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Message-ID: <alpine.LFD.2.00.1001221841490.2266@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Rafael,

on s390 we have a reproduceable testcase where, after all devices were
suspended, a memory allocation results in disk IO. I know that this is
similar to the current discussion about magically changing the gpf mask,
but in our case the related allocation is triggered not by a device driver
but directly by hibernation_snapshot. The call chain looks like this:

STACK:
 0 schedule+1796 [0x5a7af0]
 1 io_schedule+98 [0x5a82ce]
 2 sync_page_killable+4 [0x1ec424]
 3 __wait_on_bit+204 [0x5a8bc4]
 4 add_to_page_cache_locked+2 [0x1ec766]
 5 shrink_page_list+2372 [0x1fc5b0]
 6 shrink_list+2496 [0x1fd02c]
 7 shrink_zone+932 [0x1fd3e0]
 8 try_to_free_pages+668 [0x1fe4bc]
 9 __alloc_pages_nodemask+1346 [0x1f5056]
10 __get_free_pages+76 [0x1f52dc]
11 __build_sched_domains+60 [0x144f98]
12 partition_sched_domains+696 [0x145dcc]
13 update_sched_domains+100 [0x146104]
14 notifier_call_chain+166 [0x5ae112]
15 raw_notifier_call_chain+44 [0x1800c4]
16 _cpu_down+586 [0x59f212]
17 disable_nonboot_cpus+354 [0x155ad2]
18 hibernation_snapshot+324 [0x1a7938]
19 hibernate+304 [0x1a7bcc]
20 state_store+130 [0x1a645e]
21 sysfs_write_file+264 [0x2b551c]
22 vfs_write+190 [0x23f98a]
23 sys_write+100 [0x23fb50]
24 sysc_noemu+16 [0x118ff6]

a possible fix would be to call disable_nonboot_cpus before suspending the
devices..
NOTE: this affects pm debug modes
---

Since disable_nonboot_cpus triggers memory allocations we should call
it before suspending the devices in hibernation_snapshot.

 Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 kernel/power/hibernate.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -229,13 +229,9 @@ static int create_image(int platform_mod
 	}
 
 	error = platform_pre_snapshot(platform_mode);
-	if (error || hibernation_test(TEST_PLATFORM))
-		goto Platform_finish;
-
-	error = disable_nonboot_cpus();
-	if (error || hibernation_test(TEST_CPUS)
+	if (error || hibernation_test(TEST_PLATFORM)
 	    || hibernation_testmode(HIBERNATION_TEST))
-		goto Enable_cpus;
+		goto Platform_finish;
 
 	local_irq_disable();
 
@@ -269,9 +265,6 @@ static int create_image(int platform_mod
  Enable_irqs:
 	local_irq_enable();
 
- Enable_cpus:
-	enable_nonboot_cpus();
-
  Platform_finish:
 	platform_finish(platform_mode);
 
@@ -303,6 +296,10 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		goto Close;
 
+	error = disable_nonboot_cpus();
+	if (error || hibernation_test(TEST_CPUS))
+		goto Enable_cpus;
+
 	suspend_console();
 	error = dpm_suspend_start(PMSG_FREEZE);
 	if (error)
@@ -322,6 +319,8 @@ int hibernation_snapshot(int platform_mo
 	dpm_resume_end(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
 	resume_console();
+ Enable_cpus:
+	enable_nonboot_cpus();
  Close:
 	platform_end(platform_mode);
 	return error;
