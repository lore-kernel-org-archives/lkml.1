Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYHWOdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYHWOdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 10:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYHWOda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 10:33:30 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3082 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYHWOd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 10:33:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: V4L2: switch to register_chrdev_region: needs testing/review of release() handling
Date: Sat, 23 Aug 2008 16:31:26 +0200
User-Agent: KMail/1.9.9
Cc: v4l <video4linux-list@redhat.com>, Hans de Goede <j.w.r.degoede@hhs.nl>,
       david@identd.dyndns.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Mike Isely <isely@isely.net>
References: <200808171709.51258.hverkuil@xs4all.nl> <200808231601.33052.laurent.pinchart@skynet.be>
In-Reply-To: <200808231601.33052.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808231631.26716.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2008 16:01:32 Laurent Pinchart wrote:
> Hi Hans,
>
> On Sunday 17 August 2008, Hans Verkuil wrote:
> > Hi all,
> >
> > As part of my ongoing cleanup of the v4l subsystem I've been
> > looking into converting v4l from register_chrdev to
> > register_chrdev_region. The latter is more flexible and allows for
> > a larger range of minor numbers. In addition it allows us to
> > intercept the release callback when the char device's refcount
> > reaches 0.
> >
> > This is very useful for hotpluggable devices like USB webcams.
> > Currently usb video drivers need to do the refcounting themselves,
> > but with this patch they can rely on the release callback since it
> > will only be called when the last user has closed the device. Since
> > current usb drivers do the refcounting in varying degrees of
> > competency (from 'not' to 'if you're lucky' to 'buggy' to
> > 'perfect') it would be nice to have the v4l framework take care of
> > this.
> >
> > So on a disconnect the driver can call video_unregister_device()
> > even if an application still has the device open. Only when the
> > application closes as well will the release be called and the
> > driver can do the final cleanup.
> >
> > In fact, I think with this change it should even be possible to
> > reconnect the webcam even while some application is still using the
> > old char device. In that case a new minor number will be chosen
> > since the old one is still in use, but otherwise the webcam should
> > just work as usual. This is untested, though.
> >
> > Note that right now I basically copy the old release callback as
> > installed by cdev_init() and install our own v4l callback instead
> > (to be precise, I replace the ktype pointer with our own
> > kobj_type).
> >
> > It would be much cleaner if chardev.c would allow one to set a
> > callback explicitly. It's not difficult to do that, but before
> > doing that I first have to know whether my approach is working
> > correctly.
> >
> > The v4l-dvb repository with my changes is here:
> >
> > http://linuxtv.org/hg/~hverkuil/v4l-dvb-cdev2/
> >
> > To see the diff in question:
> >
> > http://linuxtv.org/hg/~hverkuil/v4l-dvb-cdev2/rev/98acd2c1dea1
> >
> > I have tested myself with the quickcam_messenger webcam. For this
> > driver this change actually fixed a bug: disconnecting while a
> > capture was in progress and then trying to use /dev/video0 would
> > lock that second application.
> >
> > I also tested with gspca: I could find no differences here, it all
> > worked as before.
> >
> > There are a lot more USB video devices and it would be great if
> > people could test with their devices to see if this doesn't break
> > anything. Having a release callback that is called when it is
> > really safe to free everything should make life a lot easier I
> > think.
>
> I've given your patch a try on 2.6.27-rc4 with the uvcvideo driver.
> Nothing seems to have been broken so far, and the uvcvideo driver got
> a bit simpler as I've been able to get rid of the refcounting logic.
> Good job.

Thanks for testing this!

> Do we really need the double refcounting (class device and character
> device) ? As far as I can tell, the class device is only used for the
> name and index sysfs attributes. Its release callback, video_release,
> is called as soon as video_unregister_device drops its reference to
> the class device, even when sysfs files are still opened.

I think that in practice it probably isn't necessary, but I do know that 
it is the correct way to do it. It doesn't matter for the driver, since 
that has only one release to deal with.

I want to do a few additional tests next weekend and if they all pass, 
then I'll ask Mauro to merge this patch.

Regards,

	Hans
