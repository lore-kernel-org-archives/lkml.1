Return-Path: <linux-kernel-owner+w=401wt.eu-S1030395AbXCCTgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030395AbXCCTgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 14:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030400AbXCCTgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 14:36:12 -0500
Received: from tag.witbe.net ([81.88.96.48]:50035 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030395AbXCCTgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 14:36:10 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Alan'" <alan@lxorguk.ukuu.org.uk>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <akpm@osdl.org>, <jgarzik@pobox.com>,
       <torvalds@osdl.org>
Subject: RE: [PATCH] libata: Cable detection fixes
Date: Sat, 3 Mar 2007 20:35:59 +0100
Organization: AS2917.net
Message-ID: <00f301c75dcb$2c1b4f40$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20070301173003.5d5ab4a6@lxorguk.ukuu.org.uk>
Thread-Index: AcdcHlSD8qHCx+2RT3CflJ0sI5Q8rwBrJgvg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tried this (as well as the next one to activate the cable_detect), 
but it doesn't help my DVD-RW detection problem on pata_jmicron :

PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.1 to 64
ata9: PATA max UDMA/100 cmd 0x0000000000019c00 ctl 0x0000000000019882 bmdma
0x0000000000019400 irq 16
ata10: PATA max UDMA/100 cmd 0x0000000000019800 ctl 0x0000000000019482 bmdma
0x0000000000019408 irq 16
scsi8 : pata_jmicron
ata9.00: ATAPI, max UDMA/66
ata9.00: qc timeout (cmd 0xef)
ata9.00: failed to set xfermode (err_mask=0x4)
ata9.00: limiting speed to UDMA/44
ata9: failed to recover some devices, retrying in 5 secs
ata9.00: qc timeout (cmd 0xef)
ata9.00: failed to set xfermode (err_mask=0x4)
ata9.00: limiting speed to PIO0
ata9: failed to recover some devices, retrying in 5 secs
ata9.00: qc timeout (cmd 0xef)
ata9.00: failed to set xfermode (err_mask=0x4)
ata9.00: disabled
scsi9 : pata_jmicron

But it seems Alan's patch doesn't touch the jmicron code, so this may 
explain why it doesn't help...

Regards,
Paul

Paul Rolland, rol(at)as2917.net
ex-AS2917 Network administrator and Peering Coordinator

--

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
  

> -----Original Message-----
> From: linux-ide-owner@vger.kernel.org 
> [mailto:linux-ide-owner@vger.kernel.org] On Behalf Of Alan
> Sent: Thursday, March 01, 2007 6:30 PM
> To: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org; 
> akpm@osdl.org; jgarzik@pobox.com; torvalds@osdl.org
> Subject: [PATCH] libata: Cable detection fixes
> 
> 
> 2.6.21-rc has horrible problems with libata and PATA cable types (and
> thus speeds). This occurs because Tejun fixed a pile of other bugs and
> we now do cable detect enforcement for drive side detection properly.
> 
> Unfortunately we don't do the process around cable detection 
> right. Tejun
> identified the problem and pointed to the right Annex in the 
> spec, this patch
> implements the needed changes.
> 
> The basic requirement is that we have to identify the slave before the
> master.
> 
> The patch switches the identify order so that we can do the drive side
> detection correctly. 
> 
> Secondly we add a ->cable_detect() method called after the identify
> sequence which allows a host to do host side detection at this point
> should it wish, or to modify the results of the drive side identify.
> 
> This separate ->cable_detect method also cleans up a lot of 
> code because
> many drivers have their own error_handler methods which 
> really just set
> the cable type.
> 
> If there is no ->cable_detect method the cable type is left alone so a
> driver setting it earlier (eg because it has the SATA flags set or
> because it uses the old error_handler approach) will still do 
> the right
> thing (or at least the same thing) as before.
> 
> This patch simply adds the cable_detect method and helpers it 
> doesn't use
> them but other follow up patches will (ie Adrian please don't submit
> patches to unexport them ;))
> 
> Alan
> 
> 
> diff -u --new-file --recursive --exclude-from 
> /usr/src/exclude 
> linux.vanilla-2.6.21-rc2/drivers/ata/libata-core.c 
> linux-2.6.21-rc2/drivers/ata/libata-core.c
> --- linux.vanilla-2.6.21-rc2/drivers/ata/libata-core.c	
> 2007-03-01 13:36:03.000000000 +0000
> +++ linux-2.6.21-rc2/drivers/ata/libata-core.c	
> 2007-03-01 15:49:21.853448880 +0000
> @@ -1800,6 +1800,56 @@
>  }
>  
>  /**
> + *	ata_cable_40wire	-	return 40pin cable type
> + *	@ap: port
> + *
> + *	Helper method for drivers which want to hardwire 40 pin cable
> + *	detection.
> + */
> + 
> +int ata_cable_40wire(struct ata_port *ap)
> +{
> +	return ATA_CBL_PATA40;
> +}
> +
> +/**
> + *	ata_cable_80wire	-	return 40pin cable type
> + *	@ap: port
> + *
> + *	Helper method for drivers which want to hardwire 80 pin cable
> + *	detection.
> + */
> + 
> +int ata_cable_80wire(struct ata_port *ap)
> +{
> +	return ATA_CBL_PATA80;
> +}
> +
> +/**
> + *	ata_cable_unknown	-	return unknown PATA cable.
> + *	@ap: port
> + *
> + *	Helper method for drivers which have no PATA cable detection.
> + */
> + 
> +int ata_cable_unknown(struct ata_port *ap)
> +{
> +	return ATA_CBL_PATA_UNK;
> +}
> +
> +/**
> + *	ata_cable_sata	-	return SATA cable type
> + *	@ap: port
> + *
> + *	Helper method for drivers which have SATA cables
> + */
> + 
> +int ata_cable_sata(struct ata_port *ap)
> +{
> +	return ATA_CBL_SATA;
> +}
> +
> +/**
>   *	ata_bus_probe - Reset and probe ATA bus
>   *	@ap: Bus to probe
>   *
> @@ -1850,8 +1900,11 @@
>  	for (i = 0; i < ATA_MAX_DEVICES; i++)
>  		ap->device[i].pio_mode = XFER_PIO_0;
>  
> -	/* read IDENTIFY page and configure devices */
> -	for (i = 0; i < ATA_MAX_DEVICES; i++) {
> +	/* read IDENTIFY page and configure devices. We have to 
> do the identify
> +	   specific sequence bass-ackwards so that PDIAG- is released by
> +	   the slave device */
> +
> +	for (i = ATA_MAX_DEVICES - 1; i >=  0; i--) {
>  		dev = &ap->device[i];
>  
>  		if (tries[i])
> @@ -1864,6 +1917,19 @@
>  				     dev->id);
>  		if (rc)
>  			goto fail;
> +	}
> +
> +	/* Now ask for the cable type as PDIAG- should have 
> been released */
> +	if (ap->ops->cable_detect)
> +		ap->cbl = ap->ops->cable_detect(ap);
> +
> +	/* After the identify sequence we can now set up the 
> devices. We do
> +	   this in the normal order so that the user doesn't 
> get confused */
> +
> +	for(i = 0; i < ATA_MAX_DEVICES; i++) {
> +		dev = &ap->device[i];
> +		if (!ata_dev_enabled(dev))
> +			continue;
>  
>  		ap->eh_context.i.flags |= ATA_EHI_PRINTINFO;
>  		rc = ata_dev_configure(dev);
> @@ -6391,3 +6456,8 @@
>  EXPORT_SYMBOL_GPL(ata_irq_ack);
>  EXPORT_SYMBOL_GPL(ata_dummy_irq_ack);
>  EXPORT_SYMBOL_GPL(ata_dev_try_classify);
> +
> +EXPORT_SYMBOL_GPL(ata_cable_40wire);
> +EXPORT_SYMBOL_GPL(ata_cable_80wire);
> +EXPORT_SYMBOL_GPL(ata_cable_unknown);
> +EXPORT_SYMBOL_GPL(ata_cable_sata);
> diff -u --new-file --recursive --exclude-from 
> /usr/src/exclude 
> linux.vanilla-2.6.21-rc2/include/linux/libata.h 
> linux-2.6.21-rc2/include/linux/libata.h
> --- linux.vanilla-2.6.21-rc2/include/linux/libata.h	
> 2007-03-01 13:36:13.000000000 +0000
> +++ linux-2.6.21-rc2/include/linux/libata.h	2007-03-01 
> 14:27:53.363612296 +0000
> @@ -615,6 +614,8 @@
>  
>  	void (*post_set_mode) (struct ata_port *ap);
>  
> +	int (*cable_detect) (struct ata_port *ap);
> +
>  	int  (*check_atapi_dma) (struct ata_queued_cmd *qc);
>  
>  	void (*bmdma_setup) (struct ata_queued_cmd *qc);
> @@ -828,6 +829,11 @@
>  extern u8 ata_irq_ack(struct ata_port *ap, unsigned int chk_drq);
>  extern u8 ata_dummy_irq_ack(struct ata_port *ap, unsigned 
> int chk_drq);
>  
> +extern int ata_cable_40wire(struct ata_port *ap);
> +extern int ata_cable_80wire(struct ata_port *ap);
> +extern int ata_cable_sata(struct ata_port *ap);
> +extern int ata_cable_unknown(struct ata_port *ap);
> +
>  /*
>   * Timing helpers
>   */
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

