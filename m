Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbZJIXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbZJIXQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761556AbZJIXQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:16:48 -0400
Received: from kroah.org ([198.145.64.141]:36726 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959AbZJIXQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:16:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:00 2009
Message-Id: <20091009231000.380054491@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 02/26] tty: Avoid dropping ldisc_mutex over hangup tty re-initialization
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=tty-avoid-dropping-ldisc_mutex-over-hangup-tty-re-initialization.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0b5759c654e74c8dc317ea2c6b3a7476160f688a upstream.

A couple of people have hit the WARN_ON() in drivers/char/tty_io.c,
tty_open() that is unhappy about seeing the tty line discipline go away
during the tty hangup. See for example

	http://bugzilla.kernel.org/show_bug.cgi?id=14255

and the reason is that we do the tty_ldisc_halt() outside the
ldisc_mutex in order to be able to flush the scheduled work without a
deadlock with vhangup_work.

However, it turns out that we can solve this particular case by

 - using "cancel_delayed_work_sync()" in tty_ldisc_halt(), which waits
   for just the particular work, rather than synchronizing with any
   random outstanding pending work.

   This won't deadlock, since the buf.work we synchronize with doesn't
   care about the ldisc_mutex, it just flushes the tty ldisc buffers.

 - realize that for this particular case, we don't need to wait for any
   hangup work, because we are inside the hangup codepaths ourselves.

so as a result we can just drop the flush_scheduled_work() entirely, and
then move the tty_ldisc_halt() call to inside the mutex.  That way we
never expose the partially torn down ldisc state to tty_open(), and hold
the ldisc_mutex over the whole sequence.

Reported-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Heinz Diehl <htd@fancy-poultry.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_ldisc.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -516,7 +516,7 @@ static void tty_ldisc_restore(struct tty
 static int tty_ldisc_halt(struct tty_struct *tty)
 {
 	clear_bit(TTY_LDISC, &tty->flags);
-	return cancel_delayed_work(&tty->buf.work);
+	return cancel_delayed_work_sync(&tty->buf.work);
 }
 
 /**
@@ -754,12 +754,9 @@ void tty_ldisc_hangup(struct tty_struct 
 	 * N_TTY.
 	 */
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
-		/* Make sure the old ldisc is quiescent */
-		tty_ldisc_halt(tty);
-		flush_scheduled_work();
-
 		/* Avoid racing set_ldisc or tty_ldisc_release */
 		mutex_lock(&tty->ldisc_mutex);
+		tty_ldisc_halt(tty);
 		if (tty->ldisc) {	/* Not yet closed */
 			/* Switch back to N_TTY */
 			tty_ldisc_reinit(tty);


