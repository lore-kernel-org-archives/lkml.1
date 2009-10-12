Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZJLROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZJLROm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZJLROl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:14:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbZJLROl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:14:41 -0400
Date: Mon, 12 Oct 2009 19:13:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] tty, serial: Fix race and NULL check in uart_close()
Message-ID: <20091012171354.GA6918@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu> <alpine.LFD.2.01.0910120850590.3438@localhost.localdomain> <alpine.LFD.2.01.0910120926110.3438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910120926110.3438@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 12 Oct 2009, Linus Torvalds wrote:
> > 
> > Commit 46d57a449 (which you then bisected to) looks really irritating, 
> > since it just renamed variables in annoying ways (ie the old "port" is now 
> > "uport", and there's a new "port" that means something else). That thing 
> > should have been split up to do the renaming separately, so that a mis-use 
> > of "port" would have caused a compile error.
> > 
> > I'm not seeing anything obvious. Alan obviously found one bug already.
> 
> Ok, so I did the "do it as two commits", and when doing that (and 
> being fairly careful at all stages to do everything as no-op 
> conversions), I get this diff.
> 
> It looks like there is not just the wrong lock, but also a test for 
> NULL state got dropped by commit 46d57a449.
> 
> NOTE! This patch is against that original bad commit. The flags have since 
> been moved from 'state' to 'port', so the test for UIF_INITIALIZED is now
> 
> 	if (port->flags & UIF_INITIALIZED)
> 
> rather than
> 
> 	if (state->flags & UIF_INITIALIZED)
> 
> and you need to either edit the patch or apply it with "git apply -C1" to 
> make it apply to current git.

And UIF_INITIALIZED changed to ASYNC_INITIALIZED as well.

> Does that missing test for NULL 'state' fix your oops?

Yes it does! Find below the combo patch against your tree.

	Ingo

-------------------->

Subject: tty, serial: Fix race and NULL check in uart_close()
From: Linus Torvalds <torvalds@linux-foundation.org>

Commit 46d57a449aa1 ("serial: use tty_port pointers in the core code") 
contained two bugs that causes (rare) crashes:

 - the rename typoed one site

 - a NULL check was missed

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 1689bda..dcc7244 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1270,6 +1270,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	BUG_ON(!kernel_locked());
 
+	if (!state)
+		return;
+
 	uport = state->uart_port;
 	port = &state->port;
 
@@ -1316,9 +1319,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 */
 	if (port->flags & ASYNC_INITIALIZED) {
 		unsigned long flags;
-		spin_lock_irqsave(&port->lock, flags);
+		spin_lock_irqsave(&uport->lock, flags);
 		uport->ops->stop_rx(uport);
-		spin_unlock_irqrestore(&port->lock, flags);
+		spin_unlock_irqrestore(&uport->lock, flags);
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially


