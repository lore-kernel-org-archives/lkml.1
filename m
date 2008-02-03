Return-Path: <linux-kernel-owner+w=401wt.eu-S936164AbYBCHay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936164AbYBCHay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbYBCHaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:30:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:19289 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbYBCHao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o4tT0Ua1RFTaaUEOBIpkwfikhT1JKE47rovMjqgPg1Sz1Qd2xVOj+QGckrR6fdZyAcJ2C5pZKaiMU8eb5E/XpslQ5t0YGOS2FcCNWUS91tW3c1UbipeQBDREatDs60w6yl+OKm9VpsKSuNGfIpofZhF3IEAxs2ve8rZOgh1AFFc=
Message-ID: <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>
Date: Sat, 2 Feb 2008 23:30:43 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Cc: "Greg KH" <greg@kroah.com>, "Tony Camuso" <tcamuso@redhat.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Loic Prylli" <loic@myri.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Martin Mares" <mj@ucw.cz>
In-Reply-To: <20080129030340.GE20198@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080114230448.GL9847@does.not.exist>
	 <20080115174643.GB28238@kroah.com>
	 <20080115175641.GE18741@parisc-linux.org>
	 <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com>
	 <20080128204431.GA15227@kroah.com>
	 <20080128223141.GA31101@parisc-linux.org>
	 <20080128225334.GD4720@kroah.com>
	 <20080129025615.GC20198@parisc-linux.org>
	 <20080129030340.GE20198@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 7:03 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> We want to allow different implementations of pci_raw_ops for standard
