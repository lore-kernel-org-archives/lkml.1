Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab0BQNhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:37:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38924 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932658Ab0BQNhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:37:13 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RFC 3/4] libata: Remove excess command issue delays
To: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Wed, 17 Feb 2010 13:13:16 +0000
Message-ID: <20100217131145.16338.70473.stgit@localhost.localdomain>
In-Reply-To: <20100217130847.16338.55586.stgit@localhost.localdomain>
References: <20100217130847.16338.55586.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to pause before a command issue for PIO (it's posted) or for
most MMIO devices (internally managed delay) so provide a routine for the
normal "sane" hardware

As a side effect it also means that those devices using PIO don't end up
generating ATA bus cycles in strange places which confuses some hardware.

Saves us about 1mS on a dumb controller, a fair bit less (uSecs on smarter
ones). ata_pause() is very very slow on controllers where it goes all the way

[For those counting thats another mS saved once we turn this stuff on]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/ata_generic.c       |    7 +++---
 drivers/ata/ata_piix.c          |    1 +
 drivers/ata/libata-sff.c        |   25 ++++++++++++++++++++
 drivers/ata/pata_acpi.c         |    1 +
 drivers/ata/pata_ali.c          |   16 +++++++------
 drivers/ata/pata_amd.c          |   48 ++++++++++++++++++++-------------------
 drivers/ata/pata_artop.c        |    2 ++
 drivers/ata/pata_atiixp.c       |   15 +++++++-----
 drivers/ata/pata_atp867x.c      |    1 +
 drivers/ata/pata_cmd640.c       |   13 ++++++-----
 drivers/ata/pata_cmd64x.c       |   23 ++++++++++---------
 drivers/ata/pata_cs5520.c       |    1 +
 drivers/ata/pata_cs5530.c       |   13 ++++++-----
 drivers/ata/pata_cs5535.c       |    9 ++++---
 drivers/ata/pata_cs5536.c       |    1 +
 drivers/ata/pata_efar.c         |    1 +
 drivers/ata/pata_hpt366.c       |   11 +++++----
 drivers/ata/pata_hpt37x.c       |   36 +++++++++++++++--------------
 drivers/ata/pata_hpt3x2n.c      |   17 +++++++-------
 drivers/ata/pata_isapnp.c       |    5 ++--
 drivers/ata/pata_it8213.c       |    1 +
 drivers/ata/pata_it821x.c       |   42 ++++++++++++++++++----------------
 drivers/ata/pata_jmicron.c      |    1 +
 drivers/ata/pata_legacy.c       |    5 ++--
 drivers/ata/pata_marvell.c      |    1 +
 drivers/ata/pata_mpiix.c        |   13 ++++++-----
 drivers/ata/pata_netcell.c      |    7 +++---
 drivers/ata/pata_ns87410.c      |   11 +++++----
 drivers/ata/pata_ns87415.c      |    1 +
 drivers/ata/pata_oldpiix.c      |    1 +
 drivers/ata/pata_opti.c         |    9 ++++---
 drivers/ata/pata_optidma.c      |   19 ++++++++-------
 drivers/ata/pata_pcmcia.c       |   19 ++++++++-------
 drivers/ata/pata_pdc202xx_old.c |    1 +
 drivers/ata/pata_piccolo.c      |    9 ++++---
 drivers/ata/pata_qdi.c          |   15 +++++++-----
 drivers/ata/pata_radisys.c      |    1 +
 drivers/ata/pata_rdc.c          |    1 +
 drivers/ata/pata_rz1000.c       |    7 +++---
 drivers/ata/pata_sc1200.c       |   15 +++++++-----
 drivers/ata/pata_sch.c          |    1 +
 drivers/ata/pata_serverworks.c  |   11 +++++----
 drivers/ata/pata_sis.c          |    2 ++
 drivers/ata/pata_triflex.c      |   13 ++++++-----
 drivers/ata/pata_via.c          |   17 +++++++-------
 drivers/ata/pata_winbond.c      |    9 ++++---
 include/linux/libata.h          |    2 ++
 47 files changed, 278 insertions(+), 202 deletions(-)


diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 12e26c3..abae7d5 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -96,9 +96,10 @@ static struct scsi_host_template generic_sht = {
 };
 
 static struct ata_port_operations generic_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= ata_cable_unknown,
-	.set_mode	= generic_set_mode,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= ata_cable_unknown,
+	.set_mode		= generic_set_mode,
 };
 
 static int all_generic_ide;		/* Set to claim all devices */
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index c338066..c5b1378 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -320,6 +320,7 @@ static struct scsi_host_template piix_sht = {
 
 static struct ata_port_operations piix_sata_ops = {
 	.inherits		= &ata_bmdma32_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.sff_irq_check		= piix_irq_check,
 };
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 3558ca8..fa18482 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -674,11 +674,34 @@ void ata_sff_exec_command(struct ata_port *ap, const struct ata_taskfile *tf)
 	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
 
 	iowrite8(tf->command, ap->ioaddr.command_addr);
-	ata_sff_pause(ap);
+	/* Slow */
+        ata_sff_pause(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_exec_command);
 
 /**
+ *	ata_sff_exec_command_nopost - issue ATA command to host controller
+ *	@ap: port to which command is being issued
+ *	@tf: ATA taskfile register set
+ *
+ *	Issues ATA command, with proper synchronization with interrupt
+ *	handler / other threads. This version of the helper does not protect
+ *	against any delayed writes done by the underlying fabric, it must
+ *	therefore not be used for MMIO devices unless the device handles
+ *	the 400nS command delay stall internally.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_sff_exec_command_nopost(struct ata_port *ap,
+                                        const struct ata_taskfile *tf)
+{
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+	iowrite8(tf->command, ap->ioaddr.command_addr);
+}
+EXPORT_SYMBOL_GPL(ata_sff_exec_command_nopost);
+
+/**
  *	ata_tf_to_host - issue ATA taskfile to host controller
  *	@ap: port to which command is being issued
  *	@tf: ATA taskfile register set
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 9e33da9..6c5765b 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -217,6 +217,7 @@ static struct scsi_host_template pacpi_sht = {
 
 static struct ata_port_operations pacpi_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.qc_issue		= pacpi_qc_issue,
 	.cable_detect		= pacpi_cable_detect,
 	.mode_filter		= pacpi_mode_filter,
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 63ba48c..940bead 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -364,16 +364,18 @@ static struct scsi_host_template ali_sht = {
  */
 
 static struct ata_port_operations ali_early_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= ali_set_piomode,
-	.sff_data_xfer  = ata_sff_data_xfer32,
+	.inherits		= &ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= ali_set_piomode,
+	.sff_data_xfer  	= ata_sff_data_xfer32,
 };
 
 static const struct ata_port_operations ali_dma_base_ops = {
-	.inherits	= &ata_bmdma32_port_ops,
-	.set_piomode	= ali_set_piomode,
-	.set_dmamode	= ali_set_dmamode,
+	.inherits		= &ata_bmdma32_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.set_piomode		= ali_set_piomode,
+	.set_dmamode		= ali_set_dmamode,
 };
 
 /*
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 567f3f7..15faa9b 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -393,44 +393,46 @@ static struct scsi_host_template amd_sht = {
 };
 
 static const struct ata_port_operations amd_base_port_ops = {
-	.inherits	= &ata_bmdma32_port_ops,
-	.prereset	= amd_pre_reset,
+	.inherits		= &ata_bmdma32_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.prereset		= amd_pre_reset,
 };
 
 static struct ata_port_operations amd33_port_ops = {
-	.inherits	= &amd_base_port_ops,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= amd33_set_piomode,
-	.set_dmamode	= amd33_set_dmamode,
+	.inherits		= &amd_base_port_ops,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= amd33_set_piomode,
+	.set_dmamode		= amd33_set_dmamode,
 };
 
 static struct ata_port_operations amd66_port_ops = {
-	.inherits	= &amd_base_port_ops,
-	.cable_detect	= ata_cable_unknown,
-	.set_piomode	= amd66_set_piomode,
-	.set_dmamode	= amd66_set_dmamode,
+	.inherits		= &amd_base_port_ops,
+	.cable_detect		= ata_cable_unknown,
+	.set_piomode		= amd66_set_piomode,
+	.set_dmamode		= amd66_set_dmamode,
 };
 
 static struct ata_port_operations amd100_port_ops = {
-	.inherits	= &amd_base_port_ops,
-	.cable_detect	= ata_cable_unknown,
-	.set_piomode	= amd100_set_piomode,
-	.set_dmamode	= amd100_set_dmamode,
+	.inherits		= &amd_base_port_ops,
+	.cable_detect		= ata_cable_unknown,
+	.set_piomode		= amd100_set_piomode,
+	.set_dmamode		= amd100_set_dmamode,
 };
 
 static struct ata_port_operations amd133_port_ops = {
-	.inherits	= &amd_base_port_ops,
-	.cable_detect	= amd_cable_detect,
-	.set_piomode	= amd133_set_piomode,
-	.set_dmamode	= amd133_set_dmamode,
+	.inherits		= &amd_base_port_ops,
+	.cable_detect		= amd_cable_detect,
+	.set_piomode		= amd133_set_piomode,
+	.set_dmamode		= amd133_set_dmamode,
 };
 
 static const struct ata_port_operations nv_base_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= ata_cable_ignore,
-	.mode_filter	= nv_mode_filter,
-	.prereset	= nv_pre_reset,
-	.host_stop	= nv_host_stop,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= ata_cable_ignore,
+	.mode_filter		= nv_mode_filter,
+	.prereset		= nv_pre_reset,
+	.host_stop		= nv_host_stop,
 };
 
 static struct ata_port_operations nv100_port_ops = {
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index d332cfd..31a28f1 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -313,6 +313,7 @@ static struct scsi_host_template artop_sht = {
 
 static struct ata_port_operations artop6210_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= artop6210_set_piomode,
 	.set_dmamode		= artop6210_set_dmamode,
@@ -322,6 +323,7 @@ static struct ata_port_operations artop6210_ops = {
 
 static struct ata_port_operations artop6260_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= artop6260_cable_detect,
 	.set_piomode		= artop6260_set_piomode,
 	.set_dmamode		= artop6260_set_dmamode,
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index ae4454d..3ded0e8 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -206,15 +206,16 @@ static struct scsi_host_template atiixp_sht = {
 };
 
 static struct ata_port_operations atiixp_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
-	.qc_prep 	= ata_sff_dumb_qc_prep,
-	.bmdma_start 	= atiixp_bmdma_start,
-	.bmdma_stop	= atiixp_bmdma_stop,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.qc_prep 		= ata_sff_dumb_qc_prep,
+	.bmdma_start 		= atiixp_bmdma_start,
+	.bmdma_stop		= atiixp_bmdma_stop,
 
-	.cable_detect	= atiixp_cable_detect,
-	.set_piomode	= atiixp_set_piomode,
-	.set_dmamode	= atiixp_set_dmamode,
+	.cable_detect		= atiixp_cable_detect,
+	.set_piomode		= atiixp_set_piomode,
+	.set_dmamode		= atiixp_set_dmamode,
 };
 
 static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_atp867x.c b/drivers/ata/pata_atp867x.c
index 6fe7ded..4376581 100644
--- a/drivers/ata/pata_atp867x.c
+++ b/drivers/ata/pata_atp867x.c
@@ -276,6 +276,7 @@ static struct scsi_host_template atp867x_sht = {
 
 static struct ata_port_operations atp867x_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= atp867x_cable_detect,
 	.set_piomode		= atp867x_set_piomode,
 	.set_dmamode		= atp867x_set_dmamode,
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 5acf9fa..8a4b990 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -169,13 +169,14 @@ static struct scsi_host_template cmd640_sht = {
 };
 
 static struct ata_port_operations cmd640_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	/* In theory xfer_noirq is not needed once we kill the prefetcher */
