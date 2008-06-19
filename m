Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbYFSNwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbYFSNwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 09:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbYFSNwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 09:52:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:15432 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbYFSNw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:52:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,672,1204531200"; 
   d="scan'208";a="343331722"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH]ACPI: Fix CMOS time error after waking up by /proc/acpi/alarm
Date: Thu, 19 Jun 2008 21:52:02 +0800
Message-ID: <42DFA526FC41B1429CE7279EF83C6BDC0148CB4C@pdsmsx415.ccr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]ACPI: Fix CMOS time error after waking up by /proc/acpi/alarm
Thread-Index: AcjSE6bcc4Rk9aMlRD2Dy8Y/UeIQuw==
From: "Chen, Huacai" <huacai.chen@intel.com>
To: <linux-acpi@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       <lenb@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Jun 2008 13:52:24.0732 (UTC) FILETIME=[B4118DC0:01C8D213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huacai Chen <huacai.chen@intel.com>

When writing /proc/acpi/alarm to wakeup up in adjust mode, this patch
read the "century" filed and add it to the "year" field before writing.
This avoids the CMOS time error (2000 years decrement) after waking up.

Signed-off-by: Huacai Chen <huacai.chen@intel.com>
---
diff --git a/drivers/acpi/sleep/proc.c b/drivers/acpi/sleep/proc.c
index 224c57c..2a85783 100644
--- a/drivers/acpi/sleep/proc.c
+++ b/drivers/acpi/sleep/proc.c
@@ -315,8 +315,11 @@ acpi_system_write_alarm(struct file *file,
 		cmos_bcd_write(day, acpi_gbl_FADT.day_alarm,
rtc_control);
 	if (acpi_gbl_FADT.month_alarm)
 		cmos_bcd_write(mo, acpi_gbl_FADT.month_alarm,
rtc_control);
-	if (acpi_gbl_FADT.century)
+	if (acpi_gbl_FADT.century){
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
