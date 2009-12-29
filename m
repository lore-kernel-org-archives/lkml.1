Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbZL2RhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbZL2RhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 12:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZL2RhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 12:37:07 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:34848 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZL2RhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 12:37:06 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       =?iso-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
       "Len Brown" <lenb@kernel.org>,
       =?iso-8859-1?Q?Malte_Schr=F6der?= <maltesch@gmx.de>
Subject: Re: [Bug #14889] System wakeup by time not working anymore
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	<srmJ8vMxKPH.A.BaC.ZwhOLB@chimera>
Date: Wed, 30 Dec 2009 02:36:56 +0900
In-Reply-To: <srmJ8vMxKPH.A.BaC.ZwhOLB@chimera> (Rafael J. Wysocki's message
	of "Tue, 29 Dec 2009 16:28:52 +0100 (CET)")
Message-ID: <87k4w5u1fr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14889
> Subject		: System wakeup by time not working anymore
> Submitter	: Malte Schröder <maltesch@gmx.de>
> Date		: 2009-12-03 18:06 (27 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=abd6633c67925f90775bb74755f9c547e30f1f20
> References	: http://marc.info/?l=linux-kernel&m=125986362631900&w=4

Specified commit would break the pnp driver which is using
driver->shutdown.

Could you test this (untested) patch?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


[PATCH] rtc_cmos: convert shutdown to new pnp_driver->shutdown

commit abd6633c67925f90775bb74755f9c547e30f1f20 adds shutdown method
to bus driver blindly. With it, driver->shutdown is invalid anymore.

Use pnp_driver->shutdown instead.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/rtc/rtc-cmos.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-shutdown-fix drivers/rtc/rtc-cmos.c
--- linux-2.6/drivers/rtc/rtc-cmos.c~rtc-cmos-shutdown-fix	2009-12-30 01:25:10.000000000 +0900
+++ linux-2.6-hirofumi/drivers/rtc/rtc-cmos.c	2009-12-30 01:27:36.000000000 +0900
@@ -1096,9 +1096,9 @@ static int cmos_pnp_resume(struct pnp_de
 #define	cmos_pnp_resume		NULL
 #endif
 
-static void cmos_pnp_shutdown(struct device *pdev)
+static void cmos_pnp_shutdown(struct pnp_dev *pnp)
 {
-	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(pdev))
+	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(&pnp->dev))
 		return;
 
 	cmos_do_shutdown();
@@ -1117,15 +1117,12 @@ static struct pnp_driver cmos_pnp_driver
 	.id_table	= rtc_ids,
 	.probe		= cmos_pnp_probe,
 	.remove		= __exit_p(cmos_pnp_remove),
+	.shutdown	= cmos_pnp_shutdown,
 
 	/* flag ensures resume() gets called, and stops syslog spam */
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
 	.suspend	= cmos_pnp_suspend,
 	.resume		= cmos_pnp_resume,
-	.driver		= {
-		.name	  = (char *)driver_name,
-		.shutdown = cmos_pnp_shutdown,
-	}
 };
 
 #endif	/* CONFIG_PNP */
_
