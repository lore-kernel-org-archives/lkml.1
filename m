Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbXDRElR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbXDRElR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXDRElQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:41:16 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:39860 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753366AbXDRElP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:41:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nt59GrLN2KK2pH6XYgFsnIivuRQ3FpbIitLsRz2hFghz8L9MwS+fEqR00wZpxWlO8jPdGN7qLMpJsw3o1xRmFpoBEMHIDaQivbtKsa6jbtOpr2PaobR5GmxtFNLW42n81JkR+/SjffGnSffotK+XUM/syohmbGc8rAxedGJYrso=  ;
X-YMail-OSG: q5ckSwsVM1lKx00wzmEpNOQKXoxwlwGvz9d9D0srTKKsZZa7Le0Kq4Dkbe9UB7oa7VkTnsU31w--
From: David Brownell <david-b@pacbell.net>
To: Len Brown <lenb@kernel.org>
Subject: Re: [patch 2.6.21-rc6-git] workaround rtc-related acpi table bugs
Date: Tue, 17 Apr 2007 21:41:11 -0700
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200704121414.01828.david-b@pacbell.net> <200704172310.33284.lenb@kernel.org>
In-Reply-To: <200704172310.33284.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704172141.12131.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 8:10 pm, Len Brown wrote:
> On Thursday 12 April 2007 17:14, David Brownell wrote:

> > --- g26.orig/drivers/acpi/glue.c	2007-04-12 10:56:35.000000000 -0700
> > +++ g26/drivers/acpi/glue.c	2007-04-12 10:56:35.000000000 -0700
> > @@ -316,13 +316,19 @@ static int __init acpi_rtc_init(void)
> >  		rtc_info.wake_on = rtc_wake_on;
> >  		rtc_info.wake_off = rtc_wake_off;
> 
> probably worth a comment right here that this clause is a BIOS workaround.

Done, see the appended.


> Unclear what value the DBG statement adds, since only somebody
> editing this file will ever enable it.

Um, it should come automagically when ACPI debug is enabled, right?
Just like when any other subsystem's debug tools are enabled.

... AH, I see, "glue" is a separate debug category not affected by
Kconfig.  Buglike.  :)

- Dave


> -Len
> 
> > +		if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
> > +			DBG("bogus FADT month_alarm\n");
> > +			acpi_gbl_FADT.month_alarm = 0;
> > +		}
> ...


===============	CUT HERE
This works around a bug seen in some RTC-related ACPI table entries, and
tweaks related diagnostics to follow the ACPI convention.

The bug prevents misleading boot-time messages:  platforms affected by this
bug wrongly report they can support alarms up to one year in the future,
when in fact the longest alarm is just 24 hours.  That will surprise anyone
trying to use those extended alarms.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/acpi/glue.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

--- g26.orig/drivers/acpi/glue.c	2007-04-17 17:46:47.000000000 -0700
+++ g26/drivers/acpi/glue.c	2007-04-17 21:31:27.000000000 -0700
@@ -316,13 +316,20 @@ static int __init acpi_rtc_init(void)
 		rtc_info.wake_on = rtc_wake_on;
 		rtc_info.wake_off = rtc_wake_off;
 
+		/* workaround bug in some ACPI tables */
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
 
@@ -331,7 +338,7 @@ static int __init acpi_rtc_init(void)
 
 		put_device(dev);
 	} else
-		pr_debug("ACPI: RTC unavailable?\n");
+		DBG("RTC unavailable?\n");
 	return 0;
 }
 /* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
