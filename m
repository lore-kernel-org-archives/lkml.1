Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYJAQxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYJAQxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYJAQxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:53:16 -0400
Received: from outbound-mail-35.bluehost.com ([69.89.18.155]:35213 "HELO
	outbound-mail-35.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753257AbYJAQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:53:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=JaBvzQCmgRGuU5CAVpAPqN9IjUK4YEjktYP4Bbrxz+wPISvcm93IVYxXspH28da+dwdl99lTDcQG2MgfLbqMNrQBVGfryTCUAl09qEEnxDlG0AZZelOUdtLgG4j2fkgZ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Zhao, Yu" <yu.zhao@intel.com>
Subject: Re: [PATCH 1/6 v3] PCI: export some functions and macros
Date: Wed, 1 Oct 2008 09:52:42 -0700
User-Agent: KMail/1.9.10
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F0@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F0@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010952.44016.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 27, 2008 1:27 am Zhao, Yu wrote:
> Export some functions and move some macros from c file to header file.
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 9c71858..f99160d 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -696,7 +696,7 @@ static struct bin_attribute pci_config_attr = {
>                 .name = "config",
>                 .mode = S_IRUGO | S_IWUSR,
>         },
> -       .size = 256,
> +       .size = PCI_CFG_SPACE_SIZE,
>         .read = pci_read_config,
>         .write = pci_write_config,

I just pushed Yanmin's cleanups here, can you separate out the rest of your 
config space size changes and push them separately?


>  extern int pci_uevent(struct device *dev, struct kobj_uevent_env *env);
> @@ -144,3 +150,17 @@ struct pci_slot_attribute {
>  };
>  #define to_pci_slot_attr(s) container_of(s, struct pci_slot_attribute,
> attr)
>
> +enum pci_bar_type {
> +       pci_bar_unknown,        /* Standard PCI BAR probe */
> +       pci_bar_io,             /* An io port BAR */
> +       pci_bar_mem32,          /* A 32-bit memory BAR */
> +       pci_bar_mem64,          /* A 64-bit memory BAR */
> +       pci_bar_rom,            /* A ROM BAR */
> +};
> +
> +extern int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
> +                               struct resource *res, unsigned int reg);
> +extern struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
> +                               struct pci_dev *bridge, int busnr);
> +
> +#endif /* DRIVERS_PCI_H */

See Matthew's comments here; the pci_read_base changes should be part of a 
separate patch too.

> a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 3abbfad..6c78cf8 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -299,7 +299,7 @@ static void pbus_size_io(struct pci_bus *bus)
>
>                         if (r->parent || !(r->flags & IORESOURCE_IO))
>                                 continue;
> -                       r_size = r->end - r->start + 1;
> +                       r_size = resource_size(r);
>
>                         if (r_size < 0x400)
>                                 /* Might be re-aligned for ISA */
> @@ -350,7 +350,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned
> long mask, unsigned long
>
>                         if (r->parent || (r->flags & mask) != type)
>                                 continue;
> -                       r_size = r->end - r->start + 1;
> +                       r_size = resource_size(r);
>                         /* For bridges size != alignment */
>                         align = resource_alignment(r);
>                         order = __ffs(align) - 20;
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index 1a5fc83..56e4042 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -133,7 +133,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>         resource_size_t size, min, align;
>         int ret;
>
> -       size = res->end - res->start + 1;
> +       size = resource_size(res);
>         min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO :
> PCIBIOS_MIN_MEM;
>
>         align = resource_alignment(res);


These resource_size changes seem like good cleanups by themselves, can you 
separate them out into a separate patch?

> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 98dc624..cc78be6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -456,8 +456,8 @@ struct pci_driver {
>
>  /**
>   * PCI_VDEVICE - macro used to describe a specific pci device in short
> form - * @vend: the vendor name
> - * @dev: the 16 bit PCI Device ID
> + * @vendor: the vendor name
> + * @device: the 16 bit PCI Device ID
>   *
>   * This macro is used to create a struct pci_device_id that matches a
>   * specific PCI device.  The subvendor, and subdevice fields will be set

Another good standalone cleanup, please submit separately.

Thanks,
--
Jesse Barnes, Intel Open Source Technology Center
