Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYA0VAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYA0VAm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYA0VAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:00:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:50698 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYA0VAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:00:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DE6Lky/76qqiZqMIcSbw1VBk8jX+OXPEUi9eo4RBd96dgexWMMZlDIP/4yOoR+FvzTS9IdkaDFKWD6A/lnQAuVXdgDAD/dmvgo2sTvTUdjRF/vgW0gPzgOA0lWhXn/O2NRrTdJuQvT1uDxnAgul55f7fujQhlIFQFx7cEEut85s=
Message-ID: <84144f020801271300g316b87bgea6beb265b5c62d3@mail.gmail.com>
Date: Sun, 27 Jan 2008 23:00:29 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: lib/idr.c: initialize struct idr_layer
Cc: "Jim Houston" <jim.houston@ccur.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0801271207j377fba5bg92cedceedbdd228@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0801271207j377fba5bg92cedceedbdd228@mail.gmail.com>
X-Google-Sender-Auth: 0a584ae5d7421048
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Jan 27, 2008 10:07 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> I am testing my kmemcheck patches, and it has come up with a couple of
> uses of uninitialized memory in lib/idr.c. These are (the line numbers
> may differ slightly):

[snip]

> @@ -39,12 +39,16 @@ static struct idr_layer *alloc_layer(struct idr *idp)
>  {
>         struct idr_layer *p;
>         unsigned long flags;
> +       int i;
>
>         spin_lock_irqsave(&idp->lock, flags);
>         if ((p = idp->id_free)) {
>                 idp->id_free = p->ary[0];
>                 idp->id_free_cnt--;
> -               p->ary[0] = NULL;
> +               p->bitmap = 0;
> +               for(i = 0; i < ARRAY_SIZE(p->ary); ++i)
> +                       p->ary[i] = NULL;
> +               p->count = 0;

But aren't these zeroed by idr_cache_ctor() already?

>         }
>         spin_unlock_irqrestore(&idp->lock, flags);
>         return(p);

                        Pekka
