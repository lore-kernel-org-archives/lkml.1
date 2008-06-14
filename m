Return-Path: <linux-kernel-owner+w=401wt.eu-S1762338AbYFNASX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762338AbYFNASX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbYFNAN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:34312 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760373AbYFNAN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:26 -0400
Date: Fri, 13 Jun 2008 17:11:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 18/47] cassini: Only use chip checksum for ipv4 packets.
Message-ID: <20080614001103.GR24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cassini-only-use-chip-checksum-for-ipv4-packets.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ upstream commit: b1443e2f6501f06930a162ff1ff08382a98bf23e ]

According to David Monro, at least with Natsemi Saturn chips the
cassini driver has some trouble with ipv6 checksums.

Until we have more information about what's going on here, only
use the chip checksums for ipv4.

This workaround was suggested and tested by David.

Update version and release date.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/cassini.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -142,8 +142,8 @@
 
 #define DRV_MODULE_NAME		"cassini"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"1.5"
-#define DRV_MODULE_RELDATE	"4 Jan 2008"
+#define DRV_MODULE_VERSION	"1.6"
+#define DRV_MODULE_RELDATE	"21 May 2008"
 
 #define CAS_DEF_MSG_ENABLE	  \
 	(NETIF_MSG_DRV		| \
@@ -2140,9 +2140,12 @@ end_copy_pkt:
 		if (addr)
 			cas_page_unmap(addr);
 	}
-	skb->csum = csum_unfold(~csum);
-	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->protocol = eth_type_trans(skb, cp->dev);
+	if (skb->protocol == htons(ETH_P_IP)) {
+		skb->csum = csum_unfold(~csum);
+		skb->ip_summed = CHECKSUM_COMPLETE;
+	} else
+		skb->ip_summed = CHECKSUM_NONE;
 	return len;
 }
 

-- 
