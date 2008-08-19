Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYHSSij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYHSSij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYHSSh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:37:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:44075 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbYHSShW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=BcbeW6L5cforrZSnGF5++v+GnPTymz3c3WPVWINfu3A1VkS8077NHL2tKFbx8s9y/p
         PZqeDnU+iTsbrZGA9PdQWbMj2oazCN93sayczJVyRfU6V0KO0LrhK+08gAgJQKRd49v5
         zIDn8NiJrcpP5gIoapKb+O8NrXDIrPRylbxqg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/5] ide: remove ide_host_alloc_all()
Date: Tue, 19 Aug 2008 20:34:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192034.10833.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove no longer used ide_host_alloc_all().

* Add MAX_HOST_PORTS define and use it instead of MAX_HWIFS
  as the maximum number of host ports possible.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   31 +++++++++----------------------
 include/linux/ide.h     |    5 +++--
 2 files changed, 12 insertions(+), 24 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1544,8 +1544,7 @@ static void ide_free_port_slot(int idx)
 	mutex_unlock(&ide_cfg_mtx);
 }
 
-struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
-				    hw_regs_t **hws)
+struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 {
 	struct ide_host *host;
 	int i;
@@ -1554,7 +1553,7 @@ struct ide_host *ide_host_alloc_all(cons
 	if (host == NULL)
 		return NULL;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		ide_hwif_t *hwif;
 		int idx;
 
@@ -1596,18 +1595,6 @@ struct ide_host *ide_host_alloc_all(cons
 
 	return host;
 }
-EXPORT_SYMBOL_GPL(ide_host_alloc_all);
-
-struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
-{
-	hw_regs_t *hws_all[MAX_HWIFS];
-	int i;
-
-	for (i = 0; i < MAX_HWIFS; i++)
-		hws_all[i] = (i < 4) ? hws[i] : NULL;
-
-	return ide_host_alloc_all(d, hws_all);
-}
 EXPORT_SYMBOL_GPL(ide_host_alloc);
 
 int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
@@ -1616,7 +1603,7 @@ int ide_host_register(struct ide_host *h
 	ide_hwif_t *hwif, *mate = NULL;
 	int i, j = 0;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL) {
@@ -1644,7 +1631,7 @@ int ide_host_register(struct ide_host *h
 		ide_port_init_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1661,7 +1648,7 @@ int ide_host_register(struct ide_host *h
 			ide_port_tune_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1685,7 +1672,7 @@ int ide_host_register(struct ide_host *h
 			ide_acpi_port_init_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1698,7 +1685,7 @@ int ide_host_register(struct ide_host *h
 			hwif_register_devices(hwif);
 	}
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1743,7 +1730,7 @@ void ide_host_free(struct ide_host *host
 	ide_hwif_t *hwif;
 	int i;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		hwif = host->ports[i];
 
 		if (hwif == NULL)
@@ -1761,7 +1748,7 @@ void ide_host_remove(struct ide_host *ho
 {
 	int i;
 
-	for (i = 0; i < MAX_HWIFS; i++) {
+	for (i = 0; i < MAX_HOST_PORTS; i++) {
 		if (host->ports[i])
 			ide_unregister(host->ports[i]);
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -830,8 +830,10 @@ typedef struct hwif_s {
 #endif
 } ____cacheline_internodealigned_in_smp ide_hwif_t;
 
+#define MAX_HOST_PORTS 4
+
 struct ide_host {
-	ide_hwif_t	*ports[MAX_HWIFS];
+	ide_hwif_t	*ports[MAX_HOST_PORTS];
 	unsigned int	n_ports;
 	struct device	*dev[2];
 	unsigned int	(*init_chipset)(struct pci_dev *);
@@ -1474,7 +1476,6 @@ void ide_undecoded_slave(ide_drive_t *);
 
 void ide_port_apply_params(ide_hwif_t *);
 
-struct ide_host *ide_host_alloc_all(const struct ide_port_info *, hw_regs_t **);
 struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
 void ide_host_free(struct ide_host *);
 int ide_host_register(struct ide_host *, const struct ide_port_info *,
