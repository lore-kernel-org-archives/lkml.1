Return-Path: <linux-kernel-owner+w=401wt.eu-S1764532AbYHDUaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764532AbYHDUaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764407AbYHDU3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:29:48 -0400
Received: from mail.suse.de ([195.135.220.2]:49345 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764392AbYHDU3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:29:46 -0400
Date: Mon, 4 Aug 2008 13:16:12 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 25/33] USB: EHCI: fix remote-wakeup regression
Message-ID: <20080804201612.GZ1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ehci-fix-remote-wakeup-regression.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit d1f114d12bb4db3147e1b1342ae31083c5a79c84 upstream

This patch (as1097) fixes a bug in the remote-wakeup handling in
ehci-hcd.  The driver currently does not keep track of whether the
change-suspend feature is enabled for each port; the feature is
automatically reset the first time it is read.  But recent changes to
the hub driver require that the feature be read at least twice in
order to work properly.

A bit-vector is added for storing the change-suspend feature values.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hub.c |    6 ++++--
 drivers/usb/host/ehci.h     |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -97,6 +97,8 @@ struct ehci_hcd {			/* one per controlle
 			dedicated to the companion controller */
 	unsigned long		owned_ports;		/* which ports are
 			owned by the companion during a bus suspend */
+	unsigned long		port_c_suspend;		/* which ports have
+			the change-suspend feature turned on */
 
 	/* per-HC memory pools (could be per-bus, but ...) */
 	struct dma_pool		*qh_pool;	/* qh per active urb */
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -621,7 +621,7 @@ static int ehci_hub_control (
 			}
 			break;
 		case USB_PORT_FEAT_C_SUSPEND:
-			/* we auto-clear this feature */
+			clear_bit(wIndex, &ehci->port_c_suspend);
 			break;
 		case USB_PORT_FEAT_POWER:
 			if (HCS_PPC (ehci->hcs_params))
@@ -700,7 +700,7 @@ static int ehci_hub_control (
 			/* resume completed? */
 			else if (time_after_eq(jiffies,
 					ehci->reset_done[wIndex])) {
-				status |= 1 << USB_PORT_FEAT_C_SUSPEND;
+				set_bit(wIndex, &ehci->port_c_suspend);
 				ehci->reset_done[wIndex] = 0;
 
 				/* stop resume signaling */
@@ -777,6 +777,8 @@ static int ehci_hub_control (
 			status |= 1 << USB_PORT_FEAT_RESET;
 		if (temp & PORT_POWER)
 			status |= 1 << USB_PORT_FEAT_POWER;
+		if (test_bit(wIndex, &ehci->port_c_suspend))
+			status |= 1 << USB_PORT_FEAT_C_SUSPEND;
 
 #ifndef	EHCI_VERBOSE_DEBUG
 	if (status & ~0xffff)	/* only if wPortChange is interesting */

-- 
