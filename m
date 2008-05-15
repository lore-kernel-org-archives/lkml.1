Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbYEOPnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbYEOPnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYEOPnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:43:08 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:45531 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYEOPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:43:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] zd1211rw: Use DMA-aware buffer for usb transfer
Date: Thu, 15 May 2008 17:42:35 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080516.001215.39152691.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080516.001215.39152691.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805151742.35366.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2008 17:12:15 Atsushi Nemoto wrote:
> @@ -312,22 +313,29 @@ int zd_usb_read_fw(struct zd_usb *usb, zd_addr_t addr, u8 *data, u16 len)
>  {
>  	int r;
>  	struct usb_device *udev = zd_usb_to_usbdev(usb);
> +	u8 *buf = kmalloc(len, GFP_KERNEL);
>  
> +	if (!buf)
> +		return -ENOMEM;

Not that my opinion counts here, but I don't like the coding style of
doing work in the variable definition block.
Pointer assignments in there are OK (like the zd_usb_to_usbdev, which just
fetches a pointer), but a kmalloc() call is IMO very confusing.

But the decision whether this is OK or not is not up to me.

>  	r = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  		USB_REQ_FIRMWARE_READ_DATA, USB_DIR_IN | 0x40, addr, 0,
> -		data, len, 5000);
> +		buf, len, 5000);
>  	if (r < 0) {
>  		dev_err(&udev->dev,
>  			"read over firmware interface failed: %d\n", r);
> -		return r;
> +		goto exit;
>  	} else if (r != len) {
>  		dev_err(&udev->dev,
>  			"incomplete read over firmware interface: %d/%d\n",
>  			r, len);
> -		return -EIO;
> +		r = -EIO;
> +		goto exit;
>  	}
> -
> -	return 0;
> +	r = 0;
> +	memcpy(data, buf, len);
> +exit:
> +	kfree(buf);
> +	return r;
>  }


-- 
Greetings Michael.