-	.sff_data_xfer	= ata_sff_data_xfer_noirq,
-	.qc_issue	= cmd640_qc_issue,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= cmd640_set_piomode,
-	.port_start	= cmd640_port_start,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.sff_data_xfer		= ata_sff_data_xfer_noirq,
+	.qc_issue		= cmd640_qc_issue,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= cmd640_set_piomode,
+	.port_start		= cmd640_port_start,
 };
 
 static void cmd640_hardware_init(struct pci_dev *pdev)
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index b40bf0f..305a473 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -269,26 +269,27 @@ static struct scsi_host_template cmd64x_sht = {
 };
 
 static const struct ata_port_operations cmd64x_base_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.set_piomode	= cmd64x_set_piomode,
-	.set_dmamode	= cmd64x_set_dmamode,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.set_piomode		= cmd64x_set_piomode,
+	.set_dmamode		= cmd64x_set_dmamode,
 };
 
 static struct ata_port_operations cmd64x_port_ops = {
-	.inherits	= &cmd64x_base_ops,
-	.cable_detect	= ata_cable_40wire,
+	.inherits		= &cmd64x_base_ops,
+	.cable_detect		= ata_cable_40wire,
 };
 
 static struct ata_port_operations cmd646r1_port_ops = {
-	.inherits	= &cmd64x_base_ops,
-	.bmdma_stop	= cmd646r1_bmdma_stop,
-	.cable_detect	= ata_cable_40wire,
+	.inherits		= &cmd64x_base_ops,
+	.bmdma_stop		= cmd646r1_bmdma_stop,
+	.cable_detect		= ata_cable_40wire,
 };
 
 static struct ata_port_operations cmd648_port_ops = {
-	.inherits	= &cmd64x_base_ops,
-	.bmdma_stop	= cmd648_bmdma_stop,
-	.cable_detect	= cmd648_cable_detect,
+	.inherits		= &cmd64x_base_ops,
+	.bmdma_stop		= cmd648_bmdma_stop,
+	.cable_detect		= cmd648_cable_detect,
 };
 
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 95ebdac..dab33ce 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -110,6 +110,7 @@ static struct scsi_host_template cs5520_sht = {
 
 static struct ata_port_operations cs5520_port_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.qc_prep		= ata_sff_dumb_qc_prep,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= cs5520_set_piomode,
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index c974b05..a299607 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -165,14 +165,15 @@ static struct scsi_host_template cs5530_sht = {
 };
 
 static struct ata_port_operations cs5530_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
-	.qc_prep 	= ata_sff_dumb_qc_prep,
-	.qc_issue	= cs5530_qc_issue,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.qc_prep 		= ata_sff_dumb_qc_prep,
+	.qc_issue		= cs5530_qc_issue,
 
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= cs5530_set_piomode,
-	.set_dmamode	= cs5530_set_dmamode,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= cs5530_set_piomode,
+	.set_dmamode		= cs5530_set_dmamode,
 };
 
 static const struct dmi_system_id palmax_dmi_table[] = {
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index c50c3a4..fe10ffd 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -161,10 +161,11 @@ static struct scsi_host_template cs5535_sht = {
 };
 
 static struct ata_port_operations cs5535_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= cs5535_cable_detect,
-	.set_piomode	= cs5535_set_piomode,
-	.set_dmamode	= cs5535_set_dmamode,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= cs5535_cable_detect,
+	.set_piomode		= cs5535_set_piomode,
+	.set_dmamode		= cs5535_set_dmamode,
 };
 
 /**
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index ffee397..c90a033 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -225,6 +225,7 @@ static struct scsi_host_template cs5536_sht = {
 
 static struct ata_port_operations cs5536_port_ops = {
 	.inherits		= &ata_bmdma32_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= cs5536_cable_detect,
 	.set_piomode		= cs5536_set_piomode,
 	.set_dmamode		= cs5536_set_dmamode,
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 89076d5..fedc121 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -225,6 +225,7 @@ static struct scsi_host_template efar_sht = {
 
 static struct ata_port_operations efar_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= efar_cable_detect,
 	.set_piomode		= efar_set_piomode,
 	.set_dmamode		= efar_set_dmamode,
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 3ec88f2..6bb4b52 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -270,11 +270,12 @@ static struct scsi_host_template hpt36x_sht = {
  */
 
 static struct ata_port_operations hpt366_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= hpt36x_cable_detect,
