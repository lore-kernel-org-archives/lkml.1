Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbXJYFVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbXJYFVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXJYFVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:21:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48735 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXJYFVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:21:07 -0400
Message-ID: <472027BC.7010400@garzik.org>
Date: Thu, 25 Oct 2007 01:21:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       akpm@linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] Enable link power management for ata drivers
References: <20070924215140.966161778@intel.com> <20070924151320.67f0c332.kristen.c.accardi@intel.com>
In-Reply-To: <20070924151320.67f0c332.kristen.c.accardi@intel.com>
Content-Type: multipart/mixed;
 boundary="------------080605020406030103070205"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080605020406030103070205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

applied as the attached two patches to jgarzik/libata-dev.git#alpm

open issues:

1) need to check ata_dev_set_feature() return value in 
ata_dev_set_dipm() and do something useful with it

2) as the name implies, this probably better belongs in ata_link.

3) however, the feature is tightly coupled to the host controller.  in 
theory PMP -might- do this, but I think its unlikely.  as such I was OK 
with the present arrangement.

4) there has been some discussion of software-initiated device/link 
power management, but I think this should go in, in parallel with those 
discussions.  ALPM
	* is quite self-contained
	* gives a noticable power savings

I'm definitely interested in seeing somebody pursue software-initiated 
link PM as well...

	Jeff




--------------080605020406030103070205
Content-Type: text/plain;
 name="patch.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.1"

commit 218f3d30e60f32394738372c594d063f8e43ee6d
Author: Jeff Garzik <jeff@garzik.org>
Date:   Thu Oct 25 00:33:27 2007 -0400

    [libata] Create internal helper ata_dev_set_feature()
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/libata-core.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

218f3d30e60f32394738372c594d063f8e43ee6d
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2d147b5..294eee3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -68,7 +68,8 @@ const unsigned long sata_deb_timing_long[]		= { 100, 2000, 5000 };
 static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
-static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable);
+static unsigned int ata_dev_set_feature(struct ata_device *dev,
+					u8 enable, u8 feature);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
@@ -1799,13 +1800,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 		 * SET_FEATURES spin-up subcommand before it will accept
 		 * anything other than the original IDENTIFY command.
 		 */
-		ata_tf_init(dev, &tf);
-		tf.command = ATA_CMD_SET_FEATURES;
-		tf.feature = SETFEATURES_SPINUP;
-		tf.protocol = ATA_PROT_NODATA;
-		tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
-		err_mask = ata_exec_internal(dev, &tf, NULL,
-					     DMA_NONE, NULL, 0, 0);
+		err_mask = ata_dev_set_feature(dev, SETFEATURES_SPINUP, 0);
 		if (err_mask && id[2] != 0x738c) {
 			rc = -EIO;
 			reason = "SPINUP failed";
@@ -2075,7 +2070,8 @@ int ata_dev_configure(struct ata_device *dev)
 			unsigned int err_mask;
 
 			/* issue SET feature command to turn this on */
-			err_mask = ata_dev_set_AN(dev, SETFEATURES_SATA_ENABLE);
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_ENABLE, SATA_AN);
 			if (err_mask)
 				ata_dev_printk(dev, KERN_ERR,
 					"failed to enable ATAPI AN "
@@ -4181,15 +4177,14 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
 }
-
 /**
- *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
+ *	ata_dev_set_feature - Issue SET FEATURES - SATA FEATURES
  *	@dev: Device to which command will be sent
  *	@enable: Whether to enable or disable the feature
+ *	@feature: The sector count represents the feature to set
  *
  *	Issue SET FEATURES - SATA FEATURES command to device @dev
- *	on port @ap with sector count set to indicate Asynchronous
- *	Notification feature
+ *	on port @ap with sector count
  *
  *	LOCKING:
  *	PCI/etc. bus probe sem.
@@ -4197,7 +4192,8 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
  *	RETURNS:
  *	0 on success, AC_ERR_* mask otherwise.
  */
