Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYKAXC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYKAXC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 19:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYKAXCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 19:02:49 -0400
Received: from styx.suse.cz ([82.119.242.94]:37063 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751776AbYKAXCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 19:02:48 -0400
Date: Sun, 2 Nov 2008 00:02:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>, Jeroen Roovers <jer@gentoo.org>,
       Helge Deller <deller@gmx.de>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
In-Reply-To: <1225579306-28524-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0811020000360.29633@jikos.suse.cz>
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008, Jiri Slaby wrote:

> `stop' left out usbhid->urb* pointers and so the next `start' thought
> it needs to allocate nothing and used the memory pointers previously
> pointed to. This led to memory corruption and device malfunction.
> 
> Also don't forget to clear disconnect flag on start which was left set
> by the previous `stop'.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/hid/usbhid/hid-core.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 18e5ddd..f0339ae 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -781,6 +781,8 @@ static int usbhid_start(struct hid_device *hid)
>  	unsigned int n, insize = 0;
>  	int ret;
>  
> +	clear_bit(HID_DISCONNECTED, &usbhid->iofl);
> +
>  	usbhid->bufsize = HID_MIN_BUFFER_SIZE;
>  	hid_find_max_report(hid, HID_INPUT_REPORT, &usbhid->bufsize);
>  	hid_find_max_report(hid, HID_OUTPUT_REPORT, &usbhid->bufsize);
> @@ -888,6 +890,9 @@ fail:
>  	usb_free_urb(usbhid->urbin);
>  	usb_free_urb(usbhid->urbout);
>  	usb_free_urb(usbhid->urbctrl);
> +	usbhid->urbin = NULL;
> +	usbhid->urbout = NULL;
> +	usbhid->urbctrl = NULL;
>  	hid_free_buffers(dev, hid);
>  	mutex_unlock(&usbhid->setup);
>  	return ret;
> @@ -924,6 +929,9 @@ static void usbhid_stop(struct hid_device *hid)
>  	usb_free_urb(usbhid->urbin);
>  	usb_free_urb(usbhid->urbctrl);
>  	usb_free_urb(usbhid->urbout);
> +	usbhid->urbin = NULL; /* don't mess up next start */
> +	usbhid->urbctrl = NULL;
> +	usbhid->urbout = NULL;
>  
>  	hid_free_buffers(hid_to_usb_dev(hid), hid);
>  	mutex_unlock(&usbhid->setup);

Jeroen, Helge,

could you please verify whether this patch fixes the corruption you were 
experiencing?

[ I will be offline for the upcoming ~9 days, will push the fix upstream 
  then, if it is not picked up through different channels in the 
  meantime ]

Thanks!

-- 
Jiri Kosina
SUSE Labs
