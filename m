Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYHYJTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYHYJTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYHYJSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:18:37 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:16550 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046AbYHYJSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hQ/xzu1ApsKpPyg1+9g+2TiEaUghEDv6PdFv+0OuUfek5GYMDL/DO/t1b2fKNdoEeM
         iQmPe/JmPt9GWjvZW0oBznewjmPm/eIqU+OfMGnNvGJJX0W0mlmnMjZ2jzubx0qGXR6Z
         oMNoDpQ02AK9oHorpn6NYsVoV4MtlBeAq9UqM=
Message-ID: <386072610808250218g583041c3l14d63f2c78a886ec@mail.gmail.com>
Date: Mon, 25 Aug 2008 17:18:34 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org, ajay.gupta@ti.com
Subject: Re: [PATCH 2/2] usb: musb: fix bug - should call usb_hcd_unlink_urb_from_ep before usb_hcd_giveback_urb
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1219655621-18510-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219655621-18510-1-git-send-email-cooloney@kernel.org>
	 <1219655621-18510-3-git-send-email-cooloney@kernel.org>
X-Google-Sender-Auth: 1fee4f848f3342b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was posted by Ajay. Please ignore it.

-Bryan

On Mon, Aug 25, 2008 at 5:13 PM, Bryan Wu <cooloney@kernel.org> wrote:
> This bug was found on Blackfin BF54x and BF52x board since kernel 2.6.24 USB API change
> http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=4265
>
> __musb_giveback is called by not only musb_giveback but also musb_urb_dequeue.
> musb_urb_dequeue also need call usb_hcd_unlink_urb_from_ep before usb_hcd_giveback_urb.
>
> So move usb_hcd_unlink_urb_from_ep from musb_giveback to __musb_giveback to fix this bug.
>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/usb/musb/musb_host.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
> index 8b4be01..ba98ac5 100644
> --- a/drivers/usb/musb/musb_host.c
> +++ b/drivers/usb/musb/musb_host.c
> @@ -291,6 +291,8 @@ __acquires(musb->lock)
>                        urb->actual_length, urb->transfer_buffer_length
>                        );
>
> +       usb_hcd_unlink_urb_from_ep(musb_to_hcd(musb), urb);
> +
>        spin_unlock(&musb->lock);
>        usb_hcd_giveback_urb(musb_to_hcd(musb), urb, status);
>        spin_lock(&musb->lock);
> @@ -353,8 +355,6 @@ musb_giveback(struct musb_qh *qh, struct urb *urb, int status)
>                break;
>        }
>
> -       usb_hcd_unlink_urb_from_ep(musb_to_hcd(musb), urb);
> -
>        qh->is_ready = 0;
>        __musb_giveback(musb, urb, status);
>        qh->is_ready = ready;
> --
> 1.5.6
>
