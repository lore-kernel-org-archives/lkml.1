Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbXJKMYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbXJKMYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbXJKMYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:24:32 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60828 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbXJKMYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:24:31 -0400
Date: Thu, 11 Oct 2007 14:24:17 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Linux RT Users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] RT: fix spin_trylock_irq
Message-ID: <20071011142417.1d965820@bull.net>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 14:30:42,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 14:30:43,
	Serialize complete at 11/10/2007 14:30:43
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  This patch fixes a bug in spin_trylock_irq() where __spin_trylock_irq() is
picked for regular (non-raw) spinlocks instead of _spin_trylock_irq().

  This results in systematic boot hangs and may have been going unnoticed
for quite some time as it only manifests (aside from a compile warning) when
booting with a NUMA config or when using the Chelsio T3 (cxgb3) driver as
these seems to be the sole users.


Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>

---
 include/linux/spinlock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc9-rt2/include/linux/spinlock.h
===================================================================
--- linux-2.6.23-rc9-rt2.orig/include/linux/spinlock.h
+++ linux-2.6.23-rc9-rt2/include/linux/spinlock.h
@@ -501,7 +501,7 @@ do {									\
 
 #define spin_trylock_irq(lock)	\
 	__cond_lock(lock, PICK_SPIN_OP_RET(__spin_trylock_irq,		\
-		__spin_trylock_irq, lock))
+		_spin_trylock_irq, lock))
 
 #define spin_trylock_irqsave(lock, flags) \
 	__cond_lock(lock, PICK_SPIN_OP_RET(__spin_trylock_irqsave, 	\
