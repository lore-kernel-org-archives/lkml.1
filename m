Return-Path: <linux-kernel-owner+w=401wt.eu-S937921AbXG0V33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937921AbXG0V33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764939AbXG0V3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:29:16 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:19632 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760891AbXG0V3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=q8B8wndttKjGGibmsQ4pV7YCQE+CCO4FlemEOfgIskQHAjMMIfuESCg+iN9wJjyhem98OSbOcGngYWxQenZjBTGmhjCWb0SH5YZ0d23IWyiWtOGdvjzrr60XAVi8Cb+QTW3g16GSyEUakIC2jZuf6tR9Qnhlas0IDU93DG7pxk8=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-scsi@vger.kernel.org
Subject: [PATCH][sas] Fix potential NULL pointer dereference bug in sas_smp_get_phy_events()
Date: Fri, 27 Jul 2007 23:27:57 +0200
User-Agent: KMail/1.9.7
Cc: Luben Tuikov <luben_tuikov@adaptec.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707272327.57356.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In sas_smp_get_phy_events() we never test if the call to 
alloc_smp_req(RPEL_REQ_SIZE) succeeds or fails. That means we run 
the risk of dereferencing a NULL pointer if it does fail. Far 
better to test if we got NULL back and in that case return -ENOMEM 
just as we already do for the other memory allocation in that 
function.
This patch reworks the memory allocation a bit to deal with it 
(compile tested only).


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/libsas/sas_expander.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b500f0c..85f5145 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -507,14 +507,21 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
 int sas_smp_get_phy_events(struct sas_phy *phy)
 {
 	int res;
+	u8 *req;
+	u8 *resp;
 	struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 	struct domain_device *dev = sas_find_dev_by_rphy(rphy);
-	u8 *req = alloc_smp_req(RPEL_REQ_SIZE);
-	u8 *resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
 
+	resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
 	if (!resp)
 		return -ENOMEM;
 
+	req = alloc_smp_req(RPEL_REQ_SIZE);
+	if (!req) {
+        	res = -ENOMEM;
+		goto out;
+	}
+
 	req[1] = SMP_REPORT_PHY_ERR_LOG;
 	req[9] = phy->number;
 





  PS. Please keep me on Cc when replying.


