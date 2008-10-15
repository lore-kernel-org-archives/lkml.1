Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbYJOJxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbYJOJxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYJOJxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:53:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39103 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040AbYJOJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:53:05 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: make sure that proc_clear_tty stores the cpu flags
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2008 10:52:34 +0100
Message-ID: <20081015095214.330.59301.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

proc_clear_tty() gets called with interrupts off (while holding the task list
lock) from sys_setid. This means that it needs the _irqsave version of the
locking primitives.

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 7053d63..3f48d88 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3032,11 +3032,12 @@ EXPORT_SYMBOL(tty_devnum);
 
 void proc_clear_tty(struct task_struct *p)
 {
+	unsigned long flags;
 	struct tty_struct *tty;
-	spin_lock_irq(&p->sighand->siglock);
+	spin_lock_irqsave(&p->sighand->siglock, flags);
 	tty = p->signal->tty;
 	p->signal->tty = NULL;
-	spin_unlock_irq(&p->sighand->siglock);
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	tty_kref_put(tty);
 }
 

