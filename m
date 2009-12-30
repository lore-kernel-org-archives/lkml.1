Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbZL3RPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbZL3RPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZL3RPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:15:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39759 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZL3RPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:15:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GXUzzbwU+nZNbTyLzfBHQ1H16uVOHfI+WXD6q/R94uhLxJIBd4qUh1PR3uvgkwfEhV
         CSdFMB/vy0azNJCsSHyomXXYxIu6yCABzjbuHp4UYhtDJJxhDvdtSKl4CObB4RldUUZl
         hHLfmh5k2ydMr5rWD/GwyZryPqS0V9FpE96c4=
Date: Wed, 30 Dec 2009 18:14:58 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: Re: [patch] USB: serial: fix DMA buffers on stack for io_edgeport.c
Message-ID: <20091230171457.GA15063@localhost>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
 <20091230160645.GC29476@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230160645.GC29476@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dan,

Looks like you forgot to free StringDesc:

> --- orig/drivers/usb/serial/io_edgeport.c	2009-12-30 16:20:35.000000000 +0200
> +++ devel/drivers/usb/serial/io_edgeport.c	2009-12-30 16:25:27.000000000 +0200
> @@ -372,21 +372,24 @@ static void update_edgeport_E2PROM(struc
>   ************************************************************************/
>  static int get_string(struct usb_device *dev, int Id, char *string, int buflen)
>  {
> -	struct usb_string_descriptor StringDesc;
> +	struct usb_string_descriptor *StringDesc;
>  	struct usb_string_descriptor *pStringDesc;
>  
>  	dbg("%s - USB String ID = %d", __func__, Id);
>  
> +	StringDesc = kmalloc(sizeof(*StringDesc), GFP_KERNEL);
> +	if (!StringDesc)
> +		return 0;
>  	if (!usb_get_descriptor(dev, USB_DT_STRING, Id,
> -					&StringDesc, sizeof(StringDesc)))
> +					StringDesc, sizeof(*StringDesc)))

here

>  		return 0;
>  
> -	pStringDesc = kmalloc(StringDesc.bLength, GFP_KERNEL);
> +	pStringDesc = kmalloc(StringDesc->bLength, GFP_KERNEL);
>  	if (!pStringDesc)

here

>  		return 0;
>  
>  	if (!usb_get_descriptor(dev, USB_DT_STRING, Id,
> -					pStringDesc, StringDesc.bLength)) {
> +					pStringDesc, StringDesc->bLength)) {

here

>  		kfree(pStringDesc);
>  		return 0;
>  	}

and here.

Thanks,
Johan

