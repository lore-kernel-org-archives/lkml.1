Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZCUOEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZCUOEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZCUOEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:04:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:5898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZCUOE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:04:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,399,1233561600"; 
   d="scan'208";a="499698963"
Date: Sat, 21 Mar 2009 22:05:11 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/8] PCI: initialize and release SR-IOV capability
Message-ID: <20090321140511.GA24964@yzhao-otc.sh.intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com> <1237519518-24048-2-git-send-email-yu.zhao@intel.com> <20090320105409.5ed80885@hobbes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320105409.5ed80885@hobbes.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 01:54:09AM +0800, Jesse Barnes wrote:
> On Fri, 20 Mar 2009 11:25:11 +0800
> Yu Zhao <yu.zhao@intel.com> wrote:
> 
> > If a device has the SR-IOV capability, initialize it (set the ARI
> > Capable Hierarchy in the lowest numbered PF if necessary; calculate
> > the System Page Size for the VF MMIO, probe the VF Offset, Stride
> > and BARs). A lock for the VF bus allocation is also initialized if
> > a PF is the lowest numbered PF.
> > 
> > Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> > Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> 
> I applied this series to my linux-next branch, but there were a few
> conflicts here and there, so please check it out.  Looks like from
> start to finish this took about 6 months to get banged into shape,
> thanks for staying on it, Yu!

Yes, I checked them and found there is conflict between the SR-IOV
changes and Yinghai's 'PCI/x86: detect host bridge config space size
w/o using quirks'. Following is the fix, thanks!


New pci_cfg_space_size() needs invalid pdev->class, put it in the
right place in the pci_setup_device().

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/probe.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 56c71e5..e2f3dd0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -713,7 +713,6 @@ int pci_setup_device(struct pci_dev *dev)
 	dev->dev.bus = &pci_bus_type;
 	dev->hdr_type = hdr_type & 0x7f;
 	dev->multifunction = !!(hdr_type & 0x80);
-	dev->cfg_size = pci_cfg_space_size(dev);
 	dev->error_state = pci_channel_io_normal;
 	set_pcie_port_type(dev);
 
@@ -738,6 +737,9 @@ int pci_setup_device(struct pci_dev *dev)
 	dev_dbg(&dev->dev, "found [%04x:%04x] class %06x header type %02x\n",
 		 dev->vendor, dev->device, class, dev->hdr_type);
 
+	/* need to have dev->class ready */
+	dev->cfg_size = pci_cfg_space_size(dev);
+
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
 
@@ -959,9 +961,6 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 		return NULL;
 	}
 
-	/* need to have dev->class ready */
-	dev->cfg_size = pci_cfg_space_size(dev);
-
 	return dev;
 }
 
-- 
1.5.6.4

