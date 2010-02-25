Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0BYJT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 04:19:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50973 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0BYJTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 04:19:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=klcwgNzPHDfB+VvIFIOlnnOoxbfuwPvuB0U/tlElWxQowA7RJupck5+d7arkM8SeDM
         ydUEGjGKiR1b9dQfwOJnF3qITkkoXhz7a3hF2OYGk2C/vu/hxJWV7fvOBuUvM/q3Rc94
         GhAOC8mR15f25KwrZ7GXpY2ySTfE4ptBZyJsM=
MIME-Version: 1.0
In-Reply-To: <1267074476-28347-3-git-send-email-airlied@gmail.com>
References: <1267074476-28347-1-git-send-email-airlied@gmail.com>
	 <1267074476-28347-2-git-send-email-airlied@gmail.com>
	 <1267074476-28347-3-git-send-email-airlied@gmail.com>
Date: Thu, 25 Feb 2010 10:19:23 +0100
Message-ID: <b170af451002250119y52c7097er995e7592248128c0@mail.gmail.com>
Subject: Re: [PATCH 2/2] vga_switcheroo: initial implementation (v8)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-fbdev@vger.kernel.org, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, sorry, but I don't like such a hidden changes, touching not
directly related things.


2010/2/25 Dave Airlie <airlied@gmail.com>:
> diff --git a/drivers/gpu/drm/radeon/r600_audio.c b/drivers/gpu/drm/radeon/r600_audio.c
> index 0dcb690..7def989 100644
> --- a/drivers/gpu/drm/radeon/r600_audio.c
> +++ b/drivers/gpu/drm/radeon/r600_audio.c
> @@ -163,6 +163,9 @@ int r600_audio_init(struct radeon_device *rdev)
>        rdev->audio_status_bits = 0;
>        rdev->audio_category_code = 0;
>
> +       if (!radeon_audio)
> +               return 0;
> +

Good catch but not for this patch. Plus we could handle audio on/off better.


> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> (...)
> +static void radeon_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_state state)
> +{
> +       struct drm_device *dev = pci_get_drvdata(pdev);
> +       struct radeon_device *rdev = dev->dev_private;
> +       pm_message_t pmm = { .event = PM_EVENT_SUSPEND };
> +       if (state == VGA_SWITCHEROO_ON) {
> +               printk(KERN_ERR "VGA switched radeon on\n");
> +               /* don't suspend or resume card normally */
> +               rdev->powered_down = false;
> +               radeon_resume_kms(dev);
> +               r600_audio_init(rdev);
> +       } else {
> +               printk(KERN_ERR "VGA switched radeon off\n");
> +               r600_audio_fini(rdev);
> +               radeon_suspend_kms(dev, pmm);
> +               /* don't suspend or resume card normally */
> +               rdev->powered_down = true;
> +       }
> +}

Don't mess with r600_audio_* there. You call if for all chipsets which
is not needed and break nice S&R layout, which is chipset specific.

I guess you needed that because you didn't work on branch containing my patch:
http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=38fd2c6ff526e6a59edfa8e08f6f0724646784c4
(you commited it to drm-linus)


> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
> index 8ba3de7..69017f2 100644
> --- a/drivers/gpu/drm/radeon/radeon_drv.c
> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
> @@ -87,7 +87,7 @@ int radeon_testing = 0;
>  int radeon_connector_table = 0;
>  int radeon_tv = 1;
>  int radeon_new_pll = 1;
> -int radeon_audio = 1;
> +int radeon_audio = 0;

Why?! What for we disable this feature by default?! If you see some
reason for that, explain it to others please. I can change my mind,
but for now I don't like this. It makes audio an option from just
working-out-of-box.

-- 
Rafał
