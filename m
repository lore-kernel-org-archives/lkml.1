Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbYHGUms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbYHGUms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbYHGUmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:42:38 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:61695 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708AbYHGUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:42:37 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Fix race/oops in tty layer after BKL pushdown
Date: Thu, 7 Aug 2008 22:42:20 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Olaf Schnapper <os@de.ibm.com>
References: <200808071433.06885.borntraeger@de.ibm.com> <20080807204439.1f8de826@lxorguk.ukuu.org.uk>
In-Reply-To: <20080807204439.1f8de826@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808072242.20422.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 7. August 2008 schrieb Alan Cox:
> > It seems that tty was already free in disassocate_ctty when it tries
> > to dereference tty->driver.
> > 
> > After moving the lock_kernel before the mutex_unlock, I can no longer
> > reproduce the problem.
> > 
> > Please review and consider to apply:
> 
> This doesn't help as the BKL doesn't protect tty here - we don't have
> refcounting on the ttys yet so this bug (which goes back forever) simply
> becomes a different sized race if you swap the lock ordering.
> 
> Given tty_vhangup just fires off a wait queue which is killed on the tty
> destruction you should be able for now at least to move the mutex_unlock
> to after the call to tty_vhangup().
> 
> Does that also fix the problem ?

You mean something like the below patch? Yes, that works as well.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 drivers/char/tty_io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: kvm/drivers/char/tty_io.c
===================================================================
--- kvm.orig/drivers/char/tty_io.c
+++ kvm/drivers/char/tty_io.c
@@ -1161,12 +1161,11 @@ void disassociate_ctty(int on_exit)
 	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
-		mutex_unlock(&tty_mutex);
 		lock_kernel();
-		/* XXX: here we race, there is nothing protecting tty */
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
 		unlock_kernel();
+		mutex_unlock(&tty_mutex);
 	} else if (on_exit) {
 		struct pid *old_pgrp;
 		spin_lock_irq(&current->sighand->siglock);
