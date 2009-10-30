Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbZJ3KN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbZJ3KN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 06:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZJ3KNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 06:13:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54311 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbZJ3KNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 06:13:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: is avoiding compat ioctls possible?
Date: Fri, 30 Oct 2009 11:13:42 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
References: <20091027.222814.137568780.davem@davemloft.net> <20091028.005342.60092591.davem@davemloft.net> <21d7e9970910291813u19cdd361u2facb864db58a712@mail.gmail.com>
In-Reply-To: <21d7e9970910291813u19cdd361u2facb864db58a712@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910301113.43174.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/5aEPkmGU2TrqKmCGm9u+gNly21jPoGBxDwoK
 cG5FHV6GxqiolDC5VWokr7qtc5kX5NOO58ZmLY1mmAwG0UcUZY
 f5No5iZPOaIJb+eLuUddA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 October 2009, Dave Airlie wrote:
> Btw when I mentioned ioctls I meant more than radeon, all the KMS
> ioctls in the common drm_crtc.c file suffer from this problem as well.
> 
> Hence why I still believe either my drm specific inline or something
> more generic (granted I can see why a generic solution would be ugly).
> 
> You patch below does suffer from a lot of #ifdefs and cut-n-paste
> that is a lot better suited to doing in an inline or macro. We can then
> comment that inline saying if anyone else does this we will be most
> unhappy.

I think it would be better to do a conversion of the pointers in
a separate compat handler, but then call the regular function, which
in case of drm already take a kernel pointer. That would be much simpler
than the compat_alloc_user_space tricks in the current code and
also cleaner than trying to handle both cases in one function using
is_compat_task().

See the (not even compile-tested) example below as an illustration
of what I think you should do. If you convert all functions in
drm_ioc32.c to this scheme, you can replace drm_compat_ioctl and
drm_compat_ioctls[] with drm_generic_compat_ioctl.

	Arnd <><

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 282d9fd..334345b 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -1040,6 +1040,122 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	return 0;
 }
 
