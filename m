Return-Path: <linux-kernel-owner+w=401wt.eu-S1760080AbZAMJGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080AbZAMJGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbZAMJEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:04:36 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:49747 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbZAMJE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:04:27 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 1/4] hvc_console: do not set low_latency
Date: Tue, 13 Jan 2009 10:04:22 +0100
User-Agent: KMail/1.9.9
Cc: Benjiman Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Peterson <joe@skyrush.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <hvc-console-29-3-1@bga.com>
In-Reply-To: <hvc-console-29-3-1@bga.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131004.22609.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 08 Januar 2009 schrieb Milton Miller:
> hvc_console is setting low_latency unconditionally, but some clients are
> interrupt driven and will call hvc_poll from irq context.  This will cause
> tty_flip_buffer_push to be called from irq context, and it very clearly
> states it must not be called from IRQ when low_latency is specified.
> 
> Looking back through history:
> v2.6.16-rc1 via 33f0f88f1c51ae5c2d593d26960c760ea154c2e2
>     [PATCH] TTY layer buffering revamp
> 
> added this new api.
> 
> v2.6.16-rc3 via 8977d929e49021d9a6e031310aab01fa72f849c2
>     [PATCH] tty buffering stall fix
> 
> claims to fix a stall discovered with hvc_console
> 
> v2.6.16-rc5 via fb5c594c2acc441f0d2d8f457484a0e0e9285db3
>    [PATCH] Fix race condition in hvc console.
> 
> said set this flag to avoid a stall problem, and was merged through
> the powerpc arch tree.
> 
> Without searching for email discussions, it would appear to be an
> overlapping "fix", but one that did not consider all users.
> 
> ---
> This version continues to set low_latency if irqs are not flagged to
> be in use, as requested by paulus.   Do all hvc drivers identify the
> interrupt this way?  (A quick look at hvc_iucv says they lock to bh
> and are not irq driven, the rest would have used the irq before that
> patch).
> 
> Having the flag set for purely polled drivers will save delaying
> the work when receiving input for 1 jiffie.
> 
> 
> Index: work.git/drivers/char/hvc_console.c
> ===================================================================
> --- work.git.orig/drivers/char/hvc_console.c	2009-01-08 
03:01:24.000000000 -0600
> +++ work.git/drivers/char/hvc_console.c	2009-01-08 03:01:51.000000000 -0600
> @@ -318,7 +318,8 @@ static int hvc_open(struct tty_struct *t
>  	} /* else count == 0 */
> 
>  	tty->driver_data = hp;
> -	tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
> +	if (!hp->irq_requested)
> +		tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
> 
>  	hp->tty = tty;
> 
> 

This wont work, since the call to notifier_add is done later:
What about:
---
 drivers/char/hvc_console.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/char/hvc_console.c
===================================================================
--- linux-2.6.orig/drivers/char/hvc_console.c
+++ linux-2.6/drivers/char/hvc_console.c
@@ -318,8 +318,6 @@ static int hvc_open(struct tty_struct *t
 	} /* else count == 0 */
 
 	tty->driver_data = hp;
-	tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
-
 	hp->tty = tty;
 
 	spin_unlock_irqrestore(&hp->lock, flags);
@@ -327,6 +325,9 @@ static int hvc_open(struct tty_struct *t
 	if (hp->ops->notifier_add)
 		rc = hp->ops->notifier_add(hp, hp->data);
 
+	if (!hp->irq_requested)
+		tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
+
 	/*
 	 * If the notifier fails we return an error.  The tty layer
 	 * will call hvc_close() after a failed open but we don't want to clean


