Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYF0NAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYF0NAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYF0NAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:00:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYF0NAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:00:44 -0400
Date: Fri, 27 Jun 2008 10:00:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       dean@sensoray.com
Subject: Re: [PATCH] add Sensoray 2255 v4l driver
Message-ID: <20080627100023.00803c90@gaivota>
In-Reply-To: <20080626231551.GA20012@kroah.com>
References: <20080626231551.GA20012@kroah.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Dean,

On Thu, 26 Jun 2008 16:15:51 -0700
Greg KH <greg@kroah.com> wrote:

> All of the previous review comments have been addressed in this version.
> Mauro, can you apply this to your tree if there are no other objections?

Oliver pointed some issues that seems to fix some bugs at the driver, including
one race condition (freeing with timers active). I would add a few other ones. 

Even with those issues, I think we should commit the driver at my tree.
Having the code there will allow more people to test and eventually discover
more issues.

So, if it is ok for you, I'm committing the current patch. I'll be waiting for
patches fixing the pointed issues.

Cheers,
Mauro

> +config USB_S2255
> +	tristate "USB Sensoray 2255 video capture device"
> +	depends on VIDEO_V4L2
> +	select VIDEOBUF_VMALLOC

I think you need also to add:
	select VIDEOBUF_GEN

since select doesn't do recursion, afaik.

> +#define SYS_FRAMES_MAXSIZE	(720*288*2*2 + 4096)

CodingStyle: it should be:

#define SYS_FRAMES_MAXSIZE	(720 * 288 * 2 * 2 + 4096)

> +module_param(debug, int, 0);
> +module_param(vid_limit, int, 0);
> +module_param(video_nr, int, 0);

Why permissions are 0? IMO, it would be better to use 0x644.

> +/* converts 2255 planar format to yuyv or uyvy */
> +static void planar422p_to_yuv_packed(const unsigned char *in,
> +				     unsigned char *out,
> +				     int width, int height,
> +				     int fmt)
> +{
> +	unsigned char *pY;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned long size = height * width;
> +	unsigned int i;
> +	pY = (unsigned char *)in;
> +	pCr = (unsigned char *)in + height * width;
> +	pCb = (unsigned char *)in + height * width + (height * width / 2);
> +	for (i = 0; i < size * 2; i += 4) {
> +		out[i] = (fmt == V4L2_PIX_FMT_YUYV) ? *pY++ : *pCr++;
> +		out[i + 1] = (fmt == V4L2_PIX_FMT_YUYV) ? *pCr++ : *pY++;
> +		out[i + 2] = (fmt == V4L2_PIX_FMT_YUYV) ? *pY++ : *pCb++;
> +		out[i + 3] = (fmt == V4L2_PIX_FMT_YUYV) ? *pCb++ : *pY++;
> +	}
> +	return;
> +}

Hmm... still keeping format conversion here? Ok for a first version, provided
that you move this to firmware on a near version. Btw, we have an userspace
library to handle such conversions right now. It allows its dynamic usage even
with applications that don't explicitly call the library (even binary-only can
use this). It is available at:
	http://hansdegoede.livejournal.com/3636.html

IMO, the proper way is to remove this conversion (and add at the library if this
conversion is not there yet).

> +static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
> +			unsigned int *size)
> +{
> +	struct s2255_fh *fh = vq->priv_data;
> +
> +	*size = fh->width * fh->height * (fh->fmt->depth >> 3);
> +
> +	if (0 == *count)
> +		*count = S2255_DEF_BUFS;
> +
> +	while (*size * *count > vid_limit * 1024 * 1024)

CodingStyle: Better to use *count inside parenthesis.

> +static int s2255_open(struct inode *inode, struct file *file)
> +{
	...
> +	dev->users[cur_channel]++;
> +	if (dev->users[cur_channel] > S2255_MAX_USERS) {
> +		dev->users[cur_channel]--;
> +		mutex_unlock(&dev->open_lock);
> +		printk(KERN_INFO "s2255drv: too many open handles!\n");
> +		return -EBUSY;
> +	}

Hmm... V4L2 API allows multiple opens by device. This is, in fact, used
sometimes to allow a better control of the video device, like, for example
using a different  app to change the device controls (for example, qv4l2).

It is preferred to not limit the max users but, instead, to limit the driver to
server more than one stream at a time.

---

I'm not seen any code for suspend/resume. I doubt that the state of the video
will return back from S1/S3 with the current code. IMO, you'll need to
implement explicit handlers for saving the current state and recovering
video/audio streams after returning back from sleep.

A last word is about the usage of locks at the driver. I suspect you would need
to lock on almost all ioctl handlers. However, as we're currently protected by
Kernel big lock, the code is ok. There are some proposed changes to move away
from KBL. When this happen, we may need to review the locking schema.
