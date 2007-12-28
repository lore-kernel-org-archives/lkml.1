Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbXL1PNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbXL1PNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 10:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXL1PN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 10:13:26 -0500
Received: from mail0.scram.de ([78.47.204.202]:45507 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbXL1PNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 10:13:25 -0500
X-Spam-Score: -3.993
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <47751287.6000801@scram.de>
Date: Fri, 28 Dec 2007 16:13:11 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: wim@iguana.be
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH/RFC] Add support for PowerQUICC watchdog
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PowerQUICC series has a watchdog which can be activated by the boot
loader and then needs to be reset in regular intervals. Once the
watchdog is enabled, it can't be disabled anymore. This patch adds
support for this kind of watchdog. An early init function is provided to
manually reset the watchdog in early board setup. Later, a kernel timer
is used to reset the watchdog until the watchdog driver is opened from
user space. This replaces mpc8xx_wdt.c (only usable for ARCH=ppc) and
mpc83xx_wdt.c (untested on this platform).

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/platforms/8xx/mpc86xads_setup.c |    5 +
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |    5 +
 arch/powerpc/sysdev/Makefile                 |    3 +
 arch/powerpc/sysdev/pq_wdt.c                 |  204 +++++++++++++++++++++++
 arch/powerpc/sysdev/pq_wdt.h                 |   28 ++++
 drivers/watchdog/Kconfig                     |   13 ++-
 drivers/watchdog/Makefile                    |    1 +
 drivers/watchdog/pq_wdt.c                    |  222 ++++++++++++++++++++++++++
 8 files changed, 480 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/sysdev/pq_wdt.c
 create mode 100644 arch/powerpc/sysdev/pq_wdt.h
 create mode 100644 drivers/watchdog/pq_wdt.c

diff --git a/arch/powerpc/platforms/8xx/mpc86xads_setup.c b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
index 4901283..c468ec2 100644
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -38,6 +38,7 @@
 #include <asm/prom.h>
 
 #include <sysdev/commproc.h>
+#include <sysdev/pq_wdt.h>
 
 static void init_smc1_uart_ioports(struct fs_uart_platform_info* fpi);
 static void init_smc2_uart_ioports(struct fs_uart_platform_info* fpi);
@@ -251,6 +252,10 @@ static void __init mpc86xads_setup_arch(void)
 	mpc86xads_board_setup();
 
 	ROOT_DEV = Root_NFS;
+
+#if defined(CONFIG_PQ_WDT) || defined(CONFIG_PQ_WDT_MODULE)
+	pq_wdt_early_init();
+#endif
 }
 
 static int __init mpc86xads_probe(void)
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 2cf1b6a..f076b67 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -41,6 +41,7 @@
 #include <asm/udbg.h>
 
 #include <sysdev/commproc.h>
+#include <sysdev/pq_wdt.h>
 
 static u32 __iomem *bcsr, *bcsr5;
 
@@ -246,6 +247,10 @@ static void __init mpc885ads_setup_arch(void)
 	m8xx_pcmcia_ops.hw_ctrl = pcmcia_hw_setup;
 	m8xx_pcmcia_ops.voltage_set = pcmcia_set_voltage;
 #endif
+
+#if defined(CONFIG_PQ_WDT) || defined(CONFIG_PQ_WDT_MODULE)
+	pq_wdt_early_init();
+#endif
 }
 
 static int __init mpc885ads_probe(void)
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 99a77d7..84f190e 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -35,5 +35,8 @@ obj-$(CONFIG_CPM)		+= cpm_common.o
 obj-$(CONFIG_CPM2)		+= cpm2_common.o cpm2_pic.o
 obj-$(CONFIG_PPC_DCR)		+= dcr.o
 obj-$(CONFIG_8xx)		+= mpc8xx_pic.o commproc.o
+ifneq ($(CONFIG_PQ_WDT),)
+obj-y				+= pq_wdt.o
+endif
 obj-$(CONFIG_UCODE_PATCH)	+= micropatch.o
 endif
