Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYH3I21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYH3I21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 04:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYH3I2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 04:28:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:32949 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYH3I2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 04:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=pVH9ejpcdqqV1yrnenA2BI4v7Ur0VSlis9wrpf+5K5eN4RQvhregrI2VVvElStskFz
         /3oUlkZ8MoTLHKztBLpkeBRPLx4+ur2Dh6gisTgwPMUIR6DxciDFOHLDiJ/PyX9oS9Tr
         CTTqm5OGWHXAOHqvs8Nt42TzKSLos7TgwKC60=
Date: Sat, 30 Aug 2008 10:28:16 +0200
To: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bitfields API
Message-ID: <20080830082816.GA21198@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808281238w18a53b90wc55591a572c225da@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 9:38 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Thu, Aug 28, 2008 at 9:02 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>> Why not do something like this (as suggested by Ingo, I think)? Yeah, the
>> macro should go into kmemcheck.h but I don't have a tree handy...
>>
>>                Pekka
>>
>> Index: linux-2.6/include/linux/bitfield.h
>> ===================================================================
>> --- /dev/null
>> +++ linux-2.6/include/linux/bitfield.h
>> @@ -0,0 +1,10 @@
>> +#ifndef __LINUX_BITFIELD_H
>> +#define __LINUX_BITFIELD_H
>> +
>> +#ifdef CONFIG_KMEMCHECK
>> +#define KMEMCHECK_BIT_FIELD(field) do { field = 0; } while (0)
>> +#else
>> +#define KMEMCHECK_BIT_FIELD(field) do { } while (0)
>> +#endif /* CONFIG_KMEMCHECK */
>> +
>> +#endif /* __LINUX_BITFIELD_H */
>>
>> Index: linux-2.6/net/core/skbuff.c
>> ===================================================================
>> --- linux-2.6.orig/net/core/skbuff.c
>> +++ linux-2.6/net/core/skbuff.c
>> @@ -55,6 +55,7 @@
>>  #include <linux/rtnetlink.h>
>>  #include <linux/init.h>
>>  #include <linux/scatterlist.h>
>> +#include <linux/bitfield.h>
>>
>>  #include <net/protocol.h>
>>  #include <net/dst.h>
>> @@ -209,6 +210,11 @@ struct sk_buff *__alloc_skb(unsigned int
>>        skb->data = data;
>>        skb_reset_tail_pointer(skb);
>>        skb->end = skb->tail + size;
>> +       KMEMCHECK_BIT_FIELD(skb->local_df);
>> +       KMEMCHECK_BIT_FIELD(skb->cloned);
>> +       KMEMCHECK_BIT_FIELD(skb->ip_summed);
>> +       KMEMCHECK_BIT_FIELD(skb->nohdr);
>> +       KMEMCHECK_BIT_FIELD(skb->nfctinfo);
>>        /* make sure we initialize shinfo sequentially */
>>        shinfo = skb_shinfo(skb);
>>        atomic_set(&shinfo->dataref, 1);
>>
>
> That looks good to me. If the extra lines are okay with net people, we
> can put this in the fixlets branch and make it the norm for dealing
> with bitfields in kmemcheck.
>
> One thing to keep in mind that if the members of the bitfield does not
> span the entire width of the bitfield, the remaining bits must also be
> assigned (as an extra "filler" member), otherwise GCC will not
> optimize it to a single store. But that is not an issue in this
> particular case since all the bits are used.

Hm, and this is exactly the case for the "do_not_encrypt" field of skbuff:

#ifdef CONFIG_IPV6_NDISC_NODETYPE
        __u8                    ndisc_nodetype:2;
#endif
#if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
        __u8                    do_not_encrypt:1;
#endif  

So we have no way to know where or how big the filler should be. This is
why the simple patch above is not sufficient.

Alexey: I have a modified proposal with slightly different syntax for
DEFINE_BITFIELD. Can you say whether this is acceptable or not? Please
see this short mockup example:


<--- cut --->

#include <stdint.h>
#include <string.h>

#define DEFINE_BITFIELD(name, fields...)	\
	union {					\
		struct fields name;		\
		struct fields;			\
	};

#define KMEMCHECK_ANNOTATE_BITFIELD(bitfield)			\
	do {							\
		memset(&(bitfield), 0, sizeof(bitfield));	\
	} while(0)

struct skbuff {
	DEFINE_BITFIELD(flags1, {
		uint8_t			pkt_type:3,
					fclone:2,
					ipvs_property:1,
					peeked:1,
					nf_trace:1;
		uint16_t		protocol;
	});

	DEFINE_BITFIELD(flags2, {
#ifdef CONFIG_IPV6_NDISC_NODETYPE
		uint8_t			ndisc_nodetype:2;
#endif
#if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
		uint8_t			do_not_encrypt:1;
#endif
	});
};

void __alloc_skb(struct skbuff *skb)
{
	KMEMCHECK_ANNOTATE_BITFIELD(skb->flags1);
	KMEMCHECK_ANNOTATE_BITFIELD(skb->flags2);
}

<--- cut --->


Thanks,


Vegard
