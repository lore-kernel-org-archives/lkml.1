Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbZHBVdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbZHBVdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 17:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZHBVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 17:33:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753760AbZHBVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 17:33:18 -0400
Date: Sun, 2 Aug 2009 14:33:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
In-Reply-To: <87k51l9apo.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Aug 2009, OGAWA Hirofumi wrote:
> 
> In this case, what is happening seems to be simple.
> 
> 2735 tty1	Ss	0:0 init [S]          <- session leader
> 2736 tty1	S	0:0  \_ bash
> 
> Sequence is,
> 
>     bash        tty_read()
>                     tty_ldisc_ref_wait()               <- take refcount
>                     n_tty_read()
>                         schedule_timeout()
> 
>     init [S]    do_exit()
>                     [...]
>                         do_tty_hangup()
>                             tty_ldisc_hangup()
>                                 wake_up_interruptible_poll(read_wait)
> 
>     bash                /* n_tty_read() can't see the hangup state of tty,
>                          * because anybody don't teach it to tty or ldisc */
>                         schedule_timeout()             <- wait again

Hmm. Wouldn't it trigger on tty_hung_up_p(file)?

[ Reading further.. ]

> And another related point which I'm don't know is why we don't change
> console_fops to hung_up_tty_fops in do_tty_hangup() in the below.

Yup, you're right. Because console_fops has 

        .write          = redirected_tty_write,

we won't actually hang up the console due to that test for "write != 
tty_write".

That's just a classic example of some of the crazy hacks we have in the 
tty layers. I do wonder whether it's even necessary any more. Maybe we 
could just hang things up forcefully now and get rid of that console 
handling special case.

But I guess that all does explain why it only happens in single-user mode. 

So exactly what _does_ happen if we get rid of that hack?

		Linus

---
 drivers/char/tty_io.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a3afa0c..80540ec 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -496,10 +496,8 @@ static void do_tty_hangup(struct work_struct *work)
 {
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, hangup_work);
-	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
 	struct task_struct *p;
-	int    closecount = 0, n;
 	unsigned long flags;
 	int refs = 0;
 
@@ -520,11 +518,6 @@ static void do_tty_hangup(struct work_struct *work)
 	file_list_lock();
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
 	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
-		if (filp->f_op->write == redirected_tty_write)
-			cons_filp = filp;
-		if (filp->f_op->write != tty_write)
-			continue;
-		closecount++;
 		tty_fasync(-1, filp, 0);	/* can't block */
 		filp->f_op = &hung_up_tty_fops;
 	}
@@ -574,17 +567,7 @@ static void do_tty_hangup(struct work_struct *work)
 	while (refs--)
 		tty_kref_put(tty);
 
-	/*
-	 * If one of the devices matches a console pointer, we
-	 * cannot just call hangup() because that will cause
-	 * tty->count and state->count to go out of sync.
-	 * So we just call close() the right number of times.
-	 */
-	if (cons_filp) {
-		if (tty->ops->close)
-			for (n = 0; n < closecount; n++)
-				tty->ops->close(tty, cons_filp);
-	} else if (tty->ops->hangup)
+	if (tty->ops->hangup)
 		(tty->ops->hangup)(tty);
 	/*
 	 * We don't want to have driver/ldisc interactions beyond
