Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbYKQHc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbYKQHc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYKQHVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:38 -0500
Received: from kroah.org ([198.145.64.141]:38645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752485AbYKQHVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:32 -0500
Date: Sun, 16 Nov 2008 23:16:39 -0800
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
       alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 35/46] USB: gadget: cdc-acm deadlock fix
Message-ID: <20081117071639.GJ29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-gadget-cdc-acm-deadlock-fix.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Brownell <dbrownell@users.sourceforge.net>

commit e50ae572b33646656fa7037541613834dcadedfb upstream.

This fixes a deadlock appearing with some USB peripheral drivers
when running CDC ACM gadget code.

The newish (2.6.27) CDC ACM event notification mechanism sends
messages (IN to the host) which are short enough to fit in most
FIFOs.  That means that with some peripheral controller drivers
(evidently not the ones used to verify the notification code!!)
the completion callback can be issued before queue() returns.

The deadlock would come because the completion callback and the
event-issuing code shared a spinlock.  Fix is trivial:  drop
that lock while queueing the message.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/f_acm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -463,7 +463,11 @@ static int acm_cdc_notify(struct f_acm *
 	notify->wLength = cpu_to_le16(length);
 	memcpy(buf, data, length);
 
+	/* ep_queue() can complete immediately if it fills the fifo... */
+	spin_unlock(&acm->lock);
 	status = usb_ep_queue(ep, req, GFP_ATOMIC);
+	spin_lock(&acm->lock);
+
 	if (status < 0) {
 		ERROR(acm->port.func.config->cdev,
 				"acm ttyGS%d can't notify serial state, %d\n",

-- 
