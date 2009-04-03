Return-Path: <linux-kernel-owner+w=401wt.eu-S934841AbZDCRZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841AbZDCRZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765641AbZDCRZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:25:38 -0400
Received: from mx40.mail.ru ([94.100.176.54]:54509 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761506AbZDCRZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:25:37 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] firmware: speed up request_firmware()
Date: Fri, 3 Apr 2009 21:25:24 +0400
User-Agent: KMail/1.11.2 (Linux/2.6.29-1avb; KDE/4.2.2; i686; ; )
Cc: Ira Snyder <iws@ovro.caltech.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
References: <20090128180446.GB31107@ovro.caltech.edu> <20090128203421.GC31107@ovro.caltech.edu> <49D5B0B3.2040405@ladisch.de>
In-Reply-To: <49D5B0B3.2040405@ladisch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1459720.xnBk3OXHsR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904032125.28803.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1459720.xnBk3OXHsR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 03 of April 2009 10:46:11 Clemens Ladisch wrote:
> Ira Snyder wrote:
> > I didn't want to change an existing kernel interface, so I just
> > made the easiest change that worked for me.
>
> Well, userspace does know the actual size of the image, so I see no
> reason why it shouldn't be able to tell the kernel about it
> beforehand.
>

Right; but it will need some time for user space to catch up.

> > I'd be happy to test patches anyone comes up with.
>
> =3D=3D=3D=3D=3D
>
> This adds a data_size attribute to the firmware loading device so
> that userspace can tell us about the firmware image size.  This
> allows us to preallocate the buffer with the final size, thus
> avoiding reallocating the buffer for every page of data as it comes
> in.
>
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
>
> --- linux-2.6.orig/Documentation/firmware_class/README
> +++ linux-2.6/Documentation/firmware_class/README
> @@ -21,7 +21,7 @@
>   kernel(driver): calls request_firmware(&fw_entry, $FIRMWARE,
> device)
>
>   userspace:
> - 	- /sys/class/firmware/xxx/{loading,data} appear.
> + 	- /sys/class/firmware/xxx/{loading,data,data_size} appear.
>  	- hotplug gets called with a firmware identifier in $FIRMWARE
>  	  and the usual hotplug environment.
>  		- hotplug: echo 1 > /sys/class/firmware/xxx/loading
> @@ -29,11 +29,13 @@
>   kernel: Discard any previous partial load.
>
>   userspace:
> +		- hotplug: echo ... > /sys/class/firmware/xxx/data_size
>  		- hotplug: cat appropriate_firmware_image > \
>  					/sys/class/firmware/xxx/data
>
> - kernel: grows a buffer in PAGE_SIZE increments to hold the image as
> it -	 comes in.
> + kernel: Copies the firmware image into a buffer of the specified
> size. +	 If the image is larger, the buffer automatically grows in +=09
> PAGE_SIZE increments.
>
>   userspace:
>  		- hotplug: echo 0 > /sys/class/firmware/xxx/loading
> @@ -60,6 +62,9 @@
>
>  	HOTPLUG_FW_DIR=3D/usr/lib/hotplug/firmware/
>
> +	if [ -e /sys/$DEVPATH/data_size ]; then
> +		stat -c %s $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data_size
> +	fi
>  	echo 1 > /sys/$DEVPATH/loading
>  	cat $HOTPLUG_FW_DIR/$FIRMWARE > /sysfs/$DEVPATH/data
>  	echo 0 > /sys/$DEVPATH/loading
> @@ -73,6 +78,9 @@
>   - firmware_data_read() and firmware_loading_show() are just
> provided for testing and completeness, they are not called in normal
> use.
>
> + - /sys/class/firmware/xxx/data_size is optional for compatibility
> with +   older kernels.
> +
>   - There is also /sys/class/firmware/timeout which holds a timeout
> in seconds for the whole load operation.
>
> --- linux-2.6.orig/Documentation/firmware_class/hotplug-script
> +++ linux-2.6/Documentation/firmware_class/hotplug-script
> @@ -6,6 +6,9 @@
>
>  HOTPLUG_FW_DIR=3D/usr/lib/hotplug/firmware/
>
> +if [ -e /sys/$DEVPATH/data_size ]; then
> +	stat -c %s $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data_size
> +fi
>  echo 1 > /sys/$DEVPATH/loading
>  cat $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data
>  echo 0 > /sys/$DEVPATH/loading
> --- linux-2.6.orig/drivers/base/firmware_class.c
> +++ linux-2.6/drivers/base/firmware_class.c
> @@ -46,6 +46,7 @@ struct firmware_priv {
>  	struct firmware *fw;
>  	unsigned long status;
>  	int alloc_size;
> +	int size_hint;

Unsigned?

>  	struct timer_list timeout;
>  };
>
> @@ -114,6 +115,32 @@ static struct class firmware_class =3D {
>  	.dev_release	=3D fw_dev_release,
>  };
>
> +static ssize_t firmware_data_size_show(struct device *dev,
> +				       struct device_attribute *attr, char *buf)
> +{
> +	struct firmware_priv *fw_priv =3D dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d\n", fw_priv->size_hint);
> +}
> +

Why would you need it? It is no importance once firmware had been=20
loaded. I'd personally consider it as write-only.

> +static ssize_t firmware_data_size_store(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct firmware_priv *fw_priv =3D dev_get_drvdata(dev);
> +	long value;
> +	int err;
> +
> +	err =3D strict_strtol(buf, 10, &value);
> +	if (err)
> +		return err;
> +	fw_priv->size_hint =3D value;

Should not there be some protection against using silly large values?=20

> +	return count;
> +}
> +
> +static DEVICE_ATTR(data_size, 0644,
> +		   firmware_data_size_show, firmware_data_size_store);
> +
>  static ssize_t firmware_loading_show(struct device *dev,
>  				     struct device_attribute *attr, char *buf)
>  {
> @@ -207,6 +234,7 @@ fw_realloc_buffer(struct firmware_priv *
>  	if (min_size <=3D fw_priv->alloc_size)
>  		return 0;
>
> +	min_size =3D max(min_size, fw_priv->size_hint);
>  	new_size =3D ALIGN(min_size, PAGE_SIZE);
>  	new_data =3D vmalloc(new_size);
>  	if (!new_data) {
> @@ -359,6 +387,12 @@ static int fw_setup_device(struct firmwa
>  		goto error_unreg;
>  	}
>
> +	retval =3D device_create_file(f_dev, &dev_attr_data_size);
> +	if (retval) {
> +		dev_err(device, "%s: device_create_file failed\n", __func__);
> +		goto error_unreg;
> +	}
> +
>  	retval =3D device_create_file(f_dev, &dev_attr_loading);
>  	if (retval) {
>  		dev_err(device, "%s: device_create_file failed\n", __func__);


--nextPart1459720.xnBk3OXHsR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknWRogACgkQR6LMutpd94xmuQCdHyHzeAKKWDyn7kbUYweNTGxA
yNoAnjH1I9H+/q8rjgp3UYz5awWdghXW
=QCKS
-----END PGP SIGNATURE-----

--nextPart1459720.xnBk3OXHsR--
