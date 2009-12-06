Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZLGAgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZLGAgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZLGAMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:33 -0500
Received: from kroah.org ([198.145.64.141]:34172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222AbZLGAM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:41 2009
Message-Id: <20091207000641.813085557@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [008/119] rtl8187: Fix kernel oops when device is removed when LEDS enabled
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=rtl8187-fix-kernel-oops-when-device-is-removed-when-leds-enabled.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

commit 37b12dd2b07b4d7dc222a5f7f88b25cec532b2aa upstream.

As reported by Rick Farina (sidhayn@gmail.com), removing the RTL8187
USB stick, or unloading the driver rtl8187 using rmmod will cause a
kernel oops.  There are at least two forms of the failure, (1) BUG:
Scheduling while atomic, and (2) a fatal kernel page fault. This
problem is reported in Bugzilla #14539.

This problem does not occur for kernel 2.6.31, but does for 2.6.32-rc2,
thus it is technically a regression; however, bisection did not locate
any faulty patch. The fix was found by comparing the faulty code in
rtl8187 with p54usb.  My interpretation is that the handling of work
queues in mac80211 changed enough to the LEDs to be unregistered
before tasks on the work queues are cancelled. Previously, these
actions could be done in either order.

(Herton Ronaldo Krzesinski <herton@mandriva.com.br> reports that the
code is the same in 2.6.31, so this may be a candidate for 2.6.31.x.
-- JWL)

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Rick Farina <sidhayn@gmail.com>
Tested-by: Rick Farina <sidhayn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl818x/rtl8187_leds.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -210,10 +210,10 @@ void rtl8187_leds_exit(struct ieee80211_
 
 	/* turn the LED off before exiting */
 	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
-	cancel_delayed_work_sync(&priv->led_off);
-	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
 	rtl8187_unregister_led(&priv->led_tx);
+	cancel_delayed_work_sync(&priv->led_off);
+	cancel_delayed_work_sync(&priv->led_on);
 }
 #endif /* def CONFIG_RTL8187_LED */
 


