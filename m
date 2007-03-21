Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbXCUB4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbXCUB4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 21:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXCUB4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 21:56:54 -0400
Received: from userg503.nifty.com ([202.248.238.83]:29311 "EHLO
	userg503.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXCUB4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 21:56:52 -0400
DomainKey-Signature: a=rsa-sha1; s=userg503; d=nifty.com; c=nofws; q=dns;
	b=t0CNyjnd4CGdO0ijHNt7VyTsLn1YvysM9Gp9KSegb7YWT19x3rwX3F2twmw6SqSS2
	E3z9kZzd9RbqaD7XIAEkA==
Date: Wed, 21 Mar 2007 10:56:45 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: pcmcia - spot slave decode flaws (for testing)
Message-Id: <20070321105645.f16ef374.komurojun-mbn@nifty.com>
In-Reply-To: <20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
	<20070211114013.65b2be2c.komurojun-mbn@nifty.com>
	<20070218110914.888de729.komurojun-mbn@nifty.com>
	<20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

"[PATCH]: pcmcia - spot slave decode flaws (for testing)" works properly.
(kernel 2.6.21-rc4-mm1)

pccard: PCMCIA card inserted into slot 1
pcmcia: registering new device pcmcia1.0
ata3: PATA max PIO0 cmd 0x00010100 ctl 0x0001010e bmdma 0x00000000 irq 3
scsi2 : pata_pcmcia
ata3.00: CFA: SunDisk SDP5-10, Rev 3.70, max PIO0
ata3.00: 20480 sectors, multi 0: LBA 
ata3.01: CFA: SunDisk SDP5-10, Rev 3.70, max PIO0
ata3.01: 20480 sectors, multi 0: LBA 
ata3.01: is a ghost device, ignoring.
ata3.01: disabled
ata3.00: configured for PIO0
scsi 2:0:0:0: Direct-Access     ATA      SunDisk SDP5-10  Rev  PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 20480 512-byte hardware sectors (10 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 20480 512-byte hardware sectors (10 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 2:0:0:0: [sda] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg0 type 0

Best Regards
Komuro


>If you've got a CF adapter or PCMCIA disc which shows up twice in libata
>pata_pcmcia can you try this patch on top of the updates posted. It tries
>to spot when the slave is a mirror of the master and to fix up problems
>that causes.
>
>Signed-off-by: Alan Cox <alan@redhat.com>
>
>diff -u --new-file --recursive --exclude-from /usr/src/exclude \
>linux.vanilla-2.6.20-mm2/drivers/ata/pata_pcmcia.c \
>                linux-2.6.20-mm2/drivers/ata/pata_pcmcia.c
>--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_pcmcia.c	2007-02-20 13:37:58.000000000 \
>                +0000
>+++ linux-2.6.20-mm2/drivers/ata/pata_pcmcia.c	2007-02-20 14:28:13.000000000 +0000
>@@ -54,6 +54,39 @@
> 	dev_node_t	node;
> };
> 
>+/**
>+ *	pcmcia_set_mode	-	PCMCIA specific mode setup
>+ *	@ap: Port
>+ *	@r_failed_dev: Return pointer for failed device
>+ *
>+ *	Perform the tuning and setup of the devices and timings, which
>+ *	for PCMCIA is the same as any other controller. We wrap it however
>+ *	as we need to spot hardware with incorrect or missing master/slave
>+ *	decode, which alas is embarrassingly common in the PC world
>+ */
>+ 
>+static int pcmcia_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
>+{
>+	struct ata_device *master = &ap->device[0];
>+	struct ata_device *slave = &ap->device[1];
>+	
>+	if (!ata_dev_enabled(master) || !ata_dev_enabled(slave))
>+		return ata_do_set_mode(ap, r_failed_dev);
>+		
>+	if (memcmp(master->id + ATA_ID_FW_REV,  slave->id + ATA_ID_FW_REV,
>+			   ATA_ID_FW_REV_LEN + ATA_ID_PROD_LEN) == 0)
>+	{
>+		/* Suspicious match, but could be two cards from
>+		   the same vendor - check serial */
>+		if (memcmp(master->id + ATA_ID_SERNO, slave->id + ATA_ID_SERNO,
>+			   ATA_ID_SERNO_LEN) == 0 && master->id[ATA_ID_SERNO] >> 8) {
>+			ata_dev_printk(slave, KERN_WARNING, "is a ghost device, ignoring.\n");
>+			ata_dev_disable(slave);
>+		}	 
>+	}
>+	return ata_do_set_mode(ap, r_failed_dev);
>+}
>+
> static struct scsi_host_template pcmcia_sht = {
> 	.module			= THIS_MODULE,
> 	.name			= DRV_NAME,
>@@ -73,6 +106,7 @@
> };
> 
> static struct ata_port_operations pcmcia_port_ops = {
>+	.set_mode	= pcmcia_set_mode,
> 	.port_disable	= ata_port_disable,
> 	.tf_load	= ata_tf_load,
> 	.tf_read	= ata_tf_read,
