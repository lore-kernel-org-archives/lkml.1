Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXJXPLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXJXPLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJXPKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:10:54 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:20098 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbXJXPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:10:53 -0400
X-Belgacom-Dynamic: yes
Date: Wed, 24 Oct 2007 17:16:56 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Gilles Gigan <gilles.gigan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add Nano 7240 driver
Message-ID: <20071024151656.GA6015@infomag.infomag.iguana.be>
References: <20071024121159.03d209ec.gilles.gigan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024121159.03d209ec.gilles.gigan@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gilles,

> +static ssize_t fop_write(struct file *file, const char __user *buf,
> +			  size_t count, loff_t *ppos)
> +{
> +	size_t i;
> +	char c;
> +	int got_magic_char = 0;
> +
> +	/* is there a magic char ? */
> +	for (i = 0; i != count; i++) {
> +		if (get_user(c, buf + i))
> +			return -EFAULT;
> +		if (c == SBC7240_MAGIC_CHAR) {
> +			got_magic_char = 1;
> +			break;
> +		}
> +	}
> +
> +	if (got_magic_char)
> +		wdt_disable();
> +	else
> +		wdt_keepalive();
> +
> +	return count;
> +}
> +
> +static int fop_open(struct inode *inode, struct file *file)
> +{
> +	if (test_and_set_bit(OPEN_STATUS_BIT, &wdt_status))
> +		return -EBUSY;
> +
> +	return nonseekable_open(inode, file);
> +}
> +
> +static int fop_close(struct inode *inode, struct file *file)
> +{
> +	if (!nowayout)
> +		wdt_disable();
> +
> +	clear_bit(OPEN_STATUS_BIT, &wdt_status);
> +	return 0;
> +}

Normal watchdog  behaviour: The magic char should be written and then
/dev/watchdog can be closed and then the watchdog will stop.
What you did here was: if you write the magic char then stop the watchdog
even when the /dev/watchdog device is still open.
This is not the way that it should work.

> +static int __init sbc7240_wdt_init(void)
> +{
> +	int rc = -EBUSY;
> +
> +	if (!request_region(SBC7240_ENABLE_PORT, 1, "SBC7240 WDT")) {
> +		printk(KERN_ERR SBC7240_PREFIX "I/O address 0x%04x already in use\n",
> +		       SBC7240_ENABLE_PORT);
> +		rc = -EIO;
> +		goto err_out;
> +	}
> +
> +	/* The IO port 0x043 used to disable the watchdog
> +	 * is already claimed by the system timer, so we
> +	 * cant request_region() it ...*/
> +
> +	rc = misc_register(&wdt_miscdev);
> +	if (rc) {
> +		printk(KERN_ERR SBC7240_PREFIX
> +		       "cannot register miscdev on minor=%d (err=%d)\n",
> +		       wdt_miscdev.minor, rc);
> +		goto err_out_region1;
> +	}
> +
> +	rc = register_reboot_notifier(&wdt_notifier);
> +	if (rc) {
> +		printk(KERN_ERR SBC7240_PREFIX
> +		       "cannot register reboot notifier (err=%d)\n", rc);
> +		goto err_out_miscdev;
> +	}
> +
> +	if (timeout < 1 || timeout > SBC7240_MAX_TIMEOUT) {
> +		timeout = SBC7240_TIMEOUT;
> +		printk(KERN_INFO SBC7240_PREFIX
> +		       "timeout value must be 1<=x<=%d, using %d\n",
> +		       SBC7240_MAX_TIMEOUT, timeout);
> +	}
> +	wdt_set_timeout(timeout);
> +
> +	printk(KERN_INFO SBC7240_PREFIX
> +	       "Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
> +	       nowayout);

It's better to do the misc_register as last action. Reason herefor is that
you want to only enable the user-space interface when all the other settings
and interfacing was succesfull. Else you risk that userspace get's enabled and
that you then exit the watchdog driver.
Second problem that I see here is that you should make sure that the watchdog
device driver is stopped/disabled before that you give userspace access via
/dev/watchdog to the watchdog.

Greetings,
wim.

