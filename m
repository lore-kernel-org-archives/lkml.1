Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZD1Cnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZD1Cnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbZD1Cnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:43:45 -0400
Received: from n23b.bullet.mail.mud.yahoo.com ([68.142.206.142]:48052 "HELO
	n23b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758444AbZD1Cnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:43:43 -0400
X-Yahoo-Newman-Id: 462269.80594.bm@omp419.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZZjeObKmAaA0/Wk1BQErJ41s4+a3w1CcDV+tbQEfKAlBsQpBR206Ono6GT2P5SYtPOqm2GoEIoMsLsqYIyHjkklJpMlFABmlTEYtijGNXb/Hx4w7Ud8laz7W9o/TjyCbKFwiGIf/pzBzjBqLegK9XP9eVVzoraWSCV/NeVkkYzQ=  ;
X-YMail-OSG: WA1YbksVM1nqWFRK2GexMJxIoztLTxtB.kuxLQ2RNv9C4rPTow14FhVTTlw0yAfbhEEFcOKk81FFLjwNwUEQD62ph13iSlitUcsmJ5cHrrnYDoIwELfXaxuTyAn6H6JJJEYjK5E7JY2kWsQ0BSh71yualG0cAIHcus.xmlyR1jswsOSieyw3K92V9E_FgluQqFc47HFGJYz7D9rz.ug3vueFxG6_P3OZfy41li2Ty6_vGpWc0uTHoEoZHwnxOcUvBd9hOwLwlCm_D7vM5IGX_LyGU4lfvoyGQmlIwwMLPuYPpSIZ7J7vOw61QA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.30-rc3] platform_bus:  remove "which platform_data?" confusion
Date: Mon, 27 Apr 2009 19:43:40 -0700
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271943.40588.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Recent patches have caused platform_device_add_pdata() users
to trigger confused "use which platform_data?" error messages
from the kernel.  ("The _only_ one you were given, dummy!" is
the correct answer.)

This patch fixes those messages so they only appear if there's
reason to be confused.  (The call should probably fail too...)

Those patches seem to support what I think is a misguided
notion:  that somehow device.platform_data might move into
the platform_device.  The problem with that idea is that it's
a general purpose hook, and is used by other busses to provide
board-specific configuration data ... not just for platform_bus.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
For 2.6.30, which recently acquired this confusion.

 drivers/base/platform.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -251,16 +251,20 @@ int platform_device_add(struct platform_
 	* if all platform devices pass its platform specific data
 	* from platform_device. The conversion is going to be a
 	* long time, so we allow the two cases coexist to make
-	* this kind of fix more easily*/
-	if (pdev->platform_data && pdev->dev.platform_data) {
-		printk(KERN_ERR
-			       "%s: use which platform_data?\n",
-			       dev_name(&pdev->dev));
-	} else if (pdev->platform_data) {
-		pdev->dev.platform_data = pdev->platform_data;
-	} else if (pdev->dev.platform_data) {
+	* this kind of fix more easily
+	*
+	* REVISIT platform_data is used by more than "platform_bus".
+	* It's a generic hook for data that's specific to a given
+	* board.  Removing it seems rather impractical...
+	*/
+	if (!pdev->platform_data)
 		pdev->platform_data = pdev->dev.platform_data;
-	}
+	else if (!pdev->dev.platform_data)
+		pdev->dev.platform_data = pdev->platform_data;
+
+	if (pdev->platform_data != pdev->dev.platform_data)
+		pr_err("%s: use which platform_data?\n",
+			       dev_name(&pdev->dev));
 
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];

