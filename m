Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYKBIvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYKBIvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 03:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYKBIvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 03:51:37 -0500
Received: from userg500.nifty.com ([202.248.238.80]:41606 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYKBIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 03:51:36 -0500
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=eaTPPjcYofSLL/kN8avIBXKMKtLJ7tsqL+jipHpsGfkILuHZ942OgxNhcoPGZet1w
	p0jxfNvL3QQ7qUL3TYwFQ==
X-Nifty-SrcIP: [219.116.19.114]
Date: Sun, 2 Nov 2008 17:46:22 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux@dominikbrodowski.net
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       torvalds@osdl.org, linux-pcmcia@lists.infradead.org
Subject: Re: [BUG REPORT!!!] [PATCH 19/49] pcmcia: remove remaining
 in-kernel pcmcia_get_configuration_info() users
Message-Id: <20081102174622.02500138.komurojun-mbn@nifty.com>
In-Reply-To: <20081101110746.41733076.komurojun-mbn@nifty.com>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	<20080922215617.GA13057@comet.dominikbrodowski.net>
	<20080922231227.2625dd09@lxorguk.ukuu.org.uk>
	<20080922222655.GA3792@isilmar.linta.de>
	<20081101110746.41733076.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dominik


The reason of this bug is link->io is not copied
to the slave serial_cs device.

My patch below fix this problem.

--- ds.c.orig   2008-11-01 08:59:13.000000000 +0900
+++ ds.c        2008-11-02 17:05:44.000000000 +0900
@@ -668,6 +668,7 @@ struct pcmcia_device * pcmcia_device_add
         list_for_each_entry(tmp_dev, &s->devices_list, socket_device_list)
                 if (p_dev->func == tmp_dev->func) {
                        p_dev->function_config = tmp_dev->function_config;
+                       p_dev->io = tmp_dev->io;
                        kref_get(&p_dev->function_config->ref);
                }



Best Regards
Komuro



> Dear Dominik
> 
> Unfortunately, your path "[PATCH 19/49] pcmcia: remove remaining in-kernel
> pcmcia_get_configuration_info() users"
> broke the "serial_cs" and other drivers.
> 
> You replace "config->BasePort2" to "link->io.BasePort2" at serial_cs. 
> 
> But link->io.BasePort2, link->io.NumPorts2(etc) 
> does not contain correct value (it is zero).
> 
> Please fix this problem (or reveart the patch).
> 
> 
> Best Regards
> Komuro
> 
> Here is your patch.
> >--- a/drivers/serial/serial_cs.c
> >+++ b/drivers/serial/serial_cs.c
> >@@ -488,23 +488,23 @@ static int simple_config_check_notpicky(struct pcmcia_device *p_dev,
> > static int simple_config(struct pcmcia_device *link)
> > {
> > 	struct serial_info *info = link->priv;
> >-	config_info_t config;
> >-	int i, try;
> >+	int i = -ENODEV, try;
> > 
> > 	/* If the card is already configured, look up the port and irq */
> >-	i = pcmcia_get_configuration_info(link, &config);
> >-	if ((i == CS_SUCCESS) && (config.Attributes & CONF_VALID_CLIENT)) {
> >+	if (link->function_config) {
> > 		unsigned int port = 0;
> >-		if ((config.BasePort2 != 0) && (config.NumPorts2 == 8)) {
> >-			port = config.BasePort2;
> >+		if ((link->io.BasePort2 != 0) &&
> >+		    (link->io.NumPorts2 == 8)) {
> >+			port = link->io.BasePort2;
> > 			info->slave = 1;
> > 		} else if ((info->manfid == MANFID_OSITECH) &&
> >-			   (config.NumPorts1 == 0x40)) {
> >-			port = config.BasePort1 + 0x28;
> >+			   (link->io.NumPorts1 == 0x40)) {
> >+			port = link->io.BasePort1 + 0x28;
> > 			info->slave = 1;
> > 		}
> > 		if (info->slave) {
> >-			return setup_serial(link, info, port, config.AssignedIRQ);
> >+			return setup_serial(link, info, port,
> >+					    link->irq.AssignedIRQ);
>  		}
>  	}
> 
> 
> 
> 
> _______________________________________________
> Linux PCMCIA reimplementation list
> http://lists.infradead.org/mailman/listinfo/linux-pcmcia


-- 
Komuro <komurojun-mbn@nifty.com>
