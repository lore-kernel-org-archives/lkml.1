Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZJVHHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZJVHHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 03:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZJVHHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 03:07:09 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:41537 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZJVHHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 03:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bV/GKoIUyC5cC06N/j6uY6WIffpj0aSBTyyvmxR8Eig7OMKEuUhWzFmIGj0Vyf4E/z
         Lg39/OGTaNIxcgNpLFTbFqEBF5z2QEJ/vjIikAFZWxJW9hUwD6QYVNaFR645JJ3GVg0M
         vZZVeK5qbKpOcfQ+/GZaOqUVR/nhP8rzTA5P8=
MIME-Version: 1.0
In-Reply-To: <20091006182346.GA22770@linux-os.sc.intel.com>
References: <72D8A09E39A89147BE9CFBB6F0C73C306073445396@rrsmsx501.amr.corp.intel.com>
	 <6E2431EDEB6AE64F827F8A1B0D0DA1A603C322CF@azsmsx501.amr.corp.intel.com>
	 <72D8A09E39A89147BE9CFBB6F0C73C30607344552A@rrsmsx501.amr.corp.intel.com>
	 <20091002211844.GA14352@linux-os.sc.intel.com>
	 <20091002215019.GB23379@8bytes.org>
	 <20091006182346.GA22770@linux-os.sc.intel.com>
Date: Thu, 22 Oct 2009 00:07:11 -0700
Message-ID: <86802c440910220007s5881653o5fbbc810523b18fe@mail.gmail.com>
Subject: Re: [PATCH] PCIe hot plug for Intel iommu
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Fenghua Yu <fenghua.yu@intel.com>, jbarnes@virtuousgeek.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
       Francois Isabelle <Francois.Isabelle@ca.kontron.com>,
       iommu <iommu@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 11:23 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> To support PCIe hot plug in IOMMU, we register a notifier to respond to device
> change action.
>
> When the notifier gets BUS_NOTIFY_UNBOUND_DRIVER, it removes the device from its
> DMAR domain.
>
> A hot added device will be added into an IOMMU domain when it first does IOMMU
> op. So there is no need to add more code for hot add.
>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>
> ---
>
>  intel-iommu.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+)
>
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 855dd7c..d8b8cfc 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -3193,6 +3193,33 @@ static int __init init_iommu_sysfs(void)
>  }
>  #endif /* CONFIG_PM */
>
> +/*
> + * Here we only respond to action of unbound device from driver.
> + *
> + * Added device is not attached to its DMAR domain here yet. That will happen
> + * when mapping the device to iova.
> + */
> +static int device_notifier(struct notifier_block *nb,
> +                                 unsigned long action, void *data)
> +{
> +       struct device *dev = data;
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +       struct dmar_domain *domain;
> +
> +       domain = find_domain(pdev);
> +       if (!domain)
> +               return 0;
> +
> +       if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through)
> +               domain_remove_one_dev_info(domain, pdev);
> +
> +       return 0;
> +}
> +
> +static struct notifier_block device_nb = {
> +       .notifier_call = device_notifier,
> +};
> +
>  int __init intel_iommu_init(void)
>  {
>        int ret = 0;
> @@ -3245,6 +3272,8 @@ int __init intel_iommu_init(void)
>
>        register_iommu(&intel_iommu_ops);
>
> +       bus_register_notifier(&pci_bus_type, &device_nb);
> +
>        return 0;
>  }
>

it seems this one should be get into 2.6.32....and .stable

otherwise second hot plug in the same pcie slot will not work with dma.

YH
