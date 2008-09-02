Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYIBXlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYIBXlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbYIBXlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:41:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42326 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbYIBXlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:41:09 -0400
Message-ID: <48BDCF09.7000603@garzik.org>
Date: Tue, 02 Sep 2008 19:40:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Fix long standing Marvell regressions
References: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>
In-Reply-To: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed;
 boundary="------------090504040208040502030101"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090504040208040502030101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:
> pata_marvell: Undo the regressions Jeff caused
> 
> From: Alan Cox <alan@redhat.com>
> 
> I've been chasing Jeff about this for months so am now giving up and sending
> it directly. Jeff added the Marvell device identifiers to the ahci driver
> without making the AHCI driver handle the PATA port. This means a lot of users
> can't use current kernels and in most distro cases can't even install. This has
> been going on since March 2008 for the 6121 Marvell, and late 2007 for the 6145.
> 
> This was all pointed out at the time and repeatedly ignored. Bugs assigned
> to Jeff about this are ignored also.
> 
> To quote Jeff in email
> 
> "Just switch the order of 'ahci' and 'pata_marvell' in
> /etc/modprobe.conf, then use Fedora's tools regenerate the initrd.
> 
> See?  It's not rocket science, and the current configuration can be
> easily made to work for Fedora users."
> 
> (Which isn't trivial, isn't end user, shouldn't be needed, and as it usually
> breaks at install time is in fact impossible)
> 
> To quote Jeff in August 2007
> 
> "   mv-ahci-pata
> Marvell 6121/6141 PATA support.  Needs fixing in the 'PATA controller
> command' area before it is usable, and can go upstream."
> 
> Only he applied it all anyway later and broke everything.

Completely and utterly false.  libata-dev.git#mv-ahci-pata has not yet 
gone upstream, as is blatantly clear if you had bothered to LOOK.

It helps to look at source code before posting, Alan:

         /*
          * Temporary Marvell 6145 hack: PATA port presence
          * is asserted through the standard AHCI port
          * presence register, as bit 4 (counting from 0)
          */
         if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
                 if (pdev->device == 0x6121)
                         mv = 0x3;
                 else
                         mv = 0xf;

Clearly PATA support is not applied, because the code masks out the PATA 
ports.


> The actual fix for the moment is very simple. If the user has included
> the pata_marvell driver let it drive the ports. If they've only selected
> for SATA support give them the AHCI driver which will run the port a fraction
> faster.

You omit details that hurt your case, namely that a ton of users were 
asking for AHCI support EVEN IF IT IS SATA ONLY, because the SATA 
support via pata_marvell legacy mode was so poor and problematic.

Among the pata_marvell complaints I received that were solved were:

* bloody awful error handling, with no hotplug support
* problems with suspend/resume (apparently some BIOS assumed you were in 
AHCI/enhanced mode)
* problems with speed negotiation of 3.0 Gbps SATA devices

So any claim that SATA always worked wonderfully under pata_marvell is 
specious.



Finally,

> +#if  !defined(CONFIG_PATA_MARVELL) && !defined(CONFIG_PATA_MARVELL_MODULE)
>  	/* Marvell */

this prevents users from choosing the driver that works best for them, 
including bringing back all the SATA problems just as you bring back PATA.

The attached patch is more reasonable, but neither your nor my patch 
actually address the relevant problem:  distros choosing the module.

So at this point, applying your patch would create regressions just as 
it purports to solve regressions, since Marvell AHCI is out there in 
active use as well.


How to move forward?  I recommend,

1) Applying my attached patch

2) Communicating with distros

3) See if we can get Marvell docs to someone willing to code in support. 
  Marvell has been very responsive in the past year with regards to 
'mvsas', so maybe they can help here too.

I kept hoping Marvell would pick up my unfinished #mv-ahci-pata work and 
polish it up.  They indicated interest, but kept putting it off.

	Jeff




--------------090504040208040502030101
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 674965f..56462ee 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,6 +1,8 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
+obj-$(CONFIG_PATA_MARVELL)	+= pata_marvell.o
+
 obj-$(CONFIG_SATA_AHCI)		+= ahci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
@@ -47,7 +49,6 @@ obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
 obj-$(CONFIG_PATA_OPTI)		+= pata_opti.o
 obj-$(CONFIG_PATA_OPTIDMA)	+= pata_optidma.o
 obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
-obj-$(CONFIG_PATA_MARVELL)	+= pata_marvell.o
 obj-$(CONFIG_PATA_MPIIX)	+= pata_mpiix.o
 obj-$(CONFIG_PATA_OLDPIIX)	+= pata_oldpiix.o
 obj-$(CONFIG_PATA_PCMCIA)	+= pata_pcmcia.o

--------------090504040208040502030101--
