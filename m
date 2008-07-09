Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYGIULE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYGIULE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYGIUKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:10:54 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:35262 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbYGIUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:10:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEAALu3dEhR8saB/2dsb2JhbAAIsSQ
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Roland Dreier <roland@digitalvampire.org>
Subject: Re: Linux 2.6.26-rc9 circular lock with uvcvideo on resume from hibernation
Date: Wed, 9 Jul 2008 22:10:56 +0200
User-Agent: KMail/1.9.9
Cc: Romano Giannetti <romano@dea.icai.upcomillas.es>,
       linux-kernel@vger.kernel.org, linux-uvc-devel@berlios.de
References: <1215426867.5113.8.camel@pern> <200807092129.03679.laurent.pinchart@skynet.be> <87mykq96mh.fsf@shaolin.home.digitalvampire.org>
In-Reply-To: <87mykq96mh.fsf@shaolin.home.digitalvampire.org>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092210.56678.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2008, Roland Dreier wrote:
>  > uvc_disconnect()                      | uvc_v4l2_open()
>  > ...                                   |
>  > mutex_lock(&uvc_driver.open_mutex);   |
>  > dev->state |= UVC_DEV_DISCONNECTED;   |
>  > mutex_unlock(&uvc_driver.open_mutex); |
>  >
>  >                                       | mutex_lock(&uvc_driver.open_mute
>  >                                       |x); vdev = video_devdata(file);
>  >                                       | video = video_get_drvdata(vdev);
>  >
>  > kref_put(&dev->kref, uvc_delete);     |
>  >
>  >                                       | if (video->dev->state...)
>  >
>  > kref_put() in uvc_disconnect() will call uvc_delete(), which will in
>  > turn free the video structure. uvc_v4l2_open() will then dereference
>  > freed memory when testing the device state.
>
> I don't believe this is correct.  I tried to explain it in my
> changelog by saying "uvc_delete() does uvc_unregister_video() (and
> hence video_unregister_device(), which is synchronized with
> videodev_lock) as its first thing, so there is no risk of
> use-after-free in uvc_v4l2_open()."
>
> In other words, the first thing uvc_delete() does is call
> uvc_unregister_video(), which will video_unregister_device().  Since
> this needs to take videodev_lock, it will wait until uvc_v4l2_open()
> returns (which it will do, since state is now UVC_DEV_DISCONNECTED).
> So the video struct will not be freed until after uvc_v4l2_open()
> returns.
>
> As far as I can see there is no use-after-free.

My bad, you seem to be right. I'll apply your patch.

Have you checked David's videodev patch ? Any opinion ?

Best regards,

Laurent Pinchart
