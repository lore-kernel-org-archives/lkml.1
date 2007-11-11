Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXKKX3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXKKX3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 18:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXKKX3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 18:29:31 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:44383 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbXKKX33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 18:29:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gGWGS249vox1jbt+t4MW97F4hWU8KmQTy8C1Fa2IvvrYjt/PSgNKIugqeDd+RWCQwFUsMsy7lGggh0GKQTWjq6272k0VZu8O9qIQ/swL1e/sgCDwmLeHF/zDV5IdC58qNJ8d5yAs3oJflhaifsRyWT7Jfx5/XTjgRt1ZvKEK+9M=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-scsi@vger.kernel.org
Subject: [PATCH] Fix problem with size of allocation in libsas
Date: Mon, 12 Nov 2007 00:24:54 +0100
User-Agent: KMail/1.9.7
Cc: Luben Tuikov <luben_tuikov@adaptec.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711120024.54773.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

in sas_get_phy_change_count(), the line
	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
will allocate 56 bytes due to this define:
	#define DISCOVER_RESP_SIZE 56
But, the struct is actually 60 bytes in size.

So change the define to be 
	#define DISCOVER_RESP_SIZE sizeof(struct smp_resp)
so we always get the correct size even when people 
fiddle with the structure.

This change also fixes the same problem in 
sas_get_phy_attached_sas_addr()

(Found by the Coverity checker. Compile tested only)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 sas_expander.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 8727436..a666cb1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -211,7 +211,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 }
 
 #define DISCOVER_REQ_SIZE  16
-#define DISCOVER_RESP_SIZE 56
+#define DISCOVER_RESP_SIZE sizeof(struct smp_resp)
 
 static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 				      u8 *disc_resp, int single)



