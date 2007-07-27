Return-Path: <linux-kernel-owner+w=401wt.eu-S1764782AbXG0UAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764782AbXG0UAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765997AbXG0UAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:00:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:30694 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765408AbXG0T75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qO0b58glj2Ts028SQVc/Jg1r8vTmkPbiH+zUrA32zf3pxSp4Cr+3BpKhW/o+PKxg/6OLe7+tyUKuIqjB+wF7Fh8q/kN/3rA+TfT7Yh9NnshAuuU5/1LNyOcgptjgNDefHZ6QebOK59NRIBoNO2/YDO3wbUS33hvyEbB3+U/1PPs=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-scsi@vger.kernel.org
Subject: [PATCH][sas] Fix potential NULL pointer dereference bug in sas_smp_handler()
Date: Fri, 27 Jul 2007 21:58:41 +0200
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
Message-Id: <200707272158.41374.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The Coverity checker found a problem in 
drivers/scsi/libsas/sas_expander.c::sas_smp_handler().
We dereference a pointer before testing if it is NULL. Easily fixed 
in this case by simply moving an assignment down a bit.

Please consider for inclusion.

Patch has been compile tested only.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/libsas/sas_expander.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b500f0c..7871406 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1879,7 +1879,7 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    struct request *req)
 {
 	struct domain_device *dev;
-	int ret, type = rphy->identify.device_type;
+	int ret, type;
 	struct request *rsp = req->next_rq;
 
 	if (!rsp) {
@@ -1895,6 +1895,8 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		return -EINVAL;
 	}
 
+	type = rphy->identify.device_type;
+
 	if (type != SAS_EDGE_EXPANDER_DEVICE &&
 	    type != SAS_FANOUT_EXPANDER_DEVICE) {
 		printk("%s: can we send a smp request to a device?\n",





  PS. Please keep me on Cc when replying.


