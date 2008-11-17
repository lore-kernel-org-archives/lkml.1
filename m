Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYKQHXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYKQHXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYKQHVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:01 -0500
Received: from kroah.org ([198.145.64.141]:38250 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752141AbYKQHUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:20:54 -0500
Date: Sun, 16 Nov 2008 23:14:34 -0800
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
       alan@lxorguk.ukuu.org.uk, Eilon Greenstein <eilong@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>, Alex Chiang <achiang@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/46] bnx2x: PCI configuration bug on big-endian
Message-ID: <20081117071434.GG29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bnx2x-pci-configuration-bug-on-big-endian.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eilon Greenstein <eilong@broadcom.com>

commit 7d96567ac0527703cf1b80043fc0ebd7f21a10ad upstream.

The current code read nothing but zeros on big-endian (wrong part of the
32bits). This caused poor performance on big-endian machines. Though this
issue did not cause the system to crash, the performance is significantly
better with the fix so I view it as critical bug fix.

Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2x_init.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/bnx2x_init.h
+++ b/drivers/net/bnx2x_init.h
@@ -564,14 +564,15 @@ static const struct arb_line write_arb_a
 
 static void bnx2x_init_pxp(struct bnx2x *bp)
 {
+	u16 devctl;
 	int r_order, w_order;
 	u32 val, i;
 
 	pci_read_config_word(bp->pdev,
-			     bp->pcie_cap + PCI_EXP_DEVCTL, (u16 *)&val);
-	DP(NETIF_MSG_HW, "read 0x%x from devctl\n", (u16)val);
-	w_order = ((val & PCI_EXP_DEVCTL_PAYLOAD) >> 5);
-	r_order = ((val & PCI_EXP_DEVCTL_READRQ) >> 12);
+			     bp->pcie_cap + PCI_EXP_DEVCTL, &devctl);
+	DP(NETIF_MSG_HW, "read 0x%x from devctl\n", devctl);
+	w_order = ((devctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5);
+	r_order = ((devctl & PCI_EXP_DEVCTL_READRQ) >> 12);
 
 	if (r_order > MAX_RD_ORD) {
 		DP(NETIF_MSG_HW, "read order of %d  order adjusted to %d\n",

-- 
