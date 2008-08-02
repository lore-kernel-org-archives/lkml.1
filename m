Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbYHBPNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbYHBPNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYHBPNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:13:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37782 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbYHBPNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:13:12 -0400
Date: Sat, 2 Aug 2008 17:13:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: ben.collins@ubuntu.com, stefanr@s5r6.in-berlin.de,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/10] drivers/ieee1394: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.64.0808021712460.20095@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/ieee1394/csr1212.c |    2 +-
 drivers/ieee1394/eth1394.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/ieee1394/csr1212.c b/drivers/ieee1394/csr1212.c
--- a/drivers/ieee1394/csr1212.c
+++ b/drivers/ieee1394/csr1212.c
@@ -84,7 +84,7 @@ static const u8 csr1212_key_id_type_map[
 
 
 #define quads_to_bytes(_q) ((_q) * sizeof(u32))
-#define bytes_to_quads(_b) (((_b) + sizeof(u32) - 1) / sizeof(u32))
+#define bytes_to_quads(_b) DIV_ROUND_UP(_b, sizeof(u32))
 
 static void free_keyval(struct csr1212_keyval *kv)
 {
diff -u -p a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -1361,7 +1361,7 @@ static unsigned int ether1394_encapsulat
 		hdr->ff.dgl = dgl;
 		adj_max_payload = max_payload - hdr_type_len[ETH1394_HDR_LF_FF];
 	}
-	return (dg_size + adj_max_payload - 1) / adj_max_payload;
+	return DIV_ROUND_UP(dg_size, adj_max_payload);
 }
 
 static unsigned int ether1394_encapsulate(struct sk_buff *skb,
