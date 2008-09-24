Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYIXP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYIXP5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYIXP5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:57:12 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:45910 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYIXP5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:57:11 -0400
From: Julien Brunel <brunel@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/usb/host: Use an IS_ERR test rather than a NULL test
Date: Wed, 24 Sep 2008 18:00:36 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241800.36320.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of error, the function isp1760_register returns an ERR
pointer, but never returns a NULL pointer. So after a call to this
function, a NULL test should be replaced by an IS_ERR test. Moreover,
we have noticed that:
(1) the result of isp1760_register is assigned through the function
pci_set_drvdata without an error test,
(2) if the call to isp1760_register fails, the current function
(isp1761_pci_probe) returns 0, and if it succeeds, it returns -ENOMEM,
which seems odd.

Thus, we suggest to move the test before the call to pci_set_drvdata
to correct (1), and to turn it into a non IS_ERR test to correct (2).

The semantic match that finds this problem is as follows: 
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@bad_null_test@
expression x,E;
statement S1, S2;
@@
x =  isp1760_register(...)
... when != x = E
* if (x == NULL)
S1 else S2
// </smpl>

Signed-off-by:  Julien Brunel <brunel@diku.dk>
Signed-off-by:  Julia Lawall <julia@diku.dk>

---
 drivers/usb/host/isp1760-if.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -u -p a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -232,9 +232,10 @@ static int __devinit isp1761_pci_probe(s
 	hcd = isp1760_register(pci_mem_phy0, length, dev->irq,
 		IRQF_SHARED | IRQF_DISABLED, &dev->dev, dev_name(&dev->dev),
 		devflags);
-	pci_set_drvdata(dev, hcd);
-	if (!hcd)
+	if (!IS_ERR(hcd)) {
+		pci_set_drvdata(dev, hcd);
 		return 0;
+	}
 clean:
 	status = -ENODEV;
 	iounmap(iobase);
