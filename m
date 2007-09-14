Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbXINHrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbXINHrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 03:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXINHri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 03:47:38 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:46026 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbXINHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 03:47:37 -0400
Date: Fri, 14 Sep 2007 09:48:52 +0200
From: aherrman@arcor.de
To: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] v4l: fix build error for et61x251 driver
Message-ID: <20070914074852.GA5598@devil>
References: <20070913123627.GD10348@devil> <200709140028.34661.luca.risolia@studio.unibo.it> <alpine.LFD.0.999.0709131705070.16478@woody.linux-foundation.org> <200709140353.07087.luca.risolia@studio.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709140353.07087.luca.risolia@studio.unibo.it>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 03:53:06AM +0200, Luca Risolia wrote:
> On Friday 14 September 2007 02:09:01 Linus Torvalds wrote:
> > On Fri, 14 Sep 2007, Luca Risolia wrote:
> > > Hacked-by: Luca Risolia <luca.risolia@studio.unibo.it>
> > >
> > > On Friday 14 September 2007 00:27:17 Andreas Herrmann wrote:
> > > > This fixes a kernel build problem and
> > > > should make it into 2.6.23, I think.
> > > >
> > > >



> > This patch is really ugly.

Well, yes. I should have known as I converted so many occurences of
to_video_device to container_of in my second patch.

> > Why can't the "to_video_device()" macro be used? Just move it to a place
> > where it's usable! IOW, what's wrong with the *much* simpler patch below?
> 
> There's nothing wtong in my opinion. I do not know the exact reason why Mauro 
> moved "to_video_device()" into CONFIG_VIDEO_V4L1_COMPAT. Pheraps he can give 
> more details about this change.

BTW, just a few V4L2 drivers and videodev seem to use this construct:
  video/usbvision/usbvision-video.c:    container_of(cd, struct video_device, class_dev);

  video/sn9c102/sn9c102_core.c:   cam = video_get_drvdata(container_of(cd, struct video_device,
  video/sn9c102/sn9c102_core.c-                                        class_dev));

  video/videodev.c:       struct video_device *vfd = container_of(cd, struct video_device,
  video/videodev.c-                                               class_dev);

And then their are drivers with other variants of container_of, e.g.:
  video/pvrusb2/pvrusb2-v4l2.c:   vp = container_of(chp,struct pvr2_v4l2,channel);
  video/bt8xx/bttv-vbi.c: struct bttv_buffer *buf = container_of(vb,struct bttv_buffer,vb);
   ...

I think, there should be a to_video_device macro for usage in v4l2.
An most probable for the other container_of stuff (when more there is more
than one occurence of a particular construct), drivers should provide their own macro,
e.g. to_video_buffer() or so.

That's what other subsystems do. It is more self-explanatory than a direct usage
of container_of.

So why not apply (my first patch ... oh no, of course that's  rubbish ;-) 
Linus' below patch for 2.6.23 to fix the compilation for that particular driver.
And to work on the conversion of container_of() stuff to meaningful macros for the
next kernel release?


Regards,

Andreas


> 
> 
> > That "to_video_device()" macro has absolutely _nothing_ to do with
> > CONFIG_VIDEO_V4L1_COMPAT, as far as I can tell!
> >
> > 			Linus
> > ---
> > diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> > index d62847f..17f8f3a 100644
> > --- a/include/media/v4l2-dev.h
> > +++ b/include/media/v4l2-dev.h
> > @@ -337,6 +337,9 @@ void *priv;
> >  	struct class_device class_dev; /* sysfs */
> >  };
> >
> > +/* Class-dev to video-device */
> > +#define to_video_device(cd) container_of(cd, struct video_device,
> > class_dev) +
> >  /* Version 2 functions */
> >  extern int video_register_device(struct video_device *vfd, int type, int
> > nr); void video_unregister_device(struct video_device *);
> > @@ -354,11 +357,9 @@ extern int video_usercopy(struct inode *inode, struct
> > file *file, int (*func)(struct inode *inode, struct file *file,
> >  				      unsigned int cmd, void *arg));
> >
> > -
> >  #ifdef CONFIG_VIDEO_V4L1_COMPAT
> >  #include <linux/mm.h>
> >
> > -#define to_video_device(cd) container_of(cd, struct video_device,
> > class_dev) static inline int __must_check
> >  video_device_create_file(struct video_device *vfd,
> >  			 struct class_device_attribute *attr)
> 
> Best regards
> Luca Risolia

