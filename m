Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbZASUvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbZASUvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZASUve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:51:34 -0500
Received: from mx1.wp.pl ([212.77.101.5]:8797 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbZASUvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:51:33 -0500
Date: Mon, 19 Jan 2009 21:54:27 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbmem: copy_from/to_user() with mutex held (v2)
Message-Id: <20090119215427.7f23a76f.krzysztof.h1@wp.pl>
In-Reply-To: <1232363044-8878-1-git-send-email-righi.andrea@gmail.com>
References: <1232363044-8878-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [YWPk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 12:04:04 +0100
Andrea Righi <righi.andrea@gmail.com> wrote:

> Avoid to call copy_from/to_user() with fb_info->lock mutex held in fbmem
> ioctl().
> 
> fb_mmap() is called under mm->mmap_sem (A) held, that also acquires
> fb_info->lock (B); fb_ioctl() takes fb_info->lock (B) and does
> copy_from/to_user() that might acquire mm->mmap_sem (A), causing a
> deadlock.
> 
> NOTE: it doesn't push down the fb_info->lock in each own driver's
> fb_ioctl(), so there're still potential deadlocks somewhere.
> 

> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 756efeb..fe6033e 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1013,25 +1013,26 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
(...)
>  	case FBIOPUT_VSCREENINFO:
> -		if (copy_from_user(&var, argp, sizeof(var))) {
> -			ret =  -EFAULT;
> -			break;
> -		}
> +		if (copy_from_user(&var, argp, sizeof(var)))
> +			return -EFAULT;
> +		if (!lock_fb_info(info))
> +			return -ENODEV;
>  		acquire_console_sem();
>  		info->flags |= FBINFO_MISC_USEREVENT;
>  		ret = fb_set_var(info, &var);
> @@ -1041,104 +1042,109 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>  			ret = -EFAULT;
>  		break;

I don't see a call to unlock_fb_info(info) in the case for FBIOPUT_VSCREENINFO.
Is it intentional?

Kind regards,
Krzysztof
