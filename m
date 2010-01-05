Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320Ab0AETBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0AETBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269Ab0AETA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:00:56 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59982 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab0AETAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:00:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=t5rKvWvJQxbwyxHb8iGo1kxe6GybbP65auMVsBFZOICBZABE6K1sXL/JpCVPleouHW
         BmB9mrtp3qVu8zQFyHoFxz/gafoS42sT0TjEn8bQ2FvpNOE+wdNTBmagayTpvQFXuHOs
         i1xehKQY2eH90BpV3vqQ/BsFvoSeV5ra76z9U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] add PATA host controller support for Cirrus Logic's EP93xx CPUs
Date: Tue, 5 Jan 2010 19:56:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux-ide@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Joao Ramos <joao.ramos@inov.pt>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
References: <200911261651.40928.bzolnier@gmail.com> <4B26B0D6.4080809@bluewatersys.com> <4B26B6EA.8050403@garzik.org>
In-Reply-To: <4B26B6EA.8050403@garzik.org>
MIME-Version: 1.0
Message-Id: <201001051956.50961.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009 11:06:34 pm Jeff Garzik wrote:
> On 12/14/2009 04:40 PM, Ryan Mallon wrote:
> > I have added some of my own debugging. The problem appears to be that
> > __pata_ep93xx_write gets called from probe (via ata_host_activate), but
> > ap->private_data (ata_timing) is still null. The timing private_data is
> > set by pata_ep93xx_set_piomode, but that needs adev->pio_mode set, but I
> > don't know where this happens. I assume the ATA core handles this. Do I
> > need to call pata_ep93xx_set_piomode from pata_ep93xx_probe before
> > ata_host_activate, or should the private_data timing be set to some
> > default in the probe?
> 
> 
> ap->private_data is traditionally initialized in the ->port_start() hook.

Ryan, this incremental patch should fix the OOPS (it adds ->port_start
implementation which sets the default 'port PIO mode' to PIO0 so we have
sane default setting before device probing takes place and ->set_piomode
takes over), please retest the driver once you have a minute..

[ Thanks for debugging the problem and sorry for the delay.. ]

---
 drivers/ata/pata_ep93xx.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: b/drivers/ata/pata_ep93xx.c
===================================================================
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -613,6 +613,15 @@ static void pata_ep93xx_postreset(struct
 	}
 }
 
+static int pata_ep93xx_port_start(struct ata_port *ap)
+{
+	const struct ata_timing *cmd_t = ata_timing_find_mode(XFER_PIO_0);
+
+	ap->private_data = (void *)cmd_t;
+
+	return ata_sff_port_start(ap);
+}
+
 static struct ata_port_operations pata_ep93xx_port_ops = {
 	.inherits		= &ata_sff_port_ops,
 
@@ -631,6 +640,8 @@ static struct ata_port_operations pata_e
 	.freeze			= pata_ep93xx_freeze,
 	.softreset		= pata_ep93xx_softreset,
 	.postreset		= pata_ep93xx_postreset,
+
+	.port_start		= pata_ep93xx_port_start,
 };
 
 static int __init pata_ep93xx_probe(struct platform_device *pdev)