-	.mode_filter	= hpt366_filter,
-	.set_piomode	= hpt366_set_piomode,
-	.set_dmamode	= hpt366_set_dmamode,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= hpt36x_cable_detect,
+	.mode_filter		= hpt366_filter,
+	.set_piomode		= hpt366_set_piomode,
+	.set_dmamode		= hpt366_set_dmamode,
 };
 
 /**
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 228dc1a..ba398bd 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -565,15 +565,16 @@ static struct scsi_host_template hpt37x_sht = {
  */
 
 static struct ata_port_operations hpt370_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
-	.bmdma_stop	= hpt370_bmdma_stop,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.bmdma_stop		= hpt370_bmdma_stop,
 
-	.mode_filter	= hpt370_filter,
-	.cable_detect	= hpt37x_cable_detect,
-	.set_piomode	= hpt370_set_piomode,
-	.set_dmamode	= hpt370_set_dmamode,
-	.prereset	= hpt37x_pre_reset,
+	.mode_filter		= hpt370_filter,
+	.cable_detect		= hpt37x_cable_detect,
+	.set_piomode		= hpt370_set_piomode,
+	.set_dmamode		= hpt370_set_dmamode,
+	.prereset		= hpt37x_pre_reset,
 };
 
 /*
@@ -581,8 +582,8 @@ static struct ata_port_operations hpt370_port_ops = {
  */
 
 static struct ata_port_operations hpt370a_port_ops = {
-	.inherits	= &hpt370_port_ops,
-	.mode_filter	= hpt370a_filter,
+	.inherits		= &hpt370_port_ops,
+	.mode_filter		= hpt370a_filter,
 };
 
 /*
@@ -593,12 +594,13 @@ static struct ata_port_operations hpt370a_port_ops = {
 static struct ata_port_operations hpt372_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
-	.bmdma_stop	= hpt37x_bmdma_stop,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.bmdma_stop		= hpt37x_bmdma_stop,
 
-	.cable_detect	= hpt37x_cable_detect,
-	.set_piomode	= hpt372_set_piomode,
-	.set_dmamode	= hpt372_set_dmamode,
-	.prereset	= hpt37x_pre_reset,
+	.cable_detect		= hpt37x_cable_detect,
+	.set_piomode		= hpt372_set_piomode,
+	.set_dmamode		= hpt372_set_dmamode,
+	.prereset		= hpt37x_pre_reset,
 };
 
 /*
@@ -607,9 +609,9 @@ static struct ata_port_operations hpt372_port_ops = {
  */
 
 static struct ata_port_operations hpt374_fn1_port_ops = {
-	.inherits	= &hpt372_port_ops,
-	.cable_detect	= hpt374_fn1_cable_detect,
-	.prereset	= hpt37x_pre_reset,
+	.inherits		= &hpt372_port_ops,
+	.cable_detect		= hpt374_fn1_cable_detect,
+	.prereset		= hpt37x_pre_reset,
 };
 
 /**
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 4a29122..c396a94 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -332,17 +332,18 @@ static struct scsi_host_template hpt3x2n_sht = {
  */
 
 static struct ata_port_operations hpt3x2n_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
