Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbXDLVOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbXDLVOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbXDLVOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:14:08 -0400
Received: from smtp106.sbc.mail.re2.yahoo.com ([68.142.229.99]:28091 "HELO
	smtp106.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753821AbXDLVOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:14:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=HPQWdFIzQGJ6SLQFksuiF8hBqR0mIgcOVTKqqRzMnFsuGGSJf1f5RHkcKY1eATWVgYV8+q950SR+mOjb5+4JPRLRDG46DRk2OdwBZp7Pb2TUMlliMfHtQUgzTDYYZ3R6HD1lWgsv1R8QSXYxBZcMQiPQPhBKybajq6VALDUQhpA=  ;
X-YMail-OSG: 0N.3TfsVM1lE3_tL8YKXnF1cSJO7tUQfMl_eawLH8e3im1FUVtVhOzxmr2f.v5mLn7jXSRN7ag--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc6-git] workaround rtc-related acpi table bugs
Date: Thu, 12 Apr 2007 14:14:01 -0700
User-Agent: KMail/1.7.1
Cc: linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704121414.01828.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This works around a bug seen in some RTC-related ACPI table entries, and
tweaks related diagnostics to follow the ACPI convention.

The bug prevents misleading boot-time messages:  platforms affected by this
bug wrongly report they can support alarms up to one year in the future,
when in fact the longest alarm is just 24 hours.  That will surprise anyone
trying to use those extended alarms.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 glue.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

--- g26.orig/drivers/acpi/glue.c	2007-04-12 10:56:35.000000000 -0700
+++ g26/drivers/acpi/glue.c	2007-04-12 10:56:35.000000000 -0700
@@ -316,13 +316,19 @@ static int __init acpi_rtc_init(void)
 		rtc_info.wake_on = rtc_wake_on;
 		rtc_info.wake_off = rtc_wake_off;
 
+		if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
+			DBG("bogus FADT month_alarm\n");
+			acpi_gbl_FADT.month_alarm = 0;
+		}
+
 		rtc_info.rtc_day_alarm = acpi_gbl_FADT.day_alarm;
 		rtc_info.rtc_mon_alarm = acpi_gbl_FADT.month_alarm;
 		rtc_info.rtc_century = acpi_gbl_FADT.century;
 
 		/* NOTE:  S4_RTC_WAKE is NOT currently useful to Linux */
 		if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
-			printk("ACPI: RTC can wake from S4\n");
+			printk(PREFIX "RTC can wake from S4\n");
+
 
 		dev->platform_data = &rtc_info;
 
@@ -331,7 +337,7 @@ static int __init acpi_rtc_init(void)
 
 		put_device(dev);
 	} else
-		pr_debug("ACPI: RTC unavailable?\n");
+		DBG("RTC unavailable?\n");
 	return 0;
 }
 /* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
