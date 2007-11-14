Return-Path: <linux-kernel-owner+w=401wt.eu-S1764919AbXKNWto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764919AbXKNWto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbXKNWtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:49:32 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:63139 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbXKNWtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:49:31 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 209.94.135.27
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/RBwRXiSyOoxappmRSdyyO
Message-ID: <473B7B71.6050104@reed.com>
Date: Wed, 14 Nov 2007 17:49:21 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
CC: Allessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] time: fix typo that makes sync_cmos_clock erratic
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>	 <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>	 <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>	 <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos>
In-Reply-To: <1184274754.12353.254.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in ntp.c that has caused updating of the persistent (RTC)
clock when synced to NTP to behave erratically.

When debugging a freeze that arises on my AMD64 machines when I
run the ntpd service, I added a number of printk's to monitor the
sync_cmos_clock procedure.  I discovered that it was not syncing to
cmos RTC every 11 minutes as documented, but instead would keep trying
every second for hours at a time.  The reason turned out to be a typo
in sync_cmos_clock, where it attempts to ensure that
update_persistent_clock is called very close to 500 msec. after a 1
second boundary (required by the PC RTC's spec). That typo referred to
"xtime" in one spot, rather than "now", which is derived from "xtime"
but not equal to it.  This makes the test erratic, creating a
"coin-flip" that decides when update_persistent_clock is called - when
it is called, which is rarely, it may be at any time during the one
second period, rather than close to 500 msec, so the value written is
needlessly incorrect, too.

Signed-off-by: David P. Reed

---
I have thoroughly tested this on several x86_64 machines, and also
on one 32-bit machine.  I have also submitted a patch to fix the
freeze cited above, but both patches are independent, and should be
treated separately.

Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -205,7 +205,7 @@ static void sync_cmos_clock(unsigned lon
  		return;

  	getnstimeofday(&now);
-	if (abs(xtime.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
  		fail = update_persistent_clock(now);

  	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;
