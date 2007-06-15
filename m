Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbXFOIoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbXFOIoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXFOIos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:44:48 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60055 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbXFOIor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:44:47 -0400
Subject: Re: drm: fix radeon setparam on 32/64 bit systems.
From: David Woodhouse <dwmw2@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@linux.ie>, benh@kernel.crashing.org
In-Reply-To: <200706150159.l5F1xNgM000459@hera.kernel.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 09:44:20 +0100
Message-Id: <1181897060.25228.323.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 01:59 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9b01bd5b284bbf519b726b39f1352023cb5e9e69
> Commit:     9b01bd5b284bbf519b726b39f1352023cb5e9e69
> Parent:     dc7a93190c21edbf3ed23e678ad04f852b9cff28
> Author:     Dave Airlie <airlied@linux.ie>
> AuthorDate: Sun Jun 10 16:00:27 2007 +1000
> Committer:  Dave Airlie <airlied@linux.ie>
> CommitDate: Sun Jun 10 16:00:27 2007 +1000
> 
>     drm: fix radeon setparam on 32/64 bit systems.
>     
>     The alignment on 64-bit is different for 64-bit values.

Only on i386. I think you just broke ppc32-on-ppc64.

>     Signed-off-by: Dave Airlie <airlied@linux.ie>
> ---
>  drivers/char/drm/radeon_ioc32.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/drm/radeon_ioc32.c b/drivers/char/drm/radeon_ioc32.c
> index 1f1f9cc..04126c2 100644
> --- a/drivers/char/drm/radeon_ioc32.c
> +++ b/drivers/char/drm/radeon_ioc32.c
> @@ -349,6 +349,31 @@ static int compat_radeon_irq_emit(struct file *file, unsigned int cmd,
>  			 DRM_IOCTL_RADEON_IRQ_EMIT, (unsigned long)request);
>  }
>  
> +typedef struct drm_radeon_setparam32 {
> +	int param;
> +	u64 value;
> +} __attribute__((packed)) drm_radeon_setparam32_t;
> +
> +static int compat_radeon_cp_setparam(struct file *file, unsigned int cmd,
> +				     unsigned long arg)
> +{
> +	drm_radeon_setparam32_t req32;
> +	drm_radeon_setparam_t __user *request;
> +
> +	if (copy_from_user(&req32, (void __user *) arg, sizeof(req32)))
> +		return -EFAULT;
> +
> +	request = compat_alloc_user_space(sizeof(*request));
> +	if (!access_ok(VERIFY_WRITE, request, sizeof(*request))
> +	    || __put_user(req32.param, &request->param)
> +	    || __put_user((void __user *)(unsigned long)req32.value,
> +			  &request->value))
> +		return -EFAULT;
> +
> +	return drm_ioctl(file->f_dentry->d_inode, file,
> +			 DRM_IOCTL_RADEON_SETPARAM, (unsigned long) request);
> +}
> +
>  drm_ioctl_compat_t *radeon_compat_ioctls[] = {
>  	[DRM_RADEON_CP_INIT] = compat_radeon_cp_init,
>  	[DRM_RADEON_CLEAR] = compat_radeon_cp_clear,
> @@ -357,6 +382,7 @@ drm_ioctl_compat_t *radeon_compat_ioctls[] = {
>  	[DRM_RADEON_VERTEX2] = compat_radeon_cp_vertex2,
>  	[DRM_RADEON_CMDBUF] = compat_radeon_cp_cmdbuf,
>  	[DRM_RADEON_GETPARAM] = compat_radeon_cp_getparam,
> +	[DRM_RADEON_SETPARAM] = compat_radeon_cp_setparam,
>  	[DRM_RADEON_ALLOC] = compat_radeon_mem_alloc,
>  	[DRM_RADEON_IRQ_EMIT] = compat_radeon_irq_emit,
>  };
> -
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
dwmw2

