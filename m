Return-Path: <linux-kernel-owner+w=401wt.eu-S1751601AbXCEDiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbXCEDiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 22:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXCEDiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 22:38:24 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:31755 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbXCEDiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 22:38:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=KTiTJD7BnAuwkR/bOr06CmqEYoeI09ecB9mVLAW7RYHX5oNQKLSMwVqEmCp8QmWCcBHj4+CJrEV15PMtwzDfa7LrOxcSQhsPS/+zhNg9rs2A86BMpkESUrj2ONNuopB+oKlFK1xAEkeMTCEyCfoH3Dg5tiBkDe897sTiQlrSUlY=
Date: Mon, 5 Mar 2007 12:38:19 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, pavel@ucw.cz,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] implement __attribute_discard_text/data__ and use it to leave out PM functions if !CONFIG_PM
Message-ID: <20070305033819.GA32687@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patch is the result from the following discussion.

  http://thread.gmane.org/gmane.linux.ide/16475

The problem is that CONFIG_PM affects a lot of low level drivers and
scattering CONFIG_PM all over the place is too ugly.  This patch...

* implements __attribute_discard_text__ and __attribute_discard_data__
  (not implemented for modules yet, only for built-ins)
* uses them to implement __pm and __pmdata markers
* convert libata midlayer and ahci to use it instead of CONFIG_PM

__attribute_discard_text/data__ puts the marked symbols in separate
sections which are located from VMA 0 and discarded when generating
the final image.  It's similar to putting those into /DISCARD/ section
but won't complain even if the discarded symbols are referenced by
active sections.  As the discard sections are located from VMA 0,
actually dereferencing such symbols will result in OOPS.

This trick certainly makes LLDs cleaner but there are also some
downsides, so here are the cons.

* Cannot depend on the compiler to detect illegal dereferences to
  discarded symbols.  We probably can do this using sparse.

* Cannot use the compiler to detect unused but unmarked symbols.  This
  also probably can be done with sparse.

* EXPORT_SYMBOL() is nullified, so it will take extra bytes for
  each symbol marked with __pm.  (insignificant)

* Implementation involves modifying kernel image, module build process
  and possibly sparse.  It might be too expensive to achieve device
  driver prettiness, but there are a lot of device drivers out there
  and a lot of CONFIG_PM's to be added.  Also, discard attributes can
  be used for other purposes too.

Any better ideas?  Comments?

DO NOT APPLY.

diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index bd28f9f..2806dfe 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -25,7 +25,7 @@ CC              := $(CC) -m32
 endif
 
 LDFLAGS		:= -m elf_i386
-OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
+OBJCOPYFLAGS	:= -O binary -R .note -R .comment -R .discard -S
 ifdef CONFIG_RELOCATABLE
 LDFLAGS_vmlinux := --emit-relocs
 endif
diff --git a/arch/i386/kernel/vmlinux.lds.S b/arch/i386/kernel/vmlinux.lds.S
index ca51610..69b18c6 100644
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -32,6 +32,7 @@ PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
 	data PT_LOAD FLAGS(7);	/* RWE */
 	note PT_NOTE FLAGS(4);	/* R__ */
+	QUIET_DISCARD_PHDR
 }
 SECTIONS
 {
@@ -217,6 +218,8 @@ SECTIONS
   }
 
   /* Sections to be discarded */
+  QUIET_DISCARD
+
   /DISCARD/ : {
 	*(.exitcall.exit)
 	}
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 43cc43d..bfb0135 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -219,12 +219,10 @@ static void ahci_thaw(struct ata_port *ap);
 static void ahci_error_handler(struct ata_port *ap);
 static void ahci_vt8251_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
-#ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int ahci_port_resume(struct ata_port *ap);
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
-#endif
 
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
@@ -243,10 +241,8 @@ static struct scsi_host_template ahci_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -275,10 +271,8 @@ static const struct ata_port_operations ahci_ops = {
 	.error_handler		= ahci_error_handler,
 	.post_internal_cmd	= ahci_post_internal_cmd,
 
-#ifdef CONFIG_PM
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
-#endif
 
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
@@ -310,10 +304,8 @@ static const struct ata_port_operations ahci_vt8251_ops = {
 	.error_handler		= ahci_vt8251_error_handler,
 	.post_internal_cmd	= ahci_post_internal_cmd,
 
-#ifdef CONFIG_PM
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
-#endif
 
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
@@ -444,10 +436,8 @@ static struct pci_driver ahci_pci_driver = {
 	.id_table		= ahci_pci_tbl,
 	.probe			= ahci_init_one,
 	.remove			= ata_pci_remove_one,
-#ifdef CONFIG_PM
 	.suspend		= ahci_pci_device_suspend,
 	.resume			= ahci_pci_device_resume,
-#endif
 };
 
 
@@ -587,8 +577,7 @@ static void ahci_power_up(void __iomem *port_mmio, u32 cap)
 	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
 }
 
-#ifdef CONFIG_PM
-static void ahci_power_down(void __iomem *port_mmio, u32 cap)
+static void __pm ahci_power_down(void __iomem *port_mmio, u32 cap)
 {
 	u32 cmd, scontrol;
 
@@ -605,7 +594,6 @@ static void ahci_power_down(void __iomem *port_mmio, u32 cap)
 	cmd &= ~PORT_CMD_SPIN_UP;
 	writel(cmd, port_mmio + PORT_CMD);
 }
-#endif
 
 static void ahci_init_port(void __iomem *port_mmio, u32 cap,
 			   dma_addr_t cmd_slot_dma, dma_addr_t rx_fis_dma)
@@ -1347,8 +1335,7 @@ static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 	}
 }
 