-static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
+static unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable,
+					u8 feature)
 {
 	struct ata_taskfile tf;
 	unsigned int err_mask;
@@ -4210,7 +4206,7 @@ static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
 	tf.feature = enable;
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.protocol = ATA_PROT_NODATA;
-	tf.nsect = SATA_AN;
+	tf.nsect = feature;
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 

--------------080605020406030103070205
Content-Type: text/plain;
 name="patch.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.2"

commit 01fdf95f877e2a3f767248a5896e08a9e8787971
Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Date:   Thu Oct 25 00:58:59 2007 -0400

    [libata] Link power management infrastructure
    
    Device Initiated Power Management, which is defined
    in SATA 2.5 can be enabled for disks which support it.
    This patch enables DIPM when the user sets the link
    power management policy to "min_power".
    
    Additionally, libata drivers can define a function
    (enable_pm) that will perform hardware specific actions to
    enable whatever power management policy the user set up
    for Host Initiated Power management (HIPM).
    This power management policy will be activated after all
    disks have been enumerated and intialized.  Drivers should
    also define disable_pm, which will turn off link power
    management, but not change link power management policy.
    
    Documentation/scsi/link_power_management_policy.txt has additional
    information.
    
    Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 Documentation/scsi/link_power_management_policy.txt |   19 +
 drivers/ata/libata-core.c                           |  196 +++++++++++++++++++-
 drivers/ata/libata-eh.c                             |    4 
 drivers/ata/libata-scsi.c                           |   68 ++++++
 drivers/ata/libata.h                                |    2 
 include/linux/ata.h                                 |   21 ++
 include/linux/libata.h                              |   21 ++
 7 files changed, 329 insertions(+), 2 deletions(-)

01fdf95f877e2a3f767248a5896e08a9e8787971
diff --git a/Documentation/scsi/link_power_management_policy.txt b/Documentation/scsi/link_power_management_policy.txt
new file mode 100644
index 0000000..d18993d
--- /dev/null
+++ b/Documentation/scsi/link_power_management_policy.txt
@@ -0,0 +1,19 @@
+This parameter allows the user to set the link (interface) power management.
+There are 3 possible options:
+
+Value			Effect
+----------------------------------------------------------------------------
+min_power		Tell the controller to try to make the link use the
+			least possible power when possible.  This may
+			sacrifice some performance due to increased latency
+			when coming out of lower power states.
+
+max_performance		Generally, this means no power management.  Tell
+			the controller to have performance be a priority
+			over power management.
+
+medium_power		Tell the controller to enter a lower power state
+			when possible, but do not enter the lowest power
+			state, thus improving latency over min_power setting.
+
+
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 294eee3..a89ab56 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -620,6 +620,177 @@ void ata_dev_disable(struct ata_device *dev)
 	}
 }
 
