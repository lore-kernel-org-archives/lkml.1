Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYBFTcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYBFTcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYBFTcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:32:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47612 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbYBFTcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:32:35 -0500
Date: Wed, 6 Feb 2008 19:31:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP Jornada 7xx handhelds
Message-ID: <20080206193155.GE32245@flint.arm.linux.org.uk>
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com> <47A9A944.7090401@tiscali.nl> <47A9AA4F.80508@tiscali.nl> <20080206173341.619c52c8.Kristoffer.ericson@gmail.com> <20080206164435.GC32245@flint.arm.linux.org.uk> <20080206202128.06fbcafa.Kristoffer.ericson@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206202128.06fbcafa.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 08:21:28PM +0100, Kristoffer Ericson wrote:
> Oh, and thanks for all the feedback people! (and for doing it nicely)

I'm afraid you missed one - and there's a better fix for one of the other
points I made... 8)

> +static int jornada_bl_probe(struct platform_device *pdev)
> +{
> +	struct bllcd_device *bllcd;

	int ret;

> +
> +	bllcd = kzalloc(sizeof(*bllcd), GFP_KERNEL);
> +	if (bllcd == NULL)
> +		return -ENOMEM;
> +
> +	/* bl driver - name must match fb driver name */
> +	bllcd->bl_device = backlight_device_register(S1D_DEVICENAME,
> +	&pdev->dev, NULL, &jornada_bl_ops);
> +
> +	if (IS_ERR(bllcd->bl_device)) {

		ret = PTR_ERR(bllcd->bl_device);

> +		kfree(bllcd);
> +		printk(KERN_ERR "bl :failed to register device\n");
> +		return -ENODEV;

delete the line above, and then swap the two remaining lines.

		return ret;

> +	}
> +
> +	/* lcd driver */
> +	bllcd->lcd_device = lcd_device_register(S1D_DEVICENAME,
> +				&pdev->dev, NULL, &jornada_lcd_ops);
> +	if (IS_ERR(bllcd->lcd_device)) {
> +		backlight_device_unregister(bllcd->bl_device);

		ret = PTR_ERR(bllcd->lcd_device);

> +		kfree(bllcd);
> +		printk(KERN_ERR "lcd :failed to register device\n");
> +		return -ENODEV;

delete the line above, and then swap the two remaining lines.

		return ret;

The reason for swapping the two lines is that it _might_ give gcc a
chance to optimise the two paths.

> +static struct platform_driver jornada_bl_driver = {
> +	.probe	= jornada_bl_probe,
> +	.remove	= jornada_bl_remove,
> +#ifdef CONFIG_PM
> +	.suspend = jornada_bl_suspend,
> +	.resume = jornada_bl_resume,
> +#endif
> +	.driver = {
> +	    .name = "jornada_bllcd",

You missed this one - which currently is: tab space space space space.
It should be two tabs.
