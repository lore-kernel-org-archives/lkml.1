Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZGTQnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZGTQnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbZGTQnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:43:21 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4108 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZGTQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:43:20 -0400
Subject: Re: [PATCH] add SBC-FITPC2 watchdog driver
From: Joe Perches <joe@perches.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
       Andrey Panin <pazke@centrinvest.ru>,
       Denis Turischev <denis@compulab.co.il>
In-Reply-To: <4A6492EB.1080709@compulab.co.il>
References: <4A6492EB.1080709@compulab.co.il>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 09:43:09 -0700
Message-Id: <1248108189.31365.40.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 18:53 +0300, Mike Rapoport wrote:
> diff -Nru linux-2.6.31-rc3.orig/drivers/watchdog/sbc_fitpc2_wdt.c linux-2.6.31-rc3/drivers/watchdog/sbc_fitpc2_wdt.c
> --- linux-2.6.31-rc3.orig/drivers/watchdog/sbc_fitpc2_wdt.c	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.31-rc3/drivers/watchdog/sbc_fitpc2_wdt.c	2009-07-20 16:08:40.000000000 +0300

Hi.  Some trivial comments below:

[]

> +static ssize_t
> +fitpc2_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
> +{
> +	if (len) {
> +		if (!nowayout) {
> +			size_t i;

using
	if (!len)
		return 0;
	if (nowayout) {
		wdt_enable();
		return 0;
	}

would reduce the indent a couple of levels.

[]

> +static int fitpc2_wdt_release(struct inode *inode, struct file *file)
> +{
> +	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
> +		wdt_disable();
> +		printk(KERN_CRIT "WATCHDOG: Device disabled\n");

I think you should verify the printk KERN_CRIT uses.
This seems like this one should be KERN_INFO.

[]

> +static int __init fitpc2_wdt_init(void)
[]
> +		printk(KERN_CRIT "WATCHDOG: board name is: %s. Should be SBC-FITPC2\n",
> +			dmi_get_system_info(DMI_BOARD_NAME));
[]
> +		printk(KERN_CRIT "WATCHDOG: I/O address 0x%04x already in use\n",
> +			COMMAND_PORT);
[]
> +		printk(KERN_CRIT "WATCHDOG: I/O address 0x%04x already in use\n",
> +			DATA_PORT);
[]
> +		printk(KERN_CRIT "WATCHDOG: margin must be in range 31 - 255"
> +		" seconds, you tried to set %d\n", margin);

Maybe all of these should be KERN_ERR.

You could use:

#define pr_fmt(fmt) KBUILD_MODNAME " WATCHDOG: " fmt

and convert the printk(KERN_<level> "WATCHDOG: " etc...)
to pr_<level>(etc...)


