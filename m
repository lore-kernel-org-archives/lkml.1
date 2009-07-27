Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZG0P4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZG0P4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZG0P4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:56:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:52976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZG0P4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=HgskVUZxAt1i865m9wTw9in8BVLL52XMHB8vj6J4TD8z7wPmyzsc+ZeA9RF5d9knmU
         CsROdivoYWrt/GpmAvbyFvvPI4IWPT97lk6B/d0OxYCUbkYvyh50p3IapexAF+1NQ581
         a9Q0lkx9yiYWo6vnL06ppjSeY34Kyiw+Mh4Eg=
Date: Mon, 27 Jul 2009 08:55:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Peter Feuerer <peter@piie.net>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com> <cone.1247683003.40459.21332.1000@deskpiie> <20090723082904.GE3997@dtor-d630.eng.vmware.com> <cone.1248339143.133822.15136.1000@arca> <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com> <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090727162940.DA90C526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 02:53:17PM +0200, Borislav Petkov wrote:
> > Dmitry's right, suspend() and resume() are used only for S2R. Since
> > the only thing we do when suspending/hibernating is set fan speed to
> > auto, we might just as well replicate those functions to .freeze() and
> > .thaw().
> 
> here's a fix:
> 
> --
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Wed, 15 Jul 2009 17:33:32 +0200
> Subject: [PATCH] acerhdf: convert to dev_pm_ops
> 
> v 1.1:
> Add .freeze/.thaw func ptrs to support
> suspend-to-disk, as suggested by Dmitry Torokhov.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/platform/x86/acerhdf.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index aa298d6..8cd7a7b 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -435,7 +435,7 @@ struct thermal_cooling_device_ops acerhdf_cooling_ops = {
>  };
> 
>  /* suspend / resume functionality */
> -static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
> +static int acerhdf_suspend(struct device *dev)
>  {
>  	if (kernelmode)
>  		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
> @@ -446,7 +446,7 @@ static int acerhdf_suspend(struct platform_device
> *dev, pm_message_t state)
>  	return 0;
>  }
> 
> -static int acerhdf_resume(struct platform_device *device)
> +static int acerhdf_resume(struct device *dev)
>  {
>  	if (verbose)
>  		pr_notice("resuming\n");
> @@ -464,15 +464,21 @@ static int acerhdf_remove(struct platform_device *device)
>  	return 0;
>  }
> 
> +static struct dev_pm_ops acerhdf_pm_ops = {
> +	.suspend = acerhdf_suspend,
> +	.resume  = acerhdf_resume,
> +	.freeze  = acerhdf_suspend,
> +	.thaw	 = acerhdf_resume,
> +};
> +

Hmm, looking at the driver I think the only function that actually is
needed is poweroff() that would turn the fan in automatic mode before
shutting down. The driver does not perform any actions when resuming so
why bother?

BTW, I wasn't entirely correct, for S2D if you need freeze() and thaw()
you also need restore() because that's the one that is called after
restoring hibernation image.

-- 
Dmitry
