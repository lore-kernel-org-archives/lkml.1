Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYH1TCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYH1TCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYH1TCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:02:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55877 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYH1TCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:02:09 -0400
Date: Thu, 28 Aug 2008 22:02:08 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bitfields API
In-Reply-To: <19f34abd0808281146o7a00388eie9322ff778665961@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0808282201190.11146@melkki.cs.Helsinki.FI>
References: <20080828183223.GA30781@localhost.localdomain> 
 <20080828184025.GA22165@x200.localdomain> <19f34abd0808281146o7a00388eie9322ff778665961@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Vegard Nossum wrote:
> On Thu, Aug 28, 2008 at 8:40 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > On Thu, Aug 28, 2008 at 08:32:23PM +0200, Vegard Nossum wrote:
> >> How do you feel about this patch? It's all about making kmemcheck more
> >> useful... and not much else. Does it have any chance of entering the
> >> kernel along with kmemcheck (when/if that happens)?
> >
> > DEFINE_BITFIELD is horrible.
> >
> >> @@ -285,11 +286,12 @@ struct sk_buff {
> >>               };
> >>       };
> >>       __u32                   priority;
> >> -     __u8                    local_df:1,
> >> +     DEFINE_BITFIELD(__u8,   flags1,
> >> +                             local_df:1,
> >>                               cloned:1,
> >>                               ip_summed:2,
> >>                               nohdr:1,
> >> -                             nfctinfo:3;
> >> +                             nfctinfo:3);
> >>       __u8                    pkt_type:3,
> >>                               fclone:2,
> >>                               ipvs_property:1,
> 
> Ok, that's constructive :-P
> 
> Can we skip the type and always assume that it should be __u8/uint8_t?
> I read somewhere that bitfields should anyway always be 1 byte wide if
> the bitfield should be "portable". Would it help (to make this less
> horrible) to omit the type declaration and have just the bitfield
> members as arguments to the macro?

Why not do something like this (as suggested by Ingo, I think)? Yeah, the 
macro should go into kmemcheck.h but I don't have a tree handy...

		Pekka

Index: linux-2.6/include/linux/bitfield.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/bitfield.h
@@ -0,0 +1,10 @@
+#ifndef __LINUX_BITFIELD_H
+#define __LINUX_BITFIELD_H
+
+#ifdef CONFIG_KMEMCHECK
+#define KMEMCHECK_BIT_FIELD(field) do { field = 0; } while (0)
+#else
+#define KMEMCHECK_BIT_FIELD(field) do { } while (0)
+#endif /* CONFIG_KMEMCHECK */
+
+#endif /* __LINUX_BITFIELD_H */

Index: linux-2.6/net/core/skbuff.c
===================================================================
--- linux-2.6.orig/net/core/skbuff.c
+++ linux-2.6/net/core/skbuff.c
@@ -55,6 +55,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/init.h>
 #include <linux/scatterlist.h>
+#include <linux/bitfield.h>
 
 #include <net/protocol.h>
 #include <net/dst.h>
@@ -209,6 +210,11 @@ struct sk_buff *__alloc_skb(unsigned int
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
 	skb->end = skb->tail + size;
+	KMEMCHECK_BIT_FIELD(skb->local_df);
+	KMEMCHECK_BIT_FIELD(skb->cloned);
+	KMEMCHECK_BIT_FIELD(skb->ip_summed);
+	KMEMCHECK_BIT_FIELD(skb->nohdr);
+	KMEMCHECK_BIT_FIELD(skb->nfctinfo);
 	/* make sure we initialize shinfo sequentially */
 	shinfo = skb_shinfo(skb);
 	atomic_set(&shinfo->dataref, 1);
