Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbYBAVNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbYBAVNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759513AbYBAVM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:12:56 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:27401 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759309AbYBAVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:12:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PQwjQFaGuIyNcExJULLDawmEvv/iA1AUryEWa76M4tmyIhhsA4VUkhaqzkqaR+qPedrHOIGyTfsPyYSr2HsRvtdVnpPgO5U0/PyKzzxMYVULzXUeYSMilFthO8gP1k1na3UpG5+lWvZEmGa2LEjtL/tot+Mqc3YPB+zXBZpF6T0=  ;
X-YMail-OSG: VZe36UMVM1nuIMONynwA_rXaxzMjouGMB7TAW76AM0M90kFp
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.24-git] rtc: remove more dev->power.power_state usage
Date: Fri, 1 Feb 2008 13:08:39 -0800
User-Agent: KMail/1.9.6
Cc: rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011308.40200.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some more references to dev->power.power_state.  That field
is overdue for removal, but we can't do that while it's still
referenced in the kernel.  The only reason to update it was to make
the /sys/devices/.../power/state files (now removed) work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/rtc/rtc-sa1100.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- at91.orig/drivers/rtc/rtc-sa1100.c	2008-02-01 12:31:16.000000000 -0800
+++ at91/drivers/rtc/rtc-sa1100.c	2008-02-01 12:32:14.000000000 -0800
@@ -357,23 +357,15 @@ static int sa1100_rtc_remove(struct plat
 #ifdef CONFIG_PM
 static int sa1100_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	if (pdev->dev.power.power_state.event != state.event) {
-		if (state.event == PM_EVENT_SUSPEND &&
-		    device_may_wakeup(&pdev->dev))
-			enable_irq_wake(IRQ_RTCAlrm);
-
-		pdev->dev.power.power_state = state;
-	}
+	if (device_may_wakeup(&pdev->dev))
+		enable_irq_wake(IRQ_RTCAlrm);
 	return 0;
 }
 
 static int sa1100_rtc_resume(struct platform_device *pdev)
 {
-	if (pdev->dev.power.power_state.event != PM_EVENT_ON) {
-		if (device_may_wakeup(&pdev->dev))
-			disable_irq_wake(IRQ_RTCAlrm);
-		pdev->dev.power.power_state = PMSG_ON;
-	}
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(IRQ_RTCAlrm);
 	return 0;
 }
 #else
