Return-Path: <linux-kernel-owner+w=401wt.eu-S936049AbZLQEUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936049AbZLQEUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936035AbZLQEFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:12 -0500
Received: from kroah.org ([198.145.64.141]:55824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935987AbZLQEFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:57 2009
Message-Id: <20091217035657.124098529@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [109/151] ip_fragment: also adjust skb->truesize for packets not owned by a socket
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

[ Upstream commit b2722b1c3a893ec6021508da15b32282ec79f4da ]

When a large packet gets reassembled by ip_defrag(), the head skb
accounts for all the fragments in skb->truesize. If this packet is
refragmented again, skb->truesize is not re-adjusted to reflect only
the head size since its not owned by a socket. If the head fragment
then gets recycled and reused for another received fragment, it might
exceed the defragmentation limits due to its large truesize value.

skb_recycle_check() explicitly checks for linear skbs, so any recycled
skb should reflect its true size in skb->truesize. Change ip_fragment()
to also adjust the truesize value of skbs not owned by a socket.

Reported-and-tested-by: Ben Menchaca <ben@bigfootnetworks.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/ip_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -501,8 +501,8 @@ int ip_fragment(struct sk_buff *skb, int
 			if (skb->sk) {
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
-				truesizes += frag->truesize;
 			}
+			truesizes += frag->truesize;
 		}
 
 		/* Everything is OK. Generate! */


