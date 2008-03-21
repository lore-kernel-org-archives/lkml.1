Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbYCUWwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbYCUWwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbYCUWqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:51 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58935 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762865AbYCUWqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:49 -0400
Message-Id: <20080321224448.555683304@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
       davem@davemloft.net, Eric Leblond <eric@inl.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 67/76] NETFILTER: nfnetlink_queue: fix computation of allocated size for netlink skb
Content-Disposition: inline; filename=netfilter-nfnetlink_queue-fix-computation-of-allocated-size-for-netlink-skb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eric Leblond <eric@inl.fr>

Upstream commit cabaa9bf:

Size of the netlink skb was wrongly computed because the formula was using
NLMSG_ALIGN instead of NLMSG_SPACE. NLMSG_ALIGN does not add the room for
netlink header as NLMSG_SPACE does. This was causing a failure of message
building in some cases.

On my test system, all messages for packets in range [8*k+41, 8*k+48] where k
is an integer were invalid and the corresponding packets were dropped.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 net/netfilter/nfnetlink_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -353,7 +353,7 @@ nfqnl_build_packet_message(struct nfqnl_
 
 	QDEBUG("entered\n");
 
-	size =    NLMSG_ALIGN(sizeof(struct nfgenmsg))
+	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */

-- 
