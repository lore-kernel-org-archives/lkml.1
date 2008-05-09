Return-Path: <linux-kernel-owner+w=401wt.eu-S1765663AbYEIRKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765663AbYEIRKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYEIRK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:10:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:51989 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbYEIRKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=ja1jNfisB4LiwfeFBCYr2YI8pO4CyiTMARtetfaAY2IoM+CvkblIXIQsX+ES7zgGhtNodxoHGRFr5GqP4eJQcxJ84mwzrWwv1PAiaPPOhElXH+MUaKrI8R48pk7ADjf7x182IFPQB+bWsRmUp6Hvnd3vx4YVHno9npF5yv3daWw=
Date: Fri, 9 May 2008 18:10:12 +0100
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] video: fix build bugs in
	drivers/media/video/stk-webcam.c
Message-ID: <20080509171012.GA3473@singular.sob>
References: <20080429131824.GA4742@elte.hu> <461039140804300011v5454a169ldbd17ebefa2391d@mail.gmail.com> <20080507162950.23f191e2@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080507162950.23f191e2@gaivota>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El mié. 07 de may. de 2008, a las 16:29:50 -0300, Mauro Carvalho Chehab escribió:
> The V4L1 symbols are used to help us to track what drivers are still using the
> depreciated V4L1 API, or otherwise provide support for V4L1 compatibility
> layer. This is not the case of stkwebcam.
> 
> So, instead of the proposed patch, I prefer just to disable the additional
> non-V4L2 sysfs interface, if the flag is not enabled.

Yeah, that might be the best solution to this problem.

> 
> There are some discussions at the ML to create a standard to allow configuring
> V4L2 controls via sysfs, but this is not standard yet. The idea is to add some
> support at videodev.h using the same handlers defined by video_ioctl2.
> Unfortunately, people stopped discussing this, due to the lack of time and
> people to work on this.
> 
> I think this could be a nice addition to V4L2, and will help to avoid creating
> non-standardized interfaces at sysfs.
> 
> > For the record, this bug was found in march, but it seems
> > I forgot to CC: the patch to Mauro, Sorry about that.
> > 
> > http://marc.info/?l=linux-video&m=120594964524615&w=2
> 
> I probably missed this.
> 
> ---
> 
> Instead of Ingo's approach, this seems to be cleaner:
> 
> Fix compilation, when V4L1_COMPAT is disabled
> 
> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> This driver uses some sysfs helper functions that are available only for legacy
> drivers. It also requires linux/mm.h.
> 
> This patch fixes compiliation when not in compat mode.
> 
> Thanks to Ingo Molnar for identifying this issue.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: Jaime Velasco Juan <jsagarribay@gmail.com>

Regards

> ---
> 
>  drivers/media/video/stk-webcam.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
> index 9276ed9..b12c60c 100644
> --- a/drivers/media/video/stk-webcam.c
> +++ b/drivers/media/video/stk-webcam.c
> @@ -30,6 +30,7 @@
>  #include <linux/kref.h>
>  
>  #include <linux/usb.h>
> +#include <linux/mm.h>
>  #include <linux/vmalloc.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-common.h>
> @@ -245,6 +246,8 @@ static int stk_initialise(struct stk_camera *dev)
>  		return -1;
>  }
>  
> +#ifdef CONFIG_VIDEO_V4L1_COMPAT
> +
>  /* sysfs functions */
>  /*FIXME cleanup this */
>  
> @@ -350,6 +353,10 @@ static void stk_remove_sysfs_files(struct video_device *vdev)
>  	video_device_remove_file(vdev, &dev_attr_vflip);
>  }
>  
> +#else
> +#define stk_create_sysfs_files(a)
> +#define stk_remove_sysfs_files(a)
> +#endif
>  
>  /* *********************************************** */
>  /*
> 
> 
> 
> 
> 
> Cheers,
> Mauro
