Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZLDLN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZLDLN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZLDLN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:13:27 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:64367 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZLDLN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=K4VlQpJgywHmwq8NT1XaN0gvWhhAydoWhWioFZ6BYifaSVFJMQqyW+q2p2pxe/Vbz0
         49RDgft2IgPyR8az24J+VtxvCWQ6N06hn3y/9IFub85JcLK44vXKTsdnLJK97mDyCQRo
         ZPXLUblaueLYWq5U+6qyolEShGgXfIwk2HlC0=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-sh@vger.kernel.org, johnstul@us.ibm.com,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
       tglx@linutronix.de
Date: Fri, 04 Dec 2009 20:07:59 +0900
Message-Id: <20091204110759.17863.39630.sendpatchset@rxone.opensource.se>
Subject: [PATCH] clocksource: Start CMT at clocksource resume V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add code to start the CMT timer on clocksource resume.
While at it handle the suspend case as well.
Remove the platform device specific suspend calls.

This makes sure the timer is started during sysdev_resume().
Without this patch the clocksource may be read as suspended,
this after sysdev resume but before platform device resume.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 V2 adds suspend handling.

 Depends on the clocksource resume argument patch and the
 clocksource suspend patch.

 drivers/clocksource/sh_cmt.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

--- 0001/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2009-12-04 19:48:00.000000000 +0900
@@ -40,7 +40,6 @@ struct sh_cmt_priv {
 	struct platform_device *pdev;
 
 	unsigned long flags;
-	unsigned long flags_suspend;
 	unsigned long match_value;
 	unsigned long next_match_value;
 	unsigned long max_match_value;
@@ -432,6 +431,11 @@ static void sh_cmt_clocksource_disable(s
 	sh_cmt_stop(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
 }
 
+static void sh_cmt_clocksource_resume(struct clocksource *cs)
+{
+	sh_cmt_start(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
+}
+
 static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
 				       char *name, unsigned long rating)
 {
@@ -442,6 +446,8 @@ static int sh_cmt_register_clocksource(s
 	cs->read = sh_cmt_clocksource_read;
 	cs->enable = sh_cmt_clocksource_enable;
 	cs->disable = sh_cmt_clocksource_disable;
+	cs->suspend = sh_cmt_clocksource_disable;
+	cs->resume = sh_cmt_clocksource_resume;
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 	pr_info("sh_cmt: %s used as clock source\n", cs->name);
@@ -668,38 +674,11 @@ static int __devexit sh_cmt_remove(struc
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
-static int sh_cmt_suspend(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
-
-	/* save flag state and stop CMT channel */
-	p->flags_suspend = p->flags;
-	sh_cmt_stop(p, p->flags);
-	return 0;
-}
-
-static int sh_cmt_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
-
-	/* start CMT channel from saved state */
-	sh_cmt_start(p, p->flags_suspend);
-	return 0;
-}
-
-static struct dev_pm_ops sh_cmt_dev_pm_ops = {
-	.suspend = sh_cmt_suspend,
-	.resume = sh_cmt_resume,
-};
-
 static struct platform_driver sh_cmt_device_driver = {
 	.probe		= sh_cmt_probe,
 	.remove		= __devexit_p(sh_cmt_remove),
 	.driver		= {
 		.name	= "sh_cmt",
-		.pm	= &sh_cmt_dev_pm_ops,
 	}
 };
 
