Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935960Ab0CMA5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:57:21 -0500
Received: from kroah.org ([198.145.64.141]:46829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935362Ab0CMAbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:17 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.911854837@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [042/145] inet: Remove bogus IGMPv3 report handling
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit c6b471e6454c0e1c6d756672841cbaeae7c949f8 ]

Currently we treat IGMPv3 reports as if it were an IGMPv2/v1 report.
This is broken as IGMPv3 reports are formatted differently.  So we
end up suppressing a bogus multicast group (which should be harmless
as long as the leading reserved field is zero).

In fact, IGMPv3 does not allow membership report suppression so
we should simply ignore IGMPv3 membership reports as a host.

This patch does exactly that.  I kept the case statement for it
so people won't accidentally add it back thinking that we overlooked
this case.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/igmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -946,7 +946,6 @@ int igmp_rcv(struct sk_buff *skb)
 		break;
 	case IGMP_HOST_MEMBERSHIP_REPORT:
 	case IGMPV2_HOST_MEMBERSHIP_REPORT:
-	case IGMPV3_HOST_MEMBERSHIP_REPORT:
 		/* Is it our report looped back? */
 		if (skb_rtable(skb)->fl.iif == 0)
 			break;
@@ -960,6 +959,7 @@ int igmp_rcv(struct sk_buff *skb)
 		in_dev_put(in_dev);
 		return pim_rcv_v1(skb);
 #endif
+	case IGMPV3_HOST_MEMBERSHIP_REPORT:
 	case IGMP_DVMRP:
 	case IGMP_TRACE:
 	case IGMP_HOST_LEAVE_MESSAGE:


