Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbZBMQ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbZBMQ63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZBMQ56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:57:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55944 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZBMQ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:57:56 -0500
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/7] PCI: initialize and release SR-IOV capability
From: Andi Kleen <andi@firstfloor.org>
References: <1234256355-23153-1-git-send-email-yu.zhao@intel.com>
	<1234256355-23153-2-git-send-email-yu.zhao@intel.com>
Date: Fri, 13 Feb 2009 17:56:44 +0100
In-Reply-To: <1234256355-23153-2-git-send-email-yu.zhao@intel.com> (Yu Zhao's message of "Tue, 10 Feb 2009 16:59:09 +0800")
Message-ID: <877i3uwa0j.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yu Zhao <yu.zhao@intel.com> writes:
> +
> +
> +static int sriov_init(struct pci_dev *dev, int pos)
> +{
> +	int i;
> +	int rc;
> +	int nres;
> +	u32 pgsz;
> +	u16 ctrl, total, offset, stride;
> +	struct pci_sriov *iov;
> +	struct resource *res;
> +	struct pci_dev *pdev;
> +
> +	if (dev->pcie_type != PCI_EXP_TYPE_RC_END &&
> +	    dev->pcie_type != PCI_EXP_TYPE_ENDPOINT)
> +		return -ENODEV;
> +

It would be a good idea to put a might_sleep() here just in 
case the msleep happens below and drivers call it incorrectly.

> +	pci_read_config_word(dev, pos + PCI_SRIOV_CTRL, &ctrl);
> +	if (ctrl & PCI_SRIOV_CTRL_VFE) {
> +		pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
> +		msleep(100);


That's really long. Hopefully that's really needed.

> +
> +	pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
> +	pci_write_config_word(dev, pos + PCI_SRIOV_NUM_VF, total);
> +	pci_read_config_word(dev, pos + PCI_SRIOV_VF_OFFSET, &offset);
> +	pci_read_config_word(dev, pos + PCI_SRIOV_VF_STRIDE, &stride);
> +	if (!offset || (total > 1 && !stride))
> +		return -EIO;
> +
> +	pci_read_config_dword(dev, pos + PCI_SRIOV_SUP_PGSIZE, &pgsz);
> +	i = PAGE_SHIFT > 12 ? PAGE_SHIFT - 12 : 0;
> +	pgsz &= ~((1 << i) - 1);
> +	if (!pgsz)
> +		return -EIO;

All the error paths don't seem to undo the config space writes.
How will the devices behave with half initialized context?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
