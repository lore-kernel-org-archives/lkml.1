Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYJXMhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYJXMhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYJXMh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:37:27 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:15835 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbYJXMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:37:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEAEpeAUlR9Ner/2dsb2JhbACBdb9Jg1A
Date: Fri, 24 Oct 2008 14:37:23 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Add support for the WM8350 watchdog
Message-ID: <20081024123723.GQ30246@infomag.infomag.iguana.be>
References: <1224529931-9860-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224529931-9860-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

Finally a stable ADSL line again. I just finished reviewing your driver:

> +static int wm8350_wdt_open(struct inode *inode, struct file *file)
> +{
> +	struct wm8350 *wm8350 = get_wm8350();
> +	int ret;
> +
> +	if (!wm8350) {
> +		printk(KERN_CRIT "FNORD\n");

:-) as you pointed out this should be removed.

> +static int wm8350_wdt_release(struct inode *inode, struct file *file)
> +{
> +	struct wm8350 *wm8350 = get_wm8350();
> +
> +	if (wm8350_wdt_expect_close)
> +		wm8350_wdt_stop(wm8350);
> +	else
> +		dev_warn(wm8350->dev, "Watchdog device closed uncleanly\n");

you should ping the watchdog if you don't stop it.

> +static int wm8350_wdt_ioctl(struct inode *inode, struct file *file,
> +			    unsigned int cmd, unsigned long arg)

we use the unlocked_ioctl call in watchdog drivers now. So this should be:
static long wm8350_wdt_ioctl(struct file *file, unsigned int cmd,
						unsigned long arg)

> +{
> +	struct wm8350 *wm8350 = get_wm8350();
> +	int ret = -ENOTTY, time, i;
> +	void __user *argp = (void __user *)arg;
> +	int __user *p = argp;
> +	u16 reg;
> +
> +	switch (cmd) {
> +	case WDIOC_GETSUPPORT:
> +		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
> +		break;
> +
> +	case WDIOC_GETSTATUS:

Bootstatus is a mandatory ioctl according to the API. So just add:
	case WDIOC_GETBOOTSTATUS:

> +static const struct file_operations wm8350_wdt_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.write = wm8350_wdt_write,
> +	.ioctl = wm8350_wdt_ioctl,

and for the unlocked_ioctl call this needs to be:
	.unlocked_ioctl = wm8350_wdt_ioctl,

For the rest: seems OK to me.

Kind regards,
Wim.

