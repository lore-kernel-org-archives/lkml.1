Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZECMTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZECMTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 08:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZECMTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 08:19:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41904 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZECMS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 08:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Efyvy4gE+YcNI0kJ6GjIH1+Ovo6IDvsUWvbLy6EEO+Hfxnn+SkK5HZBKV7HvvGbPWq
         fujjC+MvOBVLcQYh0jj5UlL1Dm/5c+Qxjz2yF6eIkmIlDMy1b794JHfKfImrHxVGEr4A
         PJHsDyHORxRmrB32xQy1o6Hd3XDspDw8ops4s=
MIME-Version: 1.0
In-Reply-To: <20090501004105.GA16409@sgi.com>
References: <20090501004105.GA16409@sgi.com>
Date: Sun, 3 May 2009 15:18:58 +0300
X-Google-Sender-Auth: f1b6e5f773b71c98
Message-ID: <84144f020905030518u22c256ealb1d2511c397454e3@mail.gmail.com>
Subject: Re: [PATCH] - Fix memory corruption in slbq
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jack Steiner <steiner@sgi.com>
Cc: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jack,

(Please cc me when sending patches to SL*B.)

On Fri, May 1, 2009 at 3:41 AM, Jack Steiner <steiner@sgi.com> wrote:
> Fix memory corruption caused by slqb overrunning the end
> of the page allocated in kmem_cache_dyn_array_alloc() for
> initial caches.
>
> Signed-off-by: Jack Steiner <steiner@sgi.com>
>
> ---
>  mm/slqb.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> Index: linux/mm/slqb.c
> ===================================================================
> --- linux.orig/mm/slqb.c        2009-04-30 15:47:16.000000000 -0500
> +++ linux/mm/slqb.c     2009-04-30 19:08:33.000000000 -0500
> @@ -2194,15 +2194,14 @@ static void *kmem_cache_dyn_array_alloc(
>                 * never get freed by definition so we can do it rather
>                 * simply.
>                 */
> -               if (!nextmem) {
> +               if (!nextmem || offset_in_page(nextmem) + size > PAGE_SIZE) {
>                        nextmem = alloc_pages_exact(size, GFP_KERNEL);
>                        if (!nextmem)
>                                return NULL;
>                }
>                ret = nextmem;
>                nextmem = (void *)((unsigned long)ret + size);
> -               if ((unsigned long)ret >> PAGE_SHIFT !=
> -                               (unsigned long)nextmem >> PAGE_SHIFT)
> +               if (offset_in_page(ret) + size >= PAGE_SIZE)
>                        nextmem = NULL;
>                memset(ret, 0, size);
>                return ret;

I don't think this is needed now that commit 8804e6f ("SLQB:  fix dumb
early allocation cache") is merged:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff_plain;h=8804e6f0001668656d4cb2a329e1a6e69e695a0f

Or do you still see the corruption with it?

                                              Pekka
