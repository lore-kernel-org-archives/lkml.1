Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXL0ImY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXL0ImY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 03:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXL0ImP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 03:42:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:5986 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXL0ImO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 03:42:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,201,1196668800"; 
   d="scan'208";a="351277014"
Subject: [PATCH linux-acpi] Remove superfluous code and correct counting
	error in function acpi_system_write_alarm
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Thu, 27 Dec 2007 16:41:39 +0800
Message-Id: <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function acpi_system_write_alarm in file drivers/acpi/sleep/proc.c,
big sec, min, hr, mo, day and yr are counted twice to get reasonable
values, that is very superfluous, we can do that only once.

In additon, /proc/acpi/alarm can set a related value which can be
specified as YYYY years MM months DD days HH hours MM minutes SS
senconds, it isn't a date, so you can specify as +0000-00-00 96:00:00
, that means 3 days later, current code can't handle such a case.

This patch removes unnecessary code and does with the aforementioned
situation.

Before applying this patch:

[root@localhost /]# cat /proc/acpi/alarm
2007-12-00 00:00:00
[root@localhost /]# echo "0000-00-00 96:180:180" > /proc/acpi/alarm
[root@localhost /]# cat /proc/acpi/alarm
0007-12-02 **:**:**
[root@localhost /]#

After applying this patch:

[root@localhost ~]# echo "2007-12-00 00:00:00" > /proc/acpi/alarm
[root@localhost ~]# cat /proc/acpi/alarm
2007-12-00 00:00:00
[root@localhost ~]# echo "0000-00-00 96:180:180" > /proc/acpi/alarm
[root@localhost ~]# cat /proc/acpi/alarm
0007-12-04 03:03:00
[root@localhost ~]#

Signed-off by Yi Yang <yi.y.yang@intel.com>

diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index fce78fb..f8df521 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -256,27 +256,6 @@ acpi_system_write_alarm(struct file *file,
 	if ((result = get_date_field(&p, &sec)))
 		goto end;
 
-	if (sec > 59) {
-		min += 1;
-		sec -= 60;
-	}
-	if (min > 59) {
-		hr += 1;
-		min -= 60;
-	}
-	if (hr > 23) {
-		day += 1;
-		hr -= 24;
-	}
-	if (day > 31) {
-		mo += 1;
-		day -= 31;
-	}
-	if (mo > 12) {
-		yr += 1;
-		mo -= 12;
-	}
-
 	spin_lock_irq(&rtc_lock);
 
 	rtc_control = CMOS_READ(RTC_CONTROL);
@@ -293,24 +272,24 @@ acpi_system_write_alarm(struct file *file,
 	spin_unlock_irq(&rtc_lock);
 
 	if (sec > 59) {
-		min++;
-		sec -= 60;
+		min += sec/60;
+		sec = sec%60;
 	}
 	if (min > 59) {
-		hr++;
-		min -= 60;
+		hr += min/60;
+		min = min%60;
 	}
 	if (hr > 23) {
-		day++;
-		hr -= 24;
+		day += hr/24;
+		hr = hr%24;
 	}
 	if (day > 31) {
-		mo++;
-		day -= 31;
+		mo += day/32;
+		day = day%32;
 	}
 	if (mo > 12) {
-		yr++;
-		mo -= 12;
+		yr += mo/13;
+		mo = mo%13;
 	}
 
 	spin_lock_irq(&rtc_lock);


