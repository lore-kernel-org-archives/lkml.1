Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZGMPIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZGMPIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZGMPIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:08:37 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:33041 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbZGMPIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YK5gT1FGmnXhiqiOzETa5jI/6Fl5FWK1fxtStLxKffSi/+RN9Ms4JLekbra/rw5Fft
         SBhW5CDX2OapxXUz8ldqb2Xl3hGVfA9FFf7HmoeX6PKPAN34yUrnTbhtg++9PsJINzo0
         gu/DajGKRoxthOeDBJoJcgwiG7JSVAIekmrkY=
MIME-Version: 1.0
In-Reply-To: <20090713145451.GA2265@cmpxchg.org>
References: <20090713130921.6441.17011.stgit@pc1117.cambridge.arm.com>
	 <1247493898.14968.0.camel@penberg-laptop>
	 <20090713145451.GA2265@cmpxchg.org>
Date: Mon, 13 Jul 2009 18:08:32 +0300
X-Google-Sender-Auth: d374a0b13f2a90b3
Message-ID: <84144f020907130808u6f349d18jddf7528a3ea0f63e@mail.gmail.com>
Subject: Re: [PATCH] Fix vc_screenbuf leak via con_init()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Mon, Jul 13, 2009 at 5:54 PM, Johannes Weiner<hannes@cmpxchg.org> wrote:
>> We can probably get rid of ->vc_kmalloced completely now that the
>> bootmem allocator is no longer used by the driver.
>
> That's what I thought, too.  Copied Alan.  Patch as follows:
>
> ---
> From 4df0a75bdc567c9f2203dc4b0337d77a26715654 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 13 Jul 2009 16:39:46 +0200
> Subject: [patch] vt: drop bootmem/slab memory distinction
>
> Bootmem is not used for the vt screen buffer anymore as slab is now
> available at the time the console is initialized.
>
> Get rid of the now superfluous distinction between slab and bootmem,
> it's always slab.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  drivers/char/vt.c              |   12 +++---------
>  include/linux/console_struct.h |    1 -
>  2 files changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index d9113b4..bdb9c60 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -769,14 +769,12 @@ int vc_allocate(unsigned int currcons)    /* return 0 on success */
>            visual_init(vc, currcons, 1);
>            if (!*vc->vc_uni_pagedir_loc)
>                con_set_default_unimap(vc);
> -           if (!vc->vc_kmalloced)
> -               vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
> +           vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
>            if (!vc->vc_screenbuf) {
>                kfree(vc);
>                vc_cons[currcons].d = NULL;
>                return -ENOMEM;
>            }
> -           vc->vc_kmalloced = 1;
>            vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
>            vcs_make_sysfs(currcons);
>            atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
> @@ -912,10 +910,8 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
>        if (new_scr_end > new_origin)
>                scr_memsetw((void *)new_origin, vc->vc_video_erase_char,
>                            new_scr_end - new_origin);
> -       if (vc->vc_kmalloced)
> -               kfree(vc->vc_screenbuf);
> +       kfree(vc->vc_screenbuf);
>        vc->vc_screenbuf = newscreen;
> -       vc->vc_kmalloced = 1;
>        vc->vc_screenbuf_size = new_screen_size;
>        set_origin(vc);
>
> @@ -994,8 +990,7 @@ void vc_deallocate(unsigned int currcons)
>                vc->vc_sw->con_deinit(vc);
>                put_pid(vc->vt_pid);
>                module_put(vc->vc_sw->owner);
> -               if (vc->vc_kmalloced)
> -                       kfree(vc->vc_screenbuf);
> +               kfree(vc->vc_screenbuf);
>                if (currcons >= MIN_NR_CONSOLES)
>                        kfree(vc);
>                vc_cons[currcons].d = NULL;
> @@ -2880,7 +2875,6 @@ static int __init con_init(void)
>                INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
>                visual_init(vc, currcons, 1);
>                vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);

We can make that GFP_KERNEL, actually.

> -               vc->vc_kmalloced = 0;
>                vc_init(vc, vc->vc_rows, vc->vc_cols,
>                        currcons || !vc->vc_sw->con_save_screen);
>        }
> diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
> index d71f7c0..38fe59d 100644
> --- a/include/linux/console_struct.h
> +++ b/include/linux/console_struct.h
> @@ -89,7 +89,6 @@ struct vc_data {
>        unsigned int    vc_need_wrap    : 1;
>        unsigned int    vc_can_do_color : 1;
>        unsigned int    vc_report_mouse : 2;
> -       unsigned int    vc_kmalloced    : 1;
>        unsigned char   vc_utf          : 1;    /* Unicode UTF-8 encoding */
>        unsigned char   vc_utf_count;
>                 int    vc_utf_char;
> --
> 1.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
