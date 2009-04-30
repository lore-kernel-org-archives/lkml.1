Return-Path: <linux-kernel-owner+w=401wt.eu-S1765014AbZD3RaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765014AbZD3RaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764656AbZD3RIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:10 -0400
Received: from kroah.org ([198.145.64.141]:56638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764221AbZD3RH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:45 2009
Message-Id: <20090430165745.784965678@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:39 -0700
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
       alan@lxorguk.ukuu.org.uk, Karsten Wiese <fzu@wemgehoertderstaat.de>,
       Francois Romieu <romieu@fr.zoreil.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 50/88] r8169: Reset IntrStatus after chip reset
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0024-r8169-Reset-IntrStatus-after-chip-reset.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

upstream commit: d78ad8cbfe73ad568de38814a75e9c92ad0a907c

Original comment (Karsten):
On a MSI MS-6702E mainboard, when in rtl8169_init_one() for the first time
after BIOS has run, IntrStatus reads 5 after chip has been reset.
IntrStatus should equal 0 there, so patch changes IntrStatus reset to happen
after chip reset instead of before.

Remark (Francois):
Assuming that the loglevel of the driver is increased above NETIF_MSG_INTR,
the bug reveals itself with a typical "interrupt 0025 in poll" message
at startup. In retrospect, the message should had been read as an hint of
an unexpected hardware state several months ago :o(

Fixes (at least part of) https://bugzilla.redhat.com/show_bug.cgi?id=460747

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Tested-by: Josep <josep.puigdemont@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/r8169.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2026,8 +2026,7 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	if (!tp->pcie_cap && netif_msg_probe(tp))
 		dev_info(&pdev->dev, "no PCI Express capability\n");
 
-	/* Unneeded ? Don't mess with Mrs. Murphy. */
-	rtl8169_irq_mask_and_ack(ioaddr);
+	RTL_W16(IntrMask, 0x0000);
 
 	/* Soft reset the chip. */
 	RTL_W8(ChipCmd, CmdReset);
@@ -2039,6 +2038,8 @@ rtl8169_init_one(struct pci_dev *pdev, c
 		msleep_interruptible(1);
 	}
 
+	RTL_W16(IntrStatus, 0xffff);
+
 	/* Identify chip attached to board */
 	rtl8169_get_mac_version(tp, ioaddr);
 


