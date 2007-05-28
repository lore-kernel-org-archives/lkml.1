Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbXE1N3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbXE1N3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXE1N3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:29:11 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:35778 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753305AbXE1N3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:29:10 -0400
Message-id: <19836306752961214186@wsc.cz>
In-reply-to: <12191294601255228079@wsc.cz>
Subject: [PATCH 5/8] Char: n_r3964, use wait_event_interruptible
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 28 May 2007 15:29:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

n_r3964, use wait_event_interruptible

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2b7813d0f34703e0a4b18593a3186bdc7e719c06
tree 657e6eef237faac65c0c90920e3bb1ae5a8027d9
parent d45ae897fff813cf27d5d6ddfd92d19806831965
author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 21:45:39 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 21:45:39 +0200

 drivers/char/n_r3964.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index 14557a4..6b918b8 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1071,8 +1071,6 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 	struct r3964_client_info *pClient;
 	struct r3964_message *pMsg;
 	struct r3964_client_message theMsg;
-	DECLARE_WAITQUEUE(wait, current);
-
 	int count;
 
 	TRACE_L("read()");
@@ -1086,16 +1084,8 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 				return -EAGAIN;
 			}
 			/* block until there is a message: */
-			add_wait_queue(&pInfo->read_wait, &wait);
-repeat:
-			__set_current_state(TASK_INTERRUPTIBLE);
-			pMsg = remove_msg(pInfo, pClient);
-			if (!pMsg && !signal_pending(current)) {
-				schedule();
-				goto repeat;
-			}
-			__set_current_state(TASK_RUNNING);
-			remove_wait_queue(&pInfo->read_wait, &wait);
+			wait_event_interruptible(pInfo->read_wait,
+					(pMsg = remove_msg(pInfo, pClient)));
 		}
 
 		/* If we still haven't got a message, we must have been signalled */
