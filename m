Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZHBUUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZHBUUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZHBUUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:20:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbZHBUUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:20:31 -0400
Date: Sun, 2 Aug 2009 13:20:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
In-Reply-To: <20090802190514.GA3278@localdomain.by>
Message-ID: <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Aug 2009, Sergey Senozhatsky wrote:
> 
> non-SMP system 'fails' as well.

Ahh, can you trigger this reliably? Is it 100% of the time when you shut 
down from single user mode? Or just occasionally?

> > The ldisc refcounts are simply done wrong. They are more debugging aids 
> > (for the case where no races occur), than actual memory management 
> > refcounts.
> 
> tty_ldisc.c:798  tty_ldisc_hangup
> 	WARN_ON(tty_ldisc_wait_idle(tty) != 0);
> 
> gave WARN_ON traces.

Yes, good catch. It means that somebody seems to have held on to the 
refcount for more than five seconds.

Which shouldn't happen under any normal situation.

> So, it seems refcount is wrong before
> 	tty_ldisc_halt(tty);
> 	tty_ldisc_wait_idle(tty);

Agreed. Or something is just holding the refcount for too long, possibly 
due to some deadlockish scenario (ie we migth be in "tty_ldisc_flush()", 
and blocked forever on ld->ops->flush_buffer() while holding the ldisc 
refcount. And we hold that whole &tty->ldisc_mutex _while_ waiting, so I 
can easily see things being blocked on each other.

I'd like to drop the ldisc_mutex while sleeping, but we can't. Not every 
caller even holds it. But just for a broken test, can you try the appended 
patch (NOT meant for serious consumption!) to see if it migth be a 
deadlock (broken by the timeout) on that semaphore?

I take it that you can't get a trace with sysrq-T because nothing gets 
logged, and you don't have a serial port console? That would likely 
pinpoint it pretty quickly (you could make the WARN_ON() do a 
"show_state()" instead - no need to actually physically press 'sysrq-t').

			Linus
---
 drivers/char/tty_ldisc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index acd76b7..eb44c45 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -795,7 +795,9 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		if (tty->ldisc) {	/* Not yet closed */
 			/* Switch back to N_TTY */
 			tty_ldisc_halt(tty);
+			mutex_unlock(&tty->ldisc_mutex);	// HACK
 			tty_ldisc_wait_idle(tty);
+			mutex_lock(&tty->ldisc_mutex);		// HACK
 			tty_ldisc_reinit(tty);
 			/* At this point we have a closed ldisc and we want to
 			   reopen it. We could defer this to the next open but