+static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
+{
+	struct ata_link *link = dev->link;
+	struct ata_port *ap = link->ap;
+	u32 scontrol;
+	unsigned int err_mask;
+	int rc;
+
+	/*
+	 * disallow DIPM for drivers which haven't set
+	 * ATA_FLAG_IPM.  This is because when DIPM is enabled,
+	 * phy ready will be set in the interrupt status on
+	 * state changes, which will cause some drivers to
+	 * think there are errors - additionally drivers will
+	 * need to disable hot plug.
+	 */
+	if (!(ap->flags & ATA_FLAG_IPM) || !ata_dev_enabled(dev)) {
+		ap->pm_policy = NOT_AVAILABLE;
+		return -EINVAL;
+	}
+
+	/*
+	 * For DIPM, we will only enable it for the
+	 * min_power setting.
+	 *
+	 * Why?  Because Disks are too stupid to know that
+	 * If the host rejects a request to go to SLUMBER
+	 * they should retry at PARTIAL, and instead it
+	 * just would give up.  So, for medium_power to
+	 * work at all, we need to only allow HIPM.
+	 */
+	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
+	if (rc)
+		return rc;
+
+	switch (policy) {
+	case MIN_POWER:
+		/* no restrictions on IPM transitions */
+		scontrol &= ~(0x3 << 8);
+		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
+		if (rc)
+			return rc;
+
+		/* enable DIPM */
+		if (dev->flags & ATA_DFLAG_DIPM)
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_ENABLE, SATA_DIPM);
+		break;
+	case MEDIUM_POWER:
+		/* allow IPM to PARTIAL */
+		scontrol &= ~(0x1 << 8);
+		scontrol |= (0x2 << 8);
+		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
+		if (rc)
+			return rc;
+
+		/* disable DIPM */
+		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		break;
+	case NOT_AVAILABLE:
+	case MAX_PERFORMANCE:
+		/* disable all IPM transitions */
+		scontrol |= (0x3 << 8);
+		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
+		if (rc)
+			return rc;
+
+		/* disable DIPM */
+		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		break;
+	}
+
+	/* FIXME: handle SET FEATURES failure */
+	(void) err_mask;
+
+	return 0;
+}
+
+/**
+ *	ata_dev_enable_pm - enable SATA interface power management
+ *	@device - device to enable ipm for
+ *	@policy - the link power management policy
+ *
+ *	Enable SATA Interface power management.  This will enable
+ *	Device Interface Power Management (DIPM) for min_power
+ * 	policy, and then call driver specific callbacks for
+ *	enabling Host Initiated Power management.
+ *
+ *	Locking: Caller.
+ *	Returns: -EINVAL if IPM is not supported, 0 otherwise.
+ */
+void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy)
+{
+	int rc = 0;
+	struct ata_port *ap = dev->link->ap;
+
+	/* set HIPM first, then DIPM */
+	if (ap->ops->enable_pm)
+		rc = ap->ops->enable_pm(ap, policy);
+	if (rc)
+		goto enable_pm_out;
+	rc = ata_dev_set_dipm(dev, policy);
+
+enable_pm_out:
+	if (rc)
+		ap->pm_policy = MAX_PERFORMANCE;
+	else
+		ap->pm_policy = policy;
+	return /* rc */;	/* hopefully we can use 'rc' eventually */
+}
+
+/**
+ *	ata_dev_disable_pm - disable SATA interface power management
+ *	@device - device to enable ipm for
+ *
+ *	Disable SATA Interface power management.  This will disable
+ *	Device Interface Power Management (DIPM) without changing
+ * 	policy,  call driver specific callbacks for disabling Host
+ * 	Initiated Power management.
+ *
+ *	Locking: Caller.
+ *	Returns: void
+ */
+static void ata_dev_disable_pm(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+
+	ata_dev_set_dipm(dev, MAX_PERFORMANCE);
+	if (ap->ops->disable_pm)
+		ap->ops->disable_pm(ap);
+}
+
+void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
+{
+	ap->pm_policy = policy;
+	ap->link.eh_info.action |= ATA_EHI_LPM;
+	ap->link.eh_info.flags |= ATA_EHI_NO_AUTOPSY;
+	ata_port_schedule_eh(ap);
+}
+
+static void ata_lpm_enable(struct ata_host *host)
+{
+	struct ata_link *link;
+	struct ata_port *ap;
+	struct ata_device *dev;
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		ap = host->ports[i];
+		ata_port_for_each_link(link, ap) {
+			ata_link_for_each_dev(dev, link)
+				ata_dev_disable_pm(dev);
+		}
+	}
+}
+
+static void ata_lpm_disable(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		ata_lpm_schedule(ap, ap->pm_policy);
+	}
+}
+
+
 /**
  *	ata_devchk - PATA device presence detection
  *	@ap: ATA channel to examine
@@ -2101,6 +2272,13 @@ int ata_dev_configure(struct ata_device *dev)
 	if (dev->flags & ATA_DFLAG_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
+	if (!(dev->horkage & ATA_HORKAGE_IPM)) {
+		if (ata_id_has_hipm(dev->id))
+			dev->flags |= ATA_DFLAG_HIPM;
+		if (ata_id_has_dipm(dev->id))
+			dev->flags |= ATA_DFLAG_DIPM;
+	}
+
 	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
@@ -2126,6 +2304,13 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_IPM) {
+		dev->horkage |= ATA_HORKAGE_IPM;
+
+		/* reset link pm_policy for this port to no pm */
+		ap->pm_policy = MAX_PERFORMANCE;
+	}
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -6292,6 +6477,12 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
 	int rc;
 
