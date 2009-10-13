Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbZJMUyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbZJMUyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934158AbZJMUyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:54:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934034AbZJMUyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:54:43 -0400
Date: Tue, 13 Oct 2009 13:53:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Boyan <btanastasov@yahoo.co.uk>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <4AD4DE4C.4010402@yahoo.co.uk>
Message-ID: <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Oct 2009, Boyan wrote:
> 
> Composite is enabled in my X config, but I don't have compiz or
> something like that enabled. DRI is enabled.

I think I may actually see the problem. And if I'm right, then the bug you 
guys bisected down to is really the fundamental reason. Embarrassing. I 
was so convinced it should only change flush timing, that I didn't think 
through all the possibilities.

The reason for thinking that it only really changes timing si fairly 
simple: the only thing it really does is to call "flush_to_ldisc()" 
synchronously when needed. On the face of it, that should be perfectly 
safe.

But flush_to_ldisc() itself has a real oddity: it uses "tty->buf.lock" to 
protect everything, BUT NOT THE ACTUAL CALL TO ->receive_buf()!

So even though that function looks _trivially_ atomic, once you look 
deeper it suddenly becomes clear how it's not really atomic at all: it 
will do all the buffer handling with the spinlock held, but then after it 
has figured out the buffer, it does:

	...
        spin_unlock_irqrestore(&tty->buf.lock, flags);
        disc->ops->receive_buf(tty, char_buf,
                                        flag_buf, count);
        spin_lock_irqsave(&tty->buf.lock, flags);
	...

and by releasing that lock it actually seems to break all the buffering 
guarantees! What can happen is:

	CPU1 (or thread1 with PREEMPTION)
					CPU2 (or thread2 with PREEMPTION)

	flush_to_ldisc()
	...
	spin_lock_irqsave(..)
	.. get one buffer..
	spin_unlock_irqrestore(..);

			<- PREEMPTION POINT, anything can happen ->
			<- more buffers can be added, etc ->

					flush_to_ldisc()
					spin_lock_irqsave(..)
					.. get second buffer..
					spin_unlock_irqrestore(..);
					->receive_buf(tty, char_buf, ...
					spin_lock_irqrestore(..)
					.. all done ..


	->receive_buf(tty, char_buf, ...
        spin_lock_irqrestore(...)

Notice how the "->receive_buf()" calls were done out of order, even if the 
data was perfectly in-order in the buffers.

And you can get the same race on SMP even without preemption, just thanks 
to CPU's hitting that lock just right. CONFIG_PREEMPT just makes it easier 
(probably _much_ easier) to trigger, and possible even on UP.

As far as I can tell, this is not really a new bug (it could have happened 
with low_latency before too), but on a tty without low_latency it would 
never happen until the commit you bisected to because the workqueue itself 
would serialize everything, and only one flush would ever be pending.

Anyway, the above explanation "feels right". It would easily explain the 
behavior, because if the ->receive_buf() calls get re-ordered, then the 
events get re-ordered, and one simple case of that would be to see the key 
"release" event before the key "press" event.

It also explains how that commit seems to be indicated so consistently. It 
still requires some specific timing, but now it's not timing _introduced_ 
by the commit, it's an old bug that that commit exposed, and then needs 
some unlucky timing to actually happen.

The sane fix would be to just run ->receive_buf() under the tty->buf.lock, 
but I assume we'd have a lot of unhappy ldiscs if we did that (and 
possibly irq latency problems too).

I think the

	tty->buf.head = NULL;
	...
	/* Restore the queue head */
	tty->buf.head = head;

around that loop is actually there to try to avoid this whole problem, but 
whoever did that didn't realize that there are other things that could set 
buf.head (in particular, tty_buffer_request_room() while the lock is 
dropped, so that whole logic is totally broken anyway and might even 
conspire to make the problem worse (ie if somebody tries to add data while 
->receive_buf() is running and the lock is gone, you are now _really_ 
screwing things up).

So instead of playing games with buf.head, I think we should just rely on 
the TTY_FLUSHING bit. I'm not _entirely_ happy with this, because now if 
we call flush_to_ldisc() while somebody else is busy flushing it, it will 
return early even though the flush hasn't completed yet. But that was 
always true to some degree (ie the "buffer full" case).

Anyway, I'm not entirely happy with this patch, and I haven't actually 
TESTED it so it might well be totally broken, but something along the 
lines of the appended may just fix it. It would be good if people who see 
this problem tried it out.

			Linus
---
 drivers/char/tty_buffer.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 3108991..da59334 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -402,28 +402,24 @@ static void flush_to_ldisc(struct work_struct *work)
 		container_of(work, struct tty_struct, buf.work.work);
 	unsigned long 	flags;
 	struct tty_ldisc *disc;
-	struct tty_buffer *tbuf, *head;
-	char *char_buf;
-	unsigned char *flag_buf;
 
 	disc = tty_ldisc_ref(tty);
 	if (disc == NULL)	/*  !TTY_LDISC */
 		return;
 
 	spin_lock_irqsave(&tty->buf.lock, flags);
-	/* So we know a flush is running */
-	set_bit(TTY_FLUSHING, &tty->flags);
-	head = tty->buf.head;
-	if (head != NULL) {
-		tty->buf.head = NULL;
-		for (;;) {
-			int count = head->commit - head->read;
+
+	if (test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
+		struct tty_buffer *head;
+		while ((head = tty->buf.head) != NULL) {
+			int count;
+			char *char_buf;
+			unsigned char *flag_buf;
+
+			count = head->commit - head->read;
 			if (!count) {
-				if (head->next == NULL)
-					break;
-				tbuf = head;
-				head = head->next;
-				tty_buffer_free(tty, tbuf);
+				tty->buf.head = head->next;
+				tty_buffer_free(tty, head);
 				continue;
 			}
 			/* Ldisc or user is trying to flush the buffers
@@ -445,9 +441,9 @@ static void flush_to_ldisc(struct work_struct *work)
 							flag_buf, count);
 			spin_lock_irqsave(&tty->buf.lock, flags);
 		}
-		/* Restore the queue head */
-		tty->buf.head = head;
+		clear_bit(TTY_FLUSHING, &tty->flags);
 	}
+
 	/* We may have a deferred request to flush the input buffer,
 	   if so pull the chain under the lock and empty the queue */
 	if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
@@ -455,7 +451,6 @@ static void flush_to_ldisc(struct work_struct *work)
 		clear_bit(TTY_FLUSHPENDING, &tty->flags);
 		wake_up(&tty->read_wait);
 	}
-	clear_bit(TTY_FLUSHING, &tty->flags);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 
 	tty_ldisc_deref(disc);
