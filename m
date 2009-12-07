Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZLGATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZLGATS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbZLGASv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:18:51 -0500
Received: from kroah.org ([198.145.64.141]:34716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594AbZLGANx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:53 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:57 2009
Message-Id: <20091207000657.814193868@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Antti=20Kaijanm=C3=A4ki?= 
	<antti.kaijanmaki@nomovok.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [097/119] hso: fix soft-lockup
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=hso-fix-soft-lockup.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Antti Kaijanmäki <antti.kaijanmaki@nomovok.com>

commit dcfcb256cc23c4436691b0fe677275306699d6a1 upstream.

Fix soft-lockup in hso.c which is triggered on SMP machine when
modem is removed while file descriptor(s) under /dev are still open:

  old version called kref_put() too early which resulted in destroying
  hso_serial and hso_device objects which were still used later on.

Signed-off-by: Antti Kaijanmäki <antti.kaijanmaki@nomovok.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/net/usb/hso.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1362,7 +1362,7 @@ static void hso_serial_close(struct tty_
 	/* reset the rts and dtr */
 	/* do the actual close */
 	serial->open_count--;
-	kref_put(&serial->parent->ref, hso_serial_ref_free);
+
 	if (serial->open_count <= 0) {
 		serial->open_count = 0;
 		spin_lock_irq(&serial->serial_lock);
@@ -1382,6 +1382,8 @@ static void hso_serial_close(struct tty_
 		usb_autopm_put_interface(serial->parent->interface);
 
 	mutex_unlock(&serial->parent->mutex);
+
+	kref_put(&serial->parent->ref, hso_serial_ref_free);
 }
 
 /* close the requested serial port */


