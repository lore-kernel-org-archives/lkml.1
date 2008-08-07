Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYHGHTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYHGHTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 03:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYHGHTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 03:19:33 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:10935 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYHGHTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 03:19:32 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Spinlock recursion in hvc_poll
Date: Thu, 7 Aug 2008 09:18:34 +0200
User-Agent: KMail/1.9.9
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48973E59.1000904@citrix.com> <200808052253.10285.borntraeger@de.ibm.com> <48996B0E.5000009@citrix.com>
In-Reply-To: <48996B0E.5000009@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070918.34220.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. August 2008 schrieb Alex Nixon:
> The patch appears to fix things.

Rusty,

can this patch go into 2.6.27-rc* via your queue?

---snip----

[PATCH] fix spinlock recursion in hvc_console

commit 611e097d7707741a336a0677d9d69bec40f29f3d
Author: Christian Borntraeger <borntraeger@de.ibm.com>
hvc_console: rework setup to replace irq functions with callbacks
introduced a spinlock recursion problem. 

request_irq tries to call the handler if the IRQ is shared.
The irq handler of hvc_console calls hvc_poll and hvc_kill
which might take the hvc_struct spinlock. Therefore, we have
to call request_irq outside the spinlock.

We can move the notifier_add safely outside the spinlock as ->data must
not be changed by the backend. Otherwise, tty_hangup would fail anyway.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/char/hvc_console.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: kvm/drivers/char/hvc_console.c
===================================================================
--- kvm.orig/drivers/char/hvc_console.c
+++ kvm/drivers/char/hvc_console.c
@@ -322,11 +322,10 @@ static int hvc_open(struct tty_struct *t
 
 	hp->tty = tty;
 
-	if (hp->ops->notifier_add)
-		rc = hp->ops->notifier_add(hp, hp->data);
-
 	spin_unlock_irqrestore(&hp->lock, flags);
 
+	if (hp->ops->notifier_add)
+		rc = hp->ops->notifier_add(hp, hp->data);
 
 	/*
 	 * If the notifier fails we return an error.  The tty layer