-	.bmdma_stop	= hpt3x2n_bmdma_stop,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.bmdma_stop		= hpt3x2n_bmdma_stop,
 
-	.qc_defer	= hpt3x2n_qc_defer,
-	.qc_issue	= hpt3x2n_qc_issue,
+	.qc_defer		= hpt3x2n_qc_defer,
+	.qc_issue		= hpt3x2n_qc_issue,
 
-	.cable_detect	= hpt3x2n_cable_detect,
-	.set_piomode	= hpt3x2n_set_piomode,
-	.set_dmamode	= hpt3x2n_set_dmamode,
-	.prereset	= hpt3x2n_pre_reset,
+	.cable_detect		= hpt3x2n_cable_detect,
+	.set_piomode		= hpt3x2n_set_piomode,
+	.set_dmamode		= hpt3x2n_set_dmamode,
+	.prereset		= hpt3x2n_pre_reset,
 };
 
 /**
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 4bceb88..35df122 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -24,8 +24,9 @@ static struct scsi_host_template isapnp_sht = {
 };
 
 static struct ata_port_operations isapnp_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.cable_detect	= ata_cable_40wire,
+	.inherits		= &ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= ata_cable_40wire,
 };
 
 static struct ata_port_operations isapnp_noalt_port_ops = {
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 8f3325a..378be4f 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -235,6 +235,7 @@ static struct scsi_host_template it8213_sht = {
 
 static struct ata_port_operations it8213_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= it8213_cable_detect,
 	.set_piomode		= it8213_set_piomode,
 	.set_dmamode		= it8213_set_dmamode,
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index edc5c1f..bc5801d 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -815,35 +815,37 @@ static struct ata_port_operations it821x_smart_port_ops = {
 };
 
 static struct ata_port_operations it821x_passthru_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
-	.check_atapi_dma= it821x_check_atapi_dma,
-	.sff_dev_select	= it821x_passthru_dev_select,
-	.bmdma_start 	= it821x_passthru_bmdma_start,
-	.bmdma_stop	= it821x_passthru_bmdma_stop,
-	.qc_issue	= it821x_passthru_qc_issue,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.check_atapi_dma	= it821x_check_atapi_dma,
+	.sff_dev_select		= it821x_passthru_dev_select,
+	.bmdma_start 		= it821x_passthru_bmdma_start,
+	.bmdma_stop		= it821x_passthru_bmdma_stop,
+	.qc_issue		= it821x_passthru_qc_issue,
 
-	.cable_detect	= ata_cable_unknown,
-	.set_piomode	= it821x_passthru_set_piomode,
-	.set_dmamode	= it821x_passthru_set_dmamode,
+	.cable_detect		= ata_cable_unknown,
+	.set_piomode		= it821x_passthru_set_piomode,
+	.set_dmamode		= it821x_passthru_set_dmamode,
 
-	.port_start	= it821x_port_start,
+	.port_start		= it821x_port_start,
 };
 
 static struct ata_port_operations it821x_rdc_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
-	.check_atapi_dma= it821x_check_atapi_dma,
-	.sff_dev_select	= it821x_passthru_dev_select,
-	.bmdma_start 	= it821x_passthru_bmdma_start,
-	.bmdma_stop	= it821x_passthru_bmdma_stop,
-	.qc_issue	= it821x_passthru_qc_issue,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.check_atapi_dma	= it821x_check_atapi_dma,
+	.sff_dev_select		= it821x_passthru_dev_select,
+	.bmdma_start 		= it821x_passthru_bmdma_start,
+	.bmdma_stop		= it821x_passthru_bmdma_stop,
+	.qc_issue		= it821x_passthru_qc_issue,
 
-	.cable_detect	= it821x_rdc_cable,
-	.set_piomode	= it821x_passthru_set_piomode,
-	.set_dmamode	= it821x_passthru_set_dmamode,
+	.cable_detect		= it821x_rdc_cable,
+	.set_piomode		= it821x_passthru_set_piomode,
+	.set_dmamode		= it821x_passthru_set_dmamode,
 
-	.port_start	= it821x_port_start,
+	.port_start		= it821x_port_start,
 };
 
 static void it821x_disable_raid(struct pci_dev *pdev)
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 3a1474a..ba43bd3 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -113,6 +113,7 @@ static struct scsi_host_template jmicron_sht = {
 
 static struct ata_port_operations jmicron_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.prereset		= jmicron_pre_reset,
 };
 
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 9df1ff7..76b31c7 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -218,8 +218,9 @@ static struct scsi_host_template legacy_sht = {
 };
 
 static const struct ata_port_operations legacy_base_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.cable_detect	= ata_cable_40wire,
+	.inherits		= &ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= ata_cable_40wire,
 };
 
 /*
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index b351d81..4031bfd 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -102,6 +102,7 @@ static struct scsi_host_template marvell_sht = {
 
 static struct ata_port_operations marvell_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= marvell_cable_detect,
 	.prereset		= marvell_pre_reset,
 };
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index b21f002..2be0ccd 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -141,12 +141,13 @@ static struct scsi_host_template mpiix_sht = {
 };
 
 static struct ata_port_operations mpiix_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.qc_issue	= mpiix_qc_issue,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= mpiix_set_piomode,
-	.prereset	= mpiix_pre_reset,
-	.sff_data_xfer	= ata_sff_data_xfer32,
+	.inherits		= &ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.qc_issue		= mpiix_qc_issue,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= mpiix_set_piomode,
+	.prereset		= mpiix_pre_reset,
+	.sff_data_xfer		= ata_sff_data_xfer32,
 };
 
 static int mpiix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index f0d52f7..7472fad 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -35,9 +35,10 @@ static struct scsi_host_template netcell_sht = {
 };
 
 static struct ata_port_operations netcell_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= ata_cable_80wire,
-	.read_id	= netcell_read_id,
+	.inherits	= 	&ata_bmdma_port_ops,
+	.sff_exec_command = 	ata_sff_exec_command_nopost,
+	.cable_detect	= 	ata_cable_80wire,
+	.read_id	= 	netcell_read_id,
 };
 
 
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index ca53fac..7d2a866 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -133,11 +133,12 @@ static struct scsi_host_template ns87410_sht = {
 };
 
 static struct ata_port_operations ns87410_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.qc_issue	= ns87410_qc_issue,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= ns87410_set_piomode,
-	.prereset	= ns87410_pre_reset,
+	.inherits		= &ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.qc_issue		= ns87410_qc_issue,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= ns87410_set_piomode,
+	.prereset		= ns87410_pre_reset,
 };
 
 static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 061aa1c..6f7c647 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -302,6 +302,7 @@ static u8 ns87560_bmdma_status(struct ata_port *ap)
 static struct ata_port_operations ns87415_pata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.check_atapi_dma	= ns87415_check_atapi_dma,
 	.bmdma_setup		= ns87415_bmdma_setup,
 	.bmdma_start		= ns87415_bmdma_start,
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 9a8687d..f49c60f 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -210,6 +210,7 @@ static struct scsi_host_template oldpiix_sht = {
 
 static struct ata_port_operations oldpiix_pata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.qc_issue		= oldpiix_qc_issue,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= oldpiix_set_piomode,
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 99eddda..c4f436a 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -153,10 +153,11 @@ static struct scsi_host_template opti_sht = {
 };
 
 static struct ata_port_operations opti_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= opti_set_piomode,
-	.prereset	= opti_pre_reset,
+	.inherits		= &ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= opti_set_piomode,
+	.prereset		= opti_pre_reset,
 };
 
 static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 86885a4..ab36c1b 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -338,18 +338,19 @@ static struct scsi_host_template optidma_sht = {
 };
 
 static struct ata_port_operations optidma_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= optidma_set_pio_mode,
-	.set_dmamode	= optidma_set_dma_mode,
-	.set_mode	= optidma_set_mode,
-	.prereset	= optidma_pre_reset,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= optidma_set_pio_mode,
+	.set_dmamode		= optidma_set_dma_mode,
+	.set_mode		= optidma_set_mode,
+	.prereset		= optidma_pre_reset,
 };
 
 static struct ata_port_operations optiplus_port_ops = {
-	.inherits	= &optidma_port_ops,
-	.set_piomode	= optiplus_set_pio_mode,
-	.set_dmamode	= optiplus_set_dma_mode,
+	.inherits		= &optidma_port_ops,
+	.set_piomode		= optiplus_set_pio_mode,
+	.set_dmamode		= optiplus_set_dma_mode,
 };
 
 /**
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 147de2f..67a2964 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -163,18 +163,19 @@ static struct scsi_host_template pcmcia_sht = {
 };
 
 static struct ata_port_operations pcmcia_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.sff_data_xfer	= ata_sff_data_xfer_noirq,
-	.cable_detect	= ata_cable_40wire,
-	.set_mode	= pcmcia_set_mode,
+	.inherits		= &ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.sff_data_xfer		= ata_sff_data_xfer_noirq,
+	.cable_detect		= ata_cable_40wire,
+	.set_mode		= pcmcia_set_mode,
 };
 
 static struct ata_port_operations pcmcia_8bit_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.sff_data_xfer	= ata_data_xfer_8bit,
-	.cable_detect	= ata_cable_40wire,
-	.set_mode	= pcmcia_set_mode_8bit,
-	.drain_fifo	= pcmcia_8bit_drain_fifo,
+	.inherits		= &ata_sff_port_ops,
+	.sff_data_xfer		= ata_data_xfer_8bit,
+	.cable_detect		= ata_cable_40wire,
+	.set_mode		= pcmcia_set_mode_8bit,
+	.drain_fifo		= pcmcia_8bit_drain_fifo,
 };
 
 
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 2911120..28e42eb 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -277,6 +277,7 @@ static struct scsi_host_template pdc202xx_sht = {
 static struct ata_port_operations pdc2024x_port_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= pdc202xx_set_piomode,
 	.set_dmamode		= pdc202xx_set_dmamode,
diff --git a/drivers/ata/pata_piccolo.c b/drivers/ata/pata_piccolo.c
index bfe0180..38bd4f1 100644
--- a/drivers/ata/pata_piccolo.c
+++ b/drivers/ata/pata_piccolo.c
@@ -68,10 +68,11 @@ static struct scsi_host_template tosh_sht = {
 };
 
 static struct ata_port_operations tosh_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= ata_cable_unknown,
-	.set_piomode	= tosh_set_piomode,
-	.set_dmamode	= tosh_set_dmamode
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= ata_cable_unknown,
+	.set_piomode		= tosh_set_piomode,
+	.set_dmamode		= tosh_set_dmamode
 };
 
 /**
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 45879dc..c9a468c 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -158,16 +158,17 @@ static struct scsi_host_template qdi_sht = {
 };
 
 static struct ata_port_operations qdi6500_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.qc_issue	= qdi_qc_issue,
-	.sff_data_xfer	= qdi_data_xfer,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= qdi6500_set_piomode,
+	.inherits	= 	&ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.qc_issue	= 	qdi_qc_issue,
+	.sff_data_xfer	= 	qdi_data_xfer,
+	.cable_detect	= 	ata_cable_40wire,
+	.set_piomode	= 	qdi6500_set_piomode,
 };
 
 static struct ata_port_operations qdi6580_port_ops = {
-	.inherits	= &qdi6500_port_ops,
-	.set_piomode	= qdi6580_set_piomode,
+	.inherits	= 	&qdi6500_port_ops,
+	.set_piomode	= 	qdi6580_set_piomode,
 };
 
 /**
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 4fd25e7..7390e2d 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -189,6 +189,7 @@ static struct scsi_host_template radisys_sht = {
 
 static struct ata_port_operations radisys_pata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.qc_issue		= radisys_qc_issue,
 	.cable_detect		= ata_cable_unknown,
 	.set_piomode		= radisys_set_piomode,
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 237a24d..7a76bde 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -274,6 +274,7 @@ static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 static struct ata_port_operations rdc_pata_ops = {
 	.inherits		= &ata_bmdma32_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= rdc_pata_cable_detect,
 	.set_piomode		= rdc_set_piomode,
 	.set_dmamode		= rdc_set_dmamode,
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 2932998..ab4e6cc 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -55,9 +55,10 @@ static struct scsi_host_template rz1000_sht = {
 };
 
 static struct ata_port_operations rz1000_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.cable_detect	= ata_cable_40wire,
-	.set_mode	= rz1000_set_mode,
+	.inherits		= &ata_sff_port_ops,
+	.cable_detect		= ata_cable_40wire,
+	.set_mode		= rz1000_set_mode,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 };
 
 static int rz1000_fifo_disable(struct pci_dev *pdev)
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 3bbed83..8739ccc 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -208,13 +208,14 @@ static struct scsi_host_template sc1200_sht = {
 };
 
 static struct ata_port_operations sc1200_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.qc_prep 	= ata_sff_dumb_qc_prep,
-	.qc_issue	= sc1200_qc_issue,
-	.qc_defer	= sc1200_qc_defer,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= sc1200_set_piomode,
-	.set_dmamode	= sc1200_set_dmamode,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.qc_prep 		= ata_sff_dumb_qc_prep,
+	.qc_issue		= sc1200_qc_issue,
+	.qc_defer		= sc1200_qc_defer,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= sc1200_set_piomode,
+	.set_dmamode		= sc1200_set_dmamode,
 };
 
 /**
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index 99cceb4..9a0c0e3 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -77,6 +77,7 @@ static struct scsi_host_template sch_sht = {
 
 static struct ata_port_operations sch_pata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.cable_detect		= ata_cable_unknown,
 	.set_piomode		= sch_set_piomode,
 	.set_dmamode		= sch_set_dmamode,
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index c859767..6714adf 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -301,11 +301,12 @@ static struct scsi_host_template serverworks_sht = {
 };
 
 static struct ata_port_operations serverworks_osb4_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= serverworks_cable_detect,
-	.mode_filter	= serverworks_osb4_filter,
-	.set_piomode	= serverworks_set_piomode,
-	.set_dmamode	= serverworks_set_dmamode,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= serverworks_cable_detect,
+	.mode_filter		= serverworks_osb4_filter,
+	.set_piomode		= serverworks_set_piomode,
+	.set_dmamode		= serverworks_set_dmamode,
 };
 
 static struct ata_port_operations serverworks_csb_port_ops = {
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 5c30d56..3d9a940 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -505,6 +505,7 @@ static struct scsi_host_template sis_sht = {
 
 static struct ata_port_operations sis_133_for_sata_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.set_piomode		= sis_133_set_piomode,
 	.set_dmamode		= sis_133_set_dmamode,
 	.cable_detect		= sis_133_cable_detect,
@@ -512,6 +513,7 @@ static struct ata_port_operations sis_133_for_sata_ops = {
 
 static struct ata_port_operations sis_base_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
 	.prereset		= sis_pre_reset,
 };
 
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index f1f13ff..1a40ded 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -179,12 +179,13 @@ static struct scsi_host_template triflex_sht = {
 };
 
 static struct ata_port_operations triflex_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.bmdma_start 	= triflex_bmdma_start,
-	.bmdma_stop	= triflex_bmdma_stop,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= triflex_set_piomode,
-	.prereset	= triflex_prereset,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.bmdma_start 		= triflex_bmdma_start,
+	.bmdma_stop		= triflex_bmdma_stop,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= triflex_set_piomode,
+	.prereset		= triflex_prereset,
 };
 
 static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index eccfed2..671e0cb 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -439,14 +439,15 @@ static struct scsi_host_template via_sht = {
 };
 
 static struct ata_port_operations via_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= via_cable_detect,
-	.set_piomode	= via_set_piomode,
-	.set_dmamode	= via_set_dmamode,
-	.prereset	= via_pre_reset,
-	.sff_tf_load	= via_tf_load,
-	.port_start	= via_port_start,
-	.mode_filter	= via_mode_filter,
+	.inherits		= &ata_bmdma_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.cable_detect		= via_cable_detect,
+	.set_piomode		= via_set_piomode,
+	.set_dmamode		= via_set_dmamode,
+	.prereset		= via_pre_reset,
+	.sff_tf_load		= via_tf_load,
+	.port_start		= via_port_start,
+	.mode_filter		= via_mode_filter,
 };
 
 static struct ata_port_operations via_port_ops_noirq = {
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 6d8619b..066deea 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -126,10 +126,11 @@ static struct scsi_host_template winbond_sht = {
 };
 
 static struct ata_port_operations winbond_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.sff_data_xfer	= winbond_data_xfer,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= winbond_set_piomode,
+	.inherits	= 	&ata_sff_port_ops,
+	.sff_exec_command	= ata_sff_exec_command_nopost,
+	.sff_data_xfer	= 	winbond_data_xfer,
+	.cable_detect	= 	ata_cable_40wire,
+	.set_piomode	= 	winbond_set_piomode,
 };
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a85adc2..ac70e4d 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1591,6 +1591,8 @@ extern void ata_sff_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 extern void ata_sff_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 extern void ata_sff_exec_command(struct ata_port *ap,
 				 const struct ata_taskfile *tf);
+extern void ata_sff_exec_command_nopost(struct ata_port *ap,
+				 const struct ata_taskfile *tf);
 extern unsigned int ata_sff_data_xfer(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
 extern unsigned int ata_sff_data_xfer32(struct ata_device *dev,

