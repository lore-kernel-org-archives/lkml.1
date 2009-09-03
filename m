Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZICGQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZICGQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZICGQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:16:46 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:42337 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbZICGQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DDtpUQdBVVjbMEyYK90/PrtkyzXEqgtnrlXwCN5nxvdMznSjqAz6GnpbznAcbrPFu7
         JJUIVIVdWaoq7K+PC7e1cIU1Qm3MAzGxBwvY1P9MbJ4YyGVUag6rEAYWIVEw1iWLPjgQ
         3Mtd3mSWYOHiM1q7VWnCHRCwilW/50oTM0pwQ=
MIME-Version: 1.0
In-Reply-To: <1251942059-21448-5-git-send-email-lrodriguez@atheros.com>
References: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
	 <1251942059-21448-5-git-send-email-lrodriguez@atheros.com>
Date: Thu, 3 Sep 2009 09:16:46 +0300
X-Google-Sender-Auth: 32557524c02932cf
Message-ID: <84144f020909022316gbbe1e5dt8a61d5a6b8499b9b@mail.gmail.com>
Subject: Re: [PATCH 4/5] kmemleak: fix sparse warning over overshadowed flags
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 4:40 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> This fixes this sparse warning:
> mm/kmemleak.c:512:31: warning: symbol 'flags' shadows an earlier one
> mm/kmemleak.c:448:23: originally declared here
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  mm/kmemleak.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 7bb1d48..09ddf9c 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -509,14 +509,14 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
>         * random memory blocks.
>         */
>        if (node != &object->tree_node) {
> -               unsigned long flags;
> +               unsigned long flags_object;
>
>                kmemleak_stop("Cannot insert 0x%lx into the object search tree "
>                              "(already existing)\n", ptr);
>                object = lookup_object(ptr, 1);
> -               spin_lock_irqsave(&object->lock, flags);
> +               spin_lock_irqsave(&object->lock, flags_object);
>                dump_object_info(object);
> -               spin_unlock_irqrestore(&object->lock, flags);
> +               spin_unlock_irqrestore(&object->lock, flags_object);

Catalin, why do we have nested "irqsave" in this function? Can't we
just make these two spin_lock() and spin_unlock()?

>
>                goto out;
>        }
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
