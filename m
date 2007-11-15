Return-Path: <linux-kernel-owner+w=401wt.eu-S933478AbXKOHCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbXKOHCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbXKOGrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58087 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbXKOGrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:41 -0500
Date: Wed, 14 Nov 2007 22:45:13 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <larry.finger@lwfinger.net>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [patch 24/40] USB: usbserial - fix potential deadlock between
	write() and IRQ
Message-ID: <20071115064513.GY19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-usbserial-fix-potential-deadlock-between-write-and-irq.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Kosina <jkosina@suse.cz>

patch acd2a847e7fee7df11817f67dba75a2802793e5d in mainline.

USB: usbserial - fix potential deadlock between write() and IRQ

usb_serial_generic_write() doesn't disable interrupts when taking port->lock,
and could therefore deadlock with usb_serial_generic_read_bulk_callback()
being called from interrupt, taking the same lock. Fix it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Larry Finger <larry.finger@lwfinger.net>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/generic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -208,14 +208,15 @@ int usb_serial_generic_write(struct usb_
 
 	/* only do something if we have a bulk out endpoint */
 	if (serial->num_bulk_out) {
-		spin_lock_bh(&port->lock);
+		unsigned long flags;
+		spin_lock_irqsave(&port->lock, flags);
 		if (port->write_urb_busy) {
-			spin_unlock_bh(&port->lock);
+			spin_unlock_irqrestore(&port->lock, flags);
 			dbg("%s - already writing", __FUNCTION__);
 			return 0;
 		}
 		port->write_urb_busy = 1;
-		spin_unlock_bh(&port->lock);
+		spin_unlock_irqrestore(&port->lock, flags);
 
 		count = (count > port->bulk_out_size) ? port->bulk_out_size : count;
 

-- 
