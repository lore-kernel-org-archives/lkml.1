Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZGREr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZGREr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 00:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZGRErW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 00:47:22 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:37320 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZGRErV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 00:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=K6+CX/nwBKRycANo9BefqejkVjAXFbw8piqZaBjh+SOqiSRFogJqlVVZIElEAmSXPL
         rPYoKFBUvpjMQsi0BGvZnUG9Md0vB0jMxvs65OijkRmMVBC04owjO7Yvkq45CM641YtK
         DTZCmk0d8u6EIDYygkdE5IDM1yvcnjwi7tTS8=
Message-ID: <4A61544B.5030403@gmail.com>
Date: Fri, 17 Jul 2009 22:49:15 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] libata: Export AHCI capabilities
References: <1247854427-3315-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1247854427-3315-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2009 12:13 PM, Matthew Garrett wrote:
> AHCI exports various capability bits that may be of interest to userspace
> such as whether the BIOS claims a port is hotpluggable or eSATA. Providing
> these via sysfs along with the version of the AHCI spec implemented by
> the host allows userspace to make policy decisions for things like ALPM.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> ---
>   drivers/ata/ahci.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 44 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 336eb1e..5a5c160 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -327,10 +327,24 @@ static ssize_t ahci_activity_store(struct ata_device *dev,
>   				   enum sw_activity val);
>   static void ahci_init_sw_activity(struct ata_link *link);
>
> +static ssize_t ahci_show_host_caps(struct device *dev,
> +				   struct device_attribute *attr, char *buf);
> +static ssize_t ahci_show_host_version(struct device *dev,
> +				      struct device_attribute *attr, char *buf);
> +static ssize_t ahci_show_port_cmd(struct device *dev,
> +				  struct device_attribute *attr, char *buf);
> +
> +DEVICE_ATTR(ahci_host_caps, S_IRUGO, ahci_show_host_caps, NULL);
> +DEVICE_ATTR(ahci_host_version, S_IRUGO, ahci_show_host_version, NULL);
> +DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
> +
>   static struct device_attribute *ahci_shost_attrs[] = {
>   	&dev_attr_link_power_management_policy,
>   	&dev_attr_em_message_type,
>   	&dev_attr_em_message,
> +	&dev_attr_ahci_host_caps,
> +	&dev_attr_ahci_host_version,
> +	&dev_attr_ahci_port_cmd,
>   	NULL
>   };
>
> @@ -696,6 +710,36 @@ static void ahci_enable_ahci(void __iomem *mmio)
>   	WARN_ON(1);
>   }
>
> +static ssize_t ahci_show_host_caps(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct ata_port *ap = ata_shost_to_port(shost);
> +	struct ahci_host_priv *hpriv = ap->host->private_data;
> +
> +	return sprintf(buf, "%x\n", hpriv->cap);
> +}
> +
> +static ssize_t ahci_show_host_version(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct ata_port *ap = ata_shost_to_port(shost);
> +	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
> +
> +	return sprintf(buf, "%x\n", readl(mmio + HOST_VERSION));
> +}
> +
> +static ssize_t ahci_show_port_cmd(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct ata_port *ap = ata_shost_to_port(shost);
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +
> +	return sprintf(buf, "%x\n", readl(port_mmio + PORT_CMD));
> +}
> +
>   /**
>    *	ahci_save_initial_config - Save and fixup initial config values
>    *	@pdev: target PCI device

Surely there's a better format for exporting this information to 
userspace than making it parse out the bits from the raw register 
contents.. how about separate sysfs files for ESP, HPCP, etc? Or 
something more abstracted at a higher level that other drivers (if they 
have access to similar information) could use?
