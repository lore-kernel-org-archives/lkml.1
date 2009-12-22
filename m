Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZLVUcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZLVUcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZLVUcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:32:31 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:51179 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbZLVUca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:32:30 -0500
Date: Tue, 22 Dec 2009 21:32:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: aacraid@adaptec.com, "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/6] drivers/scsi: Correct use after free
Message-ID: <Pine.LNX.4.64.0912222132080.28669@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Move the kfree after a reference to the freed structure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
identifier f;
iterator I;
statement S;
@@

*kfree(x);
... when != &x
    when != x = e
    when != I(x,...) S
*x->f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/dpt_i2o.c              |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 4967643..18c625c 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1229,12 +1229,13 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba)
 		}
 	}
 	pci_dev_put(pHba->pDev);
-	kfree(pHba);
 
 	if (adpt_sysfs_class)
 		device_destroy(adpt_sysfs_class,
 				MKDEV(DPTI_I2O_MAJOR, pHba->unit));
 
+	kfree(pHba);
+
 	if(hba_count <= 0){
 		unregister_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER);   
 		if (adpt_sysfs_class) {
