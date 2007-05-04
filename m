Return-Path: <linux-kernel-owner+w=401wt.eu-S1161292AbXEDVPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161292AbXEDVPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161333AbXEDVPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:15:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161292AbXEDVPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:15:38 -0400
Date: Fri, 4 May 2007 14:14:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Duncan Sands <duncan.sands@math.u-psud.fr>,
       Krzysztof Lichota <krzysiek@lichota.net>
Subject: Re: [PATCH 1/2] cxacru: Create sysfs attributes in atm_start
 instead of bind
Message-Id: <20070504141441.6e327140.akpm@linux-foundation.org>
In-Reply-To: <463B675A.10900@simon.arlott.org.uk>
References: <463B675A.10900@simon.arlott.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 18:03:22 +0100
Simon Arlott <simon@fire.lp0.eu> wrote:

> Since usbatm doesn't set the usb_interface driver data until after calling bind 
> and heavy_init, it would be NULL when the sysfs attributes are read. Reading the 
> MAC address from atm_dev before atm_dev exists would have been be possible too.
> 
> Calling create_device_file in atm_start will avoid this problem, and the data 
> is useless until the first status poll runs. However, it must be ready before a 
> status poll does a printk on line status change otherwise userspace could react 
> before the files exist.
> 
> For completeness I've moved remove_device_file to atm_stop so it's not called in 
> unbind when it's not needed.
> 

This patch is mysteriously mangled.

> 
> drivers/usb/atm/cxacru.c |   45 +++++++++++++++++++++++++--------------------
> 1 files changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
> index 0b12ace..4ecb4c7 100644
> --- a/drivers/usb/atm/cxacru.c
> +++ b/drivers/usb/atm/cxacru.c
> @@ -618,10 +618,22 @@ static int cxacru_card_status(struct cxacru_data *instance)
> 	return 0;
> }
> 
> +static void cxacru_remove_device_files(struct usbatm_data *usbatm_instance,
> +		struct atm_dev *atm_dev)
> +{
> +	struct usb_interface *intf = usbatm_instance->usb_intf;
> +
> +	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
> +		device_remove_file(&intf->dev, &dev_attr_##_name);
> +	CXACRU_ALL_FILES(REMOVE);
> +	#undef CXACRU_DEVICE_REMOVE_FILE
> +}
> +
> static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
> 		struct atm_dev *atm_dev)
> {

See, that "^{" should have been "^ {".  Something has gobbled the leading
space.

Anyway, after some futzing around I was able to determine that this patch
is identical to the one I already have.  Ho hum.

