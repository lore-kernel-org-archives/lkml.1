Return-Path: <linux-kernel-owner+w=401wt.eu-S1751138AbZG3FAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbZG3FAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 01:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZG3FAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 01:00:11 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:50784 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbZG3FAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 01:00:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAK/FcEpR9dpW/2dsb2JhbADSSwmCKYFfBYFJ
Date: Thu, 30 Jul 2009 07:00:06 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add watchdog driver for w90p910
Message-ID: <20090730050006.GD30892@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com> <e68bb3470907291817l69b3a0c9sac96d8fb828e2fb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e68bb3470907291817l69b3a0c9sac96d8fb828e2fb5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

will be reviewed still this week.

Kind regards,
Wim.

> Dear Wim,
> 
> How about this watchdog patch?
> Would you mind applying?
> 
> Thanks for your help.
> 
> 2009/7/24, Wan ZongShun <mcuos.com@gmail.com>:
> > Dear Wim Van Sebroeck,
> >
> > This is a watchdog driver for my w90p910 platform.
> >
> > Thanks!
> >
> >
> >
> > Add watchdog driver for w90p910 platform.
> >
> > Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
> >
> > ---
> >  drivers/watchdog/Kconfig       |    9 +
> >  drivers/watchdog/Makefile      |    1 +
> >  drivers/watchdog/w90p910_wdt.c |  340 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 350 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/watchdog/w90p910_wdt.c
> >
> > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > index b1ccc04..fba4b91 100644
> > --- a/drivers/watchdog/Kconfig
> > +++ b/drivers/watchdog/Kconfig
> > @@ -266,6 +266,15 @@ config STMP3XXX_WATCHDOG
> >          To compile this driver as a module, choose M here: the
> >          module will be called stmp3xxx_wdt.
> >
> > +config W90P910_WATCHDOG
> > +       tristate "Nuvoton W90P910 watchdog"
> > +       depends on ARCH_W90X900
> > +       help
> > +         Say Y here if to include support for the watchdog timer
> > +         for the Nuvoton W90P910 SoC.
> > +         To compile this driver as a module, choose M here: the
> > +         module will be called w90p910_wdt.
> > +
> >  # AVR32 Architecture
> >
> >  config AT32AP700X_WDT
> > diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> > index 3d77429..ecc05b4 100644
> > --- a/drivers/watchdog/Makefile
> > +++ b/drivers/watchdog/Makefile
> > @@ -44,6 +44,7 @@ obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
> >  obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
> >  obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
> >  obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
> > +obj-$(CONFIG_W90P910_WATCHDOG) += w90p910_wdt.o
> >
> >  # AVR32 Architecture
> >  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
> > diff --git a/drivers/watchdog/w90p910_wdt.c b/drivers/watchdog/w90p910_wdt.c
> > new file mode 100644
> > index 0000000..a73f85a
> > --- /dev/null
> > +++ b/drivers/watchdog/w90p910_wdt.c
> > @@ -0,0 +1,340 @@
> > +/*
> > + * Copyright (c) 2009 Nuvoton technology corporation.
> > + *
> > + * Wan ZongShun <mcuos.com@gmail.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation;version 2 of the License.
> > + *
> > + */
> > +
> > +#include <linux/bitops.h>
> > +#include <linux/errno.h>
> > +#include <linux/fs.h>
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/clk.h>
> > +#include <linux/kernel.h>
> > +#include <linux/miscdevice.h>
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/types.h>
> > +#include <linux/watchdog.h>
> > +#include <linux/uaccess.h>
> > +
> > +#define WDT_DEFAULT_TIME_LEVEL 0       /* if 0, time = 2^14 clocks */
> > +#define WDT_MAX_TIME_LEVEL     3       /* if 3, time = 2^20 clocks */
> > +#define REG_WTCR               0x1c
> > +#define WTCLK                  (0x01 << 10)
> > +#define WTE                    (0x01 << 7)     /*wdt enable*/
> > +#define WTIE                   (0x01 << 6)     /*wdt interrupt enable*/
> > +#define WTISBIT                        (0x04)
> > +#define WTIS                   (0x03 << 4)
> > +#define WTIF                   (0x01 << 3)
> > +#define WTRF                   (0x01 << 2)
> > +#define WTRE                   (0x01 << 1)
> > +#define WTR                    0x01
> > +
> > +static int wdt_time = WDT_DEFAULT_TIME_LEVEL;
> > +static int nowayout = WATCHDOG_NOWAYOUT;
> > +
> > +module_param(wdt_time, int, 0);
> > +MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
> > +                               __MODULE_STRING(WDT_DEFAULT_TIME) ")");
> > +
> > +#ifdef CONFIG_WATCHDOG_NOWAYOUT
> > +module_param(nowayout, int, 0);
> > +MODULE_PARM_DESC(nowayout,
> > +               "Watchdog cannot be stopped once started (default="
> > +                               __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> > +#endif
> > +
> > +struct w90p910_wdt {
> > +       struct resource  *res;
> > +       struct clk       *wdt_clock;
> > +       struct platform_device *pdev;
> > +       unsigned int     open_lock;
> > +       unsigned int     wdt_irq;
> > +       void __iomem     *wdt_base;
> > +       char             expect_close;
> > +       spinlock_t       wdt_lock;
> > +};
> > +
> > +static unsigned long w90p910wdt_busy;
> > +struct w90p910_wdt *w90p910_wdt;
> > +
> > +static void w90p910_wdt_keepalive(void)
> > +{
> > +       unsigned int val;
> > +
> > +       spin_lock(&w90p910_wdt->wdt_lock);
> > +
> > +       val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
> > +       val |= (WTR | WTIF);
> > +       __raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
> > +
> > +       spin_unlock(&w90p910_wdt->wdt_lock);
> > +}
> > +
> > +static irqreturn_t w90p910_wdt_irq(int irq, void *dev_id)
> > +{
> > +       w90p910_wdt_keepalive();
> > +       return IRQ_HANDLED;
> > +}
> > +
> > +static inline void w90p910_wdt_stop(void)
> > +{
> > +       unsigned int val;
> > +
> > +       spin_lock(&w90p910_wdt->wdt_lock);
> > +
> > +       val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
> > +       val &= ~WTE;
> > +       __raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
> > +
> > +       spin_unlock(&w90p910_wdt->wdt_lock);
> > +}
> > +
> > +static inline void w90p910_wdt_start(void)
> > +{
> > +       unsigned int val;
> > +
> > +       spin_lock(&w90p910_wdt->wdt_lock);
> > +
> > +       val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
> > +       val |= (WTRE | WTIE | WTE | WTR | WTCLK | WTIF);
> > +       val |= (wdt_time << 0x04);
> > +       __raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
> > +
> > +       spin_unlock(&w90p910_wdt->wdt_lock);
> > +}
> > +
> > +static int w90p910_wdt_open(struct inode *inode, struct file *file)
> > +{
> > +
> > +       if (test_and_set_bit(0, &w90p910wdt_busy))
> > +               return -EBUSY;
> > +
> > +       w90p910_wdt_start();
> > +       return nonseekable_open(inode, file);
> > +}
> > +
> > +static int w90p910_wdt_close(struct inode *inode, struct file *file)
> > +{
> > +       if (!nowayout)
> > +               w90p910_wdt_stop();
> > +
> > +       clear_bit(0, &w90p910wdt_busy);
> > +       return 0;
> > +}
> > +
> > +static int w90p910_wdt_settimeout(int new_time_level)
> > +{
> > +       unsigned int val;
> > +
> > +       if ((new_time_level < 0) || (new_time_level > WDT_MAX_TIME_LEVEL))
> > +               return -EINVAL;
> > +
> > +       val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
> > +       val &= ~WTIS;
> > +       val |= new_time_level;
> > +       __raw_writel(val, w90p910_wdt->wdt_base + REG_WTCR);
> > +
> > +       wdt_time = new_time_level;
> > +       return 0;
> > +}
> > +
> > +static struct watchdog_info w90p910_wdt_info = {
> > +       .identity       = "w90p910 watchdog",
> > +       .options        = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
> > +};
> > +
> > +static long w90p910_wdt_ioctl(struct file *file,
> > +                                       unsigned int cmd, unsigned long arg)
> > +{
> > +       void __user *argp = (void __user *)arg;
> > +       int __user *p = argp;
> > +       int new_value;
> > +
> > +       switch (cmd) {
> > +       case WDIOC_GETSUPPORT:
> > +               return copy_to_user(argp, &w90p910_wdt_info,
> > +                               sizeof(w90p910_wdt_info)) ? -EFAULT : 0;
> > +       case WDIOC_GETSTATUS:
> > +       case WDIOC_GETBOOTSTATUS:
> > +               return put_user(0, p);
> > +       case WDIOC_SETOPTIONS:
> > +               if (get_user(new_value, p))
> > +                       return -EFAULT;
> > +               if (new_value & WDIOS_DISABLECARD)
> > +                       w90p910_wdt_stop();
> > +               if (new_value & WDIOS_ENABLECARD)
> > +                       w90p910_wdt_start();
> > +               return 0;
> > +       case WDIOC_KEEPALIVE:
> > +               w90p910_wdt_keepalive();
> > +               return 0;
> > +       case WDIOC_SETTIMEOUT:
> > +               if (get_user(new_value, p))
> > +                       return -EFAULT;
> > +               if (w90p910_wdt_settimeout(new_value))
> > +                       return -EINVAL;
> > +
> > +               w90p910_wdt_start();
> > +
> > +               return put_user(wdt_time, p);
> > +       case WDIOC_GETTIMEOUT:
> > +               return put_user(wdt_time, p);
> > +       default:
> > +               return -ENOTTY;
> > +       }
> > +}
> > +
> > +static ssize_t w90p910_wdt_write(struct file *file, const char *data,
> > +                                               size_t len, loff_t *ppos)
> > +{
> > +       w90p910_wdt_keepalive();
> > +       return len;
> > +}
> > +
> > +static const struct file_operations w90p910wdt_fops = {
> > +       .owner          = THIS_MODULE,
> > +       .llseek         = no_llseek,
> > +       .unlocked_ioctl = w90p910_wdt_ioctl,
> > +       .open           = w90p910_wdt_open,
> > +       .release        = w90p910_wdt_close,
> > +       .write          = w90p910_wdt_write,
> > +};
> > +
> > +static struct miscdevice w90p910wdt_miscdev = {
> > +       .minor          = WATCHDOG_MINOR,
> > +       .name           = "watchdog",
> > +       .fops           = &w90p910wdt_fops,
> > +};
> > +
> > +static int __devinit w90p910wdt_probe(struct platform_device *pdev)
> > +{
> > +       int ret;
> > +
> > +       w90p910_wdt = kzalloc(sizeof(struct w90p910_wdt), GFP_KERNEL);
> > +       if (!w90p910_wdt)
> > +               return -ENOMEM;
> > +
> > +       w90p910_wdt->pdev = pdev;
> > +
> > +       w90p910_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +       if (w90p910_wdt->res == NULL) {
> > +               dev_err(&pdev->dev, "no memory resource specified\n");
> > +               ret = -ENOENT;
> > +               goto err_get;
> > +       }
> > +
> > +       if (!request_mem_region(w90p910_wdt->res->start,
> > +                               resource_size(w90p910_wdt->res), pdev->name)) {
> > +               dev_err(&pdev->dev, "failed to get memory region\n");
> > +               ret = -ENOENT;
> > +               goto err_req;
> > +       }
> > +
> > +       w90p910_wdt->wdt_base = ioremap(w90p910_wdt->res->start,
> > +                                       resource_size(w90p910_wdt->res));
> > +       if (w90p910_wdt->wdt_base == NULL) {
> > +               dev_err(&pdev->dev, "failed to ioremap() region\n");
> > +               ret = -EINVAL;
> > +               goto err_req;
> > +       }
> > +
> > +       w90p910_wdt->wdt_irq = platform_get_irq(pdev, 0);
> > +       ret = request_irq(w90p910_wdt->wdt_irq,
> > +                               w90p910_wdt_irq, 0, pdev->name, NULL);
> > +       if (ret != 0) {
> > +               dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
> > +               goto err_map;
> > +       }
> > +
> > +       w90p910_wdt->wdt_clock = clk_get(&pdev->dev, NULL);
> > +       if (IS_ERR(w90p910_wdt->wdt_clock)) {
> > +               dev_err(&pdev->dev, "failed to find watchdog clock source\n");
> > +               ret = PTR_ERR(w90p910_wdt->wdt_clock);
> > +               goto err_irq;
> > +       }
> > +
> > +       clk_enable(w90p910_wdt->wdt_clock);
> > +
> > +       if (misc_register(&w90p910wdt_miscdev)) {
> > +               dev_err(&pdev->dev, "err register miscdev on minor=%d (%d)\n",
> > +                       WATCHDOG_MINOR, ret);
> > +               goto err_clk;
> > +       }
> > +
> > +       return 0;
> > +
> > +err_clk:
> > +       clk_disable(w90p910_wdt->wdt_clock);
> > +       clk_put(w90p910_wdt->wdt_clock);
> > +err_irq:
> > +       free_irq(w90p910_wdt->wdt_irq, NULL);
> > +err_map:
> > +       iounmap(w90p910_wdt->wdt_base);
> > +err_req:
> > +       release_mem_region(w90p910_wdt->res->start,
> > +                                       resource_size(w90p910_wdt->res));
> > +err_get:
> > +       kfree(w90p910_wdt);
> > +       return ret;
> > +}
> > +
> > +static int __devexit w90p910wdt_remove(struct platform_device *pdev)
> > +{
> > +       free_irq(w90p910_wdt->wdt_irq, NULL);
> > +
> > +       clk_disable(w90p910_wdt->wdt_clock);
> > +       clk_put(w90p910_wdt->wdt_clock);
> > +
> > +       iounmap(w90p910_wdt->wdt_base);
> > +
> > +       release_mem_region(w90p910_wdt->res->start,
> > +                                       resource_size(w90p910_wdt->res));
> > +
> > +       kfree(w90p910_wdt);
> > +
> > +       misc_deregister(&w90p910wdt_miscdev);
> > +       return 0;
> > +}
> > +
> > +static void w90p910wdt_shutdown(struct platform_device *pdev)
> > +{
> > +       w90p910_wdt_stop();
> > +}
> > +
> > +static struct platform_driver w90p910wdt_driver = {
> > +       .probe          = w90p910wdt_probe,
> > +       .remove         = __devexit_p(w90p910wdt_remove),
> > +       .shutdown       = w90p910wdt_shutdown,
> > +       .driver         = {
> > +               .name   = "w90p910-wdt",
> > +               .owner  = THIS_MODULE,
> > +       },
> > +};
> > +
> > +static int __init w90p910_wdt_init(void)
> > +{
> > +       return platform_driver_register(&w90p910wdt_driver);
> > +}
> > +
> > +static void __exit w90p910_wdt_exit(void)
> > +{
> > +       platform_driver_unregister(&w90p910wdt_driver);
> > +}
> > +
> > +module_init(w90p910_wdt_init);
> > +module_exit(w90p910_wdt_exit);
> > +
> > +MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
> > +MODULE_DESCRIPTION("Watchdog driver for W90P910");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> > +MODULE_ALIAS("platform:w90p910-wdt");
> > --
> > 1.5.6.3
> >
> 
> 
> -- 
> Wan z.s
