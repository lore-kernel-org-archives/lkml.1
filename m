Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZKWJi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZKWJi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbZKWJi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:38:26 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:45036 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbZKWJiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:38:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dF5WEdW5s+dIuWV080UAPHza9ysZ/rFnKpDWNPIbEHrUl+sODj0qmpUtpL06KjXr7Z
         0rccDWRoqvcADwyoJTGHfeUrk/SlQkHlZ3R5/Y1r6rvFFSpNX9qS3Ea/wN1YfMh/ZtlO
         ty8lBygSwB1JgXyILfBf4HfSXTaah6ma86VBU=
MIME-Version: 1.0
In-Reply-To: <0e91f1c4ecc5bc5000f729ccb56e9b6e1fbd4bd3.1258805412.git.andre.goddard@gmail.com>
References: <cover.1258805412.git.andre.goddard@gmail.com>
	 <0e91f1c4ecc5bc5000f729ccb56e9b6e1fbd4bd3.1258805412.git.andre.goddard@gmail.com>
Date: Mon, 23 Nov 2009 11:38:30 +0200
X-Google-Sender-Auth: 9815b71f9a0fa5fe
Message-ID: <84144f020911230138v11b18709q28c186f9260f6d66@mail.gmail.com>
Subject: Re: [PATCH 1/2] pid: tighten pidmap spinlock critical section by 
	removing kfree()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding some CC's.)

On Sat, Nov 21, 2009 at 2:16 PM, André Goddard Rosa
<andre.goddard@gmail.com> wrote:
> Avoid calling kfree() under pidmap spinlock, calling it afterwards.
>
> Normally kfree() is very fast, but sometimes it can be slow, so avoid
> calling it under the spinlock if we can.
>
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
> cc: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  kernel/pid.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index d3f722d..55fd590 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>                         * installing it:
>                         */
>                        spin_lock_irq(&pidmap_lock);
> -                       if (map->page)
> -                               kfree(page);
> -                       else
> +                       if (!map->page) {
>                                map->page = page;
> +                               page = NULL;
> +                       }
>                        spin_unlock_irq(&pidmap_lock);
> +                       kfree(page);
>                        if (unlikely(!map->page))
>                                break;
>                }
> --
> 1.6.5.3.298.g39add
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