diff --git a/arch/powerpc/sysdev/pq_wdt.c b/arch/powerpc/sysdev/pq_wdt.c
new file mode 100644
index 0000000..0adbe42
--- /dev/null
+++ b/arch/powerpc/sysdev/pq_wdt.c
@@ -0,0 +1,204 @@
+/*
+ * pq_wdt.c - Freescale PowerQUICC watchdog driver
+ *
+ * Author: Florian Schirmer <jolt@tuxbox.org>
+ *
+ * 2002 (c) Florian Schirmer <jolt@tuxbox.org> This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ *
+ * 2007 (c) Jochen Friedrich <jochen@scram.de> ported to ARCH=powerpc and
+ * extended to be useful on any Power QUICC 1/2/2pro which have the same
+ * style of watchdog.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <asm/irq.h>
+#include <asm/io.h>
+#include <asm/prom.h>
+
+#include "pq_wdt.h"
+
+struct pq_wdt {
+	__be32 res0;
+	__be32 swcrr; /* System watchdog control register */
+	__be32 swcnr; /* System watchdog count register */
+	u8 res1[2];
+	__be16 swsrr; /* System watchdog service register */
+};
+
+static int wdt_timeout;
+static int wdt_freq;
+static struct pq_wdt __iomem *wdt_reg;
+static int wdt_scale;
+
+void pq_wdt_reset(void)
+{
+	if (!wdt_reg)
+		return;
+
+	out_be16(&wdt_reg->swsrr, 0x556c);	/* write magic1 */
+	out_be16(&wdt_reg->swsrr, 0xaa39);	/* write magic2 */
+}
+EXPORT_SYMBOL(pq_wdt_reset);
+
+static void wdt_timer_func(unsigned long data);
+
+static struct timer_list wdt_timer =
+	TIMER_INITIALIZER(wdt_timer_func, 0, 0);
+
+void pq_wdt_stop_timer(void)
+{
+	del_timer(&wdt_timer);
+}
+EXPORT_SYMBOL_GPL(pq_wdt_stop_timer);
+
+void pq_wdt_install_timer(void)
+{
+	pq_wdt_reset();
+	mod_timer(&wdt_timer, jiffies + (HZ/2));
+}
+EXPORT_SYMBOL_GPL(pq_wdt_install_timer);
+
+static void wdt_timer_func(unsigned long data)
+{
+	pq_wdt_install_timer();
+}
+
+int pq_wdt_present(void)
+{
+	if (!wdt_reg)
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pq_wdt_present);
+
+int pq_wdt_get_timeout(void)
+{
+	return wdt_timeout / wdt_freq;
+}
+EXPORT_SYMBOL_GPL(pq_wdt_get_timeout);
+
+static int wdt_readparam(void)
+{
+	u32 swcrr;
+
+	if (!wdt_reg)
+		return -ENODEV;
+
+	wdt_timeout = 0;
+
+	swcrr = in_be32(&wdt_reg->swcrr);
+
+	if (!(swcrr & SWCRR_SWEN)) {
+		printk(KERN_NOTICE "pq_wdt: wdt disabled (SWCRR: 0x%08X)\n",
+		       swcrr);
+		return -ENODEV;
+	}
+
+	pq_wdt_reset();
+
+	printk(KERN_NOTICE
+	       "pq_wdt: active wdt found (SWTC: 0x%04X, SWP: 0x%01X)\n",
+	       (swcrr >> 16), swcrr & 0x07);
+
+	wdt_timeout = (swcrr >> 16) & 0xFFFF;
+
+	if (!wdt_timeout)
+		wdt_timeout = 0xFFFF;
+
+	if (swcrr & SWCRR_SWPR)
+		wdt_timeout *= wdt_scale;
+
+	return 0;
+}
+
+int pq_wdt_setup(int value)
+{
+	if (!wdt_reg)
+		return -ENODEV;
+		
+	out_be32(&wdt_reg->swcrr, value);
+	return wdt_readparam();
+}
+EXPORT_SYMBOL_GPL(pq_wdt_setup);
+
+int __init pq_wdt_init_timer(void)
+{
+	int ret;
+
+	if (!wdt_reg) {
+		ret = pq_wdt_early_init();
+		if (ret)
+			return ret;
+	}
+
+	if (!wdt_reg)
+		return -ENODEV;
+
+	pq_wdt_install_timer();
+	return 0;
+}
+arch_initcall(pq_wdt_init_timer);
+
+int __init pq_wdt_early_init(void)
+{
+	struct device_node *np, *soc;
+	int ret;
+	const u32 *data;
+
+	if (wdt_reg)
+		return 0;
+
+	wdt_scale = 2048;
+	np = of_find_compatible_node(NULL, NULL, "fsl,pq1-wdt");
+	if (np == NULL)
+		np = of_find_compatible_node(NULL, NULL, "fsl,pq2-wdt");
+	if (np == NULL) {
+		np = of_find_compatible_node(NULL, NULL, "fsl,pq2pro-wdt");
+		wdt_scale = 65536;
+	}
+	if (np == NULL) {
+		printk(KERN_ERR "Could not find fsl,pq1/2/2pro-wdt node\n");
+		return -ENODEV;
+	}
+
+	soc = of_find_node_by_type(NULL, "soc");
+	if (!soc) {
+		printk(KERN_ERR "Could not find soc node\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	data = of_get_property(soc, "bus-frequency", NULL);
+	if (!data) {
+		of_node_put(soc);
+		printk(KERN_ERR "Could not find bus-frequency in soc node\n");
+		ret = -ENODEV;
+		goto out;
+	}
+	of_node_put(soc);
+	wdt_freq = *data;
+
+	wdt_reg = of_iomap(np, 0);
+	if (wdt_reg == NULL) {
+		printk(KERN_ERR "Could not iomap wdt\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wdt_readparam();
+	if (ret) {
+		iounmap(wdt_reg);
+		wdt_reg = NULL;
+	}
+out:
+	of_node_put(np);
+	return ret;
+}
diff --git a/arch/powerpc/sysdev/pq_wdt.h b/arch/powerpc/sysdev/pq_wdt.h
new file mode 100644
index 0000000..c5ca7bc
--- /dev/null
+++ b/arch/powerpc/sysdev/pq_wdt.h
@@ -0,0 +1,28 @@
+/*
+ * Author: Florian Schirmer <jolt@tuxbox.org>
+ *
+ * 2002 (c) Florian Schirmer <jolt@tuxbox.org> This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ *
+ * 2007 (c) Jochen Friedrich <jochen@scram.de> ported to ARCH=powerpc and
+ * extended to be useful on any Power QUICC 1/2/2pro which have the same
+ * style of watchdog.
+ */
+#ifndef _POWERPC_SYSDEV_PQ_WDT_H
+#define _POWERPC_SYSDEV_PQ_WDT_H
+
+#define SWCRR_SWEN 0x00000004 /* Watchdog Enable bit. */
+#define SWCRR_SWRI 0x00000002 /* Software Watchdog Reset/Interrupt Select bit.*/
+#define SWCRR_SWPR 0x00000001 /* Software Watchdog Counter Prescale bit. */
+
+extern int pq_wdt_get_timeout(void);
+extern void pq_wdt_reset(void);
+extern void pq_wdt_install_timer(void);
+extern void pq_wdt_stop_timer(void);
+extern int pq_wdt_setup(int);
+extern int pq_wdt_present(void);
+extern int pq_wdt_early_init(void);
+
+#endif				/* _POWERPC_SYSDEV_PQ_WDT_H */
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 52dff40..bc1c513 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -649,7 +649,18 @@ config MPC5200_WDT
 
 config 8xx_WDT
 	tristate "MPC8xx Watchdog Timer"
-	depends on 8xx
+	depends on 8xx && ! OF
+
+config PQ_WDT
+	tristate "Power QUICC Watchdog Timer"
+	depends on (8xx || PPC_82xx || PPC_83xx) && OF
+	default y
+	help
+	  Watchdog driver for Power QUICC 1/2/2pro style watchdog drivers.
+	  You should really select this unless your boot loader turns
+	  off the watchdog. As the watchdog is turned on by default and
+	  can be turned on/off only once after reboot, your board won't
+	  run otherwise. Say 'M' if unsure.
 
 config 83xx_WDT
 	tristate "MPC83xx Watchdog Timer"
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 87483cc..8005cc8 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_AR7_WDT) += ar7_wdt.o
 
 # POWERPC Architecture
 obj-$(CONFIG_8xx_WDT) += mpc8xx_wdt.o
+obj-$(CONFIG_PQ_WDT) += pq_wdt.o
 obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt.o
 obj-$(CONFIG_83xx_WDT) += mpc83xx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
diff --git a/drivers/watchdog/pq_wdt.c b/drivers/watchdog/pq_wdt.c
new file mode 100644
index 0000000..bb597e7
--- /dev/null
+++ b/drivers/watchdog/pq_wdt.c
@@ -0,0 +1,222 @@
+/*
+ * pq_wdt.c - Power QUICC watchdog userspace interface
+ *
+ * Author: Florian Schirmer <jolt@tuxbox.org>
+ *
+ * 2002 (c) Florian Schirmer <jolt@tuxbox.org> This file is licensed under
+ * the terms of the GNU General Public License version 2. This program
+ * is licensed "as is" without any warranty of any kind, whether express
+ * or implied.
+ *
+ * 2007 (c) Jochen Friedrich <jochen@scram.de> renamed to pq_wdt.c and
+ * extended to be useful on any Power QUICC 1/2/2pro which have the same
+ * style of watchdog.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/watchdog.h>
+#include <linux/of_platform.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
+#include <sysdev/pq_wdt.h>
+
+static unsigned long wdt_opened;
+static int wdt_status;
+
+static u16 timeout = 0xffff;
+module_param(timeout, ushort, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in ticks. (0<timeout<65536, default=65535");
+
+static int reset = 1;
+module_param(reset, bool, 0);
+MODULE_PARM_DESC(reset,
+	"Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset (default)");
+
+static int prescale = 1;
+
+static void pq_wdt_handler_disable(void)
+{
+	pq_wdt_stop_timer();
+
+	pr_debug("pq_wdt: keep-alive handler deactivated\n");
+}
+
+static void pq_wdt_handler_enable(void)
+{
+	pq_wdt_install_timer();
+
+	pr_debug("pq_wdt: keep-alive handler activated\n");
+}
+
+static int pq_wdt_open(struct inode *inode, struct file *file)
+{
+	u32 tmp = SWCRR_SWEN;
+
+	if (test_and_set_bit(0, &wdt_opened))
+		return -EBUSY;
+
+	pq_wdt_reset();
+
+	if (prescale)
+		tmp |= SWCRR_SWPR;
+	if (reset)
+		tmp |= SWCRR_SWRI;
+
+	tmp |= timeout << 16;
+
+	if (pq_wdt_setup(tmp))
+		return -EBUSY;
+
+#if defined(CONFIG_WATCHDOG_NOWAYOUT)
+	/* Once we start the watchdog we can't stop it */
+	__module_get(THIS_MODULE);
+#endif
+
+	pq_wdt_handler_disable();
+
+	return nonseekable_open(inode, file);
+}
+
+static int pq_wdt_release(struct inode *inode, struct file *file)
+{
+	pq_wdt_reset();
+
+#if !defined(CONFIG_WATCHDOG_NOWAYOUT)
+	pq_wdt_handler_enable();
+#endif
+
+	clear_bit(0, &wdt_opened);
+
+	return 0;
+}
+
+static ssize_t pq_wdt_write(struct file *file, const char *data, size_t len,
+				loff_t *ppos)
+{
+	if (len)
+		pq_wdt_reset();
+
+	return len;
+}
+
+static int pq_wdt_ioctl(struct inode *inode, struct file *file,
+			    unsigned int cmd, unsigned long arg)
+{
+	int timeout;
+	static struct watchdog_info info = {
+		.options = WDIOF_KEEPALIVEPING,
+		.firmware_version = 0,
+		.identity = "PQ watchdog",
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user((void *)arg, &info, sizeof(info)))
+			return -EFAULT;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		if (put_user(wdt_status, (int *)arg))
+			return -EFAULT;
+		wdt_status &= ~WDIOF_KEEPALIVEPING;
+		break;
+
+	case WDIOC_GETTEMP:
+		return -EOPNOTSUPP;
+
+	case WDIOC_SETOPTIONS:
+		return -EOPNOTSUPP;
+
+	case WDIOC_KEEPALIVE:
+		pq_wdt_reset();
+		wdt_status |= WDIOF_KEEPALIVEPING;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		return -EOPNOTSUPP;
+
+	case WDIOC_GETTIMEOUT:
+		timeout = pq_wdt_get_timeout();
+		if (put_user(timeout, (int *)arg))
+			return -EFAULT;
+		break;
+
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static const struct file_operations pq_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = pq_wdt_write,
+	.ioctl = pq_wdt_ioctl,
+	.open = pq_wdt_open,
+	.release = pq_wdt_release,
+};
+
+static struct miscdevice pq_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &pq_wdt_fops,
+};
+
+static int __devinit pq_wdt_probe(struct of_device *op, const struct of_device_id *match)
+{
+	int ret;
+
+	ret = pq_wdt_present();
+	if (ret)
+		return ret;
+
+	pq_wdt_handler_enable();
+
+	return misc_register(&pq_wdt_miscdev);
+}
+
+static int __devexit pq_wdt_remove(struct of_device *op)
+{
+	misc_deregister(&pq_wdt_miscdev);
+	return 0;
+}
+
+static struct of_device_id pq_wdt_match[] = {
+	{ .compatible = "fsl,pq1-wdt", },
+	{ .compatible = "fsl,pq2-wdt", },
+	{ .compatible = "fsl,pq2pro-wdt", },
+	{},
+};
+
+static struct of_platform_driver pq_wdt_driver = {
+	.owner		= THIS_MODULE,
+	.name		= "pq-wdt",
+	.match_table	= pq_wdt_match,
+	.probe		= pq_wdt_probe,
+	.remove		= pq_wdt_remove,
+};
+
+static int __init pq_wdt_moduleinit(void)
+{
+	return of_register_platform_driver(&pq_wdt_driver);
+}
+
+static void __exit pq_wdt_moduleexit(void)
+{
+	of_unregister_platform_driver(&pq_wdt_driver);
+}
+
+module_init(pq_wdt_moduleinit);
+module_exit(pq_wdt_moduleexit);
+
+MODULE_AUTHOR("Florian Schirmer <jolt@tuxbox.org>");
+MODULE_DESCRIPTION("PQ watchdog driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.5.3.7

