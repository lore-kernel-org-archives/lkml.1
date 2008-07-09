Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYGITxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYGITxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbYGITxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:53:30 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:47577 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbYGITx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:53:29 -0400
X-Authority-Analysis: v=1.0 c=1 a=fmkApugzUIIA:10 a=kpXAE35kjxYA:10
 a=GJPMjpJTlsuecQNlq0UA:9 a=H4b-8a9W12fmFzzUvBZkI9m4DmwA:4 a=JTUSPwgBgNAA:10
 a=oCUJXWGl-OwA:10
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Romano Giannetti <romano@dea.icai.upcomillas.es>,
       linux-kernel@vger.kernel.org, linux-uvc-devel@berlios.de
Subject: Re: Linux 2.6.26-rc9 circular lock with uvcvideo on resume from hibernation
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
References: <1215426867.5113.8.camel@pern>
	<878wwdbnjn.fsf@shaolin.home.digitalvampire.org>
	<200807092129.03679.laurent.pinchart@skynet.be>
From: Roland Dreier <roland@digitalvampire.org>
Date: Wed, 09 Jul 2008 12:53:26 -0700
In-Reply-To: <200807092129.03679.laurent.pinchart@skynet.be> (Laurent Pinchart's message of "Wed, 9 Jul 2008 21:29:03 +0200")
Message-ID: <87mykq96mh.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > uvc_disconnect()                      | uvc_v4l2_open()
 > ...                                   |
 > mutex_lock(&uvc_driver.open_mutex);   |
 > dev->state |= UVC_DEV_DISCONNECTED;   |
 > mutex_unlock(&uvc_driver.open_mutex); |
 >                                       |
 >                                       | mutex_lock(&uvc_driver.open_mutex);
 >                                       | vdev = video_devdata(file);
 >                                       | video = video_get_drvdata(vdev);
 >                                       |
 > kref_put(&dev->kref, uvc_delete);     |
 >                                       |
 >                                       | if (video->dev->state...) 
 > 
 > kref_put() in uvc_disconnect() will call uvc_delete(), which will in turn free 
 > the video structure. uvc_v4l2_open() will then dereference freed memory when 
 > testing the device state.

I don't believe this is correct.  I tried to explain it in my
changelog by saying "uvc_delete() does uvc_unregister_video() (and
hence video_unregister_device(), which is synchronized with
videodev_lock) as its first thing, so there is no risk of
use-after-free in uvc_v4l2_open()."

In other words, the first thing uvc_delete() does is call
uvc_unregister_video(), which will video_unregister_device().  Since
this needs to take videodev_lock, it will wait until uvc_v4l2_open()
returns (which it will do, since state is now UVC_DEV_DISCONNECTED).
So the video struct will not be freed until after uvc_v4l2_open()
returns.

As far as I can see there is no use-after-free.

 - R.
-- 
Roland Dreier  <roland@digitalvampire.org>  GPG Key: 1024D/E0EEFAC0
Fingerprint:     A89F B5E9 C185 F34D BD50  4009 37E2 25CC E0EE FAC0

 Sending >500KB attachments is forbidden by the Geneva Convention.
        Your country may be at risk if you fail to comply.
