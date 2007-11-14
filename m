Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbXKNWry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbXKNWry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbXKNWrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:47:45 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:62491 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXKNWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:47:45 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 209.94.135.27
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bgB5naHAbm4Dlt6/I10RM
Message-ID: <473B7B07.505@reed.com>
Date: Wed, 14 Nov 2007 17:47:35 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
CC: Allessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] x86: fix freeze in x86_64 RTC update code in time_64.c
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos>
In-Reply-To: <1184274754.12353.254.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix hard freeze on x86_64 when the ntpd service calls 
update_persistent_clock()

A repeatable but randomly timed freeze has been happening in Fedora 6
and 7 for the last year, whenever I run the ntpd service on my AMD64x2
HP Pavilion dv9000z laptop.  This freeze is due to the use of
spin_lock(&rtc_lock) under the assumption (per a bad comment) that
set_rtc_mmss is called only with interrupts disabled.  The call from
ntp.c to update_persistent_clock is made with interrupts enabled.

Signed-off-by: David P. Reed <dpreed@reed.com>
---
I have thoroughly tested this patch on a number of x86_64 machines
with various numbers of cores and chipsets, using 2.6.24rc2 kernel
source.

Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -82,18 +82,15 @@ static int set_rtc_mmss(unsigned long no
  	int retval = 0;
  	int real_seconds, real_minutes, cmos_minutes;
  	unsigned char control, freq_select;
+	unsigned long flags;

  /*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
+ * set_rtc_mmss is called when irqs are enabled, so disable irqs here
   */
-
-	spin_lock(&rtc_lock);
-
+	spin_lock_irqsave(&rtc_lock, flags);
  /*
   * Tell the clock it's being set and stop it.
   */
-
  	control = CMOS_READ(RTC_CONTROL);
  	CMOS_WRITE(control | RTC_SET, RTC_CONTROL);

@@ -138,7 +135,7 @@ static int set_rtc_mmss(unsigned long no
  	CMOS_WRITE(control, RTC_CONTROL);
  	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);

-	spin_unlock(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);

  	return retval;
  }


