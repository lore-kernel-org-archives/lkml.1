Return-Path: <linux-kernel-owner+w=401wt.eu-S968812AbXFHIOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968812AbXFHIOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968738AbXFHINa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:13:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:6368 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030450AbXFHINW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:13:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,399,1175497200"; 
   d="scan'208";a="254658736"
Subject: Re: [PATCH]: add parameter "struct bin_attribute *" in
	.read/.write methods for sysfs binary attributes
From: Zhang Rui <rui.zhang@intel.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>, lenb@kernel.org
In-Reply-To: <20070608044809.GB28395@kroah.com>
References: <1181208695.5317.2.camel@localhost.localdomain>
	 <20070608044809.GB28395@kroah.com>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 16:13:05 +0800
Message-Id: <1181376785.5471.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>
> > Well, first of all, I don't want to change so many files either.
> > 
> > What I do:
> > Adding a new parameter "struct bin_attribute *" in the
> > .read/.write methods for the sysfs binary attributes.
> > 
> > In fact, only the four lines change in fs/sysfs/bin.c and
> > include/linux/sysfs.h do the real work.
> > But I have to update all the files that use binary attributes
> > to make them compatible with the new .read and .write methods.
> > I'm not sure if I missed any. :(
> > 
> > Why I do this:
> > For a sysfs attribute, we can get a pointer pointing to the
> > struct attribute in the .show/.store method,
> > while we can't do this for the binary attributes.
> > I don't know why this is different, but this does make it not
> > so handy to use the binary attributes as the regular ones.
> > So I think this patch is reasonable. :)
> > 
> > Who benefits from it:
> > The patch that exposes ACPI tables in sysfs
> > requires such an improvement.
> > All the table binary attributes share the same .read method.
> > Parameter "struct bin_attribute *" is used to get
> > the table signature and instance number which are used to
> > distinguish different ACPI table binary attributes.
> > 
> > Without this parameter, we need to offer different .read methods
> > for different ACPI table binary attributes.
> > This is impossible as there are various ACPI tables on different
> > platforms, and we don't know what they are until they are loaded.
> 
> I have no objection to this patch but it failes the checkpatch.pl script
> pretty badly with too long of lines.  Care to fix it up and resend it?
> 
> thanks,
> 
> greg k-h

This is the refreshed version. Thanks.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 Documentation/firmware_class/firmware_sample_firmware_class.c |    2 
 drivers/base/firmware_class.c                                 |    4 
 drivers/firmware/dcdbas.c                                     |   10 +-
 drivers/firmware/dell_rbu.c                                   |   25 +++--
 drivers/i2c/chips/eeprom.c                                    |    3 
 drivers/i2c/chips/max6875.c                                   |    5 -
 drivers/pci/hotplug/acpiphp_ibm.c                             |    6 -
 drivers/pci/pci-sysfs.c                                       |   18 ++-
 drivers/pcmcia/socket_sysfs.c                                 |    8 +
 drivers/rapidio/rio-sysfs.c                                   |    6 -
 drivers/rtc/rtc-ds1553.c                                      |   10 +-
 drivers/rtc/rtc-ds1742.c                                      |   10 +-
 drivers/s390/cio/chp.c                                        |   10 +-
 drivers/scsi/arcmsr/arcmsr_attr.c                             |   15 +--
 drivers/scsi/ipr.c                                            |   18 ++-
 drivers/scsi/libsas/sas_expander.c                            |   16 ++-
 drivers/scsi/lpfc/lpfc_attr.c                                 |   12 +-
 drivers/scsi/qla2xxx/qla_attr.c                               |   50 ++++++----
 drivers/spi/at25.c                                            |    6 -
 drivers/video/aty/radeon_base.c                               |    8 +
 drivers/w1/slaves/w1_ds2433.c                                 |   10 +-
 drivers/w1/slaves/w1_therm.c                                  |    7 +
 drivers/w1/w1.c                                               |   12 +-
 drivers/zorro/zorro-sysfs.c                                   |    5 -
 fs/sysfs/bin.c                                                |    4 
 include/linux/sysfs.h                                         |    6 -
 net/bridge/br_sysfs_br.c                                      |    5 -
 27 files changed, 185 insertions(+), 106 deletions(-)

