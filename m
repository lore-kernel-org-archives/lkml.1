Return-Path: <linux-kernel-owner+w=401wt.eu-S1750967AbZKWFA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbZKWFA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 00:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZKWFA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 00:00:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:41803 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750746AbZKWFA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 00:00:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+sOf1aRFys0REAtAnoUCBomMZHNZ7h58xVJgCxXY
	B+mwTgcF9mgI5O
Subject: Re: [bisected] pty performance problem
From: Mike Galbraith <efault@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Swan <swan.r.l@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091122122312.71a343d9@lxorguk.ukuu.org.uk>
References: <20091121222319.GA3905@swanrl.gmail.com>
	 <20091122063926.GA18224@elte.hu>
	 <20091122122312.71a343d9@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 06:00:31 +0100
Message-Id: <1258952431.6261.38.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 12:23 +0000, Alan Cox wrote:
> On Sun, 22 Nov 2009 07:39:26 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > (Cc:-ed Alan and Linus - mail repeated below. eot.)
> 
> I saw it and replied already. The kernel now queues the work for the pty
> as it does normal tty devices. If the CPU load is that low and nothing
> else is happening it makes me wonder what the scheduler thinks it is
> doing ?

Hm.  Looks to me like it's doing what it was told to do.

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 66fa4e1..92a0864 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -495,7 +495,7 @@ void tty_flip_buffer_push(struct tty_struct *tty)
 	if (tty->low_latency)
 		flush_to_ldisc(&tty->buf.work.work);
 	else
-		schedule_delayed_work(&tty->buf.work, 1);
+		schedule_delayed_work(&tty->buf.work, 0);
 }
 EXPORT_SYMBOL(tty_flip_buffer_push);
 
Telling it to execute now made test proggy happy.. and likely broke tons
of things that need a delay there.  So, what's wrong with delaying, when
that's what the customer asked for?  /me must be missing something.  It
could know that no delay is needed?

	-Mike

