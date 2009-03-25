Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZCYHem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZCYHem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbZCYHeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:34:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:41223 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbZCYHeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DcwWbWbjCkimJvosZkkemuWtYqUIFfKkaT0DyU3WlwQQR2GQdgnV9VgreP3qHDvzHK
         w9mR0CtqY/PNwRgMWrLluo2azCM33bkhfIjgqxKkKJKJbnJ3ScvW5+iBJIhRC3hOhkW5
         YS1RKRDsN7NGk5tR+bDFIuYDkdNMbI9s0FWLM=
MIME-Version: 1.0
In-Reply-To: <20090325052023.071564146@goodmis.org>
References: <20090325051920.406564281@goodmis.org>
	 <20090325052023.071564146@goodmis.org>
Date: Wed, 25 Mar 2009 09:34:13 +0200
X-Google-Sender-Auth: bbc3a87aaa76836f
Message-ID: <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 7:19 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
>
> Impact: clean up
>
> A NULL pointer to kfree is no longer unlikely, as seen by the
> annotated branch profiler:
>
>  correct incorrect  %        Function                  File              Line
>  ------- ---------  -        --------                  ----              ----
>  728571  1315540  64 kfree                          slab.c               3719
>
> This makes sense, since we now encourage developers to just call kfree
> without checking for NULL.

But those are _error handling paths_ (at least supposed to be). I
wonder which call-sites are responsible for this. Can frtrace help us
here?

> ---
>  mm/slab.c |    2 +-
>  mm/slob.c |    2 +-
>  mm/slub.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 4d00855..0386c33 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3716,7 +3716,7 @@ void kfree(const void *objp)
>        struct kmem_cache *c;
>        unsigned long flags;
>
> -       if (unlikely(ZERO_OR_NULL_PTR(objp)))
> +       if (ZERO_OR_NULL_PTR(objp))
>                return;
>        local_irq_save(flags);
>        kfree_debugcheck(objp);
> diff --git a/mm/slob.c b/mm/slob.c
> index 52bc8a2..e077174 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -491,7 +491,7 @@ void kfree(const void *block)
>  {
>        struct slob_page *sp;
>
> -       if (unlikely(ZERO_OR_NULL_PTR(block)))
> +       if (ZERO_OR_NULL_PTR(block))
>                return;
>
>        sp = (struct slob_page *)virt_to_page(block);
> diff --git a/mm/slub.c b/mm/slub.c
> index 0280eee..65dc436 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2743,7 +2743,7 @@ void kfree(const void *x)
>        struct page *page;
>        void *object = (void *)x;
>
> -       if (unlikely(ZERO_OR_NULL_PTR(x)))
> +       if (ZERO_OR_NULL_PTR(x))
>                return;
>
>        page = virt_to_head_page(x);
> --
> 1.6.2
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
