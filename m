Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYKCKMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYKCKMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYKCKMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:12:30 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45139 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754640AbYKCKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:12:29 -0500
Date: Mon, 3 Nov 2008 11:12:18 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Keith Packard <keithp@keithp.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: [PATCH] [drivers/video/fb] Eliminate recursive mutex in compat
 fb ioctl path
In-Reply-To: <1225696010-6574-1-git-send-email-keithp@keithp.com>
Message-ID: <Pine.LNX.4.64.0811031110450.12897@vixen.sonytel.be>
References: <1225696010-6574-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1721940234-1225707050=:12897"
Content-ID: <Pine.LNX.4.64.0811031111210.12897@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1721940234-1225707050=:12897
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0811031111211.12897@vixen.sonytel.be>

On Sun, 2 Nov 2008, Keith Packard wrote:
> fb_compat_ioctl grabbed the fb mutex and then called fb_ioctl, which also
> grabs the same mutex. I traced through all existing fb_compat_ioctl
> functions in the various fb drivers and found that they also transform their
> arguments and call the native fb_ioctl function. So, it is correct to just
> remove the mutex_lock/mutex_unlock pair in the top-level compat path.

Last week I submitted an alternative fix: http://lkml.org/lkml/2008/10/31/162

Probably Rafael wants to keep track of this regression, too?

> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/video/fbmem.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index cd5f20d..548cf26 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1253,7 +1253,6 @@ fb_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	struct fb_ops *fb = info->fbops;
>  	long ret = -ENOIOCTLCMD;
>  
> -	mutex_lock(&info->lock);
>  	switch(cmd) {
>  	case FBIOGET_VSCREENINFO:
>  	case FBIOPUT_VSCREENINFO:
> @@ -1279,7 +1278,6 @@ fb_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  			ret = fb->fb_compat_ioctl(info, cmd, arg);
>  		break;
>  	}
> -	mutex_unlock(&info->lock);
>  	return ret;
>  }
>  #endif

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1721940234-1225707050=:12897--
