Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYGIT3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYGIT3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYGIT3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:29:04 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:23590 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbYGIT3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:29:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEAAHysdEhR8saB/2dsb2JhbAAIsUo
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Roland Dreier <roland@digitalvampire.org>
Subject: Re: Linux 2.6.26-rc9 circular lock with uvcvideo on resume from hibernation
Date: Wed, 9 Jul 2008 21:29:03 +0200
User-Agent: KMail/1.9.9
Cc: Romano Giannetti <romano@dea.icai.upcomillas.es>,
       linux-kernel@vger.kernel.org, linux-uvc-devel@berlios.de
References: <1215426867.5113.8.camel@pern> <878wwdbnjn.fsf@shaolin.home.digitalvampire.org>
In-Reply-To: <878wwdbnjn.fsf@shaolin.home.digitalvampire.org>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092129.03679.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Romano and Roland,

On Monday 07 July 2008, Roland Dreier wrote:
>  > [ 1132.942569] khubd/2264 is trying to acquire lock:
>  > [ 1132.942614]  (videodev_lock){--..}, at: [<f89e4595>]
>  > video_unregister_device+0x15/0x60 [videodev] [ 1132.942810]
>  > [ 1132.942811] but task is already holding lock:
>  > [ 1132.942890]  (&uvc_driver.open_mutex){--..}, at: [<f8a35c09>]
>  > uvc_disconnect+0x29/0x50 [uvcvideo]
>
> Thanks very much for the report (and for testing development kernels
> with lockdep enabled!).

I second this. Thanks a lot.

> I think the patch below should fix this.
>
> Laurent -- if this patch looks good to you, please forward on for
> merging.
>
> Thanks,
>   Roland
>
> ---
>
> [PATCH] uvc: Fix possible AB-BA deadlock with videodev_lock and open_mutex
>
> The uvcvideo driver's uvc_v4l2_open() method is called from videodev's
> video_open() function, which means it is called with the videodev_lock
> mutex held.  uvc_v4l2_open() then takes uvc_driver.open_mutex to check
> dev->state and avoid racing against a device disconnect, which means
> that open_mutex must nest inside videodev_lock.

The open_mutex lock's main purpose is to prevent uvc_delete() being called 
from kref_put() while an open operation is in progress. Protected dev->state 
is a side effect which might not be required.

> However uvc_disconnect() takes the open_mutex around setting
> dev->state and also around putting its device reference.  However, if
> uvc_disconnect() ends up dropping the last reference, it will call
> uvc_delete(), which calls into the videodev code to unregister its
> device, and this will end up taking videodev_lock.  This opens a
> (unlikely in practice) window for an AB-BA deadlock and also causes a
> lockdep warning because of the lock misordering.

I agree with this analysis.

> Fortunately there is no apparent reason to hold open_mutex when doing
> kref_put() in uvc_disconnect(): if uvc_v4l2_open() runs before the
> state is set to UVC_DEV_DISCONNECTED, then it will take another
> reference to the device and kref_put() won't call uvc_delete; if
> uvc_v4l2_open() runs after the state is set, it will run before
> uvc_delete(), see the state, and return immediately -- uvc_delete()
> does uvc_unregister_video() (and hence video_unregister_device(),
> which is synchronized with videodev_lock) as its first thing, so there
> is no risk of use-after-free in uvc_v4l2_open().

This introduces a race condition, see below.

> Bug diagnosed based on a lockdep warning reported by Romano Giannetti
> <romano@dea.icai.upcomillas.es>.
>
> Signed-off-by: Roland Dreier <roland@digitalvampire.org>
> ---
>  drivers/media/video/uvc/uvc_driver.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index 60ced58..5d60cb3 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -1634,11 +1634,10 @@ static void uvc_disconnect(struct usb_interface
> *intf) * chance to increase the reference count (kref_get).
>  	 */
>  	mutex_lock(&uvc_driver.open_mutex);
> -
>  	dev->state |= UVC_DEV_DISCONNECTED;
> -	kref_put(&dev->kref, uvc_delete);
> -
>  	mutex_unlock(&uvc_driver.open_mutex);
> +
> +	kref_put(&dev->kref, uvc_delete);
>  }
>
>  static int uvc_suspend(struct usb_interface *intf, pm_message_t message)

uvc_disconnect()                      | uvc_v4l2_open()
...                                   |
mutex_lock(&uvc_driver.open_mutex);   |
dev->state |= UVC_DEV_DISCONNECTED;   |
mutex_unlock(&uvc_driver.open_mutex); |
                                      |
                                      | mutex_lock(&uvc_driver.open_mutex);
                                      | vdev = video_devdata(file);
                                      | video = video_get_drvdata(vdev);
                                      |
kref_put(&dev->kref, uvc_delete);     |
                                      |
                                      | if (video->dev->state...) 

kref_put() in uvc_disconnect() will call uvc_delete(), which will in turn free 
the video structure. uvc_v4l2_open() will then dereference freed memory when 
testing the device state.

I proper fix will involve videodev modifications. Fortunately, David 
Ellingsworth posted a videodev patch to address the same kind of issue a few 
days ago. Search the video4linux mailing list for a thread called "[PATCH] 
videodev: fix sysfs kobj ref count". I'm currently reviewing his patch. As 
soon as a proper fix is applied to videodev I will probably drop the 
open_mutex lock acquisition in uvc_disconnect().

In the meantime, and for kernel versions that don't include the videodev 
patch, I don't know what to choose between a race condition that can lead to 
freed memory dereference, and a AB-BA deadlock. Any opinion on that ?

Best regards,

Laurent Pinchart
