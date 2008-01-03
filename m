Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYACWZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYACWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYACWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:25:16 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:33315 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYACWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:25:14 -0500
X-Greylist: delayed 1512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 17:25:13 EST
Date: Thu, 3 Jan 2008 23:00:03 +0100
From: Matthias Goebl <matthias@goebl.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de
Subject: [PATCH] isdn/i4l: Fix DLE handling for i4l-audio
Message-ID: <20080103220003.GU19071@night.goebl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DLE handling in i4l-audio seems to be broken.

It produces spurious DLEs so asterisk 1.2.24 with chan_modem_i4l
gets irritated, the error message is:
"chan_modem_i4l.c:450 i4l_read: Value of escape is ^ (17)".
-> There shouldn't be a DLE-^.
If a spurious DLE-ETX occurs, the audio connection even dies.
I use a "AVM Fritz!PCI" isdn card.

I found two issues that only appear if ISDN_AUDIO_SKB_DLECOUNT(skb) > 0:
- The loop in isdn_tty.c:isdn_tty_try_read() doesn't escape a DLE if it's
  the last character.

- The loop in isdn_common.c:isdn_readbchan_tty() doesn't copy its characters,
  it only remembers the last one ("last = *p;").

  Compare it with the loop in isdn_common.c:isdn_readbchan(), that *does*
  copy them ("*cp++ = *p;") correctly.
  The special handling of the "last" character made it more difficult.
  I compared it to linux-2.4.19: There was no "last"-handling and both loops
  did escape and copy all characters correctly.


Signed-off-by: Matthias Goebl <matthias.goebl@goebl.net>

--- linux-2.6.23.12.orig/drivers/isdn/i4l/isdn_common.c	2007-12-22 21:13:49.000000000 +0100
+++ linux-2.6.23.12/drivers/isdn/i4l/isdn_common.c	2007-12-26 11:36:52.000000000 +0100
@@ -914,6 +914,9 @@
 			dflag = 0;
 			count_pull = count_put = 0;
 			while ((count_pull < skb->len) && (len > 0)) {
+				/* push every character but the last to the tty buffer directly */
+				if ( count_put )
+					tty_insert_flip_char(tty, last, TTY_NORMAL);
 				len--;
 				if (dev->drv[di]->DLEflag & DLEmask) {
 					last = DLE;
--- linux-2.6.23.12.orig/drivers/isdn/i4l/isdn_tty.c	2007-12-22 21:13:49.000000000 +0100
+++ linux-2.6.23.12/drivers/isdn/i4l/isdn_tty.c	2007-12-26 11:37:18.000000000 +0100
@@ -85,6 +85,8 @@
 								tty_insert_flip_char(tty, DLE, 0);
 							tty_insert_flip_char(tty, *dp++, 0);
 						}
+						if (*dp == DLE)
+							tty_insert_flip_char(tty, DLE, 0);
 						last = *dp;
 					} else {
 #endif
