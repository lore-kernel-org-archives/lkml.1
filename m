Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0CIHmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:42:06 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48217 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0CIHmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G69z9qyb3Z2VyV11oYeCERCUhxNce8payUmpdQ4TqqjvvfBIqNeBNjLIsA1L8X03P3
         YexejSjG+35Xsgg6484+LSelR7zHqd9kfSexdelF55m2bL5XRFuNSE5gH82yHvrpp3/X
         3BzL9pAMaXDesnn2oO4qmLNIWFUyPNnm4kwS0=
Date: Mon, 8 Mar 2010 23:41:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Achatz <stefan_achatz@web.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       wylda@volny.cz, Pavel Machek <pavel@suse.cz>,
       Alessandro Guido <ag@alessandroguido.name>,
       Tomas Hanak <tomas.hanak@gmail.com>, Jason Noble <nobleja@polezero.com>,
       simon.windows@gmail.com, Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, Henning Glawe <glaweh@debian.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Added locks for sysfs attributes and internal data.
Message-ID: <20100309074155.GA17288@core.coreip.homeip.net>
References: <201002200911.53900.stefan_achatz@web.de>
 <31758929.1286552.1266912188132.JavaMail.fmail@mwmweb006>
 <20100226074422.GA17062@core.coreip.homeip.net>
 <201003081704.30119.stefan_achatz@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003081704.30119.stefan_achatz@web.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Mon, Mar 08, 2010 at 05:04:29PM +0100, Stefan Achatz wrote:
