Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYIVNWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYIVNWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYIVNWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:22:11 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:10150 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbYIVNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:22:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYFAE8510jCTsYx/2dsb2JhbACBXbRQgWY
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-uvc-devel@lists.berlios.de
Subject: Re: [Linux-uvc-devel] Buffer overflow in uvc-video.
Date: Mon, 22 Sep 2008 15:22:03 +0200
User-Agent: KMail/1.9.9
Cc: Ralph Loader <suckfish@ihug.co.nz>, linux-kernel@vger.kernel.org
References: <20080920201258.66c4c657@i.geek.nz>
In-Reply-To: <20080920201258.66c4c657@i.geek.nz>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221522.03694.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralph,

On Saturday 20 September 2008, Ralph Loader wrote:
> Hi,
>
> There appears to be a buffer overflow in
> drivers/media/video/uvc/uvc_ctrl.c:
>
> Sep 20 17:53:12 i kernel: BUG kmalloc-8 (Not tainted): Redzone
> overwritten Sep 20 17:53:12 i kernel:
> --------------------------------------------------------------------
> --------- Sep 20 17:53:12 i kernel:
> Sep 20 17:53:12 i kernel: INFO: 0xf2c5ce08-0xf2c5ce0b. First byte 0xa1
> instead of 0xcc
> Sep 20 17:53:12 i kernel: INFO: Allocated in
> uvc_query_v4l2_ctrl+0x3c/0x239 [uvcvideo] age=13 cpu=1 pid=4975
> ...
>
>
> A fixed size 8-byte buffer is allocated, and a variable size field is
> read into it; there is no particular bound on the size of the field
> (it is dependent on hardware and configuration) and it can overflow
> [also verified by inserting printk's.]

Thanks for catching this.

> The patch below attempts to size the buffer to the correctly; I do not
> know if sufficient validation of that size is carried out.

UVC control sizes come either from the predefined controls (uvc_ctrls in 
uvc_ctrl.c) or from user-defined controls.

Predefined controls size doesn't need any validation. User-defined controls 
size should be validated, but defining a new UVC control from userspace 
requires root privileges. This currently mitigates the issue. I'll submit a 
patch with an upper bound check on the size.

> Cheers,
> Ralph Loader.
>
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ct rl.c
> index 6ef3e52..feab12a 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -592,7 +592,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_device
> *video, if (ctrl == NULL)
>                 return -EINVAL;
>
> -       data = kmalloc(8, GFP_KERNEL);
> +       data = kmalloc(ctrl->info->size, GFP_KERNEL);
>         if (data == NULL)
>                 return -ENOMEM;

Laurent Pinchart
