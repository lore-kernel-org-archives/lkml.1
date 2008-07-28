Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYG1JE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYG1JE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 05:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYG1JES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 05:04:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:47859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYG1JER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 05:04:17 -0400
Subject: Re: [PATCH] smc91c92_cs: use request_firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: LKML <linux-kernel@vger.kernel.org>, dahinds@users.sourceforge.net,
       becker@scyld.com, x-csrdh@jcu.edu.au, erik@vt.edu,
       Jeff Garzik <jeff@garzik.org>, netdev <netdev@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20080728082814.GA4708@isilmar.linta.de>
References: <1217170341.3537.9.camel@jaswinder.satnam>
	 <20080728082814.GA4708@isilmar.linta.de>
Content-Type: text/plain; charset=utf8
Date: Mon, 28 Jul 2008 14:32:54 +0530
Message-Id: <1217235775.6407.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ﻿Dominik,

On Mon, 2008-07-28 at 10:28 +0200, Dominik Brodowski wrote:
> > +static int osi_load_firmware(struct pcmcia_device *link)
> > +{
> > +	struct platform_device *pdev;
> > +	const struct firmware *fw;
> > +	const char fw_name[] = "ositech/Xilinx7OD.bin"; 
> > +	int i, err;
> > + 
> > +	pdev = platform_device_register_simple("ositech", 0, NULL, 0);
> 
> Why do we need a platform_device here? Can't we just use the pcmcia device
> (so &link->dev) here?
> 

Thanks for pointing it out, I was searching for it.

Here is the fix:

diff --git a/drivers/net/pcmcia/smc91c92_cs.c b/drivers/net/pcmcia/smc91c92_cs.c
index 03f9be9..43d8e23 100644
--- a/drivers/net/pcmcia/smc91c92_cs.c
+++ b/drivers/net/pcmcia/smc91c92_cs.c
@@ -43,7 +43,6 @@
 #include <linux/mii.h>
 #include <linux/jiffies.h>
 #include <linux/firmware.h>
-#include <linux/platform_device.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
@@ -794,18 +793,11 @@ static int osi_config(struct pcmcia_device *link)
 
 static int osi_load_firmware(struct pcmcia_device *link)
 {
-	struct platform_device *pdev;
 	const struct firmware *fw;
 	const char fw_name[] = "ositech/Xilinx7OD.bin"; 
 	int i, err;
  
-	pdev = platform_device_register_simple("ositech", 0, NULL, 0);
-	if (IS_ERR(pdev)) {
-		printk(KERN_ERR "Failed to register platform device ositech\n");
-		return IS_ERR(pdev);
-	}
-	err = request_firmware(&fw, fw_name, &pdev->dev);
-	platform_device_unregister(pdev);
+	err = request_firmware(&fw, fw_name, &link->dev);
 	if (err) {
 		printk(KERN_ERR "Failed to load firmware \"%s\"\n",
 		       fw_name);

You can check updated patch from :-

http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git

Thank you,

Jaswinder Singh.

