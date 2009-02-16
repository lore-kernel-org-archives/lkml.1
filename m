Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZBPXUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZBPXUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZBPXU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:20:28 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:44630 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZBPXU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:20:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=arpVho709GMyqUciUIBHObUZiYhBse7Bjqx5odza7l/RxKi0C8nCNlUuzUm8ebSz+d
         p2fyUkEGS1pWXXT1MreebffKf7vGwMumjVet3og7HhxM5VeThXNoN/TUIDBmsnkXrnNW
         o1E/Sedu5tRblHNB57zZJPUbJ5+nD2FtcQt60=
Date: Tue, 17 Feb 2009 00:20:16 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: netdev@vger.kernel.org, netfilter@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: problem with IPoA (CLIP),  NAT, and VLANS
Message-ID: <20090216232016.GA4803@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49997FEA.9040300@hiramoto.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Hiramoto wrote, On 02/16/2009 04:02 PM:
...
> The problem ended up being the packet being corrupted when the vlan tag
> was being added and skb_cow_head()  was being called.
> 
> Anyone know why skb_cow_head() would corrupt the packet?  Perhaps it was
> not allocated correctly?     I'm using a big-endian ARM IXP435 board.

Hi,
Very nice debugging, but I think your patch doesn't look like enough:
1) it skips copy for cloned skbs,
2) this skb_cow_head() is needed anyway, sometimes.
So the real bug should be found in skb_cow_head() or elsewhere.

I attach here 2 patches for testing:
1) skb->mac_header update: it looks like needed, but I don't know if
   it matters here,
2) an extention of your patch but with pskb_expand_head() called for
   one to one copy.

BTW, if it's not a big problem it would be nice to try this e.g. on
2.6.29-rc5.

Thanks,
Jarek P.

---> patch #1

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

---> patch #2

 include/linux/if_vlan.h |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index f8ff918..e9a5eb1 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -202,9 +202,16 @@ static inline struct sk_buff *__vlan_put_tag(struct sk_buff *skb, u16 vlan_tci)
 {
 	struct vlan_ethhdr *veth;
 
-	if (skb_cow_head(skb, VLAN_HLEN) < 0) {
-		kfree_skb(skb);
-		return NULL;
+	if (skb_headroom(skb) < VLAN_HLEN) {
+		if (skb_cow_head(skb, VLAN_HLEN) < 0) {
+			kfree_skb(skb);
+			return NULL;
+		}
+	} else {
+		if (pskb_expand_head(skb, 0, 0, GFP_ATOMIC) < 0) {
+			kfree_skb(skb);
+			return NULL;
+		}
 	}
 	veth = (struct vlan_ethhdr *)skb_push(skb, VLAN_HLEN);
 
