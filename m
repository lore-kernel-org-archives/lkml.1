Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZJ1MNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZJ1MNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 08:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZJ1MNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 08:13:35 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62965 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZJ1MNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 08:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=gAZ8SEVkuAcEUGJHxL8hAnQrUF+rhwkbdSLbqggXvund5ieL7K1PtFjizl5E2p45ph
         l4J8/v4lGlphTqqgEetertpxHied7sdJzZYAlvQt+8KT7BtPStCRBIEoF9Edx7zS6PQ2
         e8WDWlffH7geQg7BwJcWxCqYWUidI6EbPGP9g=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: is avoiding compat ioctls possible?
Date: Wed, 28 Oct 2009 13:13:32 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
References: <20091027.222814.137568780.davem@davemloft.net> <20091027.230450.222178419.davem@davemloft.net> <20091028.005342.60092591.davem@davemloft.net>
In-Reply-To: <20091028.005342.60092591.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910281313.32827.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 October 2009, David Miller wrote:
> -/* The two 64-bit arches where alignof(u64)==4 in 32-bit code */
>  #if defined (CONFIG_X86_64) || defined(CONFIG_IA64)
>  typedef struct drm_radeon_setparam32 {
>         int param;
>         u64 value;
>  } __attribute__((packed)) drm_radeon_setparam32_t;
> +#else
> +#define drm_radeon_setparam32_t drm_radeon_setparam_t
> +#endif

I guess a cleaner way to put this would be

typedef struct drm_radeon_setparam32 {
       int param;
       compat_u64 value;
} drm_radeon_setparam32_t;

>  static int compat_radeon_cp_setparam(struct file *file, unsigned int cmd,
>                                      unsigned long arg)
>  {
>         drm_radeon_setparam32_t req32;
>         drm_radeon_setparam_t __user *request;
> +       compat_uptr_t uptr;
>  
>         if (copy_from_user(&req32, (void __user *) arg, sizeof(req32)))
>                 return -EFAULT;

The ioctl argument actually needs a compat_ptr() conversion as well.
For the s390 case, we can't do that in common code, because some
ioctl methods put a 32 bit integer into the argument. Not sure if we
want to fix that everywhere, the problem is very common and the
impact is minimal.
 
> +static int compat_radeon_info_ioctl(struct file *file, unsigned int cmd,
> +                                   unsigned long arg)
> +{
> +       struct drm_radeon_info __user *uinfo;
> +       struct drm_radeon_info kinfo;
> +       compat_uptr_t uaddr;
> +       void *uptr;
> +
> +       if (copy_from_user(&kinfo, (void __user *) arg, sizeof(kinfo)))
> +               return -EFAULT;
> +
> +       uaddr = kinfo.value;
> +       uptr = compat_ptr(uaddr);
> +       if (kinfo.value == (uint64_t) uptr)
> +               return drm_ioctl(file->f_dentry->d_inode, file,
> +                                DRM_IOCTL_RADEON_INFO, arg);
> +
> +       kinfo.value = (uint64_t) uptr;
> +
> +       uinfo = compat_alloc_user_space(sizeof(*uinfo));
> +       if (copy_to_user(uinfo, &kinfo, sizeof(kinfo)))
> +               return -EFAULT;
> +
> +       return drm_ioctl(file->f_dentry->d_inode, file,
> +                        DRM_IOCTL_RADEON_INFO, (unsigned long) uinfo);
> +}

IMHO a better way to handle the radeon specific ioctls would be to
avoid the compat_alloc_user_space and just define the common function
taking a kernel pointer, with two implementations of the copy operation:

static int __radeon_info_ioctl(struct file *file, struct drm_radeon_info *info);

static int radeon_info_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	struct drm_radeon_info kinfo;

	if (copy_from_user(&kinfo, (void __user *)arg, sizeof(kinfo)))
		return -EFAULT;

	return __radeon_info_ioctl(file, cmd, &kinfo);
}

static int radeon_info_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	struct compat_drm_radeon_info kinfo;

	if (copy_from_user(&kinfo, compat_ptr(arg), sizeof(kinfo)))
		return -EFAULT;

	kinfo.value = (u64)compat_ptr(kinfo.value);
	return __radeon_info_ioctl(file, cmd, &kinfo);
}

> @@ -426,13 +507,20 @@ long radeon_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  long radeon_kms_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>         unsigned int nr = DRM_IOCTL_NR(cmd);
> +       drm_ioctl_compat_t *fn = NULL;
>         int ret;
>  
>         if (nr < DRM_COMMAND_BASE)
>                 return drm_compat_ioctl(filp, cmd, arg);
>  
> +       if (nr < DRM_COMMAND_BASE + DRM_ARRAY_SIZE(radeon_compat_kms_ioctls))
> +               fn = radeon_compat_kms_ioctls[nr - DRM_COMMAND_BASE];
> +
>         lock_kernel();          /* XXX for now */
> -       ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
> +       if (fn != NULL)
> +               ret = (*fn) (filp, cmd, arg);
> +       else
> +               ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
>         unlock_kernel();

This could consequently become

 
       if (nr < DRM_COMMAND_BASE)
                return drm_compat_ioctl(filp, cmd, arg);
 
+	switch (cmd) {
+	case DRM_IOCTL_RADEON_INFO:
+		return radeon_info_compat_ioctl(filp, cmd, arg);
+	case ...
+	}
+
        lock_kernel();          /* XXX for now */
        ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
        unlock_kernel();


The other changes in your patch look good to me.

	Arnd <><
