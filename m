Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbXCVSfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbXCVSfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbXCVSfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:35:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58104 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbXCVSfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:35:15 -0400
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
From: john stultz <johnstul@us.ibm.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, bunk@stusta.de, jikos@jikos.cz
In-Reply-To: <20070322034523.90050DBA1@gherkin.frus.com>
References: <20070322034523.90050DBA1@gherkin.frus.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 11:35:12 -0700
Message-Id: <1174588512.5662.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 21:45 -0600, Bob Tracy wrote:
> john stultz wrote:
> > > > Also, does booting w/ "clocksource=jiffies" change the behavior?
> 
> Works fine with 2.6.21-rc4.  I'm running on that kernel as I type this.
> 
> > Also trying booting w/ "notsc" would be a useful data point.
> 
> Boot hangs at the point indicated in my original message.  I *did*
> notice the blurb in the console messages about the pit clocksource
> being selected/used.  There was also a complaint about it being
> unstable, with a negative delta.  I think these messages are consistent
> with the pre-bad-commit case other than where they appear in the boot
> messages.
> 
> > (...) a pre-bad-commit dmesg would help.
> 
> Sent under separate cover to John.

Yea. From looking at your boot log, it does look like the PIT
clocksource is being used. 

This does point to an issue w/ that clocksource, however I noticed its
getting selected over the ACPI PM timer, because you have the PIIX4 bug.
That bug drops the ACPI PM timers rating to the same as the PIT, so
that's why you're getting the PIT.

Realistically, the PIT is much slower then even the triple read ACPI PM,
so the de-ranking code is probably dropping it too far.

Try this patch and let me know if it does the right thing. Although I do
still need to dig a bit on the PIT hang issue.

-john


Don't drop ACPI PM quite so low if we see the PIIX4 bug.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index d42060e..5ac309e 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -90,7 +90,7 @@ __setup("acpi_pm_good", acpi_pm_good_set
 static inline void acpi_pm_need_workaround(void)
 {
 	clocksource_acpi_pm.read = acpi_pm_read_slow;
-	clocksource_acpi_pm.rating = 110;
+	clocksource_acpi_pm.rating = 120;
 }
 
 /*



