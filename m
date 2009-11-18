Return-Path: <linux-kernel-owner+w=401wt.eu-S932084AbZKROma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbZKROma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070AbZKROm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:42:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbZKROm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:42:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: is avoiding compat ioctls possible?
Date: Wed, 18 Nov 2009 15:42:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>, David Miller <davem@davemloft.net>,
       airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20091027.222814.137568780.davem@davemloft.net> <21d7e9970911171626m216d35ddu4c4c3189edfd37cc@mail.gmail.com> <20091118090913.GA9505@basil.fritz.box>
In-Reply-To: <20091118090913.GA9505@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181542.05152.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19f9ayxMx4/jSwz7fKxjPqEDR1+jmjmOey7T1g
 nzAGjFbkPcvCaj31pbsPfnivWcPj6g3HRAn0MXB/bHfhK9YwEF
 EpA53dVl0XeHcobbP5oZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009, Andi Kleen wrote:
> > Doing all these out-of-line hidden over here in a separate file just
> > seems crazy,
> > and I'm  having trouble wondering why ppl consider it a better idea at all.
>
> The separate file is on the way out, the modern way is to use
> ->compat_ioctl in the driver itself. Near all drivers except
> for a few exceptions like DRM put it into the same file.
> I think you should just move the code  around in DRM too
> and drop the separate file.

Right. Commonly, you can simply handle the incompatible stuff in
->compat_ioctl and then call the regular function. Another way to
do it if you want to consolidate even more is to pass a flag down
the actual function and do

static int my_common_ioctl(struct my_object *my, unsigned int cmd, unsigned long arg,
				void __user *argp, int compat)
{
	...
}

static long my_native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	return my_commmon_ioctl(file->private_data, cmd, arg, (void __user *)arg, 0);
}

static long my_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	return my_commmon_ioctl(file->private_data, cmd, arg, compat_ptr(arg), 1);
}

Doing that, you can have the ioctl handling for a subsystem consolidated in one
place, just doing the copy_from_user() part separately.

For the specific case of drm, where you have a table with all the ioctls, I can
see yet another option: add another function pointer to 'struct drm_ioctl_desc'
that does the conversion, e.g.

int drm_version_compat(void __user *argp, void *kdata, int dir)
{
	struct compat_drm_version __user *uversion = argp;
	struct compat_drm_version cversion;
	struct drm_version *version = kdata;

	if (dir == IOC_IN) {
		if (copy_from_user(&cversion, uversion, sizeof(cversion);
			return -EFAULT;
		*version = (struct drm_version) {
			.version_major       = cversion.version_major,
			.version_minor       = cversion.version_minor,
			.version_mpatchlevel = cversion.version_patchlevel,
			.name_len = cversion.name_len,
			.name     = compat_ptr(cversion.name),
			.date_len = cversion.date_len,
			.date     = compat_ptr(cversion.date),
			.desc_len = cversion.desc_len,
			.desc     = compat_ptr(cversion.desc),
		};
		return 0;
	} else if (dir == IOC_OUT) {
		cversion = (struct drm_version) {
			.version_major       = version->version_major,
			.version_minor       = version->version_minor,
			.version_mpatchlevel = version->version_patchlevel,
			.name_len = version->name_len,
			.name     = (unsigned long)version->name,
			.date_len = version->date_len,
			.date     = (unsigned long)version->date,
			.desc_len = version->desc_len,
			.desc     = (unsigned long)version->desc,
		};
		if (copy_to_user(uversion, &cversion, sizeof(cversion);
			return -EFAULT;
		return 0;
	}
	return -EINVAL;
}

static struct drm_ioctl_desc drm_ioctls[] = {
        DRM_IOCTL_DEF(DRM_IOCTL_VERSION, drm_version, drm_version_compat, 0),
	...
};

	Arnd <><
