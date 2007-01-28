Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbXA1TEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbXA1TEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932736AbXA1TEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:04:21 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42022 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932437AbXA1TEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:04:20 -0500
Date: Sun, 28 Jan 2007 20:04:26 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] fix CONFIG_SATA_SIS=y compile error
Message-ID: <20070128190426.GU6017@stusta.de>
References: <20070127234928.64d8e437.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 11:49:28PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc4-mm1:
>...
>  git-libata-all.patch
>...
>  git trees.
>...

Static code shouldn't be used from other modules.

This patch fixes the following compile error:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `sis_init_one':
sata_sis.c:(.text+0x7634cd): undefined reference to `sis_info133'
sata_sis.c:(.text+0x7634d6): undefined reference to `sis_info133'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

While I was at it, I also moved the prototype of this struct to a header
file.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/ata/libata.h   |    3 +++
 drivers/ata/pata_sis.c |    3 ++-
 drivers/ata/sata_sis.c |    4 +---
 3 files changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.20-rc6-mm1/drivers/ata/libata.h.old	2007-01-28 16:01:41.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/ata/libata.h	2007-01-28 16:02:10.000000000 +0100
@@ -151,4 +151,7 @@
 /* libata-sff.c */
 extern u8 ata_irq_on(struct ata_port *ap);
 
+/* pata_sis.c */
+extern struct ata_port_info sis_info133;
+
 #endif /* __LIBATA_H__ */
--- linux-2.6.20-rc6-mm1/drivers/ata/pata_sis.c.old	2007-01-28 16:08:26.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/ata/pata_sis.c	2007-01-28 16:02:51.000000000 +0100
@@ -32,6 +32,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <linux/ata.h>
+#include "libata.h"
 
 #define DRV_NAME	"pata_sis"
 #define DRV_VERSION	"0.4.5"
@@ -781,7 +782,7 @@
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.port_ops	= &sis_66_ops,
 };
-static struct ata_port_info sis_info133 = {
+struct ata_port_info sis_info133 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
--- linux-2.6.20-rc6-mm1/drivers/ata/sata_sis.c.old	2007-01-28 16:05:31.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/ata/sata_sis.c	2007-01-28 16:05:49.000000000 +0100
@@ -40,6 +40,7 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
+#include "libata.h"
 
 #define DRV_NAME	"sata_sis"
 #define DRV_VERSION	"0.7"
@@ -254,9 +255,6 @@
 
 static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	/* Provided by the PATA driver */
-	extern struct ata_port_info sis_info133;
-
 	static int printed_version;
 	struct ata_probe_ent *probe_ent = NULL;
 	int rc;

