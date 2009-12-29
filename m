Return-Path: <linux-kernel-owner+w=401wt.eu-S1751670AbZL2RlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbZL2RlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 12:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZL2RlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 12:41:14 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:34862 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZL2RlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 12:41:14 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tpm_infineon: Fix suspend/resume handler for pnp_driver
Date: Wed, 30 Dec 2009 02:41:10 +0900
Message-ID: <87d41xu18p.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With recent quick review, I found the bug of tpm_infineon. (I don't have
this device, and compile test only)


PNP driver must use pnp_driver->suspend/resume anymore.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/char/tpm/tpm_infineon.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/char/tpm/tpm_infineon.c~tpm-pnp_driver-convert drivers/char/tpm/tpm_infineon.c
--- linux-2.6/drivers/char/tpm/tpm_infineon.c~tpm-pnp_driver-convert	2009-12-30 02:27:07.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/tpm/tpm_infineon.c	2009-12-30 02:27:07.000000000 +0900
@@ -611,16 +611,26 @@ static __devexit void tpm_inf_pnp_remove
 	}
 }
 
+static int tpm_pnp_suspend(struct pnp_dev *dev, pm_message_t pm_state)
+{
+	return tpm_pm_suspend(&dev->dev, pm_state);
+}
+
+static int tpm_pnp_resume(struct pnp_dev *dev)
+{
+	return tpm_pm_resume(&dev->dev);
+}
+
 static struct pnp_driver tpm_inf_pnp_driver = {
 	.name = "tpm_inf_pnp",
-	.driver = {
-		.owner = THIS_MODULE,
-		.suspend = tpm_pm_suspend,
-		.resume = tpm_pm_resume,
-	},
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_inf_pnp_probe,
 	.remove = __devexit_p(tpm_inf_pnp_remove),
+	.suspend = tpm_pnp_suspend,
+	.resume = tpm_pnp_resume,
+	.driver = {
+		.owner = THIS_MODULE,
+	},
 };
 
 static int __init init_inf(void)
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
