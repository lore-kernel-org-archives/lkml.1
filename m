Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYDMR0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYDMR0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYDMR0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:26:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54843 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751423AbYDMR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:26:46 -0400
Date: Sun, 13 Apr 2008 18:22:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] isdn: switch to int put_char method
Message-ID: <20080413182217.1c3e1670@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/isdn/capi/capi.c linux-2.6.25-rc8-mm2/drivers/isdn/capi/capi.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/isdn/capi/capi.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/isdn/capi/capi.c	2008-04-13 15:40:50.000000000 +0100
@@ -1111,11 +1111,12 @@
 	return count;
 }
 
-static void capinc_tty_put_char(struct tty_struct *tty, unsigned char ch)
+static int capinc_tty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct capiminor *mp = (struct capiminor *)tty->driver_data;
 	struct sk_buff *skb;
 	unsigned long flags;
+	int ret = 1;
 
 #ifdef _DEBUG_TTYFUNCS
 	printk(KERN_DEBUG "capinc_put_char(%u)\n", ch);
@@ -1125,7 +1126,7 @@
 #ifdef _DEBUG_TTYFUNCS
 		printk(KERN_DEBUG "capinc_tty_put_char: mp or mp->ncci NULL\n");
 #endif
-		return;
+		return 0;
 	}
 
 	spin_lock_irqsave(&workaround_lock, flags);
@@ -1134,7 +1135,7 @@
 		if (skb_tailroom(skb) > 0) {
 			*(skb_put(skb, 1)) = ch;
 			spin_unlock_irqrestore(&workaround_lock, flags);
-			return;
+			return 1;
 		}
 		mp->ttyskb = NULL;
 		skb_queue_tail(&mp->outqueue, skb);
@@ -1148,8 +1149,10 @@
 		mp->ttyskb = skb;
 	} else {
 		printk(KERN_ERR "capinc_put_char: char %u lost\n", ch);
+		ret = 0;
 	}
 	spin_unlock_irqrestore(&workaround_lock, flags);
+	return ret;
 }
 
 static void capinc_tty_flush_chars(struct tty_struct *tty)
