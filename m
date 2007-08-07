Return-Path: <linux-kernel-owner+w=401wt.eu-S966155AbXHGV1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966155AbXHGV1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965040AbXHGU5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:57:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59977 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804AbXHGU5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:57:15 -0400
Date: Tue, 7 Aug 2007 13:49:19 -0700
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
       Marcel Holtmann <marcel@holtmann.org>
Subject: [2.6.22.2 review 76/84] Hangup TTY before releasing rfcomm_dev
Message-ID: <20070807204919.GZ23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hangup-tty-before-releasing-rfcomm_dev.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Rapeli <mikko.rapeli@iki.fi>

The core problem is that RFCOMM socket layer ioctl can release
rfcomm_dev struct while RFCOMM TTY layer is still actively using
it. Calling tty_vhangup() is needed for a synchronous hangup before
rfcomm_dev is freed.

Addresses the oops at http://bugzilla.kernel.org/show_bug.cgi?id=7509

Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/rfcomm/tty.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -383,6 +383,10 @@ static int rfcomm_release_dev(void __use
 	if (req.flags & (1 << RFCOMM_HANGUP_NOW))
 		rfcomm_dlc_close(dev->dlc, 0);
 
+	/* Shut down TTY synchronously before freeing rfcomm_dev */
+	if (dev->tty)
+		tty_vhangup(dev->tty);
+
 	rfcomm_dev_del(dev);
 	rfcomm_dev_put(dev);
 	return 0;

-- 
