Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYFBR5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYFBR5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYFBR5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:57:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:53423 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYFBR5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:57:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,578,1204531200"; 
   d="scan'208";a="287203339"
Date: Mon, 2 Jun 2008 10:47:53 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080602104753.3f24087d@appleyard>
In-Reply-To: <484431AB.7010005@garzik.org>
References: <20080508161008.59361de5@appleyard>
	<20080527030854.GC7515@mit.edu>
	<20080527143202.4bab5bf0@appleyard>
	<20080527225926.GE6843@mit.edu>
	<20080527163251.04054a74@appleyard>
	<20080531080015.GG5405@ucw.cz>
	<4842F5A8.9020708@garzik.org>
	<20080602080440.25fc663c@core>
	<4843A4A7.3020809@garzik.org>
	<4843EF88.2040606@rtr.ca>
	<48441AA6.8080704@garzik.org>
	<20080602100019.3d2d2522@appleyard>
	<484431AB.7010005@garzik.org>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 13:45:15 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Kristen Carlson Accardi wrote:
> > Can you tell me what part of this patch is vendor specific?  Maybe
> > I am misunderstanding what you are saying.  Here's that patch again
> > in case you need to look at it again.
> 
> 
> It's specific to AHCI, and does not cover other controllers.
> 
> Certainly PORT_CMD_HPCP must be, but the concept itself is not at all 
> AHCI-specific.
> 
> 	Jeff
> 
> 


@@ -5627,6 +5643,14 @@ int ata_host_register(struct ata_host *h

                        /* wait for EH to finish */
                        ata_port_wait_eh(ap);
+                       ata_link_for_each_dev(dev, &ap->link)
+                               if (ata_dev_enabled(dev))
+                                       device_attached++;
+                       if (!device_attached &&
+                           (ap->flags & ATA_FLAG_NO_HOTPLUG)) {
+                               /* no device present, disable port */
+                               ata_port_disable(ap);
+                       }
                } else {

Here you can see that it would be very easy for another driver
to just add code to set the NO_HOTPLUG flag and then this code
will work for them as well, since we power off the phy using
DET which is specified by SATA.

here's that code:
+static void ata_phy_offline(struct ata_link *link)
+{
+       u32 scontrol;
+       int rc;
+
+       /* set DET to 4 */
+       rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
+       if (rc)
+               return;
+       scontrol &= ~0xf;
+       scontrol |= (1 << 2);
+       sata_scr_write(link, SCR_CONTROL, scontrol);
+}

while it's true that I only modified ahci.c to set
the flag, any other driver writer can do that for the
other drivers based on whatever they want to use to
determine whether to set the NO_HOTPLUG flag.

