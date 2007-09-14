Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbXINN62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbXINN62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXINN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:58:21 -0400
Received: from as3.cineca.com ([130.186.84.211]:41869 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbXINN6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:58:20 -0400
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: luca.risolia@studio.unibo.it
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] v4l: fix build error for et61x251 driver
Date: Fri, 14 Sep 2007 15:57:56 +0200
User-Agent: KMail/1.9.6
Cc: aherrman@arcor.de, Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <20070913123627.GD10348@devil> <20070914074852.GA5598@devil> <1189774211.5292.44.camel@gaivota>
In-Reply-To: <1189774211.5292.44.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709141557.56514.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2007 14:50:11 Mauro Carvalho Chehab wrote:
> > > > This patch is really ugly.
> >
> > Well, yes. I should have known as I converted so many occurences of
> > to_video_device to container_of in my second patch.
> >
> > > > Why can't the "to_video_device()" macro be used? Just move it to a
> > > > place where it's usable! IOW, what's wrong with the *much* simpler
> > > > patch below?
> > >
> > > There's nothing wtong in my opinion. I do not know the exact reason why
> > > Mauro moved "to_video_device()" into CONFIG_VIDEO_V4L1_COMPAT. Pheraps
> > > he can give more details about this change.
> >
> > BTW, just a few V4L2 drivers and videodev seem to use this construct:
> >   video/usbvision/usbvision-video.c:    container_of(cd, struct
> > video_device, class_dev);
> >
> >   video/sn9c102/sn9c102_core.c:   cam =
> > video_get_drvdata(container_of(cd, struct video_device,
> > video/sn9c102/sn9c102_core.c-                                       
> > class_dev));
> >
> >   video/videodev.c:       struct video_device *vfd = container_of(cd,
> > struct video_device, video/videodev.c-                                   
> >            class_dev);
> >
> > And then their are drivers with other variants of container_of, e.g.:
> >   video/pvrusb2/pvrusb2-v4l2.c:   vp = container_of(chp,struct
> > pvr2_v4l2,channel); video/bt8xx/bttv-vbi.c: struct bttv_buffer *buf =
> > container_of(vb,struct bttv_buffer,vb); ...
> >
> > I think, there should be a to_video_device macro for usage in v4l2.
> > An most probable for the other container_of stuff (when more there is
> > more than one occurence of a particular construct), drivers should
> > provide their own macro, e.g. to_video_buffer() or so.
> >
> > That's what other subsystems do. It is more self-explanatory than a
> > direct usage of container_of.
> >
> > So why not apply (my first patch ... oh no, of course that's  rubbish ;-)
> > Linus' below patch for 2.6.23 to fix the compilation for that particular
> > driver. And to work on the conversion of container_of() stuff to
> > meaningful macros for the next kernel release?
>
> The to_video_device and the container_of (cd, struct video_device,
> class_dev) (as you noticed at the above drivers) are used to provide
> procfs interface.
>
> On videodev, there's the v4l2 core stuff, used on all V4L drivers. It
> allows some control to the V4L devices (basically, see/change the
> modprobe loading parameters).
>
> The other drivers that uses to_video_device (or the container_of
> alternative) to create other userspace interfaces, specific to each
> driver and not documented at V4L2 API:
>
> bttv-driver.c:static CLASS_DEVICE_ATTR(card, S_IRUGO, show_card, NULL);
> et61x251_core.c:static CLASS_DEVICE_ATTR(reg, S_IRUGO | S_IWUSR,
> et61x251_core.c:static CLASS_DEVICE_ATTR(val, S_IRUGO | S_IWUSR,
> et61x251_core.c:static CLASS_DEVICE_ATTR(i2c_reg, S_IRUGO | S_IWUSR,
> et61x251_core.c:static CLASS_DEVICE_ATTR(i2c_val, S_IRUGO | S_IWUSR,
> ov511.c:static CLASS_DEVICE_ATTR(custom_id, S_IRUGO, show_custom_id, NULL);
> ov511.c:static CLASS_DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
> ov511.c:static CLASS_DEVICE_ATTR(bridge, S_IRUGO, show_bridge, NULL);
> ov511.c:static CLASS_DEVICE_ATTR(sensor, S_IRUGO, show_sensor, NULL);
> ov511.c:static CLASS_DEVICE_ATTR(brightness, S_IRUGO, show_brightness,
> NULL); ov511.c:static CLASS_DEVICE_ATTR(saturation, S_IRUGO,
> show_saturation, NULL); ov511.c:static CLASS_DEVICE_ATTR(contrast, S_IRUGO,
> show_contrast, NULL); ov511.c:static CLASS_DEVICE_ATTR(hue, S_IRUGO,
> show_hue, NULL);
> ov511.c:static CLASS_DEVICE_ATTR(exposure, S_IRUGO, show_exposure, NULL);
> pwc-if.c:static CLASS_DEVICE_ATTR(pan_tilt, S_IRUGO | S_IWUSR,
> show_pan_tilt, pwc-if.c:static CLASS_DEVICE_ATTR(button, S_IRUGO | S_IWUSR,
> show_snapshot_button_status, sn9c102_core.c:static CLASS_DEVICE_ATTR(reg,
> S_IRUGO | S_IWUSR,
> sn9c102_core.c:static CLASS_DEVICE_ATTR(val, S_IRUGO | S_IWUSR,
> sn9c102_core.c:static CLASS_DEVICE_ATTR(i2c_reg, S_IRUGO | S_IWUSR,
> sn9c102_core.c:static CLASS_DEVICE_ATTR(i2c_val, S_IRUGO | S_IWUSR,
> sn9c102_core.c:static CLASS_DEVICE_ATTR(green, S_IWUGO, NULL,
> sn9c102_store_green); sn9c102_core.c:static CLASS_DEVICE_ATTR(blue,
> S_IWUGO, NULL, sn9c102_store_blue); sn9c102_core.c:static
> CLASS_DEVICE_ATTR(red, S_IWUGO, NULL, sn9c102_store_red);
> sn9c102_core.c:static CLASS_DEVICE_ATTR(frame_header, S_IRUGO,
> stv680.c:static CLASS_DEVICE_ATTR(name, S_IRUGO, show_##name, NULL);
> usbvision-video.c:static CLASS_DEVICE_ATTR(version, S_IRUGO, show_version,
> NULL); usbvision-video.c:static CLASS_DEVICE_ATTR(model, S_IRUGO,
> show_model, NULL); usbvision-video.c:static CLASS_DEVICE_ATTR(hue, S_IRUGO,
> show_hue, NULL); usbvision-video.c:static CLASS_DEVICE_ATTR(contrast,
> S_IRUGO, show_contrast, NULL); usbvision-video.c:static
> CLASS_DEVICE_ATTR(brightness, S_IRUGO, show_brightness, NULL);
> usbvision-video.c:static CLASS_DEVICE_ATTR(saturation, S_IRUGO,
> show_saturation, NULL); usbvision-video.c:static
> CLASS_DEVICE_ATTR(streaming, S_IRUGO, show_streaming, NULL);
> usbvision-video.c:static CLASS_DEVICE_ATTR(compression, S_IRUGO,
> show_compression, NULL); usbvision-video.c:static CLASS_DEVICE_ATTR(bridge,
> S_IRUGO, show_device_bridge, NULL);
>
> From the above, you can clearly see that et62x251 and s9c102 provides an
> interface to directly change a register at the device. The other drivers
> allows reading/changing a few controls directly via /proc (this is also
> possible, using V4L2 interface). This is not recommended, since V4L2 API
> should be the proper way to control the devices.


through ioctl()? It's not as immediate and safe as controlling the device 
registers through /sysfs (not /proc). However, the sysfs interface in those 
drivers appeared before V4L2 had its own ioctls and we agreed to keep and 
export the interface to the only users selecting CONFIG_VIDEO_ADV_DEBUG (ok, 
this is actually valid for the sn9c102, I'll submit a patch for the et61x251 
in the future). 


> From my POV, a driver that is creating its own userspace API is not
> fully compliant with V4L2 API.

Isn't Video4Linux2 ioctl() supersedeing sysfs in this case?


> Cheers,
> Mauro

Best regards
Luca Risolia