Index: linux-2.6.22-rc4/Documentation/firmware_class/firmware_sample_firmware_class.c
===================================================================
--- linux-2.6.22-rc4.orig/Documentation/firmware_class/firmware_sample_firmware_class.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/Documentation/firmware_class/firmware_sample_firmware_class.c	2007-06-08 13:25:33.000000000 +0800
@@ -78,6 +78,7 @@ static CLASS_DEVICE_ATTR(loading, 0644,
 			 firmware_loading_show, firmware_loading_store);
 
 static ssize_t firmware_data_read(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
 				  char *buffer, loff_t offset, size_t count)
 {
 	struct class_device *class_dev = to_class_dev(kobj);
@@ -88,6 +89,7 @@ static ssize_t firmware_data_read(struct
 	return count;
 }
 static ssize_t firmware_data_write(struct kobject *kobj,
+				   struct bin_attribute *bin_attr,
 				   char *buffer, loff_t offset, size_t count)
 {
 	struct class_device *class_dev = to_class_dev(kobj);
Index: linux-2.6.22-rc4/drivers/base/firmware_class.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/base/firmware_class.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/base/firmware_class.c	2004-01-03 06:36:47.000000000 +0800
@@ -175,7 +175,7 @@ static ssize_t firmware_loading_store(st
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
 
 static ssize_t
-firmware_data_read(struct kobject *kobj,
+firmware_data_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 		   char *buffer, loff_t offset, size_t count)
 {
 	struct device *dev = to_dev(kobj);
@@ -240,7 +240,7 @@ fw_realloc_buffer(struct firmware_priv *
  *	the driver as a firmware image.
  **/
 static ssize_t
-firmware_data_write(struct kobject *kobj,
+firmware_data_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 		    char *buffer, loff_t offset, size_t count)
 {
 	struct device *dev = to_dev(kobj);
Index: linux-2.6.22-rc4/drivers/firmware/dcdbas.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/firmware/dcdbas.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/firmware/dcdbas.c	2007-06-08 13:26:23.000000000 +0800
@@ -149,8 +149,9 @@ static ssize_t smi_data_buf_size_store(s
 	return count;
 }
 
-static ssize_t smi_data_read(struct kobject *kobj, char *buf, loff_t pos,
-			     size_t count)
+static ssize_t smi_data_read(struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buf, loff_t pos, size_t count)
 {
 	size_t max_read;
 	ssize_t ret;
@@ -170,8 +171,9 @@ out:
 	return ret;
 }
 
-static ssize_t smi_data_write(struct kobject *kobj, char *buf, loff_t pos,
-			      size_t count)
+static ssize_t smi_data_write(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t pos, size_t count)
 {
 	ssize_t ret;
 
Index: linux-2.6.22-rc4/drivers/firmware/dell_rbu.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/firmware/dell_rbu.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/firmware/dell_rbu.c	2007-06-08 13:27:35.000000000 +0800
@@ -543,8 +543,9 @@ static ssize_t read_rbu_mono_data(char *
 	return ret_count;
 }
 
-static ssize_t read_rbu_data(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t read_rbu_data(struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buffer, loff_t pos, size_t count)
 {
 	ssize_t ret_count = 0;
 
@@ -591,8 +592,9 @@ static void callbackfn_rbu(const struct 
 	spin_unlock(&rbu_data.lock);
 }
 
-static ssize_t read_rbu_image_type(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t read_rbu_image_type(struct kobject *kobj,
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t pos, size_t count)
 {
 	int size = 0;
 	if (!pos)
@@ -600,8 +602,9 @@ static ssize_t read_rbu_image_type(struc
 	return size;
 }
 
-static ssize_t write_rbu_image_type(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t write_rbu_image_type(struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buffer, loff_t pos, size_t count)
 {
 	int rc = count;
 	int req_firm_rc = 0;
@@ -660,8 +663,9 @@ static ssize_t write_rbu_image_type(stru
 	return rc;
 }
 
-static ssize_t read_rbu_packet_size(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t read_rbu_packet_size(struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buffer, loff_t pos, size_t count)
 {
 	int size = 0;
 	if (!pos) {
@@ -672,8 +676,9 @@ static ssize_t read_rbu_packet_size(stru
 	return size;
 }
 
-static ssize_t write_rbu_packet_size(struct kobject *kobj, char *buffer,
-	loff_t pos, size_t count)
+static ssize_t write_rbu_packet_size(struct kobject *kobj,
+				     struct bin_attribute *bin_attr,
+				     char *buffer, loff_t pos, size_t count)
 {
 	unsigned long temp;
 	spin_lock(&rbu_data.lock);
Index: linux-2.6.22-rc4/drivers/i2c/chips/eeprom.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/i2c/chips/eeprom.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/i2c/chips/eeprom.c	2004-01-03 06:36:47.000000000 +0800
@@ -110,7 +110,8 @@ exit:
 	mutex_unlock(&data->update_lock);
 }
 
-static ssize_t eeprom_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t eeprom_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+			   char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(container_of(kobj, struct device, kobj));
 	struct eeprom_data *data = i2c_get_clientdata(client);
Index: linux-2.6.22-rc4/drivers/i2c/chips/max6875.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/i2c/chips/max6875.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/i2c/chips/max6875.c	2007-06-08 13:28:14.000000000 +0800
@@ -125,8 +125,9 @@ exit_up:
 	mutex_unlock(&data->update_lock);
 }
 
-static ssize_t max6875_read(struct kobject *kobj, char *buf, loff_t off,
-			    size_t count)
+static ssize_t max6875_read(struct kobject *kobj,
+			    struct bin_attribute *bin_attr,
+			    char *buf, loff_t off, size_t count)
 {
 	struct i2c_client *client = kobj_to_i2c_client(kobj);
 	struct max6875_data *data = i2c_get_clientdata(client);
Index: linux-2.6.22-rc4/drivers/pci/hotplug/acpiphp_ibm.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/pci/hotplug/acpiphp_ibm.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/pci/hotplug/acpiphp_ibm.c	2007-06-08 13:29:09.000000000 +0800
@@ -106,7 +106,8 @@ static int ibm_get_attention_status(stru
 static void ibm_handle_events(acpi_handle handle, u32 event, void *context);
 static int ibm_get_table_from_acpi(char **bufp);
 static ssize_t ibm_read_apci_table(struct kobject *kobj,
-		char *buffer, loff_t pos, size_t size);
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t pos, size_t size);
 static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
 		u32 lvl, void *context, void **rv);
 static int __init ibm_acpiphp_init(void);
@@ -358,7 +359,8 @@ read_table_done:
  * our solution is to only allow reading the table in all at once
  **/
 static ssize_t ibm_read_apci_table(struct kobject *kobj,
-		char *buffer, loff_t pos, size_t size)
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t pos, size_t size)
 {
 	int bytes_read = -EINVAL;
 	char *table = NULL;
Index: linux-2.6.22-rc4/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/pci/pci-sysfs.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/pci/pci-sysfs.c	2004-01-03 06:36:47.000000000 +0800
@@ -213,7 +213,8 @@ struct device_attribute pci_dev_attrs[] 
 };
 
 static ssize_t
-pci_read_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev = to_pci_dev(container_of(kobj,struct device,kobj));
 	unsigned int size = 64;
@@ -285,7 +286,8 @@ pci_read_config(struct kobject *kobj, ch
 }
 
 static ssize_t
-pci_write_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+		 char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *dev = to_pci_dev(container_of(kobj,struct device,kobj));
 	unsigned int size = count;
@@ -352,7 +354,8 @@ pci_write_config(struct kobject *kobj, c
  * callback routine (pci_legacy_read).
  */
 ssize_t
-pci_read_legacy_io(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_read_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
+		   char *buf, loff_t off, size_t count)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
                                                       struct class_device,
@@ -376,7 +379,8 @@ pci_read_legacy_io(struct kobject *kobj,
  * callback routine (pci_legacy_write).
  */
 ssize_t
-pci_write_legacy_io(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_write_legacy_io(struct kobject *kobj, struct bin_attribute *bin_attr,
+		    char *buf, loff_t off, size_t count)
 {
         struct pci_bus *bus = to_pci_bus(container_of(kobj,
 						      struct class_device,
@@ -529,7 +533,8 @@ static inline void pci_remove_resource_f
  * writing anything except 0 enables it
  */
 static ssize_t
-pci_write_rom(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_write_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
+	      char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj, struct device, kobj));
 
@@ -552,7 +557,8 @@ pci_write_rom(struct kobject *kobj, char
  * device corresponding to @kobj.
  */
 static ssize_t
-pci_read_rom(struct kobject *kobj, char *buf, loff_t off, size_t count)
+pci_read_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
+	     char *buf, loff_t off, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj, struct device, kobj));
 	void __iomem *rom;
Index: linux-2.6.22-rc4/drivers/pcmcia/socket_sysfs.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/pcmcia/socket_sysfs.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/pcmcia/socket_sysfs.c	2007-06-08 14:16:28.000000000 +0800
@@ -283,7 +283,9 @@ static ssize_t pccard_extract_cis(struct
 	return (ret);
 }
 
-static ssize_t pccard_show_cis(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t pccard_show_cis(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	unsigned int size = 0x200;
 
@@ -311,7 +313,9 @@ static ssize_t pccard_show_cis(struct ko
 	return (count);
 }
 
-static ssize_t pccard_store_cis(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t pccard_store_cis(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	struct pcmcia_socket *s = to_socket(container_of(kobj, struct device, kobj));
 	cisdump_t *cis;
Index: linux-2.6.22-rc4/drivers/rapidio/rio-sysfs.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/rapidio/rio-sysfs.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/rapidio/rio-sysfs.c	2004-01-03 06:36:47.000000000 +0800
@@ -67,7 +67,8 @@ struct device_attribute rio_dev_attrs[] 
 };
 
 static ssize_t
-rio_read_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
+rio_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
 {
 	struct rio_dev *dev =
 	    to_rio_dev(container_of(kobj, struct device, kobj));
@@ -137,7 +138,8 @@ rio_read_config(struct kobject *kobj, ch
 }
 
 static ssize_t
-rio_write_config(struct kobject *kobj, char *buf, loff_t off, size_t count)
+rio_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
+		 char *buf, loff_t off, size_t count)
 {
 	struct rio_dev *dev =
 	    to_rio_dev(container_of(kobj, struct device, kobj));
Index: linux-2.6.22-rc4/drivers/rtc/rtc-ds1553.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/rtc/rtc-ds1553.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/rtc/rtc-ds1553.c	2007-06-08 13:55:23.000000000 +0800
@@ -258,8 +258,9 @@ static const struct rtc_class_ops ds1553
 	.ioctl		= ds1553_rtc_ioctl,
 };
 
-static ssize_t ds1553_nvram_read(struct kobject *kobj, char *buf,
-				 loff_t pos, size_t size)
+static ssize_t ds1553_nvram_read(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
@@ -272,8 +273,9 @@ static ssize_t ds1553_nvram_read(struct 
 	return count;
 }
 
-static ssize_t ds1553_nvram_write(struct kobject *kobj, char *buf,
-				  loff_t pos, size_t size)
+static ssize_t ds1553_nvram_write(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
Index: linux-2.6.22-rc4/drivers/rtc/rtc-ds1742.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/rtc/rtc-ds1742.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/rtc/rtc-ds1742.c	2007-06-08 13:55:47.000000000 +0800
@@ -127,8 +127,9 @@ static const struct rtc_class_ops ds1742
 	.set_time	= ds1742_rtc_set_time,
 };
 
-static ssize_t ds1742_nvram_read(struct kobject *kobj, char *buf,
-				 loff_t pos, size_t size)
+static ssize_t ds1742_nvram_read(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
@@ -141,8 +142,9 @@ static ssize_t ds1742_nvram_read(struct 
 	return count;
 }
 
-static ssize_t ds1742_nvram_write(struct kobject *kobj, char *buf,
-				  loff_t pos, size_t size)
+static ssize_t ds1742_nvram_write(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t pos, size_t size)
 {
 	struct platform_device *pdev =
 		to_platform_device(container_of(kobj, struct device, kobj));
Index: linux-2.6.22-rc4/drivers/scsi/arcmsr/arcmsr_attr.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/scsi/arcmsr/arcmsr_attr.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/scsi/arcmsr/arcmsr_attr.c	2007-06-08 13:56:37.000000000 +0800
@@ -59,8 +59,9 @@
 struct class_device_attribute *arcmsr_host_attrs[];
 
 static ssize_t
-arcmsr_sysfs_iop_message_read(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+arcmsr_sysfs_iop_message_read(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -105,8 +106,9 @@ arcmsr_sysfs_iop_message_read(struct kob
 }
 
 static ssize_t
-arcmsr_sysfs_iop_message_write(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+arcmsr_sysfs_iop_message_write(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -152,8 +154,9 @@ arcmsr_sysfs_iop_message_write(struct ko
 }
 
 static ssize_t
-arcmsr_sysfs_iop_message_clear(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+arcmsr_sysfs_iop_message_clear(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
Index: linux-2.6.22-rc4/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/scsi/ipr.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/scsi/ipr.c	2007-06-08 13:57:39.000000000 +0800
@@ -2465,6 +2465,7 @@ restart:
 /**
  * ipr_read_trace - Dump the adapter trace
  * @kobj:		kobject struct
+ * @bin_attr:		bin_attribute struct
  * @buf:		buffer
  * @off:		offset
  * @count:		buffer size
@@ -2472,8 +2473,9 @@ restart:
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_read_trace(struct kobject *kobj, char *buf,
-			      loff_t off, size_t count)
+static ssize_t ipr_read_trace(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *shost = class_to_shost(cdev);
@@ -3166,6 +3168,7 @@ static struct class_device_attribute *ip
 /**
  * ipr_read_dump - Dump the adapter
  * @kobj:		kobject struct
+ * @bin_attr:		bin_attribute struct
  * @buf:		buffer
  * @off:		offset
  * @count:		buffer size
@@ -3173,8 +3176,9 @@ static struct class_device_attribute *ip
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_read_dump(struct kobject *kobj, char *buf,
-			      loff_t off, size_t count)
+static ssize_t ipr_read_dump(struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *shost = class_to_shost(cdev);
@@ -3327,6 +3331,7 @@ static int ipr_free_dump(struct ipr_ioa_
 /**
  * ipr_write_dump - Setup dump state of adapter
  * @kobj:		kobject struct
+ * @bin_attr:		bin_attribute struct
  * @buf:		buffer
  * @off:		offset
  * @count:		buffer size
@@ -3334,8 +3339,9 @@ static int ipr_free_dump(struct ipr_ioa_
  * Return value:
  *	number of bytes printed to buffer
  **/
-static ssize_t ipr_write_dump(struct kobject *kobj, char *buf,
-			      loff_t off, size_t count)
+static ssize_t ipr_write_dump(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *shost = class_to_shost(cdev);
Index: linux-2.6.22-rc4/drivers/scsi/libsas/sas_expander.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/scsi/libsas/sas_expander.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/scsi/libsas/sas_expander.c	2007-06-08 14:01:44.000000000 +0800
@@ -38,8 +38,10 @@ static int sas_disable_routing(struct do
 
 #if 0
 /* FIXME: smp needs to migrate into the sas class */
-static ssize_t smp_portal_read(struct kobject *, char *, loff_t, size_t);
-static ssize_t smp_portal_write(struct kobject *, char *, loff_t, size_t);
+static ssize_t smp_portal_read(struct kobject *, struct bin_attribute *,
+			       char *, loff_t, size_t);
+static ssize_t smp_portal_write(struct kobject *, struct bin_attribute *,
+				char *, loff_t, size_t);
 #endif
 
 /* ---------- SMP task management ---------- */
@@ -1846,8 +1848,9 @@ out:
 #if 0
 /* ---------- SMP portal ---------- */
 
-static ssize_t smp_portal_write(struct kobject *kobj, char *buf, loff_t offs,
-				size_t size)
+static ssize_t smp_portal_write(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t offs, size_t size)
 {
 	struct domain_device *dev = to_dom_device(kobj);
 	struct expander_device *ex = &dev->ex_dev;
@@ -1873,8 +1876,9 @@ static ssize_t smp_portal_write(struct k
 	return size;
 }
 
-static ssize_t smp_portal_read(struct kobject *kobj, char *buf, loff_t offs,
-			       size_t size)
+static ssize_t smp_portal_read(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t offs, size_t size)
 {
 	struct domain_device *dev = to_dom_device(kobj);
 	struct expander_device *ex = &dev->ex_dev;
Index: linux-2.6.22-rc4/drivers/scsi/lpfc/lpfc_attr.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/scsi/lpfc/lpfc_attr.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/scsi/lpfc/lpfc_attr.c	2004-01-03 06:36:47.000000000 +0800
@@ -1133,7 +1133,8 @@ struct class_device_attribute *lpfc_host
 };
 
 static ssize_t
-sysfs_ctlreg_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+		   char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
 	struct Scsi_Host *host = class_to_shost(container_of(kobj,
@@ -1165,7 +1166,8 @@ sysfs_ctlreg_write(struct kobject *kobj,
 }
 
 static ssize_t
-sysfs_ctlreg_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+sysfs_ctlreg_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+		  char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
 	uint32_t * tmp_ptr;
@@ -1222,7 +1224,8 @@ sysfs_mbox_idle (struct lpfc_hba * phba)
 }
 
 static ssize_t
-sysfs_mbox_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+sysfs_mbox_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+		 char *buf, loff_t off, size_t count)
 {
 	struct Scsi_Host * host =
 		class_to_shost(container_of(kobj, struct class_device, kobj));
@@ -1274,7 +1277,8 @@ sysfs_mbox_write(struct kobject *kobj, c
 }
 
 static ssize_t
-sysfs_mbox_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+sysfs_mbox_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
 {
 	struct Scsi_Host *host =
 		class_to_shost(container_of(kobj, struct class_device,
Index: linux-2.6.22-rc4/drivers/scsi/qla2xxx/qla_attr.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/scsi/qla2xxx/qla_attr.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/scsi/qla2xxx/qla_attr.c	2007-06-08 14:09:53.000000000 +0800
@@ -11,8 +11,9 @@
 /* SYSFS attributes --------------------------------------------------------- */
 
 static ssize_t
-qla2x00_sysfs_read_fw_dump(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_fw_dump(struct kobject *kobj,
+			   struct bin_attribute *bin_attr,
+			   char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -31,8 +32,9 @@ qla2x00_sysfs_read_fw_dump(struct kobjec
 }
 
 static ssize_t
-qla2x00_sysfs_write_fw_dump(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
+			    struct bin_attribute *bin_attr,
+			    char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -81,8 +83,9 @@ static struct bin_attribute sysfs_fw_dum
 };
 
 static ssize_t
-qla2x00_sysfs_read_nvram(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_nvram(struct kobject *kobj,
+			 struct bin_attribute *bin_attr,
+			 char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -101,8 +104,9 @@ qla2x00_sysfs_read_nvram(struct kobject 
 }
 
 static ssize_t
-qla2x00_sysfs_write_nvram(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_nvram(struct kobject *kobj,
+			  struct bin_attribute *bin_attr,
+			  char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -157,8 +161,9 @@ static struct bin_attribute sysfs_nvram_
 };
 
 static ssize_t
-qla2x00_sysfs_read_optrom(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_optrom(struct kobject *kobj,
+			  struct bin_attribute *bin_attr,
+			  char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -176,8 +181,9 @@ qla2x00_sysfs_read_optrom(struct kobject
 }
 
 static ssize_t
-qla2x00_sysfs_write_optrom(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_optrom(struct kobject *kobj,
+			   struct bin_attribute *bin_attr,
+			   char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -206,8 +212,9 @@ static struct bin_attribute sysfs_optrom
 };
 
 static ssize_t
-qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -286,8 +293,9 @@ static struct bin_attribute sysfs_optrom
 };
 
 static ssize_t
-qla2x00_sysfs_read_vpd(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_vpd(struct kobject *kobj,
+		       struct bin_attribute *bin_attr,
+		       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -305,8 +313,9 @@ qla2x00_sysfs_read_vpd(struct kobject *k
 }
 
 static ssize_t
-qla2x00_sysfs_write_vpd(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_write_vpd(struct kobject *kobj,
+			struct bin_attribute *bin_attr,
+			char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -335,8 +344,9 @@ static struct bin_attribute sysfs_vpd_at
 };
 
 static ssize_t
-qla2x00_sysfs_read_sfp(struct kobject *kobj, char *buf, loff_t off,
-    size_t count)
+qla2x00_sysfs_read_sfp(struct kobject *kobj,
+		       struct bin_attribute *bin_attr,
+		       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
Index: linux-2.6.22-rc4/drivers/spi/at25.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/spi/at25.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/spi/at25.c	2004-01-03 06:36:47.000000000 +0800
@@ -111,7 +111,8 @@ at25_ee_read(
 }
 
 static ssize_t
-at25_bin_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+at25_bin_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+	      char *buf, loff_t off, size_t count)
 {
 	struct device		*dev;
 	struct at25_data	*at25;
@@ -236,7 +237,8 @@ at25_ee_write(struct at25_data *at25, ch
 }
 
 static ssize_t
-at25_bin_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+at25_bin_write(struct kobject *kobj, struct bin_attribute *bin_attr,
+	       char *buf, loff_t off, size_t count)
 {
 	struct device		*dev;
 	struct at25_data	*at25;
Index: linux-2.6.22-rc4/drivers/video/aty/radeon_base.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/video/aty/radeon_base.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/video/aty/radeon_base.c	2007-06-08 14:10:47.000000000 +0800
@@ -2102,7 +2102,9 @@ static ssize_t radeon_show_one_edid(char
 }
 
 
-static ssize_t radeon_show_edid1(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t radeon_show_edid1(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -2113,7 +2115,9 @@ static ssize_t radeon_show_edid1(struct 
 }
 
 
-static ssize_t radeon_show_edid2(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t radeon_show_edid2(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct pci_dev *pdev = to_pci_dev(dev);
Index: linux-2.6.22-rc4/drivers/w1/slaves/w1_ds2433.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/w1/slaves/w1_ds2433.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/w1/slaves/w1_ds2433.c	2007-06-08 14:11:37.000000000 +0800
@@ -91,8 +91,9 @@ static int w1_f23_refresh_block(struct w
 }
 #endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
-static ssize_t w1_f23_read_bin(struct kobject *kobj, char *buf, loff_t off,
-			       size_t count)
+static ssize_t w1_f23_read_bin(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 #ifdef CONFIG_W1_SLAVE_DS2433_CRC
@@ -199,8 +200,9 @@ static int w1_f23_write(struct w1_slave 
 	return 0;
 }
 
-static ssize_t w1_f23_write_bin(struct kobject *kobj, char *buf, loff_t off,
-				size_t count)
+static ssize_t w1_f23_write_bin(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	int addr, len, idx;
Index: linux-2.6.22-rc4/drivers/w1/slaves/w1_therm.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/w1/slaves/w1_therm.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/w1/slaves/w1_therm.c	2007-06-08 14:12:15.000000000 +0800
@@ -42,7 +42,8 @@ static u8 bad_roms[][9] = {
 				{}
 			};
 
-static ssize_t w1_therm_read_bin(struct kobject *, char *, loff_t, size_t);
+static ssize_t w1_therm_read_bin(struct kobject *, struct bin_attribute *,
+				 char *, loff_t, size_t);
 
 static struct bin_attribute w1_therm_bin_attr = {
 	.attr = {
@@ -159,7 +160,9 @@ static int w1_therm_check_rom(u8 rom[9])
 	return 0;
 }
 
-static ssize_t w1_therm_read_bin(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t w1_therm_read_bin(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	struct w1_master *dev = sl->master;
Index: linux-2.6.22-rc4/drivers/w1/w1.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/w1/w1.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/w1/w1.c	2007-06-08 14:12:55.000000000 +0800
@@ -105,7 +105,9 @@ static ssize_t w1_slave_read_name(struct
 	return sprintf(buf, "%s\n", sl->name);
 }
 
-static ssize_t w1_slave_read_id(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t w1_slave_read_id(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
@@ -136,7 +138,9 @@ static struct bin_attribute w1_slave_att
 
 /* Default family */
 
-static ssize_t w1_default_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t w1_default_write(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
@@ -153,7 +157,9 @@ out_up:
 	return count;
 }
 
-static ssize_t w1_default_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t w1_default_read(struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
Index: linux-2.6.22-rc4/drivers/zorro/zorro-sysfs.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/zorro/zorro-sysfs.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/zorro/zorro-sysfs.c	2007-06-08 14:13:30.000000000 +0800
@@ -49,8 +49,9 @@ static ssize_t zorro_show_resource(struc
 
 static DEVICE_ATTR(resource, S_IRUGO, zorro_show_resource, NULL);
 
-static ssize_t zorro_read_config(struct kobject *kobj, char *buf, loff_t off,
-				 size_t count)
+static ssize_t zorro_read_config(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t off, size_t count)
 {
 	struct zorro_dev *z = to_zorro_dev(container_of(kobj, struct device,
 					   kobj));
Index: linux-2.6.22-rc4/fs/sysfs/bin.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/sysfs/bin.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/fs/sysfs/bin.c	2004-01-03 06:36:47.000000000 +0800
@@ -29,7 +29,7 @@ fill_read(struct dentry *dentry, char *b
 	if (!attr->read)
 		return -EIO;
 
-	return attr->read(kobj, buffer, off, count);
+	return attr->read(kobj, attr, buffer, off, count);
 }
 
 static ssize_t
@@ -75,7 +75,7 @@ flush_write(struct dentry *dentry, char 
 	if (!attr->write)
 		return -EIO;
 
-	return attr->write(kobj, buffer, offset, count);
+	return attr->write(kobj, attr, buffer, offset, count);
 }
 
 static ssize_t write(struct file * file, const char __user * userbuf,
Index: linux-2.6.22-rc4/include/linux/sysfs.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/sysfs.h	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/include/linux/sysfs.h	2007-06-08 14:14:11.000000000 +0800
@@ -59,8 +59,10 @@ struct bin_attribute {
 	struct attribute	attr;
 	size_t			size;
 	void			*private;
-	ssize_t (*read)(struct kobject *, char *, loff_t, size_t);
-	ssize_t (*write)(struct kobject *, char *, loff_t, size_t);
+	ssize_t (*read)(struct kobject *, struct bin_attribute *,
+			char *, loff_t, size_t);
+	ssize_t (*write)(struct kobject *, struct bin_attribute *,
+			 char *, loff_t, size_t);
 	int (*mmap)(struct kobject *, struct bin_attribute *attr,
 		    struct vm_area_struct *vma);
 };
Index: linux-2.6.22-rc4/net/bridge/br_sysfs_br.c
===================================================================
--- linux-2.6.22-rc4.orig/net/bridge/br_sysfs_br.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/net/bridge/br_sysfs_br.c	2007-06-08 14:14:54.000000000 +0800
@@ -360,8 +360,9 @@ static struct attribute_group bridge_gro
  *
  * Returns the number of bytes read.
  */
-static ssize_t brforward_read(struct kobject *kobj, char *buf,
-			   loff_t off, size_t count)
+static ssize_t brforward_read(struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buf, loff_t off, size_t count)
 {
 	struct device *dev = to_dev(kobj);
 	struct net_bridge *br = to_bridge(dev);
Index: linux-2.6.22-rc4/drivers/s390/cio/chp.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/s390/cio/chp.c	2004-01-03 06:33:28.000000000 +0800
+++ linux-2.6.22-rc4/drivers/s390/cio/chp.c	2004-01-03 06:36:47.000000000 +0800
@@ -141,8 +141,9 @@ static int s390_vary_chpid(struct chp_id
 /*
  * Channel measurement related functions
  */
-static ssize_t chp_measurement_chars_read(struct kobject *kobj, char *buf,
-					  loff_t off, size_t count)
+static ssize_t chp_measurement_chars_read(struct kobject *kobj,
+					  struct bin_attribute *bin_attr,
+					  char *buf, loff_t off, size_t count)
 {
 	struct channel_path *chp;
 	unsigned int size;
@@ -193,8 +194,9 @@ static void chp_measurement_copy_block(s
 	} while (reference_buf.values[0] != buf->values[0]);
 }
 
-static ssize_t chp_measurement_read(struct kobject *kobj, char *buf,
-				    loff_t off, size_t count)
+static ssize_t chp_measurement_read(struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buf, loff_t off, size_t count)
 {
 	struct channel_path *chp;
 	struct channel_subsystem *css;
