Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZLWVVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZLWVVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbZLWVVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:45294 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZLWVVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 14/37] sh,sh-sci: Use NO_POLL_CHAR in the SCIF polled console code
Date: Wed, 23 Dec 2009 15:19:27 -0600
Message-Id: <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:13.0895 (UTC) FILETIME=[B75C7570:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sci_poll_get_char() needs to return immediately if there is no
input from the chip to process, and must return a value of
NO_POLL_CHAR.

This allows kgdboc to process multiple polled devices while kgdb is
active.

CC: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/sh-sci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 68c7f6c..ab020eb 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -126,7 +126,11 @@ static int sci_poll_get_char(struct uart_port *port)
 			handle_error(port);
 			continue;
 		}
-	} while (!(status & SCxSR_RDxF(port)));
+		break;
+	} while (1);
+
+	if (!(status & SCxSR_RDxF(port)))
+		return NO_POLL_CHAR;
 
 	c = sci_in(port, SCxRDR);
 
-- 
1.6.4.rc1

