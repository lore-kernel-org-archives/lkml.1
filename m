Return-Path: <linux-kernel-owner+w=401wt.eu-S1765491AbYBBAae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765491AbYBBAae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763479AbYBBAZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:25:03 -0500
Received: from ns.suse.de ([195.135.220.2]:54646 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763470AbYBBAY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:24:59 -0500
Date: Fri, 1 Feb 2008 16:20:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/27] CASSINI: Fix endianness bug.
Message-ID: <20080202002048.GR8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cassini_1.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit: e5e025401f6e926c1d9dc3f3f2813cf98a2d8708 ]

Here's proposed fix for RX checksum handling in cassini; it affects
little-endian working with half-duplex gigabit, but obviously needs
testing on big-endian too.

The problem is, we need to convert checksum to fixed-endian *before*
correcting for (unstripped) FCS.  On big-endian it won't matter
(conversion is no-op), on little-endian it will, but only if FCS is
not stripped by hardware; i.e. in half-duplex gigabit mode when
->crc_size is set.

cassini.c part is that fix, cassini.h one consists of trivial
endianness annotations.  With that applied the sucker is endian-clean,
according to sparse.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cassini.c |    8 +++++---
 drivers/net/cassini.h |   18 +++++++++---------
 2 files changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -1979,6 +1979,7 @@ static int cas_rx_process_pkt(struct cas
 	struct cas_page *page;
 	struct sk_buff *skb;
 	void *addr, *crcaddr;
+	__sum16 csum;
 	char *p;
 
 	hlen = CAS_VAL(RX_COMP2_HDR_SIZE, words[1]);
@@ -2158,14 +2159,15 @@ end_copy_pkt:
 		skb_put(skb, alloclen);
 	}
 
-	i = CAS_VAL(RX_COMP4_TCP_CSUM, words[3]);
+	csum = (__force __sum16)htons(CAS_VAL(RX_COMP4_TCP_CSUM, words[3]));
 	if (cp->crc_size) {
 		/* checksum includes FCS. strip it out. */
-		i = csum_fold(csum_partial(crcaddr, cp->crc_size, i));
+		csum = csum_fold(csum_partial(crcaddr, cp->crc_size,
+					      csum_unfold(csum)));
 		if (addr)
 			cas_page_unmap(addr);
 	}
-	skb->csum = ntohs(i ^ 0xffff);
+	skb->csum = csum_unfold(~csum);
 	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->protocol = eth_type_trans(skb, cp->dev);
 	return len;
--- a/drivers/net/cassini.h
+++ b/drivers/net/cassini.h
@@ -4122,8 +4122,8 @@ cas_saturn_patch_t cas_saturn_patch[] = 
 							     inserted into
 							     outgoing frame. */
 struct cas_tx_desc {
-	u64     control;
-	u64     buffer;
+	__le64     control;
+	__le64     buffer;
 };
 
 /* descriptor ring for free buffers contains page-sized buffers. the index
@@ -4131,8 +4131,8 @@ struct cas_tx_desc {
  * the completion ring.
  */
 struct cas_rx_desc {
-	u64     index;
-	u64     buffer;
+	__le64     index;
+	__le64     buffer;
 };
 
 /* received packets are put on the completion ring. */
@@ -4210,10 +4210,10 @@ struct cas_rx_desc {
 #define RX_INDEX_RELEASE                  0x0000000000002000ULL
 
 struct cas_rx_comp {
-	u64     word1;
-	u64     word2;
-	u64     word3;
-	u64     word4;
+	__le64     word1;
+	__le64     word2;
+	__le64     word3;
+	__le64     word4;
 };
 
 enum link_state {
@@ -4252,7 +4252,7 @@ struct cas_init_block {
 	struct cas_rx_comp rxcs[N_RX_COMP_RINGS][INIT_BLOCK_RX_COMP];
 	struct cas_rx_desc rxds[N_RX_DESC_RINGS][INIT_BLOCK_RX_DESC];
 	struct cas_tx_desc txds[N_TX_RINGS][INIT_BLOCK_TX];
-	u64 tx_compwb;
+	__le64 tx_compwb;
 };
 
 /* tiny buffers to deal with target abort issue. we allocate a bit

-- 
