Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYC1VTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYC1VTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYC1VTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:19:34 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49315 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755621AbYC1VTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:19:33 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 4/4] Char: rio, fix sparse warnings
Date: Fri, 28 Mar 2008 22:18:44 +0100
Message-Id: <1206739124-3875-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <20080328032449.cbc09f3b.akpm@linux-foundation.org>
References: <20080328032449.cbc09f3b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some locks and unlocks to some code paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/rio/riotable.c |    4 +++-
 drivers/char/rio/riotty.c   |    4 ++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/char/rio/riotable.c b/drivers/char/rio/riotable.c
index dfce405..2b24488 100644
--- a/drivers/char/rio/riotable.c
+++ b/drivers/char/rio/riotable.c
@@ -424,8 +424,10 @@ int RIOApel(struct rio_info *p)
 
 		MapP = &p->RIOConnectTable[Next++];
 		MapP->HostUniqueNum = HostP->UniqueNum;
-		if ((HostP->Flags & RUN_STATE) != RC_RUNNING)
+		if ((HostP->Flags & RUN_STATE) != RC_RUNNING) {
+			rio_spin_unlock_irqrestore(&HostP->HostLock, flags);
 			continue;
+		}
 		MapP->RtaUniqueNum = 0;
 		MapP->ID = 0;
 		MapP->Flags = SLOT_IN_USE;
diff --git a/drivers/char/rio/riotty.c b/drivers/char/rio/riotty.c
index 047531f..c993548 100644
--- a/drivers/char/rio/riotty.c
+++ b/drivers/char/rio/riotty.c
@@ -319,6 +319,7 @@ int riotopen(struct tty_struct *tty, struct file *filp)
 			PortP->State |= RIO_WOPEN;
 			rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 			if (RIODelay(PortP, HUNDRED_MS) == RIO_FAIL) {
+				rio_spin_lock_irqsave(&PortP->portSem, flags);
 				/*
 				 ** ACTION: verify that this is a good thing
 				 ** to do here. -- ???
@@ -334,6 +335,7 @@ int riotopen(struct tty_struct *tty, struct file *filp)
 				func_exit();
 				return -EINTR;
 			}
+			rio_spin_lock_irqsave(&PortP->portSem, flags);
 		}
 		PortP->State &= ~RIO_WOPEN;
 	}
@@ -493,6 +495,7 @@ int riotclose(void *ptr)
 
 	if (RIOShortCommand(p, PortP, RIOC_CLOSE, 1, 0) == RIO_FAIL) {
 		RIOPreemptiveCmd(p, PortP, RIOC_FCLOSE);
+		rio_spin_lock_irqsave(&PortP->portSem, flags);
 		goto close_end;
 	}
 
@@ -508,6 +511,7 @@ int riotclose(void *ptr)
 
 			if (p->RIOHalted) {
 				RIOClearUp(PortP);
+				rio_spin_lock_irqsave(&PortP->portSem, flags);
 				goto close_end;
 			}
 			if (RIODelay(PortP, HUNDRED_MS) == RIO_FAIL) {
-- 
1.5.4.4

