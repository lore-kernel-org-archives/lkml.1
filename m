Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbYBFX7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbYBFX7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764168AbYBFXyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:33 -0500
Received: from mail.suse.de ([195.135.220.2]:45148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764131AbYBFXyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:31 -0500
Date: Wed, 6 Feb 2008 15:51:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, ctusar@videon-central.com,
       jirislaby@gmail.com
Subject: [patch 11/73] tty: fix logic change introduced by
	wait_event_interruptible_timeout()
Message-ID: <20080206235117.GL13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tty-fix-logic-change-introduced-by-wait_event_interruptible_timeout.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: "Cory T. Tusar" <ctusar@videon-central.com>

patch db99247ac68fc352100090ad7704fb5efb9327b6 in mainline.

Commit 5a52bd4a2dcb570333ce6fe2e16cd311650dbdc8 introduced a subtle logic
change in tty_wait_until_sent().  The original version would only error out
of the 'do { ...  } while (timeout)' loop if signal_pending() evaluated to
true; a timeout or break due to an empty buffer would fall out of the loop
and into the tty->driver->wait_until_sent handling.  The current
implementation will error out on either a pending signal or an empty
buffer, falling through to the tty->driver->wait_until_sent handling only
on a timeout.

The ->wait_until_sent() will not be reached if the buffer empties before
timeout jiffies have elapsed.  This behavior differs from that prior to commit
5a52bd4a2dcb570333ce6fe2e16cd311650dbdc8.

I turned this up while using a little serial download utility to bootstrap an
ARM-based eval board.  The util worked fine on 2.6.22.x, but consistently
failed on 2.6.23.x.  Once I'd determined that, I narrowed things down with git
bisect, and found the above difference in logic in tty_wait_until_sent() by
inspection.

This change reverts the logic flow in tty_wait_until_sent() to match that
prior to the aforementioned commit.

Signed-off-by: Cory T. Tusar <ctusar@videon-central.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -62,7 +62,7 @@ void tty_wait_until_sent(struct tty_stru
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
 	if (wait_event_interruptible_timeout(tty->write_wait,
-			!tty->driver->chars_in_buffer(tty), timeout))
+			!tty->driver->chars_in_buffer(tty), timeout) < 0)
 		return;
 	if (tty->driver->wait_until_sent)
 		tty->driver->wait_until_sent(tty, timeout);

-- 
