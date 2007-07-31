Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbXGaE3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbXGaE3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbXGaE3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:29:30 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42219 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759AbXGaE33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:29:29 -0400
Date: Mon, 30 Jul 2007 21:31:13 -0700
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
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 01/26] BNX2: Fix netdev watchdog on 5708.
Message-ID: <20070731043113.GB3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bnx2-fix-netdev-watchdog-on-5708.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

There's a bug in the driver that only initializes half of the context
memory on the 5708.  Surprisingly, this works most of the time except
for some occasional netdev watchdogs when sending a lot of 64-byte
packets.  This fix is to add the missing code to initialize the 2nd
half of the context memory.

Update version to 1.5.8.2.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- linux-2.6.21.6.orig/drivers/net/bnx2.c
+++ linux-2.6.21.6/drivers/net/bnx2.c
@@ -54,8 +54,8 @@
 
 #define DRV_MODULE_NAME		"bnx2"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"1.5.8.1"
-#define DRV_MODULE_RELDATE	"May 7, 2007"
+#define DRV_MODULE_VERSION	"1.5.8.2"
+#define DRV_MODULE_RELDATE	"June 5, 2007"
 
 #define RUN_AT(x) (jiffies + (x))
 
@@ -1550,6 +1550,7 @@ bnx2_init_context(struct bnx2 *bp)
 	vcid = 96;
 	while (vcid) {
 		u32 vcid_addr, pcid_addr, offset;
+		int i;
 
 		vcid--;
 
@@ -1570,16 +1571,20 @@ bnx2_init_context(struct bnx2 *bp)
 			pcid_addr = vcid_addr;
 		}
 
-		REG_WR(bp, BNX2_CTX_VIRT_ADDR, 0x00);
-		REG_WR(bp, BNX2_CTX_PAGE_TBL, pcid_addr);
+		for (i = 0; i < (CTX_SIZE / PHY_CTX_SIZE); i++) {
+			vcid_addr += (i << PHY_CTX_SHIFT);
+			pcid_addr += (i << PHY_CTX_SHIFT);
+
+			REG_WR(bp, BNX2_CTX_VIRT_ADDR, 0x00);
+			REG_WR(bp, BNX2_CTX_PAGE_TBL, pcid_addr);
+
+			/* Zero out the context. */
+			for (offset = 0; offset < PHY_CTX_SIZE; offset += 4)
+				CTX_WR(bp, 0x00, offset, 0);
 
-		/* Zero out the context. */
-		for (offset = 0; offset < PHY_CTX_SIZE; offset += 4) {
-			CTX_WR(bp, 0x00, offset, 0);
+			REG_WR(bp, BNX2_CTX_VIRT_ADDR, vcid_addr);
+			REG_WR(bp, BNX2_CTX_PAGE_TBL, pcid_addr);
 		}
-
-		REG_WR(bp, BNX2_CTX_VIRT_ADDR, vcid_addr);
-		REG_WR(bp, BNX2_CTX_PAGE_TBL, pcid_addr);
 	}
 }
 

-- 
