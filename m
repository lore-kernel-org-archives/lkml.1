Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbYHUUyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbYHUUyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYHUUxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:53:53 -0400
Received: from mail.suse.de ([195.135.220.2]:46553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYHUUxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:53:52 -0400
Date: Thu, 21 Aug 2008 13:47:58 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alex Chiang <achiang@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: refcount leak in pci_get_device()?
Message-ID: <20080821204758.GB31543@suse.de>
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821202504.GU8318@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 02:25:04PM -0600, Matthew Wilcox wrote:
> On Thu, Aug 21, 2008 at 02:19:18PM -0600, Alex Chiang wrote:
> > #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
> > 
> > That eventually calls pci_get_dev_by_id(), which increases the
> > refcount on the device, but never decrements it.
> > 
> > Looks like that change in behavior happened here:
> > 
> > 	PCI: clean up search.c a lot
> > 	95247b57ed844511a212265b45cf9a919753aea1
> > 
> > pci_get_device() used to decrement the refcount, but no longer
> > does.
> > 
> > Thanks to Matthew Wilcox for helping me get this far...
> > 
> > Like I said, I'm still trying to track down my particular issue,
> > but I'd like to get your opinion on this.
> 
> In particular, I'd like to know whether this should be fixed by
> pci_get_dev_by_id() decrementing the refcount of from/dev_start,
> pci_get_subsys() decrementing 'from', or by bus_find_device()
> decrementing 'start'.  It looks like bus_find_device() is the place
> where this should logically happen, but the kerneldoc doesn't document
> the intended behaviour.

Ah, no the driver core isn't supposed to do this, it's something the pci
functions do out of "niceness" as that's how we can use them in an
iterator properly.

Does the following (untested) patch fix the issue for you all?

thanks,

greg k-h

--------------
Subject: PCI: fix reference leak in pci_get_dev_by_id()

From: Greg Kroah-Hartman <gregkh@suse.de>

Alex Chiang and Matthew Wilcox pointed out that pci_get_dev_by_id() does
not properly decrement the reference on the from pointer if it is
present, like the documentation for the function states it will.

Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Alex Chiang <achiang@hp.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 217814f..3b3b5f1 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -280,6 +280,8 @@ static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
 			      match_pci_dev_by_id);
 	if (dev)
 		pdev = to_pci_dev(dev);
+	if (from)
+		pci_dev_put(from);
 	return pdev;
 }
 
