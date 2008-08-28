Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYH1TjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYH1TjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbYH1TjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:39:01 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46939 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbYH1Ti7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Xt5eb0za9eM0DfUHq/P5c1YayI+EyBXKboZr0ow1QJZY8Uj2O5uhIs4NBkA9yfviEo
         Epf7ThqUKQydSctCKmWN1bf2+7CKrWE/80xBk8bmvdeeIZ8WBWdoXaPYmJwczA8qw/qB
         tzEITtgyAdtANEqoIWbH157O5IQ+J/Pk79kMQ=
Message-ID: <19f34abd0808281238w18a53b90wc55591a572c225da@mail.gmail.com>
Date: Thu, 28 Aug 2008 21:38:58 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [RFC][PATCH] bitfields API
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "David Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0808282201190.11146@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080828183223.GA30781@localhost.localdomain>
	 <20080828184025.GA22165@x200.localdomain>
	 <19f34abd0808281146o7a00388eie9322ff778665961@mail.gmail.com>
	 <Pine.LNX.4.64.0808282201190.11146@melkki.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 9:02 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> Why not do something like this (as suggested by Ingo, I think)? Yeah, the
> macro should go into kmemcheck.h but I don't have a tree handy...
>
>                Pekka
>
> Index: linux-2.6/include/linux/bitfield.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/bitfield.h
> @@ -0,0 +1,10 @@
> +#ifndef __LINUX_BITFIELD_H
> +#define __LINUX_BITFIELD_H
> +
> +#ifdef CONFIG_KMEMCHECK
> +#define KMEMCHECK_BIT_FIELD(field) do { field = 0; } while (0)
> +#else
> +#define KMEMCHECK_BIT_FIELD(field) do { } while (0)
> +#endif /* CONFIG_KMEMCHECK */
> +
> +#endif /* __LINUX_BITFIELD_H */
>
> Index: linux-2.6/net/core/skbuff.c
> ===================================================================
> --- linux-2.6.orig/net/core/skbuff.c
> +++ linux-2.6/net/core/skbuff.c
> @@ -55,6 +55,7 @@
>  #include <linux/rtnetlink.h>
>  #include <linux/init.h>
>  #include <linux/scatterlist.h>
> +#include <linux/bitfield.h>
>
>  #include <net/protocol.h>
>  #include <net/dst.h>
> @@ -209,6 +210,11 @@ struct sk_buff *__alloc_skb(unsigned int
>        skb->data = data;
>        skb_reset_tail_pointer(skb);
>        skb->end = skb->tail + size;
> +       KMEMCHECK_BIT_FIELD(skb->local_df);
> +       KMEMCHECK_BIT_FIELD(skb->cloned);
> +       KMEMCHECK_BIT_FIELD(skb->ip_summed);
> +       KMEMCHECK_BIT_FIELD(skb->nohdr);
> +       KMEMCHECK_BIT_FIELD(skb->nfctinfo);
>        /* make sure we initialize shinfo sequentially */
>        shinfo = skb_shinfo(skb);
>        atomic_set(&shinfo->dataref, 1);
>

That looks good to me. If the extra lines are okay with net people, we
can put this in the fixlets branch and make it the norm for dealing
with bitfields in kmemcheck.

One thing to keep in mind that if the members of the bitfield does not
span the entire width of the bitfield, the remaining bits must also be
assigned (as an extra "filler" member), otherwise GCC will not
optimize it to a single store. But that is not an issue in this
particular case since all the bits are used.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
