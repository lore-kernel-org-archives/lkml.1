Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZBQJcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZBQJcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZBQJc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:32:27 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55602 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZBQJc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BWmdsNv2EzCF97+ZGJdN2G8VSuLUQq51joTsTGtldq58oX5Yf+pNJXo2Zenp831Nfg
         pbHSEXgOqnbW2NYLg8FliimtNYRdTMqSeXoQ+i1CBc7HOeyaVDKs1fSGi+1B3cxXHqy3
         BbIKY06LO9Or4fFbZWWZcnYujFN+P5r+CCnhk=
Date: Tue, 17 Feb 2009 09:32:18 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Karl Hiramoto <karl@hiramoto.org>, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: problem with IPoA (CLIP),  NAT, and VLANS
Message-ID: <20090217093218.GA5341@ff.dom.local>
References: <20090216232016.GA4803@ami.dom.local> <499A7D7D.1090607@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499A7D7D.1090607@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:03:57AM +0100, Patrick McHardy wrote:
> Jarek Poplawski wrote:
>> Very nice debugging, but I think your patch doesn't look like enough:
>> 1) it skips copy for cloned skbs,
>> 2) this skb_cow_head() is needed anyway, sometimes.
>> So the real bug should be found in skb_cow_head() or elsewhere.
>>
>> I attach here 2 patches for testing:
>> 1) skb->mac_header update: it looks like needed, but I don't know if
>>    it matters here,
>> 2) an extention of your patch but with pskb_expand_head() called for
>>    one to one copy.
>>
>> BTW, if it's not a big problem it would be nice to try this e.g. on
>> 2.6.29-rc5.
>
> The first patch looks fine. As for the second one, I would like
> to understand why we're seing these packets. The VLAN driver uses
> the original headroom plus the space it needs itself, which suggests
> that the underlying driver specifies an incorrect headroom.
> The driver doesn't appear to be part of the mainline kernel though.
>

The second patch is only for debugging: to check if it's about offset
change or some values corrupted btw.

Since the first patch looks quite natural I resend it for applying.
I hope you'll ack it when Karl sends "Tested-by:" after checking it
at least with the currently working (IPoE) vlan case.

Thanks,
Jarek P.
----------------->
vlan: Update skb->mac_header in __vlan_put_tag().

After moving mac addresses in __vlan_put_tag() skb->mac_header() needs
to be updated.

Reported-by: Karl Hiramoto <karl@hiramoto.org>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

 include/linux/if_vlan.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index f8ff918..e1ff5b1 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -210,6 +210,7 @@ static inline struct sk_buff *__vlan_put_tag(struct sk_buff *skb, u16 vlan_tci)
 
 	/* Move the mac addresses to the beginning of the new header. */
 	memmove(skb->data, skb->data + VLAN_HLEN, 2 * VLAN_ETH_ALEN);
+	skb->mac_header -= VLAN_HLEN;
 
 	/* first, the ethernet type */
 	veth->h_vlan_proto = htons(ETH_P_8021Q);

