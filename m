Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbYBFTtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbYBFTtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbYBFTtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:49:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:19191 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbYBFTtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=xKUltI5blh9M+qLdQ/CwdMNCs4rj+8qh+f0K+y11gBBa68SgSzR8d+Amgn7DFyAAgdzic+/+DWQHFl7Mhiw87RZIEwnBjegH0gkMOVmaeMBu1kpMYZoHbWbnSKtqOCpKXT6fIcRm8P88HNzl2Zz0Uy0XrAzU2rlCawERsN4PxBU=
Date: Wed, 6 Feb 2008 20:49:05 +0100
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Roel Kluin <12o3l@tiscali.nl>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP
 Jornada 7xx handhelds
Message-Id: <20080206204905.315fde57.Kristoffer.ericson@gmail.com>
In-Reply-To: <20080206193155.GE32245@flint.arm.linux.org.uk>
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com>
	<47A9A944.7090401@tiscali.nl>
	<47A9AA4F.80508@tiscali.nl>
	<20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
	<20080206164435.GC32245@flint.arm.linux.org.uk>
	<20080206202128.06fbcafa.Kristoffer.ericson@gmail.com>
	<20080206193155.GE32245@flint.arm.linux.org.uk>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a mistake on the latest patch I sent, 

if (IS_ERR(bllcd->lcd_device)) {
+		ret = PTR_ERR(bllcd->bl_device);
+		backlight_device_unregister(bllcd->bl_device);
+		printk(KERN_ERR "lcd :failed to register device\n");
+		kfree(bllcd);
+		return ret;
+	}

should ofcourse read

if (IS_ERR(bllcd->lcd_device)) {
+		ret = PTR_ERR(bllcd->lcd_device);
+		backlight_device_unregister(bllcd->bl_device);
+		printk(KERN_ERR "lcd :failed to register device\n");
+		kfree(bllcd);
+		return ret;
+	}

Its fixed now for me. Going to test that mdelay issue now.


On Wed, 6 Feb 2008 19:31:55 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Wed, Feb 06, 2008 at 08:21:28PM +0100, Kristoffer Ericson wrote:
> > Oh, and thanks for all the feedback people! (and for doing it nicely)
> 
> I'm afraid you missed one - and there's a better fix for one of the other
> points I made... 8)
> 
> > +static int jornada_bl_probe(struct platform_device *pdev)
> > +{
> > +	struct bllcd_device *bllcd;
> 
> 	int ret;
> 
> > +
> > +	bllcd = kzalloc(sizeof(*bllcd), GFP_KERNEL);
> > +	if (bllcd == NULL)
> > +		return -ENOMEM;
> > +
> > +	/* bl driver - name must match fb driver name */
> > +	bllcd->bl_device = backlight_device_register(S1D_DEVICENAME,
> > +	&pdev->dev, NULL, &jornada_bl_ops);
> > +
> > +	if (IS_ERR(bllcd->bl_device)) {
> 
> 		ret = PTR_ERR(bllcd->bl_device);
> 
> > +		kfree(bllcd);
> > +		printk(KERN_ERR "bl :failed to register device\n");
> > +		return -ENODEV;
> 
> delete the line above, and then swap the two remaining lines.
> 
> 		return ret;
> 
> > +	}
> > +
> > +	/* lcd driver */
> > +	bllcd->lcd_device = lcd_device_register(S1D_DEVICENAME,
> > +				&pdev->dev, NULL, &jornada_lcd_ops);
> > +	if (IS_ERR(bllcd->lcd_device)) {
> > +		backlight_device_unregister(bllcd->bl_device);
> 
> 		ret = PTR_ERR(bllcd->lcd_device);
> 
> > +		kfree(bllcd);
> > +		printk(KERN_ERR "lcd :failed to register device\n");
> > +		return -ENODEV;
> 
> delete the line above, and then swap the two remaining lines.
> 
> 		return ret;
> 
> The reason for swapping the two lines is that it _might_ give gcc a
> chance to optimise the two paths.
> 
> > +static struct platform_driver jornada_bl_driver = {
> > +	.probe	= jornada_bl_probe,
> > +	.remove	= jornada_bl_remove,
> > +#ifdef CONFIG_PM
> > +	.suspend = jornada_bl_suspend,
> > +	.resume = jornada_bl_resume,
> > +#endif
> > +	.driver = {
> > +	    .name = "jornada_bllcd",
> 
> You missed this one - which currently is: tab space space space space.
> It should be two tabs.
