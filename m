Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYC1Rbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYC1Rbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYC1RbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:31:16 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:47558 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYC1RbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:31:15 -0400
Message-ID: <47ED2B35.4030601@freescale.com>
Date: Fri, 28 Mar 2008 12:30:29 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: York Sun <yorksun@freescale.com>
CC: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, a.p.zijlstra@chello.nl,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 1/2 v4] Driver for Freescale 8610 and 5121 DIU
References: <12066720572512-git-send-email-yorksun@freescale.com> <12066720572314-git-send-email-yorksun@freescale.com>
In-Reply-To: <12066720572314-git-send-email-yorksun@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

York Sun wrote:
> +static int fsl_diu_ioctl(struct fb_info *info, unsigned int cmd,
> +		       unsigned long arg)
> +{
> +	struct mfb_info *mfbi = info->par;
> +	struct diu_ad *ad = mfbi->ad;
> +	struct mfb_chroma_key ck;
> +	unsigned char global_alpha;
> +	struct aoi_display_offset aoi_d;
> +	__u32 pix_fmt;
> +
> +	switch (cmd) {
> +	case MFB_SET_PIXFMT:
> +		if (!arg)
> +			return -EINVAL;
> +		if (copy_from_user(&pix_fmt, (void __user *)arg,
> +				sizeof(pix_fmt)))

OK, you fixed the cast here...

> +			return -EFAULT;
> +		ad->pix_fmt = pix_fmt;
> +		pr_debug("Set pixel format to 0x%08x\n", ad->pix_fmt);
> +		break;
> +	case MFB_GET_PIXFMT:
> +		if (!arg)
> +			return -EINVAL;
> +		pix_fmt = ad->pix_fmt;
> +		if (copy_to_user((void *)arg, &pix_fmt, sizeof(pix_fmt)))
> +			return -EFAULT;
> +		pr_debug("get pixel format 0x%08x\n", ad->pix_fmt);
> +		break;
> +	case MFB_SET_AOID:
> +		if (!arg)
> +			return -EINVAL;
> +		if (copy_from_user(&aoi_d, (void *)arg, sizeof(aoi_d)))
> +			return -EFAULT;

...but not anywhere else.  All user pointers should have a __user 
annotation.

> +	default:
> +		printk(KERN_ERR "Unknown ioctl command (0x%08X)\n", cmd);
> +		return 0;

return -ENOIOCTLCMD;

> +	/* Read to clear the status */
> +	status = in_be32(&(hw->int_status));
> +
> +	ret = request_irq(irq, fsl_diu_isr, 0, "diu", 0);
> +	if (ret)
> +		pr_info("Request diu IRQ failed.\n");
> +	else {
> +		ints = INT_PARERR | INT_LS_BF_VS;
> +#if !defined(CONFIG_NOT_COHERENT_CACHE)
> +		ints |=	INT_VSYNC;
> +#endif
> +		if (dr.mode == MFB_MODE2 || dr.mode == MFB_MODE3)
> +			ints |= INT_VSYNC_WB;
> +
> +		/* Read to clear the status */
> +		status = in_be32(&(hw->int_status));
> +		out_be32(&(hw->int_mask), ints);

These parentheses are unnecessary; just do &hw->int_mask, etc.

-Scott
