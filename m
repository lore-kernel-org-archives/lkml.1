Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYKACNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYKACNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 22:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYKACNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 22:13:13 -0400
Received: from userg502.nifty.com ([202.248.238.82]:47844 "EHLO
	userg502.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYKACNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 22:13:12 -0400
DomainKey-Signature: a=rsa-sha1; s=userg502; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=q95t0rjGK2OKCRCCiI3Mg6mG+VmLEIzNttNVEwEcXJMlABPGQVrvsYeFEegDI+Le3
	iDATdc6rv11/mlDBGBc6w==
X-Nifty-SrcIP: [219.116.18.56]
Date: Sat, 1 Nov 2008 11:07:46 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [BUG REPORT!!!] [PATCH 19/49] pcmcia: remove remaining in-kernel
 pcmcia_get_configuration_info() users
Message-Id: <20081101110746.41733076.komurojun-mbn@nifty.com>
In-Reply-To: <20080922222655.GA3792@isilmar.linta.de>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	<20080922215617.GA13057@comet.dominikbrodowski.net>
	<20080922231227.2625dd09@lxorguk.ukuu.org.uk>
	<20080922222655.GA3792@isilmar.linta.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dominik

Unfortunately, your path "[PATCH 19/49] pcmcia: remove remaining in-kernel
pcmcia_get_configuration_info() users"
broke the "serial_cs" and other drivers.

You replace "config->BasePort2" to "link->io.BasePort2" at serial_cs. 

But link->io.BasePort2, link->io.NumPorts2(etc) 
does not contain correct value (it is zero).

Please fix this problem (or reveart the patch).


Best Regards
Komuro

Here is your patch.
>--- a/drivers/serial/serial_cs.c
>+++ b/drivers/serial/serial_cs.c
>@@ -488,23 +488,23 @@ static int simple_config_check_notpicky(struct pcmcia_device *p_dev,
> static int simple_config(struct pcmcia_device *link)
> {
> 	struct serial_info *info = link->priv;
>-	config_info_t config;
>-	int i, try;
>+	int i = -ENODEV, try;
> 
> 	/* If the card is already configured, look up the port and irq */
>-	i = pcmcia_get_configuration_info(link, &config);
>-	if ((i == CS_SUCCESS) && (config.Attributes & CONF_VALID_CLIENT)) {
>+	if (link->function_config) {
> 		unsigned int port = 0;
>-		if ((config.BasePort2 != 0) && (config.NumPorts2 == 8)) {
>-			port = config.BasePort2;
>+		if ((link->io.BasePort2 != 0) &&
>+		    (link->io.NumPorts2 == 8)) {
>+			port = link->io.BasePort2;
> 			info->slave = 1;
> 		} else if ((info->manfid == MANFID_OSITECH) &&
>-			   (config.NumPorts1 == 0x40)) {
>-			port = config.BasePort1 + 0x28;
>+			   (link->io.NumPorts1 == 0x40)) {
>+			port = link->io.BasePort1 + 0x28;
> 			info->slave = 1;
> 		}
> 		if (info->slave) {
>-			return setup_serial(link, info, port, config.AssignedIRQ);
>+			return setup_serial(link, info, port,
>+					    link->irq.AssignedIRQ);
 		}
 	}



