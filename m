Return-Path: <linux-kernel-owner+w=401wt.eu-S1761911AbXHUG4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911AbXHUG4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761211AbXHUGy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:54:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44259 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761188AbXHUGyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:54:25 -0400
Date: Mon, 20 Aug 2007 23:55:21 -0700
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
       Thomas M?ller <thomas@mathtm.de>, Andreas Adamis <blindg0@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 11/20] r8169: avoid needless NAPI poll scheduling
Message-ID: <20070821065521.GL5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r8169-avoid-needless-napi-poll-scheduling.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Francois Romieu <romieu@fr.zoreil.com>

Theory  : though needless, it should not have hurt.
Practice: it does not play nice with DEBUG_SHIRQ + LOCKDEP + UP
(see https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=3D242572).
 

The patch makes sense in itself but I should dig why it has an effect
on #242572 (assuming that NAPI do not change in a near future).

Patch in mainline as 313b0305b5a1e7e0fb39383befbf79558ce68a9c.
Backported to 2.6.22-stable by Thomas M=FCller.

Signed-off-by: Thomas M=FCller <thomas@mathtm.de>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2649,14 +2649,16 @@ rtl8169_interrupt(int irq, void *dev_ins
 			rtl8169_check_link_status(dev, tp, ioaddr);
 
 #ifdef CONFIG_R8169_NAPI
-		RTL_W16(IntrMask, rtl8169_intr_mask & ~rtl8169_napi_event);
-		tp->intr_mask = ~rtl8169_napi_event;
-
-		if (likely(netif_rx_schedule_prep(dev)))
-			__netif_rx_schedule(dev);
-		else if (netif_msg_intr(tp)) {
-			printk(KERN_INFO "%s: interrupt %04x taken in poll\n",
-			       dev->name, status);
+		if (status & rtl8169_napi_event) {
+			RTL_W16(IntrMask, rtl8169_intr_mask & ~rtl8169_napi_event);
+			tp->intr_mask = ~rtl8169_napi_event;
+
+			if (likely(netif_rx_schedule_prep(dev)))
+				__netif_rx_schedule(dev);
+			else if (netif_msg_intr(tp)) {
+				printk(KERN_INFO "%s: interrupt %04x in poll\n",
+				       dev->name, status);
+			}
 		}
 		break;
 #else

-- 
