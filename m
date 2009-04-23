Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZDWXSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZDWXSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZDWXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:18:35 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:48819 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZDWXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:18:34 -0400
Date: Thu, 23 Apr 2009 19:18:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, x86@kernel.org
Subject: [PATCH] ACPI/hpet: prevent boot hang when hpet=force used on ICH-4M
In-reply-to: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0904231917030.15843@localhost.localdomain>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Linux tells ICH4 users that they can (manually) invoke
"hpet=force" to enable the undocumented ICH-4M HPET.
The HPET becomes available for both clocksource and clockevents.

But as of ff69f2bba67bd45514923aaedbf40fe351787c59
(acpi: fix of pmtimer overflow that make Cx states time incorrect)
the HPET may be used via clocksource for idle accounting, and
hpet=force on an ICH4 box hangs boot.

It turns out that touching the MMIO HPET withing
the ARB_DIS part of C3 will hang the hardware.

The fix is to simply move the timer access outside
the ARB_DIS region.  This is a no-op on modern hardware
because ARB_DIS is no longer used.

http://bugzilla.kernel.org/show_bug.cgi?id=13087

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 6fe1214..ea23c64 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -955,6 +955,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 	 */
 	acpi_state_timer_broadcast(pr, cx, 1);
 
+	kt1 = ktime_get_real();
 	/*
 	 * disable bus master
 	 * bm_check implies we need ARB_DIS
@@ -976,10 +977,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		ACPI_FLUSH_CPU_CACHE();
 	}
 
-	kt1 = ktime_get_real();
 	acpi_idle_do_entry(cx);
-	kt2 = ktime_get_real();
-	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 	/* Re-enable bus master arbitration */
 	if (pr->flags.bm_check && pr->flags.bm_control) {
@@ -988,6 +986,8 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 		c3_cpu_count--;
 		spin_unlock(&c3_lock);
 	}
+	kt2 = ktime_get_real();
+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
-- 
1.6.3.rc1.34.g0be9b

