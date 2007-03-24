Return-Path: <linux-kernel-owner+w=401wt.eu-S934336AbXCXBCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336AbXCXBCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 21:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934338AbXCXBCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 21:02:30 -0400
Received: from vana.vc.cvut.cz ([147.32.240.58]:54262 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992655AbXCXBCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 21:02:15 -0400
Date: Sat, 24 Mar 2007 02:02:13 +0100
From: Petr Vandrovec <petr@vandrovec.name>
To: bunk@stusta.de
Cc: linux-kernel@vger.kernel.org, jengelh@linux01.gwdg.de
Subject: Re: 2.6.21-rc regression in mptbase
Message-ID: <20070324010213.GA32620@vana.vc.cvut.cz>
References: <460475EF.1040109@vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460475EF.1040109@vc.cvut.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Mar 23, 2007 at 11:39:12PM +0100, Jan Engelhardt wrote:
> > Hello world,
> > 
> > 
> > in at least 2.6.21-rc4, one or more of the mptscsi scsi modules is 
> > broken with respect to not detecting any harddisk (VMware provides that 
> > virtual LSI MPT controller), which means no working system.
> > No problems in 2.6.20.2.
> >...
> 
> Could be a bug in the driver or a bug in the emulation exposed by a 
> change in the driver.
> 
> Can you bisect which change to the driver broke it?

Hello,
   it is bug in the emulation.  It should be fixed in Workstation 6.0 RC1.  If you
want to use VMware's LSILogic emulation with older products, you need fix below until
new releases come out (or unless I'll put out binary patch to fix binaries to
return 16 instead of previous value).
							Petr

If port reports that no devices are connected to it, assume that 16 devices
are there.  Hopefully nobody will ever build device with port but no devices,
and even for them it should be safe as before code always probed 16 devices
regardless of MaxDevices reported by port facts.

Signed-off-by:  Petr Vandrovec <petr@vandrovec.name>

--- linux/drivers/message/fusion/mptbase.c.orig	2007-03-20 13:47:28.000000000 -0700
+++ linux/drivers/message/fusion/mptbase.c	2007-03-23 17:45:51.000000000 -0700
@@ -2564,6 +2564,16 @@
 	pfacts->IOCStatus = le16_to_cpu(pfacts->IOCStatus);
 	pfacts->IOCLogInfo = le32_to_cpu(pfacts->IOCLogInfo);
 	pfacts->MaxDevices = le16_to_cpu(pfacts->MaxDevices);
+	/*
+	 * VMware emulation is broken, its PortFact's MaxDevices reports value
+	 * programmed by IOC Init, so if you program IOC Init to 256 (which is 0,
+	 * as that field is only 8 bit), it reports back 0 in port facts, instead
+	 * of 256...  And unfortunately using 256 triggers another bug in the
+	 * code (parallel SCSI can have only 16 devices).
+	 */
+	if (pfacts->MaxDevices == 0) {
+	   pfacts->MaxDevices = 16;
+	}
 	pfacts->PortSCSIID = le16_to_cpu(pfacts->PortSCSIID);
 	pfacts->ProtocolFlags = le16_to_cpu(pfacts->ProtocolFlags);
 	pfacts->MaxPostedCmdBuffers = le16_to_cpu(pfacts->MaxPostedCmdBuffers);
