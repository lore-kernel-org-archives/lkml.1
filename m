Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbZD2Wid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbZD2Wid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbZD2WVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:48 -0400
Received: from kroah.org ([198.145.64.141]:40532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760053AbZD2WVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:29 2009
Message-Id: <20090429220929.573174522@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
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
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 44/58] r8169: reset IntrStatus after chip reset
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=r8169-reset-intrstatus-after-chip-reset.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

Upstream as d78ad8cbfe73ad568de38814a75e9c92ad0a907c (post 2.6.29).

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1687,8 +1687,7 @@ rtl8169_init_one(struct pci_dev *pdev, c
 		goto err_out_free_res_4;
 	}
 
-	/* Unneeded ? Don't mess with Mrs. Murphy. */
-	rtl8169_irq_mask_and_ack(ioaddr);
+	RTL_W16(IntrMask, 0x0000);
 
 	/* Soft reset the chip. */
 	RTL_W8(ChipCmd, CmdReset);
@@ -1700,6 +1699,8 @@ rtl8169_init_one(struct pci_dev *pdev, c
 		msleep_interruptible(1);
 	}
 
+	RTL_W16(IntrStatus, 0xffff);
+
 	/* Identify chip attached to board */
 	rtl8169_get_mac_version(tp, ioaddr);
 


