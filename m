Return-Path: <linux-kernel-owner+w=401wt.eu-S1764960AbYHEUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764960AbYHEUxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbYHEUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:53:38 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:7678 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936AbYHEUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:53:37 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Alex Nixon <alex.nixon@citrix.com>
Subject: Re: Spinlock recursion in hvc_poll
Date: Tue, 5 Aug 2008 22:53:10 +0200
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <48973E59.1000904@citrix.com> <48987DD8.8080009@citrix.com> <48989727.8090804@goop.org>
In-Reply-To: <48989727.8090804@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808052253.10285.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 5. August 2008 schrieb Jeremy Fitzhardinge:
> Alex Nixon wrote:
> >>> Well I say fixed - it just means I can proceed to a spinlock recursion
> >>> BUG() 2 secs into the boot process, but it should be easier to track 
down
> >>> with printks and a coherent stack dump at my disposal.
> >>>   
> >>>       
> >> What's the backtrace on this?
> >>     
> >
> > I just turned DEBUG_SPINLOCKS back on to try catch this bug again, and it
> > seems to occur (very roughly) 1/10 of the time, with nothing changing 
between
> > runs.

Ok, this is a guess, I dont fully understand the backtrace.

request_irq tries to call the handler if the IRQ is shared. The irq handler 
calls hvc_poll and hvc_kill which might take the same spinlock. 
Can you test it this patch fixes the problem?

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/char/hvc_console.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/char/hvc_console.c
===================================================================
--- linux-2.6.orig/drivers/char/hvc_console.c
+++ linux-2.6/drivers/char/hvc_console.c
@@ -322,10 +322,11 @@ static int hvc_open(struct tty_struct *t
 
 	hp->tty = tty;
 
+	spin_unlock_irqrestore(&hp->lock, flags);
+
 	if (hp->ops->notifier_add)
 		rc = hp->ops->notifier_add(hp, hp->data);
 
-	spin_unlock_irqrestore(&hp->lock, flags);
 
 
 	/*
