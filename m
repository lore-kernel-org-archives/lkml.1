Return-Path: <linux-kernel-owner+w=401wt.eu-S1765768AbXKOHAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765768AbXKOHAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932520AbXKOGrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58043 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbXKOGrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:31 -0500
Date: Wed, 14 Nov 2007 22:45:02 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benedikt Spranger <bene@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 21/40] usb-gadget-ether: prevent oops caused by error
	interrupt race
Message-ID: <20071115064502.GV19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benedikt Spranger <bene@linutronix.de>

patch 5395353e0c8272fe73ac914acd7e4add0da2bef0 in mainline.

Fix a longstanding race in the Ethernet gadget driver, which can cause an
oops on device disconnect.  The fix is just to make the TX path check
whether its freelist is empty.  That check is otherwise not necessary,
since the queue is always stopped when that list empties (and restarted
when request completion puts an entry back on that freelist).

The race window starts when the network code decides to transmit a packet,
and ends when hard_start_xmit() grabs the freelist lock.  When disconnect()
is called inside that window, it shuts down the TX queue and breaks the
otherwise-solid assumption that packets are never sent through a TX queue
that's stopped.

Signed-off-by: Benedikt Spranger <bene@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/ether.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -1989,8 +1989,20 @@ static int eth_start_xmit (struct sk_buf
 	}
 
 	spin_lock_irqsave(&dev->req_lock, flags);
+	/*
+	 * this freelist can be empty if an interrupt triggered disconnect()
+	 * and reconfigured the gadget (shutting down this queue) after the
+	 * network stack decided to xmit but before we got the spinlock.
+	 */
+	if (list_empty(&dev->tx_reqs)) {
+		spin_unlock_irqrestore(&dev->req_lock, flags);
+		return 1;
+	}
+
 	req = container_of (dev->tx_reqs.next, struct usb_request, list);
 	list_del (&req->list);
+
+	/* temporarily stop TX queue when the freelist empties */
 	if (list_empty (&dev->tx_reqs))
 		netif_stop_queue (net);
 	spin_unlock_irqrestore(&dev->req_lock, flags);

-- 
