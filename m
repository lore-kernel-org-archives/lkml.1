Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYKSIUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYKSIUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKSIUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:20:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025AbYKSIUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:20:04 -0500
Date: Wed, 19 Nov 2008 00:19:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: Re: [PATCH] Add 1-wire master driver for i.MX27 / i.MX31
Message-Id: <20081119001932.0038a80b.akpm@linux-foundation.org>
In-Reply-To: <1227046577988-git-send-email-zbr@ioremap.net>
References: <1227046577988-git-send-email-zbr@ioremap.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 01:16:13 +0300 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> From: Sascha Hauer <s.hauer@pengutronix.de>
> 
> This patch adds support for the 1-wire master interface for i.MX27 and
> i.MX31.

Looks sane.

> Ack for this one, the other patches from this series need to go via
> Russell King to prevent merge conflicts with other MX2 patches. Sorry, I
> should have made that clear.

Is this patch fully independent of the others?

>
> ...
>
> +static int __devinit mxc_w1_probe(struct platform_device *pdev)
> +{
> +	struct mxc_w1_device *mdev;
> +	struct resource *res;
> +	int err = 0;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	mdev = kzalloc(sizeof(struct mxc_w1_device) +
> +		      sizeof(struct w1_bus_master), GFP_KERNEL);

whee, that's a bit of a hack.  It would be better to do

struct foo {
	struct mxc_w1_device mxc_w1_device;
	struct w1_bus_master w1_bus_master;
};

no?

> +	if (!mdev)
> +		return -ENOMEM;
> +
> +	mdev->clk = clk_get(&pdev->dev, "owire_clk");
> +	if (!mdev->clk) {
> +		err = -ENODEV;
> +		goto failed_clk;
> +	}
> +
> +	mdev->bus_master = (struct w1_bus_master *)(mdev + 1);
> +	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;

If that 1000000 refers to microseconds then the use of USEC_PER_SEC
would be clearer.

> +	res = request_mem_region(res->start, resource_size(res),
> +				"mxc_w1");
> +	if (!res) {
> +		err = -EBUSY;
> +		goto failed_req;
> +	}
> +
> +	mdev->regs = ioremap(res->start, resource_size(res)); 
> +	if (!mdev->regs) {
> +		printk(KERN_ERR"Cannot map frame buffer registers\n");
> +		goto failed_ioremap;
> +	}
> +
> +	clk_enable(mdev->clk);
> +	__raw_writeb(mdev->clkdiv, mdev->regs + MXC_W1_TIME_DIVIDER);
> +
> +	mdev->bus_master->data = mdev;
> +	mdev->bus_master->reset_bus = &mxc_w1_ds2_reset_bus;
> +	mdev->bus_master->touch_bit = &mxc_w1_ds2_touch_bit;
> +
> +	err = w1_add_master_device(mdev->bus_master);
> +
> +	if (err)
> +		goto failed_add;
> +
> +	platform_set_drvdata(pdev, mdev);
> +	return 0;
> +
> +failed_add:
> +	iounmap(mdev->regs);
> +failed_ioremap:
> +	release_mem_region(res->start, resource_size(res));
> +failed_req:
> +	clk_put(mdev->clk);
> +failed_clk:
> +	kfree(mdev);
> +	return err;
> +}

Trivial fixes:

From: Andrew Morton <akpm@linux-foundation.org>

- coding-style fixes

- remove unneeded casts of void*

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Luotao Fu <l.fu@pengutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/mxc_w1.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/w1/masters/Kconfig~add-1-wire-master-driver-for-imx27-imx31-fix drivers/w1/masters/Kconfig
diff -puN drivers/w1/masters/Makefile~add-1-wire-master-driver-for-imx27-imx31-fix drivers/w1/masters/Makefile
diff -puN drivers/w1/masters/mxc_w1.c~add-1-wire-master-driver-for-imx27-imx31-fix drivers/w1/masters/mxc_w1.c
--- a/drivers/w1/masters/mxc_w1.c~add-1-wire-master-driver-for-imx27-imx31-fix
+++ a/drivers/w1/masters/mxc_w1.c
@@ -59,8 +59,7 @@ static u8 mxc_w1_ds2_reset_bus(void *dat
 {
 	u8 reg_val, rc = 1;
 	unsigned int timeout_cnt = 0;
-
-	struct mxc_w1_device *dev = (struct mxc_w1_device *)data;
+	struct mxc_w1_device *dev = data;
 
 	__raw_writeb(0x80, (dev->regs + MXC_W1_CONTROL));
 
@@ -87,8 +86,7 @@ static u8 mxc_w1_ds2_reset_bus(void *dat
 static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 {
 	unsigned int timeout_cnt = 400;
-
-	struct mxc_w1_device *mdev = (struct mxc_w1_device *)data;
+	struct mxc_w1_device *mdev = data;
 	void __iomem *ctrl_addr = mdev->regs + MXC_W1_CONTROL;
 
 	__raw_writeb((1 << (5 - bit)), ctrl_addr);
@@ -135,9 +133,9 @@ static int __devinit mxc_w1_probe(struct
 		goto failed_req;
 	}
 
-	mdev->regs = ioremap(res->start, resource_size(res)); 
+	mdev->regs = ioremap(res->start, resource_size(res));
 	if (!mdev->regs) {
-		printk(KERN_ERR"Cannot map frame buffer registers\n");
+		printk(KERN_ERR "Cannot map frame buffer registers\n");
 		goto failed_ioremap;
 	}
 
_

