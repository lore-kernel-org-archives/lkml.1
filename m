Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbXFJF0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbXFJF0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 01:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbXFJF01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 01:26:27 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:25916 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbXFJF00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 01:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZWkCTRTQRt5hbvXiPfOCySnTqaxjnebvQ6Z25qTX5xOzoK9crb24g2lGaho9szbOghxvKYoUsBVqGLAcDO3syXkfZR0yEyX+fKi/sV6bp+JUe7XphYB7n4Uzkmzfaqs2V/weX5Cb7ahJAsXbGhTfQj0oPNKOFK9DxeiKMvQbDhs=
Date: Sun, 10 Jun 2007 14:26:20 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] libata: limit post SRST nsect/lbal wait to ~100ms
Message-ID: <20070610052620.GH29122@htj.dyndns.org>
References: <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> <466196AD.3090502@garzik.org> <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com> <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com> <4667B347.9040900@gmail.com> <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org> <20070607224746.GA23290@havoc.gtf.org> <alpine.LFD.0.98.0706091054360.20321@woody.linux-foundation.org> <466AF98C.80101@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466AF98C.80101@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After SRST, libata used to wait for nsect/lbal to be set to 1/1 for
the slave device.  However, some ATAPI devices don't set nsect/lbal
after SRST and the wait itself isn't too useful as we're gonna wait
for !BSY right after that anyway.

Before reset-seq update, nsect/lbal wait failure used to be ignored
and caused 30sec delay during detection.  After reset-seq, all
timeouts are considered error conditions making libata fail to detect
such ATAPI devices.

This patch limits nsect/lbal wait to around 100ms.  This should give
acceptable behavior to such ATAPI devices while not disturbing the
heavily used code path too much.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
Okay, here it is.  Sorry for the delay.

 drivers/ata/libata-core.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4733f00..02a44ff 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3059,22 +3059,28 @@ static int ata_bus_post_reset(struct ata_port *ap, unsigned int devmask,
 		}
 	}
 
-	/* if device 1 was found in ata_devchk, wait for
-	 * register access, then wait for BSY to clear
+	/* if device 1 was found in ata_devchk, wait for register
+	 * access briefly, then wait for BSY to clear.
 	 */
-	while (dev1) {
-		u8 nsect, lbal;
+	if (dev1) {
+		int i;
 
 		ap->ops->dev_select(ap, 1);
-		nsect = ioread8(ioaddr->nsect_addr);
-		lbal = ioread8(ioaddr->lbal_addr);
-		if ((nsect == 1) && (lbal == 1))
-			break;
-		if (time_after(jiffies, deadline))
-			return -EBUSY;
-		msleep(50);	/* give drive a breather */
-	}
-	if (dev1) {
+
+		/* Wait for register access.  Some ATAPI devices fail
+		 * to set nsect/lbal after reset, so don't waste too
+		 * much time on it.  We're gonna wait for !BSY anyway.
+		 */
+		for (i = 0; i < 2; i++) {
+			u8 nsect, lbal;
+
+			nsect = ioread8(ioaddr->nsect_addr);
+			lbal = ioread8(ioaddr->lbal_addr);
+			if ((nsect == 1) && (lbal == 1))
+				break;
+			msleep(50);	/* give drive a breather */
+		}
+
 		rc = ata_wait_ready(ap, deadline);
 		if (rc) {
 			if (rc != -ENODEV)
