Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYKXRNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYKXRNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYKXRNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:13:16 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:11875 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYKXRNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:13:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=viUPhQneOKKdOtVXbXHAp1S2nEJHztuiNDAQxBqu3RpOLYhrR2IPzXOMgmPlWTT+RI
         ECsHBuDWtWYvYYY5ehcYVqoNeE6Uo9dqzWSUq8E8yShN8Hk4zK5VkYqxhOXGOXeJTpXI
         BuFWD34CRQ1NjkA0mU2NNFg9EmpF+nxYIiAMU=
Message-ID: <ea3b75ed0811240913k7f19f8a3j5207b971a3fb6687@mail.gmail.com>
Date: Mon, 24 Nov 2008 12:13:14 -0500
From: "Brian Phelps" <lm317t@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH] bttv: don't compare list_head's .next with NULL
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Gerd Knorr" <kraxel@bytesex.org>, linux-kernel@vger.kernel.org,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Alexander Shaduri" <ashaduri@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Julia Lawall" <julia@diku.dk>
In-Reply-To: <20081122112045.GA6890@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0811211750l7edc8037ue813341779917b0@mail.gmail.com>
	 <20081122112045.GA6890@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seems to cause a select timeout to occur with v4l2's
example capture.c file

On Sat, Nov 22, 2008 at 6:20 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi Brian,
>
> Can you see if this patch helps your problem?
>
>
> Vegard
>
>
> From 84396b14b9059de4a697df4ea4e036a22513436e Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sat, 22 Nov 2008 12:12:11 +0100
> Subject: [PATCH] bttv: don't compare list_head's .next with NULL
>
> The list implementation doesn't store NULLs in .next/.prev, but
> uses poison values (for-sure invalid pointers). I assume that this
> code wanted to test whether an entry was the last in a list.
>
> This function is only ever called for the video capture list, so
> we know which list to check (it could have been vcapture as well).
>
> Patch is untested!
>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  drivers/media/video/bt8xx/bttv-risc.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/video/bt8xx/bttv-risc.c b/drivers/media/video/bt8xx/bttv-risc.c
> index 5b1b8e4..7a54c99 100644
> --- a/drivers/media/video/bt8xx/bttv-risc.c
> +++ b/drivers/media/video/bt8xx/bttv-risc.c
> @@ -649,14 +649,14 @@ bttv_buffer_activate_video(struct bttv *btv,
>        if (NULL != set->top  &&  NULL != set->bottom) {
>                if (set->top == set->bottom) {
>                        set->top->vb.state    = VIDEOBUF_ACTIVE;
> -                       if (set->top->vb.queue.next)
> +                       if (list_is_last(&set->top->vb.queue, &btv->capture))
>                                list_del(&set->top->vb.queue);
>                } else {
>                        set->top->vb.state    = VIDEOBUF_ACTIVE;
>                        set->bottom->vb.state = VIDEOBUF_ACTIVE;
> -                       if (set->top->vb.queue.next)
> +                       if (list_is_last(&set->top->vb.queue, &btv->capture))
>                                list_del(&set->top->vb.queue);
> -                       if (set->bottom->vb.queue.next)
> +                       if (list_is_last(&set->bottom->vb.queue, &btv->capture))
>                                list_del(&set->bottom->vb.queue);
>                }
>                bttv_apply_geo(btv, &set->top->geo, 1);
> @@ -671,7 +671,7 @@ bttv_buffer_activate_video(struct bttv *btv,
>                      ~0x0f, BT848_COLOR_CTL);
>        } else if (NULL != set->top) {
>                set->top->vb.state  = VIDEOBUF_ACTIVE;
> -               if (set->top->vb.queue.next)
> +               if (list_is_last(&set->top->vb.queue, &btv->capture))
>                        list_del(&set->top->vb.queue);
>                bttv_apply_geo(btv, &set->top->geo,1);
>                bttv_apply_geo(btv, &set->top->geo,0);
> @@ -682,7 +682,7 @@ bttv_buffer_activate_video(struct bttv *btv,
>                btaor(set->top->btswap & 0x0f,   ~0x0f, BT848_COLOR_CTL);
>        } else if (NULL != set->bottom) {
>                set->bottom->vb.state = VIDEOBUF_ACTIVE;
> -               if (set->bottom->vb.queue.next)
> +               if (list_is_last(&set->bottom->vb.queue, &btv->capture))
>                        list_del(&set->bottom->vb.queue);
>                bttv_apply_geo(btv, &set->bottom->geo,1);
>                bttv_apply_geo(btv, &set->bottom->geo,0);
> --
> 1.5.6.5
>
>
