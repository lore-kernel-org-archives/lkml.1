Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZDRDGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZDRDGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 23:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZDRDF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 23:05:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbZDRDF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 23:05:57 -0400
Date: Fri, 17 Apr 2009 19:55:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: leiming <tom.leiming@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       video4linux-list@redhat.com, laurent.pinchart@skynet.be,
       mchehab@infradead.org
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
In-Reply-To: <20090418103226.54250420@linux-lm>
Message-ID: <alpine.LFD.2.00.0904171952260.4042@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <d82e647a0904161837w6b6fb652la0da05f9061e95dc@mail.gmail.com> <200904172336.12414.rjw@sisk.pl> <20090418103226.54250420@linux-lm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, leiming wrote:
> 
> >From 5715e310a939f3f7cd3e88eae8f25fedbb28def4 Mon Sep 17 00:00:00 2001
> From: Ming Lei <tom.leiming@gmail.com>
> Date: Wed, 15 Apr 2009 22:32:51 +0800
> Subject: [PATCH] V4L/DVB:usbvideo:fix uvc resume failed
> 
> Now urb buffers is not freed before suspend, so uvc_alloc_urb_buffers
> should return packet counts allocated originally during uvc resume
> , instead of zero.
> 
> This patch is against v2.6.30-rc2.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/media/video/uvc/uvc_video.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
> index a95e173..c050b22 100644
> --- a/drivers/media/video/uvc/uvc_video.c
> +++ b/drivers/media/video/uvc/uvc_video.c
> @@ -742,7 +742,7 @@ static int uvc_alloc_urb_buffers(struct uvc_video_device *video,
>  
>  	/* Buffers are already allocated, bail out. */
>  	if (video->urb_size)
> -		return 0;
> +		return DIV_ROUND_UP(video->urb_size, psize);

I don't think this is right. It should round _down_.

It's supposed to return 'npackets', but if you pass it a different packet 
size than it was passed originally, it can now return a potentially bigger 
number than the already allocated buffer, no?

So I think it should round down (ie use a regular divide). No?

		Linuse
