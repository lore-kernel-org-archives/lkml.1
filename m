Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYC1VT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYC1VT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbYC1VTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:19:34 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49316 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755608AbYC1VTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:19:33 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/4] Char: ip2, fix sparse warnings
Date: Fri, 28 Mar 2008 22:18:43 +0100
Message-Id: <1206739124-3875-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <20080328032449.cbc09f3b.akpm@linux-foundation.org>
References: <20080328032449.cbc09f3b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlock two grabbed locks on some paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/ip2/i2lib.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ip2/i2lib.c b/drivers/char/ip2/i2lib.c
index 618f5fe..1d5388c 100644
--- a/drivers/char/ip2/i2lib.c
+++ b/drivers/char/ip2/i2lib.c
@@ -643,12 +643,12 @@ i2QueueCommands(int type, i2ChanStrPtr pCh, int timeout, int nCommands,
 				// Normal Expected path - We still hold LOCK
 				break; /* from for()- Enough room: goto proceed */
 			}
-		}
-
-		ip2trace (CHANN, ITRC_QUEUE, 3, 1, totalsize );
+			ip2trace(CHANN, ITRC_QUEUE, 3, 1, totalsize);
+			write_unlock_irqrestore(lock_var_p, flags);
+		} else
+			ip2trace(CHANN, ITRC_QUEUE, 3, 1, totalsize);
 
 		// Prepare to wait for buffers to empty
-		write_unlock_irqrestore(lock_var_p, flags);
 		serviceOutgoingFifo(pB);	// Dump what we got
 
 		if (timeout == 0) {
@@ -1834,6 +1834,8 @@ i2StripFifo(i2eBordStrPtr pB)
 		default: // Neither packet? should be impossible
 			ip2trace (ITRC_NO_PORT, ITRC_SFIFO, 5, 1,
 				PTYPE_OF(pB->i2eLeadoffWord) );
+			write_unlock_irqrestore(&pB->read_fifo_spinlock,
+					bflags);
 
 			break;
 		}  // End of switch on type of packets
-- 
1.5.4.4

