Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYLJXrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYLJXrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbYLJXqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:46:17 -0500
Received: from yx-out-1718.google.com ([74.125.44.155]:56154 "EHLO
	yx-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbYLJXqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:46:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xYhpQltUGaJVi+pVihw3RBZ/DaFvvS6G2RXlCnfueF8RqAi6XC3GZfHWrpJGD1dWGi
         tInFKk4ZtuBa1L3tCLgLxIPTMj8/LpV0qfqe+u9QVb7tjvLfR0VLccDob06K2tT4o/Kq
         9b41/lgHRqH2HOVjZko0ct9gHuVd05nS5PYcQ=
Message-ID: <21d7e9970812101546n40ba9043r8fdf35b986c5d377@mail.gmail.com>
Date: Thu, 11 Dec 2008 09:46:12 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Manfred Spraul" <manfred@colorfullife.com>
Subject: Re: [PATCH] lib/idr.c: Fix bug introduced by RCU fix
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       cebbert@redhat.com, akpm@linux-foundation.org
In-Reply-To: <200812101729.mBAHTGdr008642@mail.q-ag.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812101729.mBAHTGdr008642@mail.q-ag.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 3:17 AM, Manfred Spraul
<manfred@colorfullife.com> wrote:
> The last patch to lib/idr.c caused a bug if idr_get_new_above() was
> called on an empty idr:
> Usually, nodes stay on the same layer. New layers are added to the top
> of the tree.
> The exception is idr_get_new_above() on an empty tree: In this case,
> the new root node is first added on layer 0, then moved upwards.
> p->layer was not updated.
>
> As usual: You shall never rely on the source code comments, they
> will only mislead you.
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

I've given this a run on my dri system and it appears to work great.

Tested-by: Dave Airlie <airlied@redhat.com>


> ---
>  lib/idr.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/lib/idr.c b/lib/idr.c
> index 7a785a0..1c4f928 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -220,8 +220,14 @@ build_up:
>         */
>        while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
>                layers++;
> -               if (!p->count)
> +               if (!p->count) {
> +                       /* special case: if the tree is currently empty,
> +                        * then we grow the tree by moving the top node
> +                        * upwards.
> +                        */
> +                       p->layer++;
>                        continue;
> +               }
>                if (!(new = get_from_free_list(idp))) {
>                        /*
>                         * The allocation failed.  If we built part of
> --
> 1.5.6.5
>
>
