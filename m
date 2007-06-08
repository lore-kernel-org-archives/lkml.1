Return-Path: <linux-kernel-owner+w=401wt.eu-S939494AbXFHHux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939494AbXFHHux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967762AbXFHHZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:02 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55310 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938400AbXFHHYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:55 -0400
Message-Id: <20070608072216.627543000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:58 -0700
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
       "Michael Chan" <mchan@broadcom.com>,
       David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 31/54] TG3: Fix link problem on Dells onboard 5906.
Content-Disposition: inline; filename=tg3-fix-link-problem-on-dell-s-onboard-5906.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  <mchan@broadcom.com>

The bug is caused by code that always set
(TG3_FLAG_USE_MI_INTERRUPT | TG3_FLAG_USE_LINKCHG_REG) on all Dell's
onboard devices.  With these 2 flags set, the link status is polled
by tg3_timer() and will only work when the PHY is set up to interrupt
the MAC on link changes.  This breaks 5906 because the 5906 PHY does
not support TG3_FLAG_USE_MI_INTERRUPT the same as other PHYs.

For correctness, only 5701 on Dell systems needs these 2 flags to be
set.  This change will fix the 5906 problem and will change other
Dell devices except 5700 and 5701 to use the more efficient
interrupt-driven link changes.

Update version to 3.75.2.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.21.4.orig/drivers/net/tg3.c
+++ linux-2.6.21.4/drivers/net/tg3.c
@@ -64,8 +64,8 @@
 
 #define DRV_MODULE_NAME		"tg3"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"3.75.1"
-#define DRV_MODULE_RELDATE	"May 7, 2007"
+#define DRV_MODULE_VERSION	"3.75.2"
+#define DRV_MODULE_RELDATE	"June 5, 2007"
 
 #define TG3_DEF_MAC_MODE	0
 #define TG3_DEF_RX_MODE		0
@@ -10942,6 +10942,7 @@ static int __devinit tg3_get_invariants(
 	 * upon subsystem IDs.
 	 */
 	if (tp->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
+	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5701 &&
 	    !(tp->tg3_flags2 & TG3_FLG2_PHY_SERDES)) {
 		tp->tg3_flags |= (TG3_FLAG_USE_MI_INTERRUPT |
 				  TG3_FLAG_USE_LINKCHG_REG);

-- 
