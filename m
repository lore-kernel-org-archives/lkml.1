Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbZD2W1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbZD2W1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbZD2WVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:24 -0400
Received: from kroah.org ([198.145.64.141]:40338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323AbZD2WVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:25 2009
Message-Id: <20090429220925.292347131@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:15 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 16/58] netfilter: nf_conntrack_tcp: fix unaligned memory access in tcp_sack
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-nf_conntrack_tcp-fix-unaligned-memory-access-in-tcp_sack.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark H. Weaver <mhw@netris.org>

[ Upstream commit 534f81a5068799799e264fd162e9488a129f98d4 ]

This patch fixes an unaligned memory access in tcp_sack while reading
sequence numbers from TCP selective acknowledgement options.  Prior to
applying this patch, upstream linux-2.6.27.20 was occasionally
generating messages like this on my sparc64 system:

  [54678.532071] Kernel unaligned access at TPC[6b17d4] tcp_packet+0xcd4/0xd00

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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


