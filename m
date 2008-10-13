Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbYJMS5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbYJMS5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYJMS5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:57:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:55594 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbYJMS5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:57:10 -0400
Date: Mon, 13 Oct 2008 14:57:12 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@redhat.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: inconsistent lock state (tty? input?)
Message-ID: <20081013145712.5aa06871@infradead.org>
In-Reply-To: <20081013183731.GA5676@joi>
References: <20081013183731.GA5676@joi>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 20:37:43 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On current git (a447c0932445f92ce6f4c1bd020f62c5097a7842):
\

good spotting;

the patch below should fix this:

>From 26c117549415c55585f46ad38cd58a5f84f5adc7 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 13 Oct 2008 14:56:39 -0400
Subject: [PATCH] tty: make sure that proc_clear_tty stores the cpu flags

proc_clear_tty() gets called with interrupts off (while holding the task list lock)
from sys_setid. This means that it needs the _irqsave version of the locking primitives.

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/char/tty_io.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e4dce87..4715961 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3595,9 +3595,10 @@ EXPORT_SYMBOL(tty_devnum);
 
 void proc_clear_tty(struct task_struct *p)
 {
-	spin_lock_irq(&p->sighand->siglock);
+	unsigned long flags;
+	spin_lock_irqsave(&p->sighand->siglock, flags);
 	p->signal->tty = NULL;
-	spin_unlock_irq(&p->sighand->siglock);
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 }
 
 /* Called under the sighand lock */
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
