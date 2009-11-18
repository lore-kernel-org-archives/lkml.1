Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbZKRHRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbZKRHRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 02:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbZKRHRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 02:17:54 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:64420 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZKRHRx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 02:17:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eg8GOrsAKVrMYRq54tPPxNK1QDDl8/tiwFyO4EKZuXAZjVmCDg8rH8BoeRwS71+ux4
         4FZ4F3m6KWBIxwUe7C8SbG5jN+P2hXMsCt+mCGXjccSDaWfjItz3JBjlNOgSYc7noWpF
         U9lcDi/VOAPNmylukrix7/3DQrfGcxxn4dRic=
MIME-Version: 1.0
In-Reply-To: <b741c2440911172154g62d7f3bcu7bafc65ad2eb4b21@mail.gmail.com>
References: <b741c2440911172154g62d7f3bcu7bafc65ad2eb4b21@mail.gmail.com>
Date: Wed, 18 Nov 2009 15:17:59 +0800
Message-ID: <2375c9f90911172317x781e22a9y56ecb8e682e8e061@mail.gmail.com>
Subject: Re: [PATCH] vfs: does call expand_files when needed
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Liu Aleaxander <aleaxander@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 1:54 PM, Liu Aleaxander <aleaxander@gmail.com> wrote:
> From: Liu Aleaxander <Aleaxander@gmail.com>
> Date: Wed, 18 Nov 2009 10:59:09 +0800
> Subject: [PATCH] vfs: does call expand_files when needed
>
> I don't think we should call expand_files every time we open a
> file for a new unused fd, so does the expand when necessary.
>
> Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
> ---
>  fs/file.c |   27 ++++++++++++++-------------
>  1 files changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/fs/file.c b/fs/file.c
> index 87e1290..3f3d0fc 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -452,22 +452,22 @@ repeat:
>        if (fd < files->next_fd)
>                fd = files->next_fd;
>
> -       if (fd < fdt->max_fds)
> +       if (likely(fd < fdt->max_fds)) {
>                fd = find_next_zero_bit(fdt->open_fds->fds_bits,
>                                           fdt->max_fds, fd);
> -
> -       error = expand_files(files, fd);
> -       if (error < 0)
> -               goto out;
> -
> -       /*
> -        * If we needed to expand the fs array we
> -        * might have blocked - try again.
> -        */
> -       if (error)
> -               goto repeat;
> -
> +       } else {
> +               error = expand_files(files, fd);


In expand_files(), it has the check for
' < fdt->max_fds', so this change is not necessary.


> +               if (error < 0)
> +                       goto out;
> +
> +               /*
> +                * If we needed to expand the fs array we
> +                * might have blocked - try again.
> +                */
> +               if (error)
> +                       goto repeat;
> +       }
> +
>        if (start <= files->next_fd)
>                files->next_fd = fd + 1;
>
> --
> 1.6.2.5
>
> --
> regards
> Liu Aleaxander
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
