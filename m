Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbYKDXlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbYKDXlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbYKDXiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:08 -0500
Received: from ns1.suse.de ([195.135.220.2]:47299 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236AbYKDXiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:06 -0500
Date: Tue, 4 Nov 2008 15:31:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Jay Cliburn <jacliburn@bellsouth.net>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 10/57] atl1: fix vlan tag regression
Message-ID: <20081104233117.GK659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atl1-fix-vlan-tag-regression.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jay Cliburn <jacliburn@bellsouth.net>

commit dc5596d920b504d263c7ca38bd76326179b13dee upstream

Commit 401c0aabec4b97320f962a0161a846d230a6f7aa introduced a regression
in the atl1 driver by storing the VLAN tag in the wrong TX descriptor
field.

This patch causes the VLAN tag to be stored in its proper location.

Tested-by: Ramon Casellas <ramon.casellas@cttc.es>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atlx/atl1.c |    7 ++++---
 drivers/net/atlx/atl1.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2317,7 +2317,8 @@ static void atl1_tx_queue(struct atl1_ad
 		if (tpd != ptpd)
 			memcpy(tpd, ptpd, sizeof(struct tx_packet_desc));
 		tpd->buffer_addr = cpu_to_le64(buffer_info->dma);
-		tpd->word2 = (cpu_to_le16(buffer_info->length) &
+		tpd->word2 &= ~(TPD_BUFLEN_MASK << TPD_BUFLEN_SHIFT);
+		tpd->word2 |= (cpu_to_le16(buffer_info->length) &
 			TPD_BUFLEN_MASK) << TPD_BUFLEN_SHIFT;
 
 		/*
@@ -2426,8 +2427,8 @@ static int atl1_xmit_frame(struct sk_buf
 		vlan_tag = (vlan_tag << 4) | (vlan_tag >> 13) |
 			((vlan_tag >> 9) & 0x8);
 		ptpd->word3 |= 1 << TPD_INS_VL_TAG_SHIFT;
-		ptpd->word3 |= (vlan_tag & TPD_VL_TAGGED_MASK) <<
-			TPD_VL_TAGGED_SHIFT;
+		ptpd->word2 |= (vlan_tag & TPD_VLANTAG_MASK) <<
+			TPD_VLANTAG_SHIFT;
 	}
 
 	tso = atl1_tso(adapter, skb, ptpd);
--- a/drivers/net/atlx/atl1.h
+++ b/drivers/net/atlx/atl1.h
@@ -504,7 +504,7 @@ struct rx_free_desc {
 #define TPD_PKTNT_MASK		0x0001
 #define TPD_PKTINT_SHIFT	15
 #define TPD_VLANTAG_MASK	0xFFFF
-#define TPD_VLAN_SHIFT		16
+#define TPD_VLANTAG_SHIFT	16
 
 /* tpd word 3 bits 0:13 */
 #define TPD_EOP_MASK		0x0001

-- 
