Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZJBAF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZJBAF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbZJBAF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:05:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035AbZJBAF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:05:57 -0400
Date: Thu, 1 Oct 2009 17:05:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Heinz Diehl <htd@fancy-poultry.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #14255] WARNING: at drivers/char/tty_io.c:1267
In-Reply-To: <COE24pZSBH.A.f1._MTxKB@chimera>
Message-ID: <alpine.LFD.2.01.0910011643370.6996@localhost.localdomain>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.f1._MTxKB@chimera>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14255
> Subject		: WARNING: at drivers/char/tty_io.c:1267
> Submitter	: Heinz Diehl <htd@fancy-poultry.org>
> Date		: 2009-09-20 11:37 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=125344629506309&w=4
> 		  http://lkml.org/lkml/2009/9/8/393
> Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>

So the real problem here is that horrible workqueue deadlock, but it turns 
out that I think that we should be able to safely do a

	cancel_delayed_work_sync(&tty->buf.work);

in tty_ldisc_halt(), because cancel_delayed_work_sync() should never wait 
for any other work than the exact work in question. And the buf.work thing 
is flush_to_ldisc(), so waiting for _that_ is safe - the problematic thing 
was always waiting for the (unrelated) tty->hangup_work, which can (and 
does) take the semaphore for do_tty_hangup.

So doing that synchronous version of the delayed work cancel means that we 
can now rest easy after tty_ldisc_halt(), and we don't need to worry about 
buf.work still being pending. We _do_ in general need to worry about 
hangup_work, which will call do_tty_hangup, which will call 
tty_ldisc_hangup, but that's actually the routine we are in right now, so 
for the _very_ special case of tty_ldisc_hangup that is a non-issue too.

Did that sound subtle to you? 

It should.

It's subtle as hell, and I don't like it, but I think that the two subtle 
rules above means that the following two-liner patch is safe - it can't 
cause any new deadlocks, and getting rid of a the flush_scheduled_work is 
safe in this one case.

So please give it a whirl. I'm not happy about the subtlety, but I also 
hope that we'll get rid of that in the long run, so as a short-term hack 
this looks acceptable.

To recap:

 - tty_ldisc_halt() _can_ be called under the ldisc_mutex, because while 
   it waits for the work, it never waits for _other_ work, and buf.work 
   itself doesn't need the ldisc_mutex. So no deadlock.

 - The flush_scheduled_work() after tty_ldisc_halt() is normally needed to 
   not just flush the buf.work (which is now done by tty_ldisc_halt() 
   itself), but to also make sure that there isn't any hangup work
   pending.

   So we can't remove that in general, and the other cases will still need 
   to flush all scheduled work (and worry about deadlocks with 
   ldisc_mutex). HOWEVER, in the special case of tty_ldisc_hangup() we 
   know that we are inside the hangup work, and thus don't need to wait 
   for ourselves, so we can just get rid of it there - just nowhere else.

 - The other cases of dropping the ldisc_mutex in the middle are 
   long-standing, and have that TTY_LDISC_CHANGING vs TTY_HUPPED hackery 
   to take care of the races that it opens. I'd love to get rid of that 
   too, but they all seem to work. And they have never apparently 
   triggered the WARN_ON in this bugzilla.

I'm not proud of this patch, and I'm not signing off on it until the 
people who have seen this warning have tried it and report that it seems 
to work..

		Linus

---
 drivers/char/tty_ldisc.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index aafdbae..feb5507 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -518,7 +518,7 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 static int tty_ldisc_halt(struct tty_struct *tty)
 {
 	clear_bit(TTY_LDISC, &tty->flags);
-	return cancel_delayed_work(&tty->buf.work);
+	return cancel_delayed_work_sync(&tty->buf.work);
 }
 
 /**
@@ -756,12 +756,9 @@ void tty_ldisc_hangup(struct tty_struct *tty)
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
