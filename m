Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXCANZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXCANZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXCANZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:25:58 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56706 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752389AbXCANZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:25:57 -0500
Date: Thu, 1 Mar 2007 14:25:55 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>
cc: Ben Dooks <ben@fluff.org.uk>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: sm501fb off-by-1 sysfs store
In-Reply-To: <20070301082456.GA3701@linux-sh.org>
Message-ID: <Pine.LNX.4.62.0703011423060.766@pademelon.sonytel.be>
References: <20070301082456.GA3701@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007, Paul Mundt wrote:
> Currently sm501fb_crtsrc_store() won't allow the routing to be changed
> via echos from userspace in to the sysfs file. The reason for this is
> that the strnicmp() for both heads uses a sizeof() for the string length,
> which ends up being strlen() + 1 (\0 in the normal case, but the echo
> gives a newline, which is where the issue occurs), this then causes a
> mismatch and subsequently bails with the -EINVAL.

> sizeof("string") is great for making sure you have space in your buffer,
> but rather less so for string comparisons :-)

> diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
> index 02b290c..72b5358 100644
> --- a/drivers/video/sm501fb.c
> +++ b/drivers/video/sm501fb.c
> @@ -1074,9 +1074,9 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
>  	if (len < 1)
>  		return -EINVAL;
>  
> -	if (strnicmp(buf, "crt", sizeof("crt")) == 0)
> +	if (strnicmp(buf, "crt", 3) == 0)
>  		head = HEAD_CRT;
> -	else if (strnicmp(buf, "panel", sizeof("panel")) == 0)
> +	else if (strnicmp(buf, "panel", 5) == 0)
>  		head = HEAD_PANEL;
>  	else
>  		return -EINVAL;

What about using just `strlen("string")' instead? ISTR gcc optimizes this to a
constant. Not that it matters that much, as the actual string won't be
duplicated.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
