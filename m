Return-Path: <linux-kernel-owner+w=401wt.eu-S1762349AbXLTWjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762349AbXLTWjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXLTWjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:39:37 -0500
Received: from outlb3.dejazzd.com ([66.109.229.70]:21173 "EHLO
	smtp.dejazzd.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752821AbXLTWjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:39:36 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2007 17:39:36 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Message-id: <476AE109.5070005@videon-central.com>
Date: Thu, 20 Dec 2007 16:39:21 -0500
From: "Cory T. Tusar" <ctusar@videon-central.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071219)
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH] tty: Fix logic change introduced by
 wait_event_interruptible_timeout()
X-Enigmail-Version: 0.95.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty: Fix logic change introduced by wait_event_interruptible_timeout()

Commit 5a52bd4a2dcb570333ce6fe2e16cd311650dbdc8 introduced a subtle logic
change in tty_wait_until_sent().  The original version would only error
out of the 'do { ... } while (timeout)' loop if signal_pending() evaluated
to true; a timeout or break due to an empty buffer would fall out of the
loop and into the tty->driver->wait_until_sent handling.  The current
implementation will error out on either a pending signal or an empty
buffer, falling through to the tty->driver->wait_until_sent handling
only on a timeout.

This change reverts the logic flow in tty_wait_until_sent() to match that
prior to the aforementioned commit.

Signed-off-by: Cory T. Tusar <ctusar@videon-central.com>

---
Please CC me on any replies; I'm not subscribed to lkml.  Thanks.

 drivers/char/tty_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 1bdd2bf..e02d592 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -62,7 +62,7 @@ void tty_wait_until_sent(struct tty_struct * tty, long timeout)
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
 	if (wait_event_interruptible_timeout(tty->write_wait,
-			!tty->driver->chars_in_buffer(tty), timeout))
+			!tty->driver->chars_in_buffer(tty), timeout) < 0)
 		return;
 	if (tty->driver->wait_until_sent)
 		tty->driver->wait_until_sent(tty, timeout);


-- 
Cory T. Tusar
Embedded Systems Engineer
Videon Central, Inc.
2171 Sandy Drive
State College, PA 16803
(814) 235-1111 x316
(814) 235-1118 fax


"There are two ways of constructing a software design.  One way is to
 make it so simple that there are obviously no deficiencies, and the
 other way is to make it so complicated that there are no obvious
 deficiencies."  --Sir Charles Anthony Richard Hoare



