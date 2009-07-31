Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbZGaNW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbZGaNW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZGaNW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:22:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:35284 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZGaNW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:22:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,302,1246863600"; 
   d="scan'208";a="537530157"
Date: Fri, 31 Jul 2009 21:22:48 +0800
From: Alek Du <alek.du@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <david-b@pacbell.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: [PATCH] mm gpio: Some fixing for Langwell GPIO driver
Message-ID: <20090731212248.7a3aa095@dxy.sh.intel.com>
In-Reply-To: <20090731170210.3372ca73@dxy.sh.intel.com>
References: <20090703210706.41288a2a@dxy.sh.intel.com>
	<20090730035941.16124ec0.akpm@linux-foundation.org>
	<20090731170210.3372ca73@dxy.sh.intel.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here is an incremental patch against gpio-add-intel-moorestown-platform-langwell-chip-gpio-driver.patch in mm tree.
And I think you can revert 2f69806ebbdd67a816ff971ede66ac6597ffb991 export symbols patch now.

BR,
Alek


>From 626bf5fede836670db918d47d38b6956e6f7f759 Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Fri, 31 Jul 2009 21:07:44 +0800
Subject: [PATCH] gpio: Some fixing for Langwell GPIO driver

1. remove module support.
2. add a mask handler to irqchip.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/gpio/Kconfig         |    2 +-
 drivers/gpio/langwell_gpio.c |   34 ++++++----------------------------
 2 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index c310d67..9748c0c 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -174,7 +174,7 @@ config GPIO_BT8XX
 	  If unsure, say N.
 
 config GPIO_LANGWELL
-	tristate "Intel Moorestown Platform Langwell GPIO support"
+	bool "Intel Moorestown Platform Langwell GPIO support"
 	depends on PCI
 	help
 	  Say Y here to support Intel Moorestown platform GPIO.
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index e338baa..e100583 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -152,8 +152,13 @@ static void lnw_irq_unmask(unsigned irq)
 	writel(BIT(gpio % 32), gedr);
 };
 
+static void lnw_irq_mask(unsigned irq)
+{
+};
+
 static struct irq_chip lnw_irqchip = {
 	.name		= "LNW-GPIO",
+	.mask		= lnw_irq_mask,
 	.unmask		= lnw_irq_unmask,
 	.set_type	= lnw_irq_type,
 };
@@ -277,27 +282,10 @@ done:
 	return retval;
 }
 
-static void __devexit lnw_gpio_remove(struct pci_dev *pdev)
-{
-	struct lnw_gpio *lnw = (struct lnw_gpio *)pci_get_drvdata(pdev);
-
-	if (gpiochip_remove(&lnw->chip)) {
-		dev_err(&pdev->dev, "langwell gpio driver remove error\n");
-		return;
-	}
-	pci_disable_device(pdev);
-	set_irq_chained_handler(pdev->irq, NULL);
-	pci_release_regions(pdev);
-	iounmap(lnw->reg_base);
-	pci_set_drvdata(pdev, NULL);
-	kfree(lnw);
-}
-
 static struct pci_driver lnw_gpio_driver = {
 	.name		= "langwell_gpio",
 	.id_table	= lnw_gpio_ids,
 	.probe		= lnw_gpio_probe,
-	.remove		= lnw_gpio_remove,
 };
 
 static int __init lnw_gpio_init(void)
@@ -305,14 +293,4 @@ static int __init lnw_gpio_init(void)
 	return pci_register_driver(&lnw_gpio_driver);
 }
 
-static void __exit lnw_gpio_exit(void)
-{
-	pci_unregister_driver(&lnw_gpio_driver);
-}
-
-MODULE_AUTHOR("Alek Du <alek.du@intel.com>");
-MODULE_DESCRIPTION("Intel Moorestown Platform Langwell chip GPIO driver");
-MODULE_LICENSE("GPL v2");
-
-module_init(lnw_gpio_init);
-module_exit(lnw_gpio_exit);
+device_initcall(lnw_gpio_init);
-- 
1.6.0.4


On Fri, 31 Jul 2009 17:02:10 +0800
Alek Du <alek.du@intel.com> wrote:

> Andrew,
> 
> Sorry for late response. Yes, you are right, there is no meaning to build it as module, it should be changed to bool.
> I will submit a new patch soon, I also need a mask handler to irqchip .... otherwise the free_irq will report a error.
> 
> Thanks,
> Alek
> 
> 
> 
> 
> On Thu, 30 Jul 2009 18:59:41 +0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 3 Jul 2009 21:07:06 +0800 Alek Du <alek.du@intel.com> wrote:
> > 
> > > Changes from v2:
> > > 1. Add missed MODULE_DEVICE_TABLE
> > > 
> > > Changes from v1:
> > > 1. driver name changed from lnw.c ==> langwell_gpio.c
> > > 2. removed hard coded driver data, now we get it from PCI bar1 (platform init code fills it)
> > > 3. removed alternative function setting code, it should be called in platform init part.
> > > 4. misc. style clean
> > > 
> > > 
> > > >From 8eaad3aac8cffda193adcfc4b9fcbb7c461fd4b9 Mon Sep 17 00:00:00 2001
> > > From: Alek Du <alek.du@intel.com>
> > > Date: Tue, 30 Jun 2009 12:13:27 +0800
> > > Subject: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio driver
> > > 
> > > The Langwell chip is the IO hub for Intel Moorestown platform which has a
> > > 64-pin gpio block device inside. It is exposed as a dedicated PCI device.
> > > We use it to control outside peripheral as well as to do IRQ demuxing. The
> > > gpio block uses MSI to send level type interrupt to IOAPIC.
> > 
> > The driver breaks the x86-64 allmodconfig build:
> > 
> > ERROR: "irq_to_desc" [drivers/gpio/langwell_gpio.ko] undefined!
> > ERROR: "set_irq_chip_and_handler_name" [drivers/gpio/langwell_gpio.ko] undefined!
> > ERROR: "handle_simple_irq" [drivers/gpio/langwell_gpio.ko] undefined!
> > 
> > Does it make any sense to build this driver as a module?  If not, it
> > should be changed to def_bool.  If so...
> > 
> > 
> > 
> >  kernel/irq/chip.c   |    2 ++
> >  kernel/irq/handle.c |    1 +
> >  2 files changed, 3 insertions(+)
> > 
> > diff -puN kernel/irq/handle.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch kernel/irq/handle.c
> > --- a/kernel/irq/handle.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch
> > +++ a/kernel/irq/handle.c
> > @@ -192,6 +192,7 @@ struct irq_desc *irq_to_desc(unsigned in
> >  
> >  	return NULL;
> >  }
> > +EXPORT_SYMBOL(irq_to_desc);
> >  
> >  struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
> >  {
> > diff -puN kernel/irq/chip.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch kernel/irq/chip.c
> > --- a/kernel/irq/chip.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch
> > +++ a/kernel/irq/chip.c
> > @@ -340,6 +340,7 @@ handle_simple_irq(unsigned int irq, stru
> >  out_unlock:
> >  	spin_unlock(&desc->lock);
> >  }
> > +EXPORT_SYMBOL(handle_simple_irq);
> >  
> >  /**
> >   *	handle_level_irq - Level type irq handler
> > @@ -609,6 +610,7 @@ set_irq_chip_and_handler_name(unsigned i
> >  	set_irq_chip(irq, chip);
> >  	__set_irq_handler(irq, handle, 0, name);
> >  }
> > +EXPORT_SYMBOL(set_irq_chip_and_handler_name);
> >  
> >  void __init set_irq_noprobe(unsigned int irq)
> >  {
> > _
> > 
> > 
