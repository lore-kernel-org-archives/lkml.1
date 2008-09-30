Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYI3WjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYI3WjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYI3Wi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:38:56 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:30232 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYI3Wiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:38:54 -0400
Date: Tue, 30 Sep 2008 16:38:51 -0600
From: Alex Chiang <achiang@hp.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/6 v3] PCI: support SR-IOV capability
Message-ID: <20080930223851.GC13611@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Zhao, Yu" <yu.zhao@intel.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Grant Grundler <grundler@parisc-linux.org>,
	Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>,
	Greg KH <greg@kroah.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F4@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F4@pdsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhao, Yu <yu.zhao@intel.com>:
> +/**
> + * pci_iov_init - initialize device's SR-IOV capability
> + * @dev: the PCI device
> + *
> + * Returns 0 on success, or negative on failure.
> + *
> + * The major differences between Virtual Function and PCI device are:
> + * 1) the device with multiple bus numbers uses internal routing, so
> + *    there is no explicit bridge device in this case.
> + * 2) Virtual Function memory spaces are designated by BARs encapsulated
> + *    in the capability structure, and the BARs in Virtual Function PCI
> + *    configuration space are read-only zero.
> + */
> +int pci_iov_init(struct pci_dev *dev)
> +{
> +       int i;
> +       int pos;
> +       u32 pgsz;
> +       u16 ctrl, total, initial, offset, stride;
> +       struct pci_iov *iov;
> +       struct resource *res;
> +
> +       if (!dev->is_pcie || (dev->pcie_type != PCI_EXP_TYPE_RC_END &&
> +                               dev->pcie_type != PCI_EXP_TYPE_ENDPOINT))
> +               return -ENODEV;
> +
> +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_IOV);
> +       if (!pos)
> +               return -ENODEV;
> +
> +       ctrl = pci_ari_enabled(dev) ? PCI_IOV_CTRL_ARI : 0;
> +       pci_write_config_word(dev, pos + PCI_IOV_CTRL, ctrl);
> +       ssleep(1);
> +
> +       pci_read_config_word(dev, pos + PCI_IOV_TOTAL_VF, &total);
> +       pci_read_config_word(dev, pos + PCI_IOV_INITIAL_VF, &initial);
> +       pci_write_config_word(dev, pos + PCI_IOV_NUM_VF, initial);
> +       pci_read_config_word(dev, pos + PCI_IOV_VF_OFFSET, &offset);
> +       pci_read_config_word(dev, pos + PCI_IOV_VF_STRIDE, &stride);
> +       if (!total || initial > total || (initial && !offset) ||
> +           (initial > 1 && !stride))
> +               return -EIO;
> +
> +       pci_read_config_dword(dev, pos + PCI_IOV_SUP_PGSIZE, &pgsz);
> +       i = PAGE_SHIFT > 12 ? PAGE_SHIFT - 12 : 0;
> +       pgsz &= ~((1 << i) - 1);
> +       if (!pgsz)
> +               return -EIO;
> +
> +       pgsz &= ~(pgsz - 1);
> +       pci_write_config_dword(dev, pos + PCI_IOV_SYS_PGSIZE, pgsz);
> +
> +       iov = kzalloc(sizeof(*iov), GFP_KERNEL);
> +       if (!iov)
> +               return -ENOMEM;
> +
> +       iov->dev = dev;
> +       iov->cap = pos;
> +       iov->totalvfs = total;
> +       iov->initialvfs = initial;
> +       iov->offset = offset;
> +       iov->stride = stride;
> +       iov->align = pgsz << 12;
> +       mutex_init(&iov->mutex);
> +
> +       for (i = 0; i < PCI_IOV_NUM_BAR; i++) {
> +               res = dev->resource + PCI_IOV_RESOURCES + i;
> +               pos = iov->cap + PCI_IOV_BAR_0 + i * 4;
> +               i += pci_read_base(dev, pci_bar_unknown, res, pos);
> +               if (!res->flags)
> +                       continue;
> +               res->flags &= ~IORESOURCE_SIZEALIGN;
> +               res->end = res->start + resource_size(res) * total - 1;
> +       }
> +
> +       dev->iov = iov;
> +       dev_info(&dev->dev, "SR-IOV capability is initialized\n");

Same questions here that I had for the ARI stuff. Does this
dev_info add value, or is it more noise, and is this message
informative enough? 

> +
> +       return 0;
> +}
> +
> +/**
> + * pci_iov_release - release resources used by SR-IOV capability
> + * @dev: the PCI device
> + */
> +void pci_iov_release(struct pci_dev *dev)
> +{
> +       if (!dev->iov)
> +               return;
> +
> +       mutex_destroy(&dev->iov->mutex);
> +       kfree(dev->iov);
> +       dev->iov = NULL;
> +}
> +
> +/**
> + * pci_iov_create_sysfs - create sysfs for SR-IOV capability
> + * @dev: the PCI device
> + */
> +void pci_iov_create_sysfs(struct pci_dev *dev)
> +{
> +       int rc;
> +       int i, j;
> +       struct pci_iov *iov = dev->iov;
> +
> +       if (!iov)
> +               return;
> +
> +       iov->ve = kzalloc(sizeof(*iov->ve) * iov->totalvfs, GFP_KERNEL);
> +       if (!iov->ve)
> +               return;
> +
> +       for (i = 0; i < iov->totalvfs; i++) {
> +               iov->ve[i].vfn = i;
> +               iov->ve[i].iov = iov;
> +       }
> +
> +       rc = kobject_init_and_add(&iov->kobj, &iov_ktype,
> +                                       &dev->dev.kobj, "iov");
> +       if (rc)
> +               goto failed1;
> +
> +       for (i = 0; i < ARRAY_SIZE(iov_attr); i++) {
> +               rc = sysfs_create_file(&iov->kobj, &iov_attr[i].attr);
> +               if (rc)
> +                       goto failed2;
> +       }
> +
> +       for (i = 0; i < iov->totalvfs; i++) {
> +               sprintf(iov->ve[i].name, "%d", i);
> +               rc = kobject_init_and_add(&iov->ve[i].kobj, &iov_ktype,
> +                                               &iov->kobj, iov->ve[i].name);
> +               if (rc)
> +                       goto failed3;
> +               rc = sysfs_create_file(&iov->ve[i].kobj, &vf_attr.attr);
> +               if (rc) {
> +                       kobject_put(&iov->ve[i].kobj);
> +                       goto failed3;
> +               }
> +       }

Do you want to emit a kobject_uevent here after success?

Alternatively, have you investigated making these virtual
functions into real struct device's? You get a lot of sysfs stuff
for free if you do so, including correct place in sysfs hierarchy
and uevents, etc.

My major complaints from last round (more documentation,
shouldn't be a PCI hotplug driver) have been addressed. I'll let
others comment about the other parts of your patch series.

Thanks.

/ac

