Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbXDDVQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbXDDVQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXDDVQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:16:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44945 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXDDVQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:16:40 -0400
Date: Wed, 4 Apr 2007 14:18:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Kai Svahn <kai.svahn@nokia.com>
Subject: Re: [PATCH 62/90] ARM: OMAP: Merge board specific files from N800
 tree
Message-Id: <20070404141819.637c46de.randy.dunlap@oracle.com>
In-Reply-To: <11757101352361-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757100713004-git-send-email-tony@atomide.com>
	<11757100752021-git-send-email-tony@atomide.com>
	<11757100781275-git-send-email-tony@atomide.com>
	<11757100811771-git-send-email-tony@atomide.com>
	<11757100821353-git-send-email-tony@atomide.com>
	<11757100853841-git-send-email-tony@atomide.com>
	<1175710087578-git-send-email-tony@atomide.com>
	<11757100911247-git-send-email-tony@atomide.com>
	<1175710093864-git-send-email-tony@atomide.com>
	<11757100952384-git-send-email-tony@atomide.com>
	<11757100982726-g!
 it-send-email-tony@atomide.com>
	<11757101012787-git-send-email-tony@atomide.com>
	<1175710103340-git-send-email-tony@atomide.com>
	<11757101072553-git-send-email-tony@atomide.com>
	<11757101101180-git-send-email-tony@atomide.com>
	<11757101123620-git-send-email-tony@atomide.com>
	<11757101141643-git-send-email-tony@atomide.com>
	<11757101352361-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:05:41 -0400 Tony Lindgren wrote:

> This patch merges board specific files from N800 tree.
> Nokia has published the files at:
> 

2 comments:

a.  lots of printk() calls need log levels added as well as some
indication of the source of the message, like a driver/module name
or subsystem name[*]

b.  externs should be in header files.


* Maybe this isn't so critical for an embedded environment (?)


> ---
> diff --git a/arch/arm/mach-omap2/board-n800-audio.c b/arch/arm/mach-omap2/board-n800-audio.c
> new file mode 100644
> index 0000000..1608d3d
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-n800-audio.c
> @@ -0,0 +1,357 @@
> +
> +static int n800_codec_get_clocks(struct device *dev)
> +{
> +	sys_clkout2 = clk_get(dev, "sys_clkout2");
> +	if (IS_ERR(sys_clkout2)) {
> +		printk(KERN_ERR "Could not get sys_clkout2\n");
> +		return -ENODEV;
> +	}
> +	/* configure 12 MHz output on SYS_CLKOUT2. Therefore we must use
> +	 * 96 MHz as its parent in order to get 12 MHz */
> +	func96m_clk = clk_get(dev, "func_96m_ck");
> +	if (IS_ERR(func96m_clk)) {
> +		printk(KERN_ERR "could not get func 96M clock\n");
> +		clk_put(sys_clkout2);
> +		return -ENODEV;
> +	}
> +
> +	clk_set_parent(sys_clkout2, func96m_clk);
> +	clk_set_rate(sys_clkout2, 12000000);
> +
> +	return 0;
> +}

> diff --git a/arch/arm/mach-omap2/board-n800-dsp.c b/arch/arm/mach-omap2/board-n800-dsp.c
> new file mode 100644
> index 0000000..cb01363
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-n800-dsp.c
> @@ -0,0 +1,158 @@
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +
> +#include <asm/io.h>
> +#include <asm/arch/clock.h>
> +
> +#include "../plat-omap/dsp/dsp_common.h"
> +
> +extern int n800_audio_enable(struct dsp_kfunc_device *kdev, int stage);
> +extern int n800_audio_disable(struct dsp_kfunc_device *kdev, int stage);

externs should be in a header file.

> diff --git a/arch/arm/mach-omap2/board-n800.c b/arch/arm/mach-omap2/board-n800.c
> new file mode 100644
> index 0000000..2188294
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-n800.c
> @@ -0,0 +1,525 @@
> +
> +static int blizzard_get_clocks(void)
> +{
> +	blizzard.sys_ck = clk_get(0, "osc_ck");
> +	if (IS_ERR(blizzard.sys_ck)) {
> +		printk(KERN_ERR "can't get Blizzard clock\n");
> +		return PTR_ERR(blizzard.sys_ck);
> +	}
> +	return 0;
> +}
> +
> +static void tsc2301_dev_init(void)
> +{
> +	int gpio = N800_KEYB_IRQ_GPIO;
> +
> +	if (omap_request_gpio(gpio) < 0) {
> +		printk("can't get KBIRQ GPIO\n");
> +		return;
> +	}
> +	omap_set_gpio_direction(gpio, 1);
> +	tsc2301_config.keyb_int = OMAP_GPIO_IRQ(gpio);
> +}

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