+static int compat_drm_mode_getblob_ioctl(struct drm_device *dev,
+			struct drm_mode_get_blob __user *out_resp_user,
+			struct drm_file *file_priv)
+{
+	struct drm_mode_get_blob out_resp;
+	int ret;
+
+	ret = copy_from_user(&out_resp, out_resp_user, sizeof(out_resp))
+	if (ret)
+		return -EFAULT;
+
+	out_resp.data = (unsigned long)compat_ptr(out_resp.data);
+
+	ret = drm_mode_getblob_ioctl(dev, &out_resp, file_priv);
+	if (ret)
+		return ret;
+
+	ret = copy_to_user(out_resp_user, &out_resp, sizeof(out_resp))
+	if (ret)
+		return -EFAULT;
+	return 0;
+}
+
+static int compat_drm_mode_gamma_set_ioctl(struct drm_device *dev,
+			struct drm_mode_crtc_lut __user *crtc_lut_user,
+			struct drm_file *file_priv)
+{
+	struct drm_mode_crtc_lut crtc_lut;
+
+	ret = copy_from_user(&crtc_lut, crtc_lut_user, sizeof(crtc_lut))
+	if (ret)
+		return -EFAULT;
+
+	crtc_lut.red   = (unsigned long)compat_ptr(crtc_lut.red);
+	crtc_lut.green = (unsigned long)compat_ptr(crtc_lut.green);
+	crtc_lut.blue  = (unsigned long)compat_ptr(crtc_lut.blue);
+
+	ret = drm_mode_gamma_set_ioctl(dev, &crtc_lut, file_priv);
+
+	return ret;
+}
+
+static int compat_drm_mode_gamma_get_ioctl(struct drm_device *dev,
+			struct drm_mode_crtc_lut __user *crtc_lut_user,
+			struct drm_file *file_priv)
+{
+	struct drm_mode_crtc_lut crtc_lut;
+
+	ret = copy_from_user(&crtc_lut, crtc_lut_user, sizeof(crtc_lut))
+	if (ret)
+		return -EFAULT;
+
+	crtc_lut.red   = (unsigned long)compat_ptr(crtc_lut.red);
+	crtc_lut.green = (unsigned long)compat_ptr(crtc_lut.green);
+	crtc_lut.blue  = (unsigned long)compat_ptr(crtc_lut.blue);
+
+	ret = drm_mode_gamma_get_ioctl(dev, &crtc_lut, file_priv);
+
+	return ret;
+}
+
+static int drm_generic_compat_ioctl(struct file *filp, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct drm_file *file_priv = filp->private_data;
+	struct drm_device *dev = file_priv->minor->dev;
+	unsigned int nr = DRM_IOCTL_NR(cmd);
+	int ret;
+
+	atomic_inc(&dev->ioctl_count);
+	atomic_inc(&dev->counts[_DRM_STAT_IOCTLS]);
+	++file_priv->ioctl_count;
+
+	if ((nr >= DRM_CORE_IOCTL_COUNT) &&
+	    ((nr < DRM_COMMAND_BASE) || (nr >= DRM_COMMAND_END)))
+		goto err_i1;
+	if ((nr >= DRM_COMMAND_BASE) && (nr < DRM_COMMAND_END) &&
+	    (nr < DRM_COMMAND_BASE + dev->driver->num_ioctls))
+		ioctl = &dev->driver->ioctls[nr - DRM_COMMAND_BASE];
+	else if ((nr >= DRM_COMMAND_END) || (nr < DRM_COMMAND_BASE)) {
+		ioctl = &drm_ioctls[nr];
+		cmd = ioctl->cmd;
+	} else
+		goto err_i1;
+
+	if (((ioctl->flags & DRM_ROOT_ONLY) && !capable(CAP_SYS_ADMIN)) ||
+		   ((ioctl->flags & DRM_AUTH) && !file_priv->authenticated) ||
+		   ((ioctl->flags & DRM_MASTER) && !file_priv->is_master) ||
+		   (!(ioctl->flags & DRM_CONTROL_ALLOW) && (file_priv->minor->type == DRM_MINOR_CONTROL))) {
+		ret = -EACCES;
+		goto err_il;
+	}
+
+	switch (cmd) {
+	case DRM_IOCTL_MODE_GETPROPBLOB:
+		ret = compat_drm_mode_getblob_ioctl(dev,
+					compat_ptr(arg), file_priv);
+		break;
+
+	case DRM_IOCTL_MODE_GETGAMMA:
+		ret = compat_drm_mode_gamma_set_ioctl(dev,
+					compat_ptr(arg), file_priv);
+		break;
+
+	case DRM_IOCTL_MODE_GETGAMMA:
+		ret = compat_drm_mode_gamma_get_ioctl(dev,
+					compat_ptr(arg), file_priv);
+		break;
+	}
+
+      err_i1:
+	atomic_dec(&dev->ioctl_count);
+
+	return ret;
+}
+
 drm_ioctl_compat_t *drm_compat_ioctls[] = {
 	[DRM_IOCTL_NR(DRM_IOCTL_VERSION32)] = compat_drm_version,
 	[DRM_IOCTL_NR(DRM_IOCTL_GET_UNIQUE32)] = compat_drm_getunique,
@@ -1072,6 +1188,9 @@ drm_ioctl_compat_t *drm_compat_ioctls[] = {
 	[DRM_IOCTL_NR(DRM_IOCTL_UPDATE_DRAW32)] = compat_drm_update_draw,
 #endif
 	[DRM_IOCTL_NR(DRM_IOCTL_WAIT_VBLANK32)] = compat_drm_wait_vblank,
+	[DRM_IOCTL_MODE_GETPROPBLOB] = drm_generic_compat_ioctl,
+	[DRM_IOCTL_MODE_GETGAMMA] = drm_generic_compat_ioctl,
+	[DRM_IOCTL_MODE_SETGAMMA] = drm_generic_compat_ioctl,
 };
 
 /**
