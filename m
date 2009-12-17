Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbZLQAXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbZLQAXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762845AbZLQAXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:23:39 -0500
Received: from fbr02.csee.onr.siteprotect.com ([64.26.60.146]:41111 "EHLO
	fbr02.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762824AbZLQAXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:23:38 -0500
Message-ID: <4B2979E7.7060305@boundarydevices.com>
Date: Wed, 16 Dec 2009 17:23:03 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] sound/oss/pss: Fix test of unsigned in pss_reset_dsp()
 and pss_download_boot()
References: <4B28085A.6020101@gmail.com>
In-Reply-To: <4B28085A.6020101@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> limit and jiffies are unsigned so the test does not work.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
> 
> diff --git a/sound/oss/pss.c b/sound/oss/pss.c
> index 83f5ee2..9325f4d 100644
> --- a/sound/oss/pss.c
> +++ b/sound/oss/pss.c
> @@ -269,7 +269,7 @@ static int pss_reset_dsp(pss_confdata * devc)
>  	unsigned long   i, limit = jiffies + HZ/10;
>  
>  	outw(0x2000, REG(PSS_CONTROL));
> -	for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)

I think
	for (i = 0; i < 32768 && ( (int)(limit-jiffies) >= 0); i++)

works better when jiffies wrap

> +	for (i = 0; i < 32768 && (limit >= jiffies); i++)
>  		inw(REG(PSS_CONTROL));
>  	outw(0x0000, REG(PSS_CONTROL));
>  	return 1;
> @@ -369,11 +369,11 @@ static int pss_download_boot(pss_confdata * devc, unsigned char *block, int size
>  		outw(0, REG(PSS_DATA));
>  
>  		limit = jiffies + HZ/10;
> -		for (i = 0; i < 32768 && (limit - jiffies >= 0); i++)
> +		for (i = 0; i < 32768 && (limit >= jiffies); i++)
>  			val = inw(REG(PSS_STATUS));
>  
>  		limit = jiffies + HZ/10;
> -		for (i = 0; i < 32768 && (limit-jiffies >= 0); i++)
> +		for (i = 0; i < 32768 && (limit >= jiffies); i++)
>  		{
>  			val = inw(REG(PSS_STATUS));
>  			if (val & 0x4000)
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> 

