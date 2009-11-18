Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZKRA0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZKRA0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZKRA0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:26:48 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54858 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZKRA0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:26:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uk02MQGf+SBTgu0E9NnyB8PxTCCgmbwqfMd0lFjD93ZU0FJWorjhyHmUtZ1YOkv53q
         57nHYy3m4q6shjKnrk+/4R8vqmVnv5Ps6qqhIxoXsQqKRNAIvh8QxDSzBO8vFkV+nJX6
         dbBinLiz+v3yIVmgWkBf4k+xsTr8QZROKadRI=
MIME-Version: 1.0
In-Reply-To: <200910301113.43174.arnd@arndb.de>
References: <20091027.222814.137568780.davem@davemloft.net>
	 <20091028.005342.60092591.davem@davemloft.net>
	 <21d7e9970910291813u19cdd361u2facb864db58a712@mail.gmail.com>
	 <200910301113.43174.arnd@arndb.de>
Date: Wed, 18 Nov 2009 10:26:51 +1000
Message-ID: <21d7e9970911171626m216d35ddu4c4c3189edfd37cc@mail.gmail.com>
Subject: Re: is avoiding compat ioctls possible?
From: Dave Airlie <airlied@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 8:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 30 October 2009, Dave Airlie wrote:
>> Btw when I mentioned ioctls I meant more than radeon, all the KMS
>> ioctls in the common drm_crtc.c file suffer from this problem as well.
>>
>> Hence why I still believe either my drm specific inline or something
>> more generic (granted I can see why a generic solution would be ugly).
>>
>> You patch below does suffer from a lot of #ifdefs and cut-n-paste
>> that is a lot better suited to doing in an inline or macro. We can then
>> comment that inline saying if anyone else does this we will be most
>> unhappy.
>
> I think it would be better to do a conversion of the pointers in
> a separate compat handler, but then call the regular function, which
> in case of drm already take a kernel pointer. That would be much simpler
> than the compat_alloc_user_space tricks in the current code and
> also cleaner than trying to handle both cases in one function using
> is_compat_task().
>
> See the (not even compile-tested) example below as an illustration
> of what I think you should do. If you convert all functions in
> drm_ioc32.c to this scheme, you can replace drm_compat_ioctl and
> drm_compat_ioctls[] with drm_generic_compat_ioctl.
>

I just got back out from F12 push to look at lkml again ;-)

My main problem which no-one seem to address with all these compat ioctls
is they suck for maintainance, adding the compat_ptr "hacks" into the actual
ioctls is much easier to maintain in that I can see in the code where we've done
these and if code flow has to change I can deal with it all in one place.

Doing all these out-of-line hidden over here in a separate file just
seems crazy,
and I'm  having trouble wondering why ppl consider it a better idea at all.

It adds probably 1000 more LOC versus one inline with a decent name used
inline to replace current casting in the driver.

If the ioctl flow or interface "changes" someone has to remember about all
of these (granted this is unlikely since we pretty much set them in stone).

Dave.

