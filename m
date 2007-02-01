Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXBAPhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXBAPhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXBAPgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:36:50 -0500
Received: from styx.suse.cz ([82.119.242.94]:34387 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751796AbXBAPgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:36:42 -0500
Date: Thu, 1 Feb 2007 16:36:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 9/10] CRIS: turn local_save_flags() + local_irq_disable()
 into local_irq_save() in headers
In-Reply-To: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702011617300.13648@jikos.suse.cz>
References: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

CRIS: turn local_save_flags() + local_irq_disable() into local_irq_save() in headers

Various headers for CRIS architecture contain local_irq_disable()
after local_save_flags(). Turn it into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 drivers/net/amd8111e.c              |    3 +--
 include/asm-cris/semaphore-helper.h |    9 +++------
 include/asm-cris/system.h           |    3 +--
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index 18896f2..9c399aa 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -1334,8 +1334,7 @@ err_no_interrupt:
 static void amd8111e_poll(struct net_device *dev)
 {
 	unsigned long flags;
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	amd8111e_interrupt(0, dev);
 	local_irq_restore(flags);
 }
diff --git a/include/asm-cris/semaphore-helper.h b/include/asm-cris/semaphore-helper.h
index a8e1e6c..27bfeca 100644
--- a/include/asm-cris/semaphore-helper.h
+++ b/include/asm-cris/semaphore-helper.h
@@ -30,8 +30,7 @@ static inline int waking_non_zero(struct semaphore *sem)
 	unsigned long flags;
 	int ret = 0;
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	if (read(&sem->waking) > 0) {
 		dec(&sem->waking);
 		ret = 1;
@@ -46,8 +45,7 @@ static inline int waking_non_zero_interruptible(struct semaphore *sem,
 	int ret = 0;
 	unsigned long flags;
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	if (read(&sem->waking) > 0) {
 		dec(&sem->waking);
 		ret = 1;
@@ -64,8 +62,7 @@ static inline int waking_non_zero_trylock(struct semaphore *sem)
         int ret = 1;
 	unsigned long flags;
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	if (read(&sem->waking) <= 0)
 		inc(&sem->count);
 	else {
diff --git a/include/asm-cris/system.h b/include/asm-cris/system.h
index b869f61..fea0e8d 100644
--- a/include/asm-cris/system.h
+++ b/include/asm-cris/system.h
@@ -44,8 +44,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
   /* since Etrax doesn't have any atomic xchg instructions, we need to disable
      irq's (if enabled) and do it with move.d's */
   unsigned long flags,temp;
-  local_save_flags(flags); /* save flags, including irq enable bit */
-  local_irq_disable();             /* shut off irq's */
+  local_irq_save(flags); /* save flags, including irq enable bit and shut off irqs */
   switch (size) {
   case 1:
     *((unsigned char *)&temp) = x;
