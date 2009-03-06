Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbZCFVSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbZCFVSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZCFVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:18:04 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37161 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZCFVSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:18:01 -0500
Date: Fri, 6 Mar 2009 14:17:59 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 7/7] PCI: manual for SR-IOV user and driver developer
Message-ID: <20090306211759.GJ25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-8-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235112888-9524-8-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think we'll need to go a few rounds on sorting this one out.  I don't
have time right now, but I think having this document is important.

On Fri, Feb 20, 2009 at 02:54:48PM +0800, Yu Zhao wrote:
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> ---
>  Documentation/DocBook/kernel-api.tmpl |    1 +
>  Documentation/PCI/pci-iov-howto.txt   |   99 +++++++++++++++++++++++++++++++++
>  2 files changed, 100 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/PCI/pci-iov-howto.txt
> 
> diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
> index 5818ff7..506e611 100644
> --- a/Documentation/DocBook/kernel-api.tmpl
> +++ b/Documentation/DocBook/kernel-api.tmpl
> @@ -251,6 +251,7 @@ X!Edrivers/pci/hotplug.c
>  -->
>  !Edrivers/pci/probe.c
>  !Edrivers/pci/rom.c
> +!Edrivers/pci/iov.c
>       </sect1>
>       <sect1><title>PCI Hotplug Support Library</title>
>  !Edrivers/pci/hotplug/pci_hotplug_core.c
> diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/PCI/pci-iov-howto.txt
> new file mode 100644
> index 0000000..fc73ef5
> --- /dev/null
> +++ b/Documentation/PCI/pci-iov-howto.txt
> @@ -0,0 +1,99 @@
> +		PCI Express I/O Virtualization Howto
> +		Copyright (C) 2009 Intel Corporation
> +		    Yu Zhao <yu.zhao@intel.com>
> +
> +
> +1. Overview
> +
> +1.1 What is SR-IOV
> +
> +Single Root I/O Virtualization (SR-IOV) is a PCI Express Extended
> +capability which makes one physical device appear as multiple virtual
> +devices. The physical device is referred to as Physical Function (PF)
> +while the virtual devices are referred to as Virtual Functions (VF).
> +Allocation of the VF can be dynamically controlled by the PF via
> +registers encapsulated in the capability. By default, this feature is
> +not enabled and the PF behaves as traditional PCIe device. Once it's
> +turned on, each VF's PCI configuration space can be accessed by its own
> +Bus, Device and Function Number (Routing ID). And each VF also has PCI
> +Memory Space, which is used to map its register set. VF device driver
> +operates on the register set so it can be functional and appear as a
> +real existing PCI device.
> +
> +2. User Guide
> +
> +2.1 How can I enable SR-IOV capability
> +
> +The device driver (PF driver) will control the enabling and disabling
> +of the capability via API provided by SR-IOV core. If the hardware
> +has SR-IOV capability, loading its PF driver would enable it and all
> +VFs associated with the PF.
> +
> +2.2 How can I use the Virtual Functions
> +
> +The VF is treated as hot-plugged PCI devices in the kernel, so they
> +should be able to work in the same way as real PCI devices. The VF
> +requires device driver that is same as a normal PCI device's.
> +
> +3. Developer Guide
> +
> +3.1 SR-IOV API
> +
> +To enable SR-IOV capability:
> +	int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
> +	'nr_virtfn' is number of VFs to be enabled.
> +
> +To disable SR-IOV capability:
> +	void pci_disable_sriov(struct pci_dev *dev);
> +
> +To notify SR-IOV core of Virtual Function Migration:
> +	irqreturn_t pci_sriov_migration(struct pci_dev *dev);
> +
> +3.2 Usage example
> +
> +Following piece of code illustrates the usage of the SR-IOV API.
> +
> +static int __devinit dev_probe(struct pci_dev *dev, const struct pci_device_id *id)
> +{
> +	pci_enable_sriov(dev, NR_VIRTFN);
> +
> +	...
> +
> +	return 0;
> +}
> +
> +static void __devexit dev_remove(struct pci_dev *dev)
> +{
> +	pci_disable_sriov(dev);
> +
> +	...
> +}
> +
> +static int dev_suspend(struct pci_dev *dev, pm_message_t state)
> +{
> +	...
> +
> +	return 0;
> +}
> +
> +static int dev_resume(struct pci_dev *dev)
> +{
> +	...
> +
> +	return 0;
> +}
> +
> +static void dev_shutdown(struct pci_dev *dev)
> +{
> +	...
> +}
> +
> +static struct pci_driver dev_driver = {
> +	.name =		"SR-IOV Physical Function driver",
> +	.id_table =	dev_id_table,
> +	.probe =	dev_probe,
> +	.remove =	__devexit_p(dev_remove),
> +	.suspend =	dev_suspend,
> +	.resume =	dev_resume,
> +	.shutdown =	dev_shutdown,
> +};
> -- 
> 1.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
