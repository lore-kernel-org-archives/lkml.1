Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXJIAi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXJIAi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 20:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXJIAiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 20:38:46 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54965 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXJIAip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 20:38:45 -0400
Date: Mon, 8 Oct 2007 17:39:13 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 1/2] libsas: Provide a transport-level facility to request
	SAS addrs
Message-ID: <20071009003913.GC16003@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the request_firmware() interface to get a SAS address from userspace.
This way, there's no debate as to who or how an address gets generated;
it's up to the administrator to provide one if the driver can't find one
on its own.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |   41 +++++++++++++++++++++++++++++++++++
 include/scsi/libsas.h               |    3 +++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7663841..0fa0296 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -24,6 +24,8 @@
  */
 
 #include <linux/kthread.h>
+#include <linux/firmware.h>
+#include <linux/ctype.h>
 
 #include "sas_internal.h"
 
@@ -1047,6 +1049,45 @@ void sas_target_destroy(struct scsi_target *starget)
 	return;
 }
 
+static void sas_parse_addr(u8 *sas_addr, const char *p)
+{
+	int i;
+	for (i = 0; i < SAS_ADDR_SIZE; i++) {
+		u8 h, l;
+		if (!*p)
+			break;
+		h = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
+		p++;
+		l = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
+		p++;
+		sas_addr[i] = (h<<4) | l;
+	}
+}
+
+#define SAS_STRING_ADDR_SIZE	16
+
+int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
+{
+	int res;
+	const struct firmware *fw;
+
+	res = request_firmware(&fw, "sas_addr", &shost->shost_gendev);
+	if (res)
+		return res;
+
+	if (fw->size < SAS_STRING_ADDR_SIZE) {
+		res = -ENODEV;
+		goto out;
+	}
+
+	sas_parse_addr(addr, fw->data);
+
+out:
+	release_firmware(fw);
+	return res;
+}
+EXPORT_SYMBOL_GPL(sas_request_addr);
+
 EXPORT_SYMBOL_GPL(sas_queuecommand);
 EXPORT_SYMBOL_GPL(sas_target_alloc);
 EXPORT_SYMBOL_GPL(sas_slave_configure);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8dda2d6..58aa2aa 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -676,4 +676,7 @@ extern int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg);
 
 extern int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			   struct request *req);
+
+int sas_request_addr(struct Scsi_Host *shost, u8 *addr);
+
 #endif /* _SASLIB_H_ */
