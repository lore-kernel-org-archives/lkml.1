Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbZJLQiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbZJLQiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932786AbZJLQiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:38:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932549AbZJLQiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:38:10 -0400
Date: Mon, 12 Oct 2009 09:37:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] NULL pointer dereference at IP: [<ffffffff812e9ccb>]
 uart_close+0x2a/0x1e4
In-Reply-To: <alpine.LFD.2.01.0910120850590.3438@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910120926110.3438@localhost.localdomain>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012080511.GA22607@elte.hu> <alpine.LFD.2.01.0910120850590.3438@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Linus Torvalds wrote:
> 
> Commit 46d57a449 (which you then bisected to) looks really irritating, 
> since it just renamed variables in annoying ways (ie the old "port" is now 
> "uport", and there's a new "port" that means something else). That thing 
> should have been split up to do the renaming separately, so that a mis-use 
> of "port" would have caused a compile error.
> 
> I'm not seeing anything obvious. Alan obviously found one bug already.

Ok, so I did the "do it as two commits", and when doing that (and being 
fairly careful at all stages to do everything as no-op conversions), I get 
this diff.

It looks like there is not just the wrong lock, but also a test for NULL 
state got dropped by commit 46d57a449.

NOTE! This patch is against that original bad commit. The flags have since 
been moved from 'state' to 'port', so the test for UIF_INITIALIZED is now

	if (port->flags & UIF_INITIALIZED)

rather than

	if (state->flags & UIF_INITIALIZED)

and you need to either edit the patch or apply it with "git apply -C1" to 
make it apply to current git.

Does that missing test for NULL 'state' fix your oops?

		Linus

---
 drivers/serial/serial_core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 0ffefb3..943c070 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1262,6 +1262,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	BUG_ON(!kernel_locked());
 
+	if (!state)
+		return;
+
 	uport = state->uart_port;
 	port = &state->port;
 
@@ -1308,9 +1311,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 */
 	if (state->flags & UIF_INITIALIZED) {
 		unsigned long flags;
-		spin_lock_irqsave(&port->lock, flags);
+		spin_lock_irqsave(&uport->lock, flags);
 		uport->ops->stop_rx(uport);
-		spin_unlock_irqrestore(&port->lock, flags);
+		spin_unlock_irqrestore(&uport->lock, flags);
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially
