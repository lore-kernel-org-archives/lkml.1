Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYFWKwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYFWKwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYFWKwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:52:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:29613 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbYFWKwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:52:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,689,1204531200"; 
   d="scan'208";a="580910602"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: [PATCH] RTC: Fix CMOS time error after writing /proc/acpi/alarm
Date: Mon, 23 Jun 2008 18:52:21 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC014E42D5@pdsmsx415.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] RTC: Fix CMOS time error after writing /proc/acpi/alarm
Thread-Index: AcjVHzZpftmJx8SFQfeY0g/fuU/+xw==
From: "Chen, Huacai" <huacai.chen@intel.com>
To: <linux-acpi@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       <rtc-linux@googlegroups.com>, <lenb@kernel.org>,
       <p_gortmaker@yahoo.com>, <a.zummo@towertech.it>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Jun 2008 10:52:10.0218 (UTC) FILETIME=[2FC4ACA0:01C8D51F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huacai Chen <huacai.chen@intel.com>

When writing /proc/acpi/alarm in adjust mode, e.g. 
	echo "+0000-00-00 00:00:15" >/proc/acpi/alarm 
The "century" field should be read and added to "year" field before
writing, otherwise the CMOS time will go back to 2000 years ago, e.g.
	# cat /proc/acpi/alarm
	0008-06-21 11:38:46 
Then the system time may be reset to the date of manufacture after
rebooting. This patch fixed this issue.

Signed-off-by: Huacai Chen <huacai.chen@intel.com>
Acked-by: Pavel Machek <pavel@suse.cz>
---
diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index 224c57c..c9fdf7b 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -315,8 +315,11 @@ acpi_system_write_alarm(struct file *file,
 		cmos_bcd_write(day, acpi_gbl_FADT.day_alarm,
rtc_control);
 	if (acpi_gbl_FADT.month_alarm)
 		cmos_bcd_write(mo, acpi_gbl_FADT.month_alarm,
rtc_control);
-	if (acpi_gbl_FADT.century)
+	if (acpi_gbl_FADT.century) {
+		if (adjust) 
+			yr += cmos_bcd_read(acpi_gbl_FADT.century,
rtc_control) * 100;
 		cmos_bcd_write(yr / 100, acpi_gbl_FADT.century,
rtc_control);
+	}
 	/* enable the rtc alarm interrupt */
 	rtc_control |= RTC_AIE;
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
---
This is for Linux 2.6.26-rc7.
