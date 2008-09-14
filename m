Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYINSUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYINSUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 14:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYINSUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 14:20:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:20101 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYINSUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 14:20:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ETY3gsNftAJe3TywdHRpzphSfdZlr7TpQn9c4IWnJtKmL7mis43PlVjDvEi5CathT5
         1rkRU83H7RnGu+95R8rb2yXYtT47UVgN6mFo1Fic9hnOB9tDzaBLrahiD01McURR8B22
         9rAj4eUrq4DBTcb/HY0ScO3kDobr2LVeF/FEE=
Message-ID: <86802c440809141120v5f468775n81de6a29bbb89019@mail.gmail.com>
Date: Sun, 14 Sep 2008 11:20:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86-64: fix combining of regions in init_memory_mapping()
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <48CA9C18.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48CA9C18.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 7:43 AM, Jan Beulich <jbeulich@novell.com> wrote:
> When nr_range gets decremented, the same slot must be considered for
> coalescing with its new successor again.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> ---
>  arch/x86/mm/init_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.27-rc6/arch/x86/mm/init_64.c      2008-08-29 10:53:00.000000000 +0200
> +++ 2.6.27-rc6-x86_64-mr-coalesce/arch/x86/mm/init_64.c 2008-09-12 11:58:45.000000000 +0200
> @@ -636,7 +636,7 @@ unsigned long __init_refok init_memory_m
>                old_start = mr[i].start;
>                memmove(&mr[i], &mr[i+1],
>                         (nr_range - 1 - i) * sizeof (struct map_range));
> -               mr[i].start = old_start;
> +               mr[i--].start = old_start;
>                nr_range--;
>        }
>

this patch seems not right.
Ingo, please don't apply it.

original code:
        /* try to merge same page size and continuous */
        for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
                unsigned long old_start;
                if (mr[i].end != mr[i+1].start ||
                    mr[i].page_size_mask != mr[i+1].page_size_mask)
                        continue;
                /* move it */
                old_start = mr[i].start;
                memmove(&mr[i], &mr[i+1],
                         (nr_range - 1 - i) * sizeof (struct map_range));
                mr[i].start = old_start;
                nr_range--;
        }

so it save old_start and first, and move entries forward (so old one
is overwriten), and put back old_start ...

YH
