Return-Path: <linux-kernel-owner+w=401wt.eu-S1764144AbZCaXWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764144AbZCaXWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbZCaXUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:20 -0400
Received: from sous-sol.org ([216.99.217.87]:33107 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758976AbZCaXUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:15 -0400
Message-Id: <20090331231327.584532150@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:46 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Mark H. Weaver" <mhw@netris.org>,
       David S Miller <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>
Subject: [patch 01/45] netfilter: nf_conntrack_tcp: fix unaligned memory access in tcp_sack
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=netfilter-nf_conntrack_tcp-fix-unaligned-memory-access-in-tcp_sack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mark H. Weaver <mhw@netris.org>

[ Upstream commit 534f81a5068799799e264fd162e9488a129f98d4 ]

This patch fixes an unaligned memory access in tcp_sack while reading
sequence numbers from TCP selective acknowledgement options.  Prior to
applying this patch, upstream linux-2.6.27.20 was occasionally
generating messages like this on my sparc64 system:

  [54678.532071] Kernel unaligned access at TPC[6b17d4] tcp_packet+0xcd4/0xd00

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -15,6 +15,7 @@
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
+#include <asm/unaligned.h>
 
 #include <net/tcp.h>
 
@@ -466,7 +467,7 @@ static void tcp_sack(const struct sk_buf
 				for (i = 0;
 				     i < (opsize - TCPOLEN_SACK_BASE);
 				     i += TCPOLEN_SACK_PERBLOCK) {
-					tmp = ntohl(*((__be32 *)(ptr+i)+1));
+					tmp = get_unaligned_be32((__be32 *)(ptr+i)+1);
 
 					if (after(tmp, *sack))
 						*sack = tmp;

