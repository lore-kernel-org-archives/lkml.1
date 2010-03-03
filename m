Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab0CCRRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:17:55 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:37367 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755047Ab0CCRRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:17:50 -0500
Date: Wed, 3 Mar 2010 20:17:49 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] ahci: Export generic AHCI symbols, turn libahci into
 a separate module
Message-ID: <20100303171749.GJ12362@oksana.dev.rtsoft.ru>
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100303171713.GA6322@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for non-PCI drivers that will be added soon.

Since the symbols are exported now, libahci and ahci can be built as
a separate modules.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/Kconfig   |    8 +++++++-
 drivers/ata/Makefile  |    3 ++-
 drivers/ata/libahci.c |   20 ++++++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 01c52c4..365a9da 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -59,12 +59,18 @@ config SATA_PMP
 
 config SATA_AHCI
 	tristate "AHCI SATA support"
-	depends on PCI
 	help
 	  This option enables support for AHCI Serial ATA.
 
 	  If unsure, say N.
 
+config SATA_AHCI_PCI
+	tristate "PCI AHCI SATA support"
+	depends on SATA_AHCI && PCI
+	default y
+	help
+	  This option enables support for PCI AHCI Serial ATA controllers.
+
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 75e3abd..a438cef 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,7 +1,8 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
-obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
+obj-$(CONFIG_SATA_AHCI)		+= libahci.o
+obj-$(CONFIG_SATA_AHCI_PCI)	+= ahci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 3ec32ee..d2eacc4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -47,6 +47,7 @@
 
 static int ahci_skip_host_reset;
 int ahci_ignore_sss;
+EXPORT_SYMBOL_GPL(ahci_ignore_sss);
 
 module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
 MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
@@ -137,6 +138,7 @@ struct scsi_host_template ahci_sht = {
 	.shost_attrs		= ahci_shost_attrs,
 	.sdev_attrs		= ahci_sdev_attrs,
 };
+EXPORT_SYMBOL_GPL(ahci_sht);
 
 struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
@@ -174,8 +176,10 @@ struct ata_port_operations ahci_ops = {
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
 };
+EXPORT_SYMBOL_GPL(ahci_ops);
 
 int ahci_em_messages = 1;
+EXPORT_SYMBOL_GPL(ahci_em_messages);
 module_param(ahci_em_messages, int, 0444);
 /* add other LED protocol types when they become supported */
 MODULE_PARM_DESC(ahci_em_messages,
@@ -369,6 +373,7 @@ void ahci_save_initial_config(struct device *dev,
 	hpriv->cap2 = cap2;
 	hpriv->port_map = port_map;
 }
+EXPORT_SYMBOL_GPL(ahci_save_initial_config);
 
 /**
  *	ahci_restore_initial_config - Restore initial config
@@ -443,6 +448,7 @@ void ahci_start_engine(struct ata_port *ap)
 	writel(tmp, port_mmio + PORT_CMD);
 	readl(port_mmio + PORT_CMD); /* flush */
 }
+EXPORT_SYMBOL_GPL(ahci_start_engine);
 
 int ahci_stop_engine(struct ata_port *ap)
 {
@@ -467,6 +473,7 @@ int ahci_stop_engine(struct ata_port *ap)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_stop_engine);
 
 static void ahci_start_fis_rx(struct ata_port *ap)
 {
@@ -784,6 +791,7 @@ int ahci_reset_controller(struct ata_host *host)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_reset_controller);
 
 static void ahci_sw_activity(struct ata_link *link)
 {
@@ -871,6 +879,7 @@ int ahci_reset_em(struct ata_host *host)
 	writel(em_ctl | EM_CTL_RST, mmio + HOST_EM_CTL);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_reset_em);
 
 static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 					ssize_t size)
@@ -1064,6 +1073,7 @@ void ahci_init_controller(struct ata_host *host)
 	tmp = readl(mmio + HOST_CTL);
 	VPRINTK("HOST_CTL 0x%x\n", tmp);
 }
+EXPORT_SYMBOL_GPL(ahci_init_controller);
 
 static void ahci_dev_config(struct ata_device *dev)
 {
@@ -1147,6 +1157,7 @@ int ahci_kick_engine(struct ata_port *ap)
 	ahci_start_engine(ap);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ahci_kick_engine);
 
 static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 				struct ata_taskfile *tf, int is_cmd, u16 flags,
@@ -1253,6 +1264,7 @@ int ahci_check_ready(struct ata_link *link)
 
 	return ata_check_ready(status);
 }
+EXPORT_SYMBOL_GPL(ahci_check_ready);
 
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline)
@@ -1263,6 +1275,7 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
 
 	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
 }
+EXPORT_SYMBOL_GPL(ahci_do_softreset);
 
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline)
@@ -1665,6 +1678,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 	return IRQ_RETVAL(handled);
 }
+EXPORT_SYMBOL_GPL(ahci_interrupt);
 
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
@@ -2034,6 +2048,7 @@ void ahci_print_info(struct ata_host *host, const char *scc_s)
 		cap2 & HOST_CAP2_BOH ? "boh " : ""
 		);
 }
+EXPORT_SYMBOL_GPL(ahci_print_info);
 
 void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			  struct ata_port_info *pi)
@@ -2057,3 +2072,8 @@ void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			pi->flags |= ATA_FLAG_SW_ACTIVITY;
 	}
 }
+EXPORT_SYMBOL_GPL(ahci_set_em_messages);
+
+MODULE_AUTHOR("Jeff Garzik");
+MODULE_DESCRIPTION("AHCI SATA low-level routines");
+MODULE_LICENSE("GPL");
-- 
1.7.0

