Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYJMHv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYJMHv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYJMHvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:51:49 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:54465 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbYJMHvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:51:48 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: benh@kernel.crashing.org
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions with callbacks
Date: Mon, 13 Oct 2008 09:51:31 +0200
User-Agent: KMail/1.9.9
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200806031444.21945.borntraeger@de.ibm.com> <200806031445.22561.borntraeger@de.ibm.com> <1223875013.8157.230.camel@pasglop>
In-Reply-To: <1223875013.8157.230.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810130951.31733.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. Oktober 2008 schrieb Benjamin Herrenschmidt:
>   ... key      at: [<c000000000939018>] proc_subdir_lock+0x18/0x38
>  ... acquired at:
>    [<c0000000000832e8>] .__lock_acquire+0x814/0x8ec
>    [<c000000000083464>] .lock_acquire+0xa4/0xec
>    [<c0000000004e713c>] ._spin_lock+0x44/0xa0
>    [<c000000000139144>] .xlate_proc_name+0x50/0xf8
>    [<c0000000001392f4>] .remove_proc_entry+0x44/0x298
>    [<c0000000000a1e74>] .unregister_handler_proc+0x40/0x58
>    [<c00000000009fc58>] .free_irq+0x124/0x18c
>    [<c0000000002e6634>] .notifier_del_irq+0x28/0x48
>    [<c0000000002e5ddc>] .hvc_close+0xa0/0x110
>    [<c0000000002cc328>] .release_dev+0x244/0x580
>    [<c0000000002cc688>] .tty_release+0x24/0x44
>    [<c0000000000e5384>] .__fput+0xf8/0x1dc
>    [<c0000000000e1bec>] .filp_close+0xb4/0xdc
>    [<c0000000000e33a4>] .sys_close+0xac/0x100
>    [<c0000000000084d4>] syscall_exit+0x0/0x40


Hmmm. 
Can you try if this patch fixes the lockdep trace?

This would be analog to
commit b1b135c8d619cb2c7045d6ee4e48375882518bb5
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Thu Aug 7 09:18:34 2008 +0200

    fix spinlock recursion in hvc_console

    commit 611e097d7707741a336a0677d9d69bec40f29f3d
    Author: Christian Borntraeger <borntraeger@de.ibm.com>
    hvc_console: rework setup to replace irq functions with callbacks
    introduced a spinlock recursion problem.


Signed-off-by: Christian Borntraeger<borntraeger@de.ibm.com>
---
 drivers/char/hvc_console.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/char/hvc_console.c
===================================================================
--- linux-2.6.orig/drivers/char/hvc_console.c
+++ linux-2.6/drivers/char/hvc_console.c
@@ -367,13 +367,13 @@ static void hvc_close(struct tty_struct 
 	spin_lock_irqsave(&hp->lock, flags);
 
 	if (--hp->count == 0) {
-		if (hp->ops->notifier_del)
-			hp->ops->notifier_del(hp, hp->data);
-
 		/* We are done with the tty pointer now. */
 		hp->tty = NULL;
 		spin_unlock_irqrestore(&hp->lock, flags);
 
+		if (hp->ops->notifier_del)
+			hp->ops->notifier_del(hp, hp->data);
+
 		/*
 		 * Chain calls chars_in_buffer() and returns immediately if
 		 * there is no buffered data otherwise sleeps on a wait queue
@@ -416,11 +416,11 @@ static void hvc_hangup(struct tty_struct
 	hp->n_outbuf = 0;
 	hp->tty = NULL;
 
+	spin_unlock_irqrestore(&hp->lock, flags);
+
 	if (hp->ops->notifier_del)
 			hp->ops->notifier_del(hp, hp->data);
 
-	spin_unlock_irqrestore(&hp->lock, flags);
-
 	while(temp_open_count) {
 		--temp_open_count;
 		kref_put(&hp->kref, destroy_hvc_struct);