-#ifdef CONFIG_PM
-static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
+static int __pm ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1369,7 +1356,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 	return rc;
 }
 
-static int ahci_port_resume(struct ata_port *ap)
+static int __pm ahci_port_resume(struct ata_port *ap)
 {
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -1382,7 +1369,7 @@ static int ahci_port_resume(struct ata_port *ap)
 	return 0;
 }
 
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+static int __pm ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
@@ -1402,7 +1389,7 @@ static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 	return ata_pci_device_suspend(pdev, mesg);
 }
 
-static int ahci_pci_device_resume(struct pci_dev *pdev)
+static int __pm ahci_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct ahci_host_priv *hpriv = host->private_data;
@@ -1426,7 +1413,6 @@ static int ahci_pci_device_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
 static int ahci_port_start(struct ata_port *ap)
 {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cd0ce65..f8df6d8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5338,10 +5338,9 @@ int ata_flush_cache(struct ata_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
-			       unsigned int action, unsigned int ehi_flags,
-			       int wait)
+static int __pm ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
+				    unsigned int action, unsigned int ehi_flags,
+				    int wait)
 {
 	unsigned long flags;
 	int i, rc;
@@ -5401,7 +5400,7 @@ static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
  *	RETURNS:
  *	0 on success, -errno on failure.
  */
-int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
+int __pm ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
 	int i, j, rc;
 
@@ -5448,13 +5447,12 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
-void ata_host_resume(struct ata_host *host)
+void __pm ata_host_resume(struct ata_host *host)
 {
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
 }
-#endif
 
 /**
  *	ata_port_start - Set port up for dma.
@@ -6090,8 +6088,7 @@ int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits)
 	return (tmp == bits->val) ? 1 : 0;
 }
 
-#ifdef CONFIG_PM
-void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg)
+void __pm ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -6100,7 +6097,7 @@ void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg)
 		pci_set_power_state(pdev, PCI_D3hot);
 }
 
-int ata_pci_device_do_resume(struct pci_dev *pdev)
+int __pm ata_pci_device_do_resume(struct pci_dev *pdev)
 {
 	int rc;
 
@@ -6118,7 +6115,7 @@ int ata_pci_device_do_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-int ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+int __pm ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	int rc = 0;
@@ -6132,7 +6129,7 @@ int ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 	return 0;
 }
 
-int ata_pci_device_resume(struct pci_dev *pdev)
+int __pm ata_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	int rc;
@@ -6142,7 +6139,6 @@ int ata_pci_device_resume(struct pci_dev *pdev)
 		ata_host_resume(host);
 	return rc;
 }
-#endif /* CONFIG_PM */
 
 #endif /* CONFIG_PCI */
 
@@ -6353,10 +6349,8 @@ EXPORT_SYMBOL_GPL(sata_scr_write);
 EXPORT_SYMBOL_GPL(sata_scr_write_flush);
 EXPORT_SYMBOL_GPL(ata_port_online);
 EXPORT_SYMBOL_GPL(ata_port_offline);
-#ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_host_suspend);
 EXPORT_SYMBOL_GPL(ata_host_resume);
-#endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
 EXPORT_SYMBOL_GPL(ata_id_to_dma_mode);
@@ -6372,20 +6366,16 @@ EXPORT_SYMBOL_GPL(pci_test_config_bits);
 EXPORT_SYMBOL_GPL(ata_pci_init_native_mode);
 EXPORT_SYMBOL_GPL(ata_pci_init_one);
 EXPORT_SYMBOL_GPL(ata_pci_remove_one);
-#ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_pci_device_do_suspend);
 EXPORT_SYMBOL_GPL(ata_pci_device_do_resume);
 EXPORT_SYMBOL_GPL(ata_pci_device_suspend);
 EXPORT_SYMBOL_GPL(ata_pci_device_resume);
-#endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_pci_default_filter);
 EXPORT_SYMBOL_GPL(ata_pci_clear_simplex);
 #endif /* CONFIG_PCI */
 
-#ifdef CONFIG_PM
 EXPORT_SYMBOL_GPL(ata_scsi_device_suspend);
 EXPORT_SYMBOL_GPL(ata_scsi_device_resume);
-#endif /* CONFIG_PM */
 
 EXPORT_SYMBOL_GPL(ata_eng_timeout);
 EXPORT_SYMBOL_GPL(ata_port_schedule_eh);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 684528e..9cf7afa 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -510,7 +510,6 @@ static void ata_dump_status(unsigned id, struct ata_taskfile *tf)
 	}
 }
 
