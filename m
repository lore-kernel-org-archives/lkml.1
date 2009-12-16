Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbZLPRKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbZLPRKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762324AbZLPRJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:09:53 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:52651 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762286AbZLPRJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:09:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=JssW4Ba4TQ5cG4DcRcOnA0Xus8l/LzRZRIizPA5lrCc+RDajBjUIAeS+zHHno+L+Zz
         OK0w6dFIfAAmG8ehqBRzX7tryro2iOqVdDkFvRMHAmUqFLGjhrJHWfkMYirqZHA8jtzf
         vfrGkw9apI1Q8/7iTFBUCnWvANC/2abRFDwpQ=
MIME-Version: 1.0
In-Reply-To: <1260910330-3409-1-git-send-email-jdm64@gawab.com>
References: <1260910330-3409-1-git-send-email-jdm64@gawab.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Wed, 16 Dec 2009 09:09:23 -0800
X-Google-Sender-Auth: 14c4db0233fd8a6f
Message-ID: <2c0942db0912160909k1984f6b4w16c0503fed7d5d59@mail.gmail.com>
Subject: Re: [PATCH] staging: s5k3e2fx.c: simplify complexity by factoring
To: Justin Madru <jdm64@gawab.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, error27@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 12:52 PM, Justin Madru <jdm64@gawab.com> wrote:
> the code was looping, seting s_move[i] to the following calculations
>
> if (actual_step >= 0)
>        s_move[i] = ((((i + 1) * gain + 0x200) - (i * gain + 0x200)) / 0x400);
> else
>        s_move[i] = ((((i + 1) * gain - 0x200) - (i * gain - 0x200)) / 0x400);
>
> but, this code redues to the expression
>        s_move[i] = gain >> 10;
>
> The reason for the complexity was to generate a step function with
> integer division and rounding to land on specific values. But these calculations
> can be simplified to the following code:
>
>        gain = ((actual_step << 10) / 5) >> 10;
>        for (i = 0; i <= 4; i++)
>                s_move[i] = gain;
> ---
>  drivers/staging/dream/camera/s5k3e2fx.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
> index edba198..66582af 100644
> --- a/drivers/staging/dream/camera/s5k3e2fx.c
> +++ b/drivers/staging/dream/camera/s5k3e2fx.c
> @@ -1093,14 +1093,10 @@ static int32_t s5k3e2fx_move_focus(int direction, int32_t num_steps)
>
>        actual_step = step_direction * (int16_t)num_steps;
>        pos_offset = init_code + s5k3e2fx_ctrl->curr_lens_pos;
> -       gain = actual_step * 0x400 / 5;
> +       gain = ((actual_step << 10) / 5) >> 10;
>
> -       for (i = 0; i <= 4; i++) {
> -               if (actual_step >= 0)
> -                       s_move[i] = ((((i+1)*gain+0x200) - (i*gain+0x200))/0x400);
> -               else
> -                       s_move[i] = ((((i+1)*gain-0x200) - (i*gain-0x200))/0x400);
> -       }
> +       for (i = 0; i <= 4; i++)
> +               s_move[i] = gain;
>
>        /* Ring Damping Code */
>        for (i = 0; i <= 4; i++) {
> --
> 1.6.5.6

Okay, yes, that now generates the same numbers before and after.

More worryingly, however, it's now even more obvious that there's no
need for a five-element array here to hold the steps. They're all the
same size, so the array could have been removed along with the gain
variable and the expression ((actual_step << 10) / 5) >> 10 can be
used directly in at the top of the loop in the ring damping code
directly below, the only place that uses the s_move[5] array.

(There's no point in having an array of move values unless the
individual values differ, which makes the whole thing look like
there's a bug in the code compared to the original intent of, perhaps,
making large moves in the beginning and smaller toward the end. Dunno.
This is one of those 'ask the author' sorts of things.)

Regardless, that's not your fault, and not something that has to be
rolled into this patch, so feel free to add my

Reviewed-by: Ray Lee <ray-lk@madrabbit.org>
