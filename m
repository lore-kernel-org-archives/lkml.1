Return-Path: <linux-kernel-owner+w=401wt.eu-S1751343AbXBVBBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbXBVBBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXBVBBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:01:06 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:32403 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbXBVBBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:01:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J6cfYat6A8ahAdTpOP4QHEOGx4VBZunhcsyctpCUzXTbBo+Oigik15gh8nyccRnnXrmmsBOIfwX0gjZPAcDxFEc1JsstO1T0aBihWV+5PK6uNnXTWP4hv7ufmX2ZdNjXnk+ErUtKCmeIYcqLAmdxkMJ+EN5tuA7UmFnrb8+ujeQ=
Subject: Re: [Linux-fbdev-devel] [PATCH]
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702212105280.20620@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0702212105280.20620@pentafluge.infradead.org>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 09:03:54 +0800
Message-Id: <1172106234.4217.50.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 21:23 +0000, James Simmons wrote:
> This is the new display intreface. Its goal is to provide a standard 
> interface to various types of displays. Currently we have auxdisplay, 
> output acpi device and the now defunct lcd class in the backlight directory.
> Please apply.

Is this an attempt to consolidate all display hardware and drivers?

> 
[snip]
> +struct class *display_class;
> +EXPORT_SYMBOL(display_class);
> +static int index;
> +
> +struct display_device *display_device_register(struct display_driver *driver,
> +						struct device *dev, void *devdata)
> +{
> +	struct display_device *new_dev = NULL;
> +	int ret = -EINVAL;
> +
> +	if (unlikely(!driver))
> +		return ERR_PTR(ret);
> +
> +	new_dev = kzalloc(sizeof(struct display_device), GFP_KERNEL);
> +	if (likely(new_dev) && unlikely(driver->probe(new_dev, devdata))) {
> +		new_dev->dev = device_create(display_class, dev, 0,
> +						"display%d", index);
> +
> +		if (!IS_ERR(new_dev->dev)) {
> +			dev_set_drvdata(new_dev->dev, new_dev);
> +			new_dev->driver = driver;
> +			new_dev->parent = dev;
> +			mutex_init(&new_dev->lock);
> +			index++;
> +		} else {
> +			new_dev->dev = NULL;
> +			kfree(new_dev);

Set new_dev to NULL on failure.

> +		}
> +	}
> +	return new_dev;
> +}
> +EXPORT_SYMBOL(display_device_register);
> +
> +void display_device_unregister(struct display_device *ddev)
> +{
> +	if (!ddev)
> +		return;
> +	mutex_lock(&ddev->lock);
> +	device_del(ddev->dev);
> +	ddev->driver = NULL;
> +	index--;

display0
display1
index = 2
unregister display0
index = 1
display_device_register() as device1
device1 <-- BUG, already used.

[snip]

> +
> +struct display_device;
> +
> +/* This structure defines all the properties of a Display. */
> +struct display_driver {
> +	int  (*set_contrast)(struct display_device *, unsigned int);
> +	int  (*get_contrast)(struct display_device *);
> +	void (*suspend)(struct display_device *, pm_message_t state);
> +	void (*resume)(struct display_device *);
> +	int  (*probe)(struct display_device *, void *);
> +	int  (*remove)(struct display_device *);
> +	int  max_contrast;

If this is an attempt to consolidate, I don't see the 'brightness'
hook of backlight and lcd.

If this is not a consolidation, why don't we just extend the lcd class?

Tony 


