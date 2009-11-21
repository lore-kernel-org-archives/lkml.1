Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZKUX7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZKUX7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 18:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZKUX7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 18:59:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:33073 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753531AbZKUX7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 18:59:05 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+780MphRe72zPfGDRM9MD/ziI+PnYPFdzeHy9IFd
	NXqNFJdCADMh3a
Message-ID: <4B087ECA.1070109@gmx.de>
Date: Sun, 22 Nov 2009 00:59:06 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Joseph Chan <JosephChan@via.com.tw>,
       Andrew Morton <akpm@linux-foundation.org>,
       Scott Fang <ScottFang@viatech.com.cn>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] viafb: Use sizeof struct rather	than
 pointer
References: <4B0838F1.4090202@gmail.com> <4B083957.3040500@gmail.com>
In-Reply-To: <4B083957.3040500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Roel Kluin schrieb:
> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> index 56ec696..7b181e7 100644
> --- a/drivers/video/via/viafbdev.c
> +++ b/drivers/video/via/viafbdev.c
> @@ -680,7 +680,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
>  		if (!viafb_gamma_table)
>  			return -ENOMEM;
>  		if (copy_from_user(viafb_gamma_table, argp,
> -				sizeof(viafb_gamma_table))) {
> +				sizeof(*viafb_gamma_table))) {
>  			kfree(viafb_gamma_table);
>  			return -EFAULT;
>  		}
> @@ -694,7 +694,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
>  			return -ENOMEM;
>  		viafb_get_gamma_table(viafb_gamma_table);
>  		if (copy_to_user(argp, viafb_gamma_table,
> -			sizeof(viafb_gamma_table))) {
> +			sizeof(*viafb_gamma_table))) {
>  			kfree(viafb_gamma_table);
>  			return -EFAULT;
>  		}

I'm sorry but I fear your fix isn't correct. The reason is a few lines 
above:

u32 *viafb_gamma_table;
...
viafb_gamma_table = kmalloc(256 * sizeof(u32), GFP_KERNEL);

so probably the right solution would look like this:

copy_from_user(viafb_gamma_table, argp, 256 * sizeof(u32))
copy_to_user(argp, viafb_gamma_table, 256 * sizeof(u32))

However viafb has way too many private ioctls. I would be curious 
whether there exists any program that uses any of them so that they 
could be tested. As this ioctl didn't work very well I vote to remove it 
at least temporarily.

Thanks for highlighting this problem,


Florian Tobias Schandinat
