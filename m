Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbXIXXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbXIXXNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbXIXXNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:13:10 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44816 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbXIXXNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:13:08 -0400
Message-ID: <46F84460.5090703@tiscali.nl>
Date: Tue, 25 Sep 2007 01:12:32 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, akpm@linux-foundation.org
Subject: Re: [patch 1/2] Enable link power management for ata drivers
References: <20070924215140.966161778@intel.com> <20070924151320.67f0c332.kristen.c.accardi@intel.com>
In-Reply-To: <20070924151320.67f0c332.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Device Initiated Power Management, which is defined
> in SATA 2.5 can be enabled for disks which support it.
> This patch enables DIPM when the user sets the link
> power management policy to "min_power".
> 
> Additionally, libata drivers can define a function 
> (enable_pm) that will perform hardware specific actions to 
> enable whatever power management policy the user set up 
> for Host Initiated Power management (HIPM).
> This power management policy will be activated after all 
> disks have been enumerated and intialized.  Drivers should 
> also define disable_pm, which will turn off link power 
> management, but not change link power management policy.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
>  Documentation/scsi/link_power_management_policy.txt |   19 +
>  drivers/ata/libata-core.c                           |  194 +++++++++++++++++++-
>  drivers/ata/libata-eh.c                             |    5 
>  drivers/ata/libata-scsi.c                           |   83 ++++++++
>  include/linux/ata.h                                 |    7 
>  include/linux/libata.h                              |   25 ++
>  6 files changed, 322 insertions(+), 11 deletions(-)
> 
> Index: libata-dev/drivers/ata/libata-scsi.c
> ===================================================================
> --- libata-dev.orig/drivers/ata/libata-scsi.c	2007-09-24 13:43:10.000000000 -0700
> +++ libata-dev/drivers/ata/libata-scsi.c	2007-09-24 13:46:22.000000000 -0700
> @@ -110,6 +110,78 @@ static struct scsi_transport_template at
>  };
>  
>  
> +static const struct {
> +	enum link_pm	value;
> +	char		*name;
> +} link_pm_policy[] = {
> +	{ NOT_AVAILABLE, "max_performance" },
> +	{ MIN_POWER, "min_power" },
> +	{ MAX_PERFORMANCE, "max_performance" },
> +	{ MEDIUM_POWER, "medium_power" },
> +};
> +
> +const char *ata_scsi_link_pm_policy(enum link_pm policy)
> +{
> +	int i;
> +	char *name = NULL;
> +
> +	for (i = 0; i < ARRAY_SIZE(link_pm_policy); i++) {
> +		if (link_pm_policy[i].value == policy) {
> +			name = link_pm_policy[i].name;
> +			break;
> +		}
> +	}
> +	return name;
> +}
> +
> +static ssize_t store_link_pm_policy(struct class_device *class_dev,
> +	const char *buf, size_t count)
> +{
> +	struct Scsi_Host *shost = class_to_shost(class_dev);
> +	struct ata_port *ap = ata_shost_to_port(shost);
> +	enum link_pm policy = 0;
> +	int i;
> +
> +	/*
> + 	 * we are skipping array location 0 on purpose - this
> + 	 * is because a value of NOT_AVAILABLE is displayed
> + 	 * to the user as max_performance, but when the user
> + 	 * writes "max_performance", they actually want the
> + 	 * value to match MAX_PERFORMANCE.
> + 	 */
> +	for (i = 1; i < ARRAY_SIZE(link_pm_policy); i++) {
> +		const int len = strlen(link_pm_policy[i].name);
> +		if (strncmp(link_pm_policy[i].name, buf, len) == 0 &&
> +		   buf[len] == '\n') {
> +			policy = link_pm_policy[i].value;
> +			break;
> +		}
> +	}
> +	if (!policy)
> +		return -EINVAL;
> +
> +	if (ata_scsi_set_link_pm_policy(ap, policy))
> +		return -EINVAL;
> +	return count;
> +}
> +
> +static ssize_t
> +show_link_pm_policy(struct class_device *class_dev, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(class_dev);
> +	struct ata_port *ap = ata_shost_to_port(shost);
> +	const char *policy =
> +		ata_scsi_link_pm_policy(ap->pm_policy);
> +
> +	if (!policy)
> +		return -EINVAL;
> +
> +	return snprintf(buf, 23, "%s\n", policy);
> +}
> +CLASS_DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
> +		show_link_pm_policy, store_link_pm_policy);
> +EXPORT_SYMBOL_GPL(class_device_attr_link_power_management_policy);
> +
>  static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
>  				   void (*done)(struct scsi_cmnd *))
>  {
> @@ -3041,6 +3113,17 @@ void ata_scsi_simulate(struct ata_device
>  	}
>  }
>  
> +int ata_scsi_set_link_pm_policy(struct ata_port *ap,
> +		enum link_pm policy)
> +{
> +	ap->pm_policy = policy;
> +	ap->link.eh_info.action |= ATA_EHI_LPM;
> +	ap->link.eh_info.flags |= ATA_EHI_NO_AUTOPSY;
> +	ata_port_schedule_eh(ap);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ata_scsi_set_link_pm_policy);
> +
>  int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
>  {
>  	int i, rc;
> Index: libata-dev/include/linux/libata.h
> ===================================================================
> --- libata-dev.orig/include/linux/libata.h	2007-09-24 13:43:10.000000000 -0700
> +++ libata-dev/include/linux/libata.h	2007-09-24 13:47:57.000000000 -0700
> @@ -140,6 +140,8 @@ enum {
>  	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
>  	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
>  	ATA_DFLAG_AN		= (1 << 7), /* device supports AN */
> +	ATA_DFLAG_HIPM		= (1 << 8), /* device supports HIPM */
> +	ATA_DFLAG_DIPM		= (1 << 9), /* device supports DIPM */
>  	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
>  
>  	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
> @@ -181,6 +183,7 @@ enum {
>  	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
>  	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
>  	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
> +	ATA_FLAG_IPM		= (1 << 19), /* driver can handle IPM */
>  
>  	/* The following flag belongs to ap->pflags but is kept in
>  	 * ap->flags because it's referenced in many LLDs and will be
> @@ -283,6 +286,7 @@ enum {
>  	ATA_EHI_RESUME_LINK	= (1 << 1),  /* resume link (reset modifier) */
>  	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
>  	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
> +	ATA_EHI_LPM		= (1 << 4),  /* link power management action */
>  
>  	ATA_EHI_DID_SOFTRESET	= (1 << 16), /* already soft-reset this port */
>  	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */
> @@ -308,6 +312,7 @@ enum {
>  	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
>  	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
>  	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
> +	ATA_HORKAGE_IPM		= (1 << 5), 	/* LPM problems */
>  };
>  
>  enum hsm_task_states {
> @@ -347,6 +352,18 @@ typedef int (*ata_reset_fn_t)(struct ata
>  			      unsigned long deadline);
>  typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes);
>  
> +/*
> + * host pm policy: If you alter this, you also need to alter libata-scsi.c
> + * (for the ascii descriptions)
> + */
> +enum link_pm {
> +	NOT_AVAILABLE,
> +	MIN_POWER,
> +	MAX_PERFORMANCE,
> +	MEDIUM_POWER,
> +};
> +extern struct class_device_attribute class_device_attr_link_power_management_policy;
> +
>  struct ata_ioports {
>  	void __iomem		*cmd_addr;
>  	void __iomem		*data_addr;
> @@ -585,6 +602,7 @@ struct ata_port {
>  
>  	pm_message_t		pm_mesg;
>  	int			*pm_result;
> +	enum link_pm		pm_policy;
>  
>  	struct timer_list	fastdrain_timer;
>  	unsigned long		fastdrain_cnt;
> @@ -647,7 +665,8 @@ struct ata_port_operations {
>  
>  	int (*port_suspend) (struct ata_port *ap, pm_message_t mesg);
>  	int (*port_resume) (struct ata_port *ap);
> -
> +	int (*enable_pm) (struct ata_port *ap, enum link_pm policy);
> +	int (*disable_pm) (struct ata_port *ap);
>  	int (*port_start) (struct ata_port *ap);
>  	void (*port_stop) (struct ata_port *ap);
>  
> @@ -854,7 +873,9 @@ extern int ata_cable_40wire(struct ata_p
>  extern int ata_cable_80wire(struct ata_port *ap);
>  extern int ata_cable_sata(struct ata_port *ap);
>  extern int ata_cable_unknown(struct ata_port *ap);
> -
> +extern int ata_scsi_set_link_pm_policy(struct ata_port *ap, enum link_pm);
> +extern int ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
> +extern void ata_dev_disable_pm(struct ata_device *dev);
>  /*
>   * Timing helpers
>   */
> Index: libata-dev/drivers/ata/libata-core.c
> ===================================================================
> --- libata-dev.orig/drivers/ata/libata-core.c	2007-09-24 13:43:10.000000000 -0700
> +++ libata-dev/drivers/ata/libata-core.c	2007-09-24 13:46:22.000000000 -0700
> @@ -68,7 +68,8 @@ const unsigned long sata_deb_timing_long
>  static unsigned int ata_dev_init_params(struct ata_device *dev,
>  					u16 heads, u16 sectors);
>  static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
> -static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable);
> +static unsigned int ata_dev_set_feature(struct ata_device *dev,
> +					u8 enable, u8 feature);
>  static void ata_dev_xfermask(struct ata_device *dev);
>  static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
>  
> @@ -615,6 +616,129 @@ void ata_dev_disable(struct ata_device *
>  	}
>  }
>  
> +static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
> +{
> +	struct ata_link *link = dev->link;
> +	struct ata_port *ap = link->ap;
> +	u32 scontrol;
> +
> +	/*
> +	 * disallow DIPM for drivers which haven't set
> +	 * ATA_FLAG_IPM.  This is because when DIPM is enabled,
> +	 * phy ready will be set in the interrupt status on
> +	 * state changes, which will cause some drivers to
> +	 * think there are errors - additionally drivers will
> +	 * need to disable hot plug.
> +	 */
> +	if (!(ap->flags & ATA_FLAG_IPM) || !ata_dev_enabled(dev)) {

	if (!((ap->flags & ATA_FLAG_IPM) && ata_dev_enabled(dev))) {

> +		ap->pm_policy = NOT_AVAILABLE;
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * For DIPM, we will only enable it for the
> +	 * min_power setting.
> +	 *
> +	 * Why?  Because Disks are too stupid to know that
> +	 * If the host rejects a request to go to SLUMBER
> +	 * they should retry at PARTIAL, and instead it
> +	 * just would give up.  So, for medium_power to
> +	 * work at all, we need to only allow HIPM.
> +	 */
> +	sata_scr_read(link, SCR_CONTROL, &scontrol);
> +
> +	switch (policy) {
> +	case MIN_POWER:
> +		/* no restrictions on IPM transitions */
> +		scontrol &= ~(0x3 << 8);
> +		sata_scr_write(link, SCR_CONTROL, scontrol);
> +
> +		/* enable DIPM */
> +		if (dev->flags & ATA_DFLAG_DIPM)
> +			ata_dev_set_feature(dev, SETFEATURES_SATA_ENABLE,
> +						SATA_DIPM);
> +		break;
> +	case MEDIUM_POWER:
> +		/* allow IPM to PARTIAL */
> +		scontrol &= ~(0x1 << 8);
> +		scontrol |= (0x2 << 8);
> +		sata_scr_write(link, SCR_CONTROL, scontrol);
> +
> +		/* disable DIPM */
> +		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
> +			ata_dev_set_feature(dev, SETFEATURES_SATA_DISABLE,
> +						SATA_DIPM);
> +		break;
> +	case NOT_AVAILABLE:
> +	case MAX_PERFORMANCE:
> +		/* disable all IPM transitions */
> +		scontrol |= (0x3 << 8);
> +		sata_scr_write(link, SCR_CONTROL, scontrol);
> +
> +		/* disable DIPM */
> +		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
> +			ata_dev_set_feature(dev, SETFEATURES_SATA_DISABLE,
> +						SATA_DIPM);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +/**
> + *	ata_dev_enable_pm - enable SATA interface power management
> + *	@device - device to enable ipm for
> + *	@policy - the link power management policy
> + *
> + *	Enable SATA Interface power management.  This will enable
> + *	Device Interface Power Management (DIPM) for min_power
> + * 	policy, and then call driver specific callbacks for
> + *	enabling Host Initiated Power management.
> + *
> + *	Locking: Caller.
> + *	Returns: -EINVAL if IPM is not supported, 0 otherwise.
> + */
> +int ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy)
> +{
> +	int rc = 0;
> +	struct ata_port *ap = dev->link->ap;
> +
> +	/* set HIPM first, then DIPM */
> +	if (ap->ops->enable_pm)
> +		rc = ap->ops->enable_pm(ap, policy);
> +	if (rc)
> +		goto enable_pm_out;
> +	rc = ata_dev_set_dipm(dev, policy);
> +
> +enable_pm_out:
> +	if (rc)
> +		ap->pm_policy = MAX_PERFORMANCE;
> +	else
> +		ap->pm_policy = policy;
> +	return rc;
> +}
> +
> +/**
> + *	ata_dev_disable_pm - disable SATA interface power management
> + *	@device - device to enable ipm for
> + *
> + *	Disable SATA Interface power management.  This will disable
> + *	Device Interface Power Management (DIPM) without changing
> + * 	policy,  call driver specific callbacks for disabling Host
> + * 	Initiated Power management.
> + *
> + *	Locking: Caller.
> + *	Returns: void
> + */
> +void ata_dev_disable_pm(struct ata_device *dev)
> +{
> +	struct ata_port *ap = dev->link->ap;
> +
> +	ata_dev_set_dipm(dev, MAX_PERFORMANCE);
> +	if (ap->ops->disable_pm)
> +		ap->ops->disable_pm(ap);
> +}
> +
> +
>  /**
>   *	ata_devchk - PATA device presence detection
>   *	@ap: ATA channel to examine
> @@ -2029,7 +2153,8 @@ int ata_dev_configure(struct ata_device 
>  		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id)) {
>  			int err;
>  			/* issue SET feature command to turn this on */
> -			err = ata_dev_set_AN(dev, SETFEATURES_SATA_ENABLE);
> +			err = ata_dev_set_feature(dev, SETFEATURES_SATA_ENABLE,
> +						SATA_AN);
>  			if (err)
>  				ata_dev_printk(dev, KERN_ERR,
>  						"unable to set AN, err %x\n",
> @@ -2057,6 +2182,13 @@ int ata_dev_configure(struct ata_device 
>  	if (dev->flags & ATA_DFLAG_LBA48)
>  		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
>  
> +	if (!(dev->horkage & ATA_HORKAGE_IPM)) {
> +		if (ata_id_has_hipm(dev->id))
> +			dev->flags |= ATA_DFLAG_HIPM;
> +		if (ata_id_has_dipm(dev->id))
> +			dev->flags |= ATA_DFLAG_DIPM;
> +	}
> +
>  	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
>  		/* Let the user know. We don't want to disallow opens for
>  		   rescue purposes, or in case the vendor is just a blithering
> @@ -2082,6 +2214,13 @@ int ata_dev_configure(struct ata_device 
>  		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
>  					 dev->max_sectors);
>  
> +	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_IPM) {
> +		dev->horkage |= ATA_HORKAGE_IPM;
> +
> +		/* reset link pm_policy for this port to no pm */
> +		ap->pm_policy = MAX_PERFORMANCE;
> +	}
> +
>  	if (ap->ops->dev_config)
>  		ap->ops->dev_config(dev);
>  
> @@ -4048,15 +4187,14 @@ static unsigned int ata_dev_set_xfermode
>  	DPRINTK("EXIT, err_mask=%x\n", err_mask);
>  	return err_mask;
>  }
> -
>  /**
> - *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
> + *	ata_dev_set_feature - Issue SET FEATURES - SATA FEATURES
>   *	@dev: Device to which command will be sent
>   *	@enable: Whether to enable or disable the feature
> + *	@feature: The sector count represents the feature to set
>   *
>   *	Issue SET FEATURES - SATA FEATURES command to device @dev
> - *	on port @ap with sector count set to indicate Asynchronous
> - *	Notification feature
> + *	on port @ap with sector count
>   *
>   *	LOCKING:
>   *	PCI/etc. bus probe sem.
> @@ -4064,7 +4202,8 @@ static unsigned int ata_dev_set_xfermode
>   *	RETURNS:
>   *	0 on success, AC_ERR_* mask otherwise.
>   */
> -static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
> +static unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable,
> +					u8 feature)
>  {
>  	struct ata_taskfile tf;
>  	unsigned int err_mask;
> @@ -4077,7 +4216,7 @@ static unsigned int ata_dev_set_AN(struc
>  	tf.feature = enable;
>  	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
>  	tf.protocol = ATA_PROT_NODATA;
> -	tf.nsect = SATA_AN;
> +	tf.nsect = feature;
>  
>  	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
>  
> @@ -6031,6 +6170,32 @@ int ata_flush_cache(struct ata_device *d
>  	return 0;
>  }
>  
> +static void ata_host_disable_link_pm(struct ata_host *host)
> +{
> +	int i;
> +	struct ata_link *link;
> +	struct ata_port *ap;
> +	struct ata_device *dev;
> +
> +	for (i = 0; i < host->n_ports; i++) {
> +		ap = host->ports[i];
> +		ata_port_for_each_link(link, ap) {
> +			ata_link_for_each_dev(dev, link)
> +				ata_dev_disable_pm(dev);
> +		}
> +	}
> +}
> +
> +static void ata_host_enable_link_pm(struct ata_host *host)
> +{
> +	int i;
> +
> +	for (i = 0; i < host->n_ports; i++) {
> +		struct ata_port *ap = host->ports[i];
> +		ata_scsi_set_link_pm_policy(ap, ap->pm_policy);
> +	}
> +}
> +
>  #ifdef CONFIG_PM
>  static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
>  			       unsigned int action, unsigned int ehi_flags,
> @@ -6101,6 +6266,12 @@ int ata_host_suspend(struct ata_host *ho
>  {
>  	int rc;
>  
> +	/*
> + 	 * disable link pm on all ports before requesting
> + 	 * any pm activity
> + 	 */
> +	ata_host_disable_link_pm(host);
> +
>  	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
>  	if (rc == 0)
>  		host->dev->power.power_state = mesg;
> @@ -6123,6 +6294,9 @@ void ata_host_resume(struct ata_host *ho
>  	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
>  			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
>  	host->dev->power.power_state = PMSG_ON;
> +
> +	/* reenable link pm */
> +	ata_host_enable_link_pm(host);
>  }
>  #endif
>  
> @@ -6663,6 +6837,7 @@ int ata_host_register(struct ata_host *h
>  		struct ata_port *ap = host->ports[i];
>  
>  		ata_scsi_scan_host(ap, 1);
> +		ata_scsi_set_link_pm_policy(ap, ap->pm_policy);
>  	}
>  
>  	return 0;
> @@ -7059,7 +7234,8 @@ const struct ata_port_info ata_dummy_por
>   * likely to change as new drivers are added and updated.
>   * Do not depend on ABI/API stability.
>   */
> -
> +EXPORT_SYMBOL_GPL(ata_dev_enable_pm);
> +EXPORT_SYMBOL_GPL(ata_dev_disable_pm);
>  EXPORT_SYMBOL_GPL(sata_deb_timing_normal);
>  EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
>  EXPORT_SYMBOL_GPL(sata_deb_timing_long);
> Index: libata-dev/include/linux/ata.h
> ===================================================================
> --- libata-dev.orig/include/linux/ata.h	2007-09-24 13:43:10.000000000 -0700
> +++ libata-dev/include/linux/ata.h	2007-09-24 13:46:22.000000000 -0700
> @@ -235,6 +235,7 @@ enum {
>  
>  	/* SETFEATURE Sector counts for SATA features */
>  	SATA_AN			= 0x05,  /* Asynchronous Notification */
> +	SATA_DIPM		= 0x03,  /* Device Initiated Power Management */
>  
>  	/* ATAPI stuff */
>  	ATAPI_PKT_DMA		= (1 << 0),
> @@ -367,6 +368,12 @@ struct ata_taskfile {
>  	  ((u64) (id)[(n) + 0]) )
>  
>  #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
> +#define ata_id_has_hipm(id)	\
> +	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
> +	  ((id)[76] & (1 << 9)) )
		^
		|
are you sure this
should be 76?

we can also change the first statement a bit:
	(!(((id)[76] == 0x0000) || ((id)[76] == 0xffff)) && \


> +#define ata_id_has_dipm(id)	\
> +	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \

and:
	(!(((id)[76] == 0x0000) || ((id)[76] == 0xffff)) && \

> +	  ((id)[78] & (1 << 3)) )
>  
>  static inline int ata_id_has_fua(const u16 *id)
>  {
> Index: libata-dev/Documentation/scsi/link_power_management_policy.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ libata-dev/Documentation/scsi/link_power_management_policy.txt	2007-09-24 13:46:22.000000000 -0700
> @@ -0,0 +1,19 @@
> +This parameter allows the user to set the link (interface) power management.
> +There are 3 possible options:
> +
> +Value			Effect
> +----------------------------------------------------------------------------
> +min_power		Tell the controller to try to make the link use the
> +			least possible power when possible.  This may
> +			sacrifice some performance due to increased latency
> +			when coming out of lower power states.
> +
> +max_performance		Generally, this means no power management.  Tell
> +			the controller to have performance be a priority
> +			over power management.
> +
> +medium_power		Tell the controller to enter a lower power state
> +			when possible, but do not enter the lowest power
> +			state, thus improving latency over min_power setting.
> +
> +
> Index: libata-dev/drivers/ata/libata-eh.c
> ===================================================================
> --- libata-dev.orig/drivers/ata/libata-eh.c	2007-09-24 13:43:10.000000000 -0700
> +++ libata-dev/drivers/ata/libata-eh.c	2007-09-24 13:46:22.000000000 -0700
> @@ -2400,6 +2400,11 @@ static int ata_eh_recover(struct ata_por
>  			ehc->i.flags &= ~ATA_EHI_SETMODE;
>  		}
>  
> +		if (ehc->i.action & ATA_EHI_LPM) {
> +			ata_link_for_each_dev(dev, link)
> +				ata_dev_enable_pm(dev, ap->pm_policy);
> +		}
> +
>  		/* this link is okay now */
>  		ehc->i.flags = 0;
>  		continue;
> 

