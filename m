Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbYBMRfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbYBMRfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933399AbYBMRei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:34:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45873 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329AbYBMReg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:34:36 -0500
Date: Wed, 13 Feb 2008 09:32:03 -0800
From: Greg KH <greg@kroah.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: jdmason@kudzu.us, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080213173203.GC10733@kroah.com>
References: <20080213001506.GA13933@kroah.com> <20080213001638.GB13933@kroah.com> <20080213093225.GA16985@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213093225.GA16985@rhun.haifa.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:32:26AM +0200, Muli Ben-Yehuda wrote:
> On Tue, Feb 12, 2008 at 04:16:38PM -0800, Greg KH wrote:
> 
> > Why does the calgary driver need this?  Can we just use
> > pci_get_device() instead?  Why do you need to walk the device list
> > backwards?  Do you get false positives going forward?
> 
> It's not strictly needed, we used it for symmetry.

symetry for what?  Ah, unwinding from an error condition, that makes
sense.

Is there some reason you aren't using the "real" PCI driver api here and
registering a pci driver for these devices?  That would take the whole
"loop over all pci devices" logic out of the code entirely.

> Feel free to nuke it and walk the list forward.

So something like the patch below would be fine?

thanks,

greg k-h

---
 arch/x86/kernel/pci-calgary_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1232,8 +1232,7 @@ static int __init calgary_init(void)
 
 error:
 	do {
-		dev = pci_get_device_reverse(PCI_VENDOR_ID_IBM,
-					     PCI_ANY_ID, dev);
+		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
 		if (!dev)
 			break;
 		if (!is_cal_pci_dev(dev->device))