>        Arnd <><
>
> diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
> index 282d9fd..334345b 100644
> --- a/drivers/gpu/drm/drm_ioc32.c
> +++ b/drivers/gpu/drm/drm_ioc32.c
> @@ -1040,6 +1040,122 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
>        return 0;
>  }
>
> +static int compat_drm_mode_getblob_ioctl(struct drm_device *dev,
> +                       struct drm_mode_get_blob __user *out_resp_user,
> +                       struct drm_file *file_priv)
> +{
> +       struct drm_mode_get_blob out_resp;
> +       int ret;
> +
> +       ret = copy_from_user(&out_resp, out_resp_user, sizeof(out_resp))
> +       if (ret)
> +               return -EFAULT;
> +
> +       out_resp.data = (unsigned long)compat_ptr(out_resp.data);
> +
> +       ret = drm_mode_getblob_ioctl(dev, &out_resp, file_priv);
> +       if (ret)
> +               return ret;
> +
> +       ret = copy_to_user(out_resp_user, &out_resp, sizeof(out_resp))
> +       if (ret)
> +               return -EFAULT;
> +       return 0;
> +}
> +
> +static int compat_drm_mode_gamma_set_ioctl(struct drm_device *dev,
> +                       struct drm_mode_crtc_lut __user *crtc_lut_user,
> +                       struct drm_file *file_priv)
> +{
> +       struct drm_mode_crtc_lut crtc_lut;
> +
> +       ret = copy_from_user(&crtc_lut, crtc_lut_user, sizeof(crtc_lut))
> +       if (ret)
> +               return -EFAULT;
> +
> +       crtc_lut.red   = (unsigned long)compat_ptr(crtc_lut.red);
> +       crtc_lut.green = (unsigned long)compat_ptr(crtc_lut.green);
> +       crtc_lut.blue  = (unsigned long)compat_ptr(crtc_lut.blue);
> +
> +       ret = drm_mode_gamma_set_ioctl(dev, &crtc_lut, file_priv);
> +
> +       return ret;
> +}
> +
> +static int compat_drm_mode_gamma_get_ioctl(struct drm_device *dev,
> +                       struct drm_mode_crtc_lut __user *crtc_lut_user,
> +                       struct drm_file *file_priv)
> +{
> +       struct drm_mode_crtc_lut crtc_lut;
> +
> +       ret = copy_from_user(&crtc_lut, crtc_lut_user, sizeof(crtc_lut))
> +       if (ret)
> +               return -EFAULT;
> +
> +       crtc_lut.red   = (unsigned long)compat_ptr(crtc_lut.red);
> +       crtc_lut.green = (unsigned long)compat_ptr(crtc_lut.green);
> +       crtc_lut.blue  = (unsigned long)compat_ptr(crtc_lut.blue);
> +
> +       ret = drm_mode_gamma_get_ioctl(dev, &crtc_lut, file_priv);
> +
> +       return ret;
> +}
> +
> +static int drm_generic_compat_ioctl(struct file *filp, unsigned int cmd,
> +                              unsigned long arg)
> +{
> +       struct drm_file *file_priv = filp->private_data;
> +       struct drm_device *dev = file_priv->minor->dev;
> +       unsigned int nr = DRM_IOCTL_NR(cmd);
> +       int ret;
> +
> +       atomic_inc(&dev->ioctl_count);
> +       atomic_inc(&dev->counts[_DRM_STAT_IOCTLS]);
> +       ++file_priv->ioctl_count;
> +
> +       if ((nr >= DRM_CORE_IOCTL_COUNT) &&
> +           ((nr < DRM_COMMAND_BASE) || (nr >= DRM_COMMAND_END)))
> +               goto err_i1;
> +       if ((nr >= DRM_COMMAND_BASE) && (nr < DRM_COMMAND_END) &&
> +           (nr < DRM_COMMAND_BASE + dev->driver->num_ioctls))
> +               ioctl = &dev->driver->ioctls[nr - DRM_COMMAND_BASE];
> +       else if ((nr >= DRM_COMMAND_END) || (nr < DRM_COMMAND_BASE)) {
> +               ioctl = &drm_ioctls[nr];
> +               cmd = ioctl->cmd;
> +       } else
> +               goto err_i1;
> +
> +       if (((ioctl->flags & DRM_ROOT_ONLY) && !capable(CAP_SYS_ADMIN)) ||
> +                  ((ioctl->flags & DRM_AUTH) && !file_priv->authenticated) ||
> +                  ((ioctl->flags & DRM_MASTER) && !file_priv->is_master) ||
> +                  (!(ioctl->flags & DRM_CONTROL_ALLOW) && (file_priv->minor->type == DRM_MINOR_CONTROL))) {
> +               ret = -EACCES;
> +               goto err_il;
> +       }
> +
> +       switch (cmd) {
> +       case DRM_IOCTL_MODE_GETPROPBLOB:
> +               ret = compat_drm_mode_getblob_ioctl(dev,
> +                                       compat_ptr(arg), file_priv);
> +               break;
> +
> +       case DRM_IOCTL_MODE_GETGAMMA:
> +               ret = compat_drm_mode_gamma_set_ioctl(dev,
> +                                       compat_ptr(arg), file_priv);
> +               break;
> +
> +       case DRM_IOCTL_MODE_GETGAMMA:
> +               ret = compat_drm_mode_gamma_get_ioctl(dev,
> +                                       compat_ptr(arg), file_priv);
> +               break;
> +       }
> +
> +      err_i1:
> +       atomic_dec(&dev->ioctl_count);
> +
> +       return ret;
> +}
> +


>  /**
>
