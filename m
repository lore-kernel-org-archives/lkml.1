Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbZBNCbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbZBNCbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 21:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZBNCbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 21:31:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:54413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZBNCbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 21:31:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,204,1233561600"; 
   d="scan'208";a="489939647"
Date: Fri, 13 Feb 2009 20:30:19 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/7] PCI: initialize and release SR-IOV capability
Message-ID: <20090213123019.GA16067@yzhao-otc.sh.intel.com>
References: <1234256355-23153-1-git-send-email-yu.zhao@intel.com> <1234256355-23153-2-git-send-email-yu.zhao@intel.com> <877i3uwa0j.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877i3uwa0j.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 12:56:44AM +0800, Andi Kleen wrote:
> Yu Zhao <yu.zhao@intel.com> writes:
> > +
> > +
> > +static int sriov_init(struct pci_dev *dev, int pos)
> > +{
> > +	int i;
> > +	int rc;
> > +	int nres;
> > +	u32 pgsz;
> > +	u16 ctrl, total, offset, stride;
> > +	struct pci_sriov *iov;
> > +	struct resource *res;
> > +	struct pci_dev *pdev;
> > +
> > +	if (dev->pcie_type != PCI_EXP_TYPE_RC_END &&
> > +	    dev->pcie_type != PCI_EXP_TYPE_ENDPOINT)
> > +		return -ENODEV;
> > +
> 
> It would be a good idea to put a might_sleep() here just in 
> case the msleep happens below and drivers call it incorrectly.

Yes, will do.

> > +	pci_read_config_word(dev, pos + PCI_SRIOV_CTRL, &ctrl);
> > +	if (ctrl & PCI_SRIOV_CTRL_VFE) {
> > +		pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
> > +		msleep(100);
> 
> That's really long. Hopefully that's really needed.

It's needed according to SR-IOV spec, however, these lines clear
the VF Enable bit if the BIOS or something else has set it. So it
doesn't always run into this.

> > +
> > +	pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
> > +	pci_write_config_word(dev, pos + PCI_SRIOV_NUM_VF, total);
> > +	pci_read_config_word(dev, pos + PCI_SRIOV_VF_OFFSET, &offset);
> > +	pci_read_config_word(dev, pos + PCI_SRIOV_VF_STRIDE, &stride);
> > +	if (!offset || (total > 1 && !stride))
> > +		return -EIO;
> > +
> > +	pci_read_config_dword(dev, pos + PCI_SRIOV_SUP_PGSIZE, &pgsz);
> > +	i = PAGE_SHIFT > 12 ? PAGE_SHIFT - 12 : 0;
> > +	pgsz &= ~((1 << i) - 1);
> > +	if (!pgsz)
> > +		return -EIO;
> 
> All the error paths don't seem to undo the config space writes.
> How will the devices behave with half initialized context?

Since the VF Enable bit is cleared before the initialization, setting
others SR-IOV registers won't change state of the device. So it should
be OK even without undo these writes as long as the VF Enable bit is
not set.

Thanks,
Yu
