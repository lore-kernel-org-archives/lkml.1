Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZGVNjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZGVNjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZGVNjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:39:16 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39453 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbZGVNjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:39:14 -0400
From: Nicolas Palix <npalix@diku.dk>
To: gregkh@suse.de, haiyangz@microsoft.com, hjanssen@microsoft.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Transform some kzalloc calls to kcalloc in staging/hv
Date: Wed, 22 Jul 2009 15:39:13 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Julia Lawall <julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221539.13589.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a short excerpt of the semantic patch performing
this transformation:
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@@
expression E1,E2,E3;
@@
- kzalloc(E1*sizeof(E2),E3)
+ kcalloc(E1,sizeof(E2),E3)

@@
expression E1,E3;
type T;
@@
- kzalloc(E1*sizeof(T),E3)
+ kcalloc(E1,sizeof(T),E3)
//</smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 drivers/staging/hv/storvsc_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index c080beb..830076b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -473,7 +473,7 @@ static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl, unsigne
 
 	num_pages = ALIGN_UP(len, PAGE_SIZE) >> PAGE_SHIFT;
 
-	bounce_sgl = kzalloc(num_pages * sizeof(struct scatterlist), GFP_ATOMIC);
+	bounce_sgl = kcalloc(num_pages, sizeof(struct scatterlist), GFP_ATOMIC);
 	if (!bounce_sgl)
 	{
 		return NULL;
@@ -928,14 +928,14 @@ static void storvsc_host_rescan_callback(struct work_struct *work)
 	DPRINT_ENTER(STORVSC_DRV);
 
 	host_device_ctx = (struct host_device_context*)host->hostdata;
-	lun_list = kzalloc(sizeof(unsigned int)*STORVSC_MAX_LUNS_PER_TARGET, GFP_ATOMIC);
+	lun_list = kcalloc(STORVSC_MAX_LUNS_PER_TARGET, sizeof(unsigned int), GFP_ATOMIC);
 	if (!lun_list)
 	{
 		DPRINT_ERR(STORVSC_DRV, "unable to allocate lun list");
 		return;
 	}
 
-	sdevs_remove_list = kzalloc(sizeof(void*)*STORVSC_MAX_LUNS_PER_TARGET, GFP_ATOMIC);
+	sdevs_remove_list = kcalloc(STORVSC_MAX_LUNS_PER_TARGET, sizeof(void *), GFP_ATOMIC);
 	if (!sdevs_remove_list)
 	{
 		kfree(lun_list);
-- 
1.6.0.4


-- 
Nicolas Palix
