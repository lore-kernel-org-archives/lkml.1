Return-Path: <linux-kernel-owner+w=401wt.eu-S934719AbZGQPiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbZGQPiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 11:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934703AbZGQPiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 11:38:23 -0400
Received: from mx10.kentrox.com ([192.228.33.31]:41217 "EHLO smtp.kentrox.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934687AbZGQPiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 11:38:22 -0400
X-Greylist: delayed 1826 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jul 2009 11:38:22 EDT
From: Jeff Harris <jeff_harris@kentrox.com>
To: alan@linux.intel.com, vapier@gentoo.org, adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org, Jeff Harris <jeff_harris@kentrox.com>
Subject: [PATCH] tty: Fix tcdrain hang due to tty chars_in_buffer errors
Date: Fri, 17 Jul 2009 11:07:54 -0400
Message-Id: <1247843274-7462-1-git-send-email-jeff_harris@kentrox.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 17 Jul 2009 15:07:54.0178 (UTC) FILETIME=[5C2BEA20:01CA06F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a tty driver's chars_in_buffer callback reports an error, the wait loop in
tty_wait_until_sent may never exit until its timeout.  A tty device
disconnection will hangup the tty causing the tty_wait_until_sent loop to
wake-up, but if the subsequent call to chars_in_buffer reports an error
instead of zero, the loop will go back to sleep instead of exiting.

A process calling tcdrain will block indefinitely if it calls tcdrain when the
device is disconnected.

Signed-off-by: Jeff Harris <jeff_harris@kentrox.com>
---
 drivers/char/tty_ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index ad6ba4e..306d52e 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -156,7 +156,7 @@ void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
 	if (wait_event_interruptible_timeout(tty->write_wait,
-			!tty_chars_in_buffer(tty), timeout) >= 0) {
+			tty_chars_in_buffer(tty) <= 0, timeout) >= 0) {
 		if (tty->ops->wait_until_sent)
 			tty->ops->wait_until_sent(tty, timeout);
 	}
@@ -332,7 +332,7 @@ void tty_termios_encode_baud_rate(struct ktermios *termios,
 	int iclose = ibaud/50, oclose = obaud/50;
 	int ibinput = 0;
 
-	if (obaud == 0)			/* CD dropped 		  */
+	if (obaud == 0)			/* CD dropped		  */
 		ibaud = 0;		/* Clear ibaud to be sure */
 
 	termios->c_ispeed = ibaud;
-- 
1.5.5.1