> From 47678162da8e374d6f132db21d89b718ee5cfbd1 Mon Sep 17 00:00:00 2001
> From: Stefan Achatz <erazor_de@users.sourceforge.net>
> Date: Mon, 8 Mar 2010 16:54:19 +0100
> Subject: [PATCH 4/4] Added locks for sysfs attributes and internal data.
> 
> Added mutex lock to prevent different processes from accessing
> sysfs attributes at the same time.
> Added spin lock for internal data.
> ---
>  drivers/hid/hid-roccat-kone.c |  246 ++++++++++++++++++++++++++++------------
>  drivers/hid/hid-roccat-kone.h |    9 +-
>  2 files changed, 179 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> index 941f5b3..eded7d4 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -223,11 +223,6 @@ static int kone_get_profile(struct usb_device *usb_dev,
>  	if (number < 1 || number > 5)
>  		return -EINVAL;
>  
> -	/*
> -	 * The manufacturer uses a control message of type class with interface
> -	 * as recipient and provides the profile number as index parameter.
> -	 * This is prevented in userspace by function check_ctrlrecip.
> -	 */
>  	len = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
>  			USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
>  					| USB_RECIP_INTERFACE | USB_DIR_IN,
> @@ -398,16 +393,18 @@ static int kone_get_firmware_version(struct usb_device *usb_dev, int *result)
>  static ssize_t kone_sysfs_set_settings(struct device *dev,
>  		struct device_attribute *attr, char const *buf, size_t size)
>  {
> -	struct hid_device *hdev = dev_get_drvdata(dev);
> -	struct kone_device *kone = hid_get_drvdata(hdev);
> -	struct usb_interface *intf = to_usb_interface(dev);
> -	struct usb_device *usb_dev = interface_to_usbdev(intf);
> +	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
> +	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
>  	int err;
> +	unsigned long flags;
>  
>  	if (size != sizeof(struct kone_settings))
>  		return -EINVAL;
>  
> +	mutex_lock(&kone->kone_lock);
>  	err = kone_set_settings(usb_dev, (struct kone_settings const *)buf);

Hmm, this kind of casting tells me that this is binary, not text data
and thus binary sysfs attribute shoudl be used.

> +	mutex_unlock(&kone->kone_lock);
> +
>  	if (err)
>  		return err;
>  
> @@ -415,9 +412,10 @@ static ssize_t kone_sysfs_set_settings(struct device *dev,
>  	 * If we get here, treat buf as okay (apart from checksum) and use value
>  	 * of startup_profile as its at hand
>  	 */
> +	spin_lock_irqsave(&kone->actual_lock, flags);
>  	kone->act_profile = ((struct kone_settings *)buf)->startup_profile;
> -	kone->act_profile_valid = 1;
> -	kone->act_dpi_valid = 0;
> +	kone->act_dpi = -1;
> +	spin_unlock_irqrestore(&kone->actual_lock, flags);
>  

You don't really need a spinlock to set one integer.

>  	return sizeof(struct kone_settings);
>  }
> @@ -425,10 +423,14 @@ static ssize_t kone_sysfs_set_settings(struct device *dev,
>  static ssize_t kone_sysfs_show_settings(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> -	struct usb_interface *intf = to_usb_interface(dev);
> -	struct usb_device *usb_dev = interface_to_usbdev(intf);
> +	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
> +	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
>  	int err;
> +
> +	mutex_lock(&kone->kone_lock);
>  	err = kone_get_settings(usb_dev, (struct kone_settings *)buf);
> +	mutex_unlock(&kone->kone_lock);
> +
>  	if (err)
>  		return err;
>  
> @@ -437,10 +439,14 @@ static ssize_t kone_sysfs_show_settings(struct device *dev,
>  
>  static ssize_t kone_sysfs_get_profile(struct device *dev, char *buf, int number)
>  {
> -	struct usb_interface *intf = to_usb_interface(dev);
> -	struct usb_device *usb_dev = interface_to_usbdev(intf);
> +	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
> +	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
>  	int err;
> +
> +	mutex_lock(&kone->kone_lock);
>  	err = kone_get_profile(usb_dev, (struct kone_profile *)buf, number);
> +	mutex_unlock(&kone->kone_lock);
> +
>  	if (err)
>  		return err;
>  	return sizeof(struct kone_profile);
> @@ -449,15 +455,17 @@ static ssize_t kone_sysfs_get_profile(struct device *dev, char *buf, int number)
>  static ssize_t kone_sysfs_set_profile(struct device *dev, char const *buf,
>  		size_t size, int number)
>  {
> -	struct usb_interface *intf = to_usb_interface(dev);
> -	struct usb_device *usb_dev = interface_to_usbdev(intf);
> -
> +	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
> +	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
>  	int err;
>  
>  	if (size != sizeof(struct kone_profile))
>  		return -EINVAL;
>  
> +	mutex_lock(&kone->kone_lock);
>  	err = kone_set_profile(usb_dev, buf, number);
> +	mutex_unlock(&kone->kone_lock);
> +
>  	if (err)
>  		return err;
>  
> @@ -525,32 +533,68 @@ static ssize_t kone_sysfs_set_profile_5(struct device *dev,
>  }
>  
>  /*
> - * Helper to fill kone_device structure with actual values
> - * On success returns 0
> - * On failure returns errno
> + * Fills act_profile in kone_device.
> + * Also writes result in @result.
> + * Once act_profile is valid, its not getting invalid any more.
> + * Returns on success 0, on failure errno
>   */
> -static int kone_device_set_actual_values(struct kone_device *kone,
> -		struct device *dev, int both)
> +static int kone_device_set_actual_profile(struct kone_device *kone,
> +		struct device *dev, int *result)
>  {
> -	struct usb_interface *intf = to_usb_interface(dev);
> -	struct usb_device *usb_dev = interface_to_usbdev(intf);
> -	int err;
> +	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
> +	int err, temp;
> +	unsigned long flags;
>  
> -	/* first make sure profile is valid */
> -	if (!kone->act_profile_valid) {
> -		err = kone_get_startup_profile(usb_dev, &kone->act_profile);
> +	spin_lock_irqsave(&kone->actual_lock, flags);
> +	if (kone->act_profile == -1) {
> +		spin_unlock_irqrestore(&kone->actual_lock, flags);
> +		err = kone_get_startup_profile(usb_dev, &temp);
>  		if (err)
>  			return err;
> -		kone->act_profile_valid = 1;
> +		spin_lock_irq(&kone->actual_lock);
> +		kone->act_profile = temp;
> +		spin_unlock_irqrestore(&kone->actual_lock, flags);

You shoudl not be mixing _irq/_irqrestore. Also it is probably not
needed at all. If it is needed then the common style to acquire and
release locks only once in a function - this makes checking whether
lock/unlock is balanced easier.

> +		if (result)
> +			*result = temp;
> +	} else {
> +		if (result)
> +			*result = kone->act_profile;
> +		spin_unlock_irqrestore(&kone->actual_lock, flags);
>  	}
> +	return 0;
> +}
> +
> +/*
> + * Fills act_dpi in kone_device.
> + * Also writes result in @result.
> + * On success returns 0
> + * On failure returns errno
> + */
> +static int kone_device_set_actual_dpi(struct kone_device *kone,
> +		struct device *dev, int *result)
> +{
> +	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
> +	int err, temp;
> +	unsigned long flags;
> +
> +	kone_device_set_actual_profile(kone, dev, NULL);
>  
> -	/* then get startup dpi value */
> -	if (!kone->act_dpi_valid && both) {
> +	spin_lock_irqsave(&kone->actual_lock, flags);
> +	if (kone->act_dpi == -1) {
> +		spin_unlock_irqrestore(&kone->actual_lock, flags);

So what are we protecting exactly? What if act_dpi will become -1 here
(after you released the spinlock?

>  		err = kone_get_profile_startup_dpi(usb_dev, kone->act_profile,
> -				&kone->act_dpi);
> +				&temp);

Stopped looking - locking obviously is bogus and needs to be redone. You
need to decide what exactly needs protection and what critical sections
are.

-- 
Dmitry