+	/*
+	 * disable link pm on all ports before requesting
+	 * any pm activity
+	 */
+	ata_lpm_enable(host);
+
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
 	if (rc == 0)
 		host->dev->power.power_state = mesg;
@@ -6314,6 +6505,9 @@ void ata_host_resume(struct ata_host *host)
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
+
+	/* reenable link pm */
+	ata_lpm_disable(host);
 }
 #endif
 
@@ -6856,6 +7050,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		struct ata_port *ap = host->ports[i];
 
 		ata_scsi_scan_host(ap, 1);
+		ata_lpm_schedule(ap, ap->pm_policy);
 	}
 
 	return 0;
@@ -7252,7 +7447,6 @@ const struct ata_port_info ata_dummy_port_info = {
  * likely to change as new drivers are added and updated.
  * Do not depend on ABI/API stability.
  */
-
 EXPORT_SYMBOL_GPL(sata_deb_timing_normal);
 EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
 EXPORT_SYMBOL_GPL(sata_deb_timing_long);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 93e2b54..2cae530 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2607,6 +2607,10 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			ehc->i.flags &= ~ATA_EHI_SETMODE;
 		}
 
+		if (ehc->i.action & ATA_EHI_LPM)
+			ata_link_for_each_dev(dev, link)
+				ata_dev_enable_pm(dev, ap->pm_policy);
+
 		/* this link is okay now */
 		ehc->i.flags = 0;
 		continue;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f5d5420..2111faa 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -110,6 +110,74 @@ static struct scsi_transport_template ata_scsi_transport_template = {
 };
 
 
+static const struct {
+	enum link_pm	value;
+	const char	*name;
+} link_pm_policy[] = {
+	{ NOT_AVAILABLE, "max_performance" },
+	{ MIN_POWER, "min_power" },
+	{ MAX_PERFORMANCE, "max_performance" },
+	{ MEDIUM_POWER, "medium_power" },
+};
+
+const char *ata_scsi_lpm_get(enum link_pm policy)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(link_pm_policy); i++)
+		if (link_pm_policy[i].value == policy)
+			return link_pm_policy[i].name;
+
+	return NULL;
+}
+
+static ssize_t ata_scsi_lpm_put(struct class_device *class_dev,
+	const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	enum link_pm policy = 0;
+	int i;
+
+	/*
+	 * we are skipping array location 0 on purpose - this
+	 * is because a value of NOT_AVAILABLE is displayed
+	 * to the user as max_performance, but when the user
+	 * writes "max_performance", they actually want the
+	 * value to match MAX_PERFORMANCE.
+	 */
+	for (i = 1; i < ARRAY_SIZE(link_pm_policy); i++) {
+		const int len = strlen(link_pm_policy[i].name);
+		if (strncmp(link_pm_policy[i].name, buf, len) == 0 &&
+		   buf[len] == '\n') {
+			policy = link_pm_policy[i].value;
+			break;
+		}
+	}
+	if (!policy)
+		return -EINVAL;
+
+	ata_lpm_schedule(ap, policy);
+	return count;
+}
+
+static ssize_t
+ata_scsi_lpm_show(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	struct ata_port *ap = ata_shost_to_port(shost);
+	const char *policy =
+		ata_scsi_lpm_get(ap->pm_policy);
+
+	if (!policy)
+		return -EINVAL;
+
+	return snprintf(buf, 23, "%s\n", policy);
+}
+CLASS_DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
+		ata_scsi_lpm_show, ata_scsi_lpm_put);
+EXPORT_SYMBOL_GPL(class_device_attr_link_power_management_policy);
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 90df58a..0e6cf3a 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -101,6 +101,8 @@ extern int sata_link_init_spd(struct ata_link *link);
 extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
+extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
+extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 8263a7b..bf84032 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -235,6 +235,7 @@ enum {
 
 	/* SETFEATURE Sector counts for SATA features */
 	SATA_AN			= 0x05,  /* Asynchronous Notification */
+	SATA_DIPM		= 0x03,  /* Device Initiated Power Management */
 
 	/* ATAPI stuff */
 	ATAPI_PKT_DMA		= (1 << 0),
@@ -377,6 +378,26 @@ struct ata_taskfile {
 
 #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
 
+static inline bool ata_id_has_hipm(const u16 *id)
+{
+	u16 val = id[76];
+
+	if (val == 0 || val == 0xffff)
+		return false;
+
+	return val & (1 << 9);
+}
+
+static inline bool ata_id_has_dipm(const u16 *id)
+{
+	u16 val = id[78];
+
+	if (val == 0 || val == 0xffff)
+		return false;
+
+	return val & (1 << 3);
+}
+
 static inline int ata_id_has_fua(const u16 *id)
 {
 	if ((id[84] & 0xC000) != 0x4000)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6fd24e0..ededd26 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -133,6 +133,8 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
+	ATA_DFLAG_HIPM		= (1 << 8), /* device supports HIPM */
+	ATA_DFLAG_DIPM		= (1 << 9), /* device supports DIPM */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
@@ -185,6 +187,7 @@ enum {
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
 	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
 	ATA_FLAG_PMP		= (1 << 19), /* controller supports PMP */
+	ATA_FLAG_IPM		= (1 << 20), /* driver can handle IPM */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
@@ -294,6 +297,7 @@ enum {
 	ATA_EHI_RESUME_LINK	= (1 << 1),  /* resume link (reset modifier) */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
+	ATA_EHI_LPM		= (1 << 4),  /* link power management action */
 
 	ATA_EHI_DID_SOFTRESET	= (1 << 16), /* already soft-reset this port */
 	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */
@@ -325,6 +329,7 @@ enum {
 	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
 	ATA_HORKAGE_SKIP_PM	= (1 << 5),	/* Skip PM operations */
 	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
+	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
@@ -370,6 +375,18 @@ typedef int (*ata_reset_fn_t)(struct ata_link *link, unsigned int *classes,
 			      unsigned long deadline);
 typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes);
 
+/*
+ * host pm policy: If you alter this, you also need to alter libata-scsi.c
+ * (for the ascii descriptions)
+ */
+enum link_pm {
+	NOT_AVAILABLE,
+	MIN_POWER,
+	MAX_PERFORMANCE,
+	MEDIUM_POWER,
+};
+extern struct class_device_attribute class_device_attr_link_power_management_policy;
+
 struct ata_ioports {
 	void __iomem		*cmd_addr;
 	void __iomem		*data_addr;
@@ -616,6 +633,7 @@ struct ata_port {
 
 	pm_message_t		pm_mesg;
 	int			*pm_result;
+	enum link_pm		pm_policy;
 
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
@@ -683,7 +701,8 @@ struct ata_port_operations {
 
 	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
 	int (*port_resume) (struct ata_port *ap);
-
+	int (*enable_pm) (struct ata_port *ap, enum link_pm policy);
+	void (*disable_pm) (struct ata_port *ap);
 	int (*port_start) (struct ata_port *ap);
 	void (*port_stop) (struct ata_port *ap);
 

--------------080605020406030103070205--
