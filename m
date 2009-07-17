Return-Path: <linux-kernel-owner+w=401wt.eu-S934261AbZGQInL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261AbZGQInL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 04:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934241AbZGQInK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 04:43:10 -0400
Received: from centrinvest.ru ([94.25.115.130]:42303 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934240AbZGQInI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 04:43:08 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Fri, 17 Jul 2009 12:43:03 +0400
To: Denis Turischev <denis@compulab.co.il>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: Re: SBC-FITPC2 watchdog support
Message-ID: <20090717084303.GA11781@centrinvest.ru>
Mail-Followup-To: Denis Turischev <denis@compulab.co.il>,
	Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
References: <4A5F1D12.2080907@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4A5F1D12.2080907@compulab.co.il>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 197, 07 16, 2009 at 03:29:06PM +0300, Denis Turischev wrote:
> Adds support to watchdog timer on SBC-FITPC2 board by Compulab.
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

1. please add [PATCH] to email subject next time
2. patch is wordwrapped by mailer, read Documentation/email-clients.txt
3. use request_region() to reserve ioport region
4. you can use DMI info from you reboot quirk patch to test that you
   are really running on SBC-FITPC2. You'll also get module autoload 
   as a bonus.

> diff -Nru linux-2.6.31-rc3.orig/drivers/watchdog/Kconfig
> linux-2.6.31-rc3/drivers/watchdog/Kconfig
> --- linux-2.6.31-rc3.orig/drivers/watchdog/Kconfig      2009-07-14
> 04:18:52.000000000 +0300
> +++ linux-2.6.31-rc3/drivers/watchdog/Kconfig   2009-07-16
> 13:52:08.000000000 +0300
> @@ -721,6 +721,28 @@
>           To compile this driver as a module, choose M here: the
>           module will be called sbc_epx_c3.
> 
> +config SBC_FITPC2_WATCHDOG
> +       tristate "Compulab SBC-FITPC2 watchdog"
> +       depends on X86
> +       ---help---
> +         This is the driver for the built-in watchdog timer on the fit-PC2
> +         Single-board computer made by Compulab.
> +
> +         It`s possible to enable watchdog timer either from BIOS (F2)
> or from booted Linux.
> +         When "Watchdog Timer Value" enabled one can set 31-255 s
> operational range.
> +
> +         Entering BIOS setup temporary disables watchdog operation
> regardless to current state,
> +         so system will not be restarted while user in BIOS setup.
> +
> +         Once watchdog was enabled the system will be restarted every
> +         "Watchdog Timer Value" period, so to prevent it user can
> restart or
> +         disable the watchdog.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called sbc_fitpc2_wdt.
> +
> +         Most people will say N.
> +
>  # M32R Architecture
> 
>  # M68K Architecture
> diff -Nru linux-2.6.31-rc3.orig/drivers/watchdog/Makefile
> linux-2.6.31-rc3/drivers/watchdog/Makefile
> --- linux-2.6.31-rc3.orig/drivers/watchdog/Makefile     2009-07-14
> 04:18:52.000000000 +0300
> +++ linux-2.6.31-rc3/drivers/watchdog/Makefile  2009-07-16
> 13:47:44.000000000 +0300
> @@ -93,6 +93,7 @@
>  obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
>  obj-$(CONFIG_MACHZ_WDT) += machzwd.o
>  obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
> +obj-$(CONFIG_SBC_FITPC2_WATCHDOG) += sbc_fitpc2_wdt.o
> 
>  # M32R Architecture
> 
> diff -Nru linux-2.6.31-rc3.orig/drivers/watchdog/sbc_fitpc2_wdt.c
> linux-2.6.31-rc3/drivers/watchdog/sbc_fitpc2_wdt.c
> --- linux-2.6.31-rc3.orig/drivers/watchdog/sbc_fitpc2_wdt.c    
> 1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.31-rc3/drivers/watchdog/sbc_fitpc2_wdt.c  2009-07-16
> 14:03:35.000000000 +0300
> @@ -0,0 +1,219 @@
> +/*
> + * Watchdog driver for SBC-FITPC2 board
> + *
> + * Author: Denis Turischev <denis@compulab.co.il>
> + *
> + * Adapted from the IXP2000 watchdog driver by Deepak Saxena.
> + *
> + * This file is licensed under  the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/miscdevice.h>
> +#include <linux/watchdog.h>
> +#include <linux/ioport.h>
> +#include <linux/delay.h>
> +#include <linux/notifier.h>
> +#include <linux/fs.h>
> +#include <linux/reboot.h>
> +#include <linux/init.h>
> +#include <linux/moduleparam.h>
> +
> +#include <linux/io.h>
> +#include <linux/uaccess.h>
> +#include <asm/system.h>
> +
> +static int nowayout = WATCHDOG_NOWAYOUT;
> +static unsigned int margin = 60;       /* (secs) Default is 1 minute */
> +static unsigned long wdt_status;
> +static spinlock_t wdt_lock;
> +
> +#define        WDT_IN_USE              0
> +#define        WDT_OK_TO_CLOSE         1
> +
> +#define COMMAND_PORT           0x4c
> +#define DATA_PORT              0x48
> +
> +#define IFACE_ON_COMMAND       1
> +#define REBOOT_COMMAND         2
> +
> +static void wdt_send_data(unsigned char command, unsigned char data)
> +{
> +       outb(command, COMMAND_PORT);
> +       mdelay(100);
> +       outb(data, DATA_PORT);
> +       mdelay(200);
> +}
> +
> +static void wdt_enable(void)
> +{
> +       spin_lock(&wdt_lock);
> +       wdt_send_data(IFACE_ON_COMMAND, 1);
> +       wdt_send_data(REBOOT_COMMAND, margin);
> +       spin_unlock(&wdt_lock);
> +}
> +
> +static void wdt_disable(void)
> +{
> +       spin_lock(&wdt_lock);
> +       wdt_send_data(IFACE_ON_COMMAND, 0);
> +       wdt_send_data(REBOOT_COMMAND, 0);
> +       spin_unlock(&wdt_lock);
> +}
> +
> +static int fitpc2_wdt_open(struct inode *inode, struct file *file)
> +{
> +       if (test_and_set_bit(WDT_IN_USE, &wdt_status))
> +               return -EBUSY;
> +
> +       clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
> +
> +       wdt_enable();
> +
> +       return nonseekable_open(inode, file);
> +}
> +
> +static ssize_t
> +fitpc2_wdt_write(struct file *file, const char *data, size_t len,
> loff_t *ppos)
> +{
> +       if (len) {
> +               if (!nowayout) {
> +                       size_t i;
> +
> +                       clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
> +
> +                       for (i = 0; i != len; i++) {
> +                               char c;
> +
> +                               if (get_user(c, data + i))
> +                                       return -EFAULT;
> +
> +                               if (c == 'V')
> +                                       set_bit(WDT_OK_TO_CLOSE,
> &wdt_status);
> +                       }
> +               }
> +               wdt_enable();
> +       }
> +
> +       return len;
> +}
> +
> +
> +static struct watchdog_info ident = {
> +       .options        = WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
> +                               WDIOF_KEEPALIVEPING,
> +       .identity       = "SBC-FITPC2 Watchdog",
> +};
> +
> +
> +static long
> +fitpc2_wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +       int ret = -ENOTTY;
> +       int time;
> +
> +       switch (cmd) {
> +       case WDIOC_GETSUPPORT:
> +               ret = copy_to_user((struct watchdog_info *)arg, &ident,
> +                                  sizeof(ident)) ? -EFAULT : 0;
> +               break;
> +
> +       case WDIOC_GETSTATUS:
> +               ret = put_user(0, (int *)arg);
> +               break;
> +
> +       case WDIOC_GETBOOTSTATUS:
> +               ret = put_user(0, (int *)arg);
> +               break;
> +
> +       case WDIOC_KEEPALIVE:
> +               wdt_enable();
> +               ret = 0;
> +               break;
> +
> +       case WDIOC_SETTIMEOUT:
> +               ret = get_user(time, (int *)arg);
> +               if (ret)
> +                       break;
> +
> +               if (time < 31 || time > 255) {
> +                       ret = -EINVAL;
> +                       break;
> +               }
> +
> +               margin = time;
> +               wdt_enable();
> +               /* Fall through */
> +
> +       case WDIOC_GETTIMEOUT:
> +               ret = put_user(margin, (int *)arg);
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +static int fitpc2_wdt_release(struct inode *inode, struct file *file)
> +{
> +       if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
> +               wdt_disable();
> +       } else {
> +               printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
> +                       "timer will not stop\n");
> +       }
> +
> +       clear_bit(WDT_IN_USE, &wdt_status);
> +       clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
> +
> +       return 0;
> +}
> +
> +
> +static const struct file_operations fitpc2_wdt_fops = {
> +       .owner          = THIS_MODULE,
> +       .llseek         = no_llseek,
> +       .write          = fitpc2_wdt_write,
> +       .unlocked_ioctl = fitpc2_wdt_ioctl,
> +       .open           = fitpc2_wdt_open,
> +       .release        = fitpc2_wdt_release,
> +};
> +
> +static struct miscdevice fitpc2_wdt_miscdev = {
> +       .minor          = WATCHDOG_MINOR,
> +       .name           = "watchdog",
> +       .fops           = &fitpc2_wdt_fops,
> +};
> +
> +static int __init fitpc2_wdt_init(void)
> +{
> +       if (margin < 31 || margin > 255) {
> +               printk(KERN_CRIT "WATCHDOG: margin must be in range 31 -
> 255"
> +               " seconds, you tried to set %d\n", margin);
> +               return -EINVAL;
> +       }
> +       return misc_register(&fitpc2_wdt_miscdev);
> +}
> +
> +static void __exit fitpc2_wdt_exit(void)
> +{
> +       misc_deregister(&fitpc2_wdt_miscdev);
> +}
> +
> +module_init(fitpc2_wdt_init);
> +module_exit(fitpc2_wdt_exit);
> +
> +MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
> +MODULE_DESCRIPTION("SBC-FITPC2 Watchdog");
> +
> +module_param(margin, int, 0);
> +MODULE_PARM_DESC(margin, "Watchdog margin in seconds (default 60s)");
> +
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
> +
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> +
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