> and extended config space on x86.  Rather than clutter generic code with
> knowledge of this, we make pci_raw_ops private to x86 and use it to
> implement the new raw interface -- raw_pci_read() and raw_pci_write().
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  arch/ia64/pci/pci.c               |   25 ++++++++-----------------
>  arch/ia64/sn/pci/tioce_provider.c |   16 ++++++++--------
>  arch/x86/kernel/quirks.c          |    2 +-
>  arch/x86/pci/common.c             |   25 +++++++++++++++++++++++--
>  arch/x86/pci/direct.c             |    4 ++--
>  arch/x86/pci/fixup.c              |    6 ++++--
>  arch/x86/pci/legacy.c             |    2 +-
>  arch/x86/pci/mmconfig-shared.c    |    6 +++---
>  arch/x86/pci/mmconfig_32.c        |   10 ++--------
>  arch/x86/pci/mmconfig_64.c        |    8 +-------
>  arch/x86/pci/pci.h                |   15 +++++++++++----
>  arch/x86/pci/visws.c              |    3 ---
>  drivers/acpi/osl.c                |   25 ++++++-------------------
>  drivers/ata/Kconfig               |    3 +++
>  drivers/ata/Makefile              |    3 +++
>  include/linux/pci.h               |   16 ++++++++--------
>  16 files changed, 84 insertions(+), 85 deletions(-)
>
...
>
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index fab30e1..7f73f7c 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -27,7 +27,7 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
>         pci_write_config_byte(dev, 0xf4, config|0x2);
>
>         /* read xTPR register */
> -       raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
> +       raw_pci_read(0, 0, 0x40, 0x4c, 2, &word);
>
>         if (!(word & (1 << 13))) {
>                 printk(KERN_INFO "Intel E7520/7320/7525 detected. "
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 8627463..f2bd9f3 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -26,16 +26,37 @@ int pcibios_last_bus = -1;
>  unsigned long pirq_table_addr;
>  struct pci_bus *pci_root_bus;
>  struct pci_raw_ops *raw_pci_ops;
> +struct pci_raw_ops *raw_pci_ext_ops;
> +
> +int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
> +                                               int reg, int len, u32 *val)
> +{
> +       if (reg < 256 && raw_pci_ops)
> +               return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
> +       if (raw_pci_ext_ops)
> +               return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
> +       return -EINVAL;
> +}
> +
> +int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
> +                                               int reg, int len, u32 val)
> +{
> +       if (reg < 256 && raw_pci_ops)
> +               return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
> +       if (raw_pci_ext_ops)
> +               return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
> +       return -EINVAL;
> +}
>
>  static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
>  {
> -       return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
> +       return raw_pci_read(pci_domain_nr(bus), bus->number,
>                                  devfn, where, size, value);
>  }
>
>  static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
>  {
> -       return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
> +       return raw_pci_write(pci_domain_nr(bus), bus->number,
>                                   devfn, where, size, value);
>  }
>
> diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
> index 431c9a5..42f3e4c 100644
> --- a/arch/x86/pci/direct.c
> +++ b/arch/x86/pci/direct.c
> @@ -14,7 +14,7 @@
>  #define PCI_CONF1_ADDRESS(bus, devfn, reg) \
>         (0x80000000 | (bus << 16) | (devfn << 8) | (reg & ~3))
>
> -int pci_conf1_read(unsigned int seg, unsigned int bus,
> +static int pci_conf1_read(unsigned int seg, unsigned int bus,
>                           unsigned int devfn, int reg, int len, u32 *value)
>  {
>         unsigned long flags;
> @@ -45,7 +45,7 @@ int pci_conf1_read(unsigned int seg, unsigned int bus,
>         return 0;
>  }
>
> -int pci_conf1_write(unsigned int seg, unsigned int bus,
> +static int pci_conf1_write(unsigned int seg, unsigned int bus,
>                            unsigned int devfn, int reg, int len, u32 value)
>  {
>         unsigned long flags;

any reason to change pci_conf1_read/write to static?

> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> index 6cff66d..b31cd6a 100644
> --- a/arch/x86/pci/fixup.c
> +++ b/arch/x86/pci/fixup.c
> @@ -215,7 +215,8 @@ static int quirk_aspm_offset[MAX_PCIEROOT << 3];
>
>  static int quirk_pcie_aspm_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
>  {
> -       return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
> +       return raw_pci_read(pci_domain_nr(bus), bus->number,
> +                                               devfn, where, size, value);
>  }
>
>  /*
> @@ -231,7 +232,8 @@ static int quirk_pcie_aspm_write(struct pci_bus *bus, unsigned int devfn, int wh
>         if ((offset) && (where == offset))
>                 value = value & 0xfffffffc;
>
> -       return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
> +       return raw_pci_write(pci_domain_nr(bus), bus->number,
> +                                               devfn, where, size, value);
>  }
>
>  static struct pci_ops quirk_pcie_aspm_ops = {
> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> index 5565d70..e041ced 100644
> --- a/arch/x86/pci/legacy.c
> +++ b/arch/x86/pci/legacy.c
> @@ -22,7 +22,7 @@ static void __devinit pcibios_fixup_peer_bridges(void)
>                 if (pci_find_bus(0, n))
>                         continue;
>                 for (devfn = 0; devfn < 256; devfn += 8) {
> -                       if (!raw_pci_ops->read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
> +                       if (!raw_pci_read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
>                             l != 0x0000 && l != 0xffff) {
>                                 DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
>                                 printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 6b521d3..8d54df4 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -28,7 +28,7 @@ static int __initdata pci_mmcfg_resources_inserted;
>  static const char __init *pci_mmcfg_e7520(void)
>  {
>         u32 win;
> -       pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
> +       pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
>
>         win = win & 0xf000;
>         if(win == 0x0000 || win == 0xf000)
> @@ -53,7 +53,7 @@ static const char __init *pci_mmcfg_intel_945(void)
>
>         pci_mmcfg_config_num = 1;
>
> -       pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
> +       pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
>
>         /* Enable bit */
>         if (!(pciexbar & 1))
> @@ -118,7 +118,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
>         int i;
>         const char *name;
>
> -       pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
> +       pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
>         vendor = l & 0xffff;
>         device = (l >> 16) & 0xffff;
>
> diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
> index 7b75e65..081816a 100644
> --- a/arch/x86/pci/mmconfig_32.c
> +++ b/arch/x86/pci/mmconfig_32.c
> @@ -68,9 +68,6 @@ err:          *value = -1;
>                 return -EINVAL;
>         }
>
> -       if (reg < 256)
> -               return pci_conf1_read(seg,bus,devfn,reg,len,value);
> -
>         base = get_base_addr(seg, bus, devfn);
>         if (!base)
>                 goto err;
> @@ -104,9 +101,6 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
>         if ((bus > 255) || (devfn > 255) || (reg > 4095))
>                 return -EINVAL;
>
> -       if (reg < 256)
> -               return pci_conf1_write(seg,bus,devfn,reg,len,value);
> -
>         base = get_base_addr(seg, bus, devfn);
>         if (!base)
>                 return -EINVAL;
> @@ -138,7 +132,7 @@ static struct pci_raw_ops pci_mmcfg = {
>
>  int __init pci_mmcfg_arch_init(void)
>  {
> -       printk(KERN_INFO "PCI: Using MMCONFIG\n");
> -       raw_pci_ops = &pci_mmcfg;
> +       printk(KERN_INFO "PCI: Using MMCONFIG for extended config space\n");
> +       raw_pci_ext_ops = &pci_mmcfg;
>         return 1;
>  }
> diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
> index c4cf318..9207fd4 100644
> --- a/arch/x86/pci/mmconfig_64.c
> +++ b/arch/x86/pci/mmconfig_64.c
> @@ -58,9 +58,6 @@ err:          *value = -1;
>                 return -EINVAL;
>         }
>
> -       if (reg < 256)
> -               return pci_conf1_read(seg,bus,devfn,reg,len,value);
> -
>         addr = pci_dev_base(seg, bus, devfn);
>         if (!addr)
>                 goto err;
> @@ -89,9 +86,6 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
>         if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
>                 return -EINVAL;
>
> -       if (reg < 256)
> -               return pci_conf1_write(seg,bus,devfn,reg,len,value);
> -
>         addr = pci_dev_base(seg, bus, devfn);
>         if (!addr)
>                 return -EINVAL;
> @@ -150,6 +144,6 @@ int __init pci_mmcfg_arch_init(void)
>                         return 0;
>                 }
>         }
> -       raw_pci_ops = &pci_mmcfg;
> +       raw_pci_ext_ops = &pci_mmcfg;
>         return 1;
>  }
> diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
> index 36cb44c..3431518 100644
> --- a/arch/x86/pci/pci.h
> +++ b/arch/x86/pci/pci.h
> @@ -85,10 +85,17 @@ extern spinlock_t pci_config_lock;
>  extern int (*pcibios_enable_irq)(struct pci_dev *dev);
>  extern void (*pcibios_disable_irq)(struct pci_dev *dev);
>
> -extern int pci_conf1_write(unsigned int seg, unsigned int bus,
> -                          unsigned int devfn, int reg, int len, u32 value);
> -extern int pci_conf1_read(unsigned int seg, unsigned int bus,
> -                         unsigned int devfn, int reg, int len, u32 *value);
> +struct pci_raw_ops {
> +       int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
> +                                               int reg, int len, u32 *val);
> +       int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
> +                                               int reg, int len, u32 val);
> +};
> +
> +extern struct pci_raw_ops *raw_pci_ops;
> +extern struct pci_raw_ops *raw_pci_ext_ops;
> +
> +extern struct pci_raw_ops pci_direct_conf1;
>
>  extern int pci_direct_probe(void);
>  extern void pci_direct_init(int type);
> diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
> index 8ecb1c7..c2df4e9 100644
> --- a/arch/x86/pci/visws.c
> +++ b/arch/x86/pci/visws.c
> @@ -13,9 +13,6 @@
>
>  #include "pci.h"
>
> -
> -extern struct pci_raw_ops pci_direct_conf1;
> -
>  static int pci_visws_enable_irq(struct pci_dev *dev) { return 0; }
>  static void pci_visws_disable_irq(struct pci_dev *dev) { }
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index e3a673a..f190db9 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -139,15 +139,6 @@ acpi_status __init acpi_os_initialize(void)
>
>  acpi_status acpi_os_initialize1(void)
>  {
> -       /*
> -        * Initialize PCI configuration space access, as we'll need to access
> -        * it while walking the namespace (bus 0 and root bridges w/ _BBNs).
> -        */
> -       if (!raw_pci_ops) {
> -               printk(KERN_ERR PREFIX
> -                      "Access to PCI configuration space unavailable\n");
> -               return AE_NULL_ENTRY;
> -       }
>         kacpid_wq = create_singlethread_workqueue("kacpid");
>         kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
>         BUG_ON(!kacpid_wq);
> @@ -498,11 +489,9 @@ acpi_os_read_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
>                 return AE_ERROR;
>         }
>
> -       BUG_ON(!raw_pci_ops);
> -
> -       result = raw_pci_ops->read(pci_id->segment, pci_id->bus,
> -                                  PCI_DEVFN(pci_id->device, pci_id->function),
> -                                  reg, size, value);
> +       result = raw_pci_read(pci_id->segment, pci_id->bus,
> +                               PCI_DEVFN(pci_id->device, pci_id->function),
> +                               reg, size, value);
>
>         return (result ? AE_ERROR : AE_OK);
>  }
> @@ -529,11 +518,9 @@ acpi_os_write_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
>                 return AE_ERROR;
>         }
>
> -       BUG_ON(!raw_pci_ops);
> -
> -       result = raw_pci_ops->write(pci_id->segment, pci_id->bus,
> -                                   PCI_DEVFN(pci_id->device, pci_id->function),
> -                                   reg, size, value);
> +       result = raw_pci_write(pci_id->segment, pci_id->bus,
> +                               PCI_DEVFN(pci_id->device, pci_id->function),
> +                               reg, size, value);
>
>         return (result ? AE_ERROR : AE_OK);
>  }
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index ba63619..1e71dc0 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -40,6 +40,9 @@ config ATA_ACPI
>           You can disable this at kernel boot time by using the
>           option libata.noacpi=1
>
> +config ATA_RAM
> +       tristate "ATA RAM driver"
> +

related?

YH
