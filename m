Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbYJ3Iiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbYJ3Iiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYJ3Iik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:38:40 -0400
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:35936 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752277AbYJ3Iij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:38:39 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 04:38:38 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=vePVWfnFiuuyAWxcAksI51lgNRs2/v5k9Ma4z5Dk2+l8MOsaXkL4Gd6hXzvx0KOXD/1D0K+hN98bYDxHNQ9JMenfiOYPFlqO4ogzauOBQ5pLZUh+5e1K92UcPjSp05dPoxCdrsTexcrYluYxWwZGEFfx/vYAyYKMmhlzgNMFJDg=;
X-YMail-OSG: .1HO4yMVM1kD0PZvcig3B_z8jh9.kfiIPmUuI95Mrp543G68O3.J7vevY9sgbkatgifblTWilQn7diX.mKbXvQ1VVROT.jbC41ru5dPBEIgJpZasaNRqY1xHhzGylH_zzkz6yjYCx3tLb2MpFZ_wGgWj_nti_lOV21zp9kLgAKWY
Date: Thu, 30 Oct 2008 01:31:57 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: edac: struct device - replace bus_id with dev_name(), dev_set_name()
To: Kay Sievers <kay.sievers@vrfy.org>, dougthompson@xmission.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <1225327145.5970.30.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <903984.39250.qm@web50101.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kay Sievers <kay.sievers@vrfy.org> wrote:

> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".
> 
> To set and read the device name dev_name(dev) and dev_set_name(dev)
> must be used. If your code uses static kobjects, which it shouldn't
> do, "const char *init_name" can be used to statically provide the
> name the registered device should have. At registration time, the
> init_name field is cleared, to enforce the use of dev_name(dev) to
> access the device name at a later time.
> 
> We need to get rid of all occurrences of bus_id in the entire tree
> to be able to enable the new interface. Please apply this patch,
> and possibly convert any remaining remaining occurrences of bus_id.
> 
> We want to submit a patch to -next, which will remove bus_id from
> "struct device", to find the remaining pieces to convert, and finally
> switch ober to the new api, which will remove the 20 bytes array
> and does no longer have a size limitation.
> 
> Thanks,
> Kay
> 
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: edac: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> CC: dougthompson@xmission.com
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>


Acked-by: Doug Thompson <dougthompson@xmission.com>



> ---
> 
> 
> diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
> index 5fcd3d8..bbe1bdb 100644
> --- a/drivers/edac/edac_device.c
> +++ b/drivers/edac/edac_device.c
> @@ -333,7 +333,7 @@ static int add_edac_dev_to_global_list(struct edac_device_ctl_info
> *edac_dev)
>  fail0:
>  	edac_printk(KERN_WARNING, EDAC_MC,
>  			"%s (%s) %s %s already assigned %d\n",
> -			rover->dev->bus_id, edac_dev_name(rover),
> +			dev_name(rover->dev), edac_dev_name(rover),
>  			rover->mod_name, rover->ctl_name, rover->dev_idx);
>  	return 1;
>  
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index d110392..63b1b4c 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -401,7 +401,7 @@ static int add_mc_to_global_list(struct mem_ctl_info *mci)
>  
>  fail0:
>  	edac_printk(KERN_WARNING, EDAC_MC,
> -		"%s (%s) %s %s already assigned %d\n", p->dev->bus_id,
> +		"%s (%s) %s %s already assigned %d\n",dev_name( p->dev),
>  		edac_dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
>  	return 1;
>  
> diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
> index 22ec9d5..5d3c808 100644
> --- a/drivers/edac/edac_pci.c
> +++ b/drivers/edac/edac_pci.c
> @@ -150,7 +150,7 @@ static int add_edac_pci_to_global_list(struct edac_pci_ctl_info *pci)
>  fail0:
>  	edac_printk(KERN_WARNING, EDAC_PCI,
>  		"%s (%s) %s %s already assigned %d\n",
> -		rover->dev->bus_id, edac_dev_name(rover),
> +		dev_name(rover->dev), edac_dev_name(rover),
>  		rover->mod_name, rover->ctl_name, rover->pci_idx);
>  	return 1;
>  
> diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
> index 5c153dc..422728c 100644
> --- a/drivers/edac/edac_pci_sysfs.c
> +++ b/drivers/edac/edac_pci_sysfs.c
> @@ -569,7 +569,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
>  
>  	local_irq_restore(flags);
>  
> -	debugf4("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
> +	debugf4("PCI STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));
>  
>  	/* check the status reg for errors on boards NOT marked as broken
>  	 * if broken, we cannot trust any of the status bits
> @@ -600,13 +600,13 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
>  	}
>  
>  
> -	debugf4("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev->dev.bus_id);
> +	debugf4("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev_name(&dev->dev));
>  
>  	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
>  		/* On bridges, need to examine secondary status register  */
>  		status = get_pci_parity_status(dev, 1);
>  
> -		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
> +		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));
>  
>  		/* check the secondary status reg for errors,
>  		 * on NOT broken boards
> 
> 
> 


W1DUG