-#ifdef CONFIG_PM
 /**
  *	ata_scsi_device_suspend - suspend ATA device associated with sdev
  *	@sdev: the SCSI device to suspend
@@ -525,7 +524,7 @@ static void ata_dump_status(unsigned id, struct ata_taskfile *tf)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ata_scsi_device_suspend(struct scsi_device *sdev, pm_message_t mesg)
+int __pm ata_scsi_device_suspend(struct scsi_device *sdev, pm_message_t mesg)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
@@ -595,7 +594,7 @@ int ata_scsi_device_suspend(struct scsi_device *sdev, pm_message_t mesg)
  *	RETURNS:
  *	0.
  */
-int ata_scsi_device_resume(struct scsi_device *sdev)
+int __pm ata_scsi_device_resume(struct scsi_device *sdev)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
@@ -635,7 +634,6 @@ int ata_scsi_device_resume(struct scsi_device *sdev)
 	sdev->sdev_gendev.power.power_state = PMSG_ON;
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 /**
  *	ata_to_sense_error - convert ATA error to SCSI error
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9fcc8d9..a50954b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -9,6 +9,19 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
+/* Sections to be discarded silently even if referred by other live
+ * sections.  Final objcopy is responsible for dropping them. */
+#define QUIET_DISCARD_PHDR quiet_discard PT_LOAD FLAGS(0);
+
+#define QUIET_DISCARD							\
+	. = .;								\
+	__discard_tmp = .;						\
+	.discard 0        : AT(0) {					\
+		*(.discard.text)					\
+		*(.discard.data)					\
+	} :quiet_discard						\
+	. = __discard_tmp;
+
 #define RODATA								\
 	. = ALIGN(4096);						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index aca6698..bb0b989 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -161,4 +161,22 @@ extern void __chk_io_ptr(void __iomem *);
 # define __attribute_const__	/* unimplemented */
 #endif
 
+/*
+ * Don't include marked text or data in the final image.  It might or
+ * might not be included in various building stages.  The only
+ * requirements are 1. they are not included in the final kernel or
+ * module image 2. references to the marked symbols are guaranteed to
+ * fail.
+ *
+ * The current implementation puts them into separate sections located
+ * from address 0 and discard the sections in the final objcopy stage.
+ */
+#ifndef __attribute_discard_text__
+# define __attribute_discard_text__ __attribute__((__section__(".discard.text")))
+#endif
+
+#ifndef __attribute_discard_data__
+# define __attribute_discard_data__ __attribute__((__section__(".discard.data")))
+#endif
+
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 065f494..037b0b9 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -719,12 +719,10 @@ extern void ata_std_ports(struct ata_ioports *ioaddr);
 extern int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 			     unsigned int n_ports);
 extern void ata_pci_remove_one (struct pci_dev *pdev);
-#ifdef CONFIG_PM
 extern void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg);
 extern int __must_check ata_pci_device_do_resume(struct pci_dev *pdev);
 extern int ata_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 extern int ata_pci_device_resume(struct pci_dev *pdev);
-#endif
 extern int ata_pci_clear_simplex(struct pci_dev *pdev);
 #endif /* CONFIG_PCI */
 extern int ata_device_add(const struct ata_probe_ent *ent);
@@ -750,12 +748,10 @@ extern int sata_scr_write(struct ata_port *ap, int reg, u32 val);
 extern int sata_scr_write_flush(struct ata_port *ap, int reg, u32 val);
 extern int ata_port_online(struct ata_port *ap);
 extern int ata_port_offline(struct ata_port *ap);
-#ifdef CONFIG_PM
 extern int ata_scsi_device_resume(struct scsi_device *);
 extern int ata_scsi_device_suspend(struct scsi_device *, pm_message_t mesg);
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
-#endif
 extern int ata_ratelimit(void);
 extern int ata_busy_sleep(struct ata_port *ap,
 			  unsigned long timeout_pat, unsigned long timeout);
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 21db05a..eabeced 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -70,6 +70,37 @@ enum
 #define PM_PCI_ID(dev) ((dev)->bus->number << 16 | (dev)->devfn)
 
 /*
+ * Macros to mark that a function or initialized data is used for PM.
+ * This is an alternative mechanism to CONFIG_PM ifdef's.  Becuase
+ * CONFIG_PM affects large number of low level device drivers
+ * directly, conventional ifdef method tends to result in a lot of
+ * clutter eventually lowering the quality of the code.
+ *
+ * For function, __pm should be put immediately before the name.
+ *
+ *  static int __pm my_suspend(struct device *dev)
+ *  {
+ *	suspend @dev;
+ *	return 0;
+ *  }
+ *
+ * For data, it should be immediately after the variable name.
+ *
+ *  static int pm_variable __pm = 0;
+ *  static char pm_string[] __pm = "my pm";
+ *  static int pm_uninitialized __pm;
+ *
+ * Note that the data must be initialized one and cannot be "const".
+ */
+#ifdef CONFIG_PM
+#define __pm
+#define __pmdata
+#else /* !CONFIG_PM */
+#define __pm		__attribute_discard_text__
+#define __pmdata	__attribute_discard_data__
+#endif
+
+/*
  * Request handler callback
  */
 struct pm_dev;
