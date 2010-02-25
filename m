Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab0BYV3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:29:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:63538 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933826Ab0BYVWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:22:31 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 11/28] sh,sh-sci: Use NO_POLL_CHAR in the SCIF polled console code
Date: Thu, 25 Feb 2010 15:21:16 -0600
Message-Id: <1267132893-23624-12-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:21:49.0367 (UTC) FILETIME=[8AB45470:01CAB660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sci_poll_get_char() needs to return immediately if there is no
input from the chip to process, and must return a value of
NO_POLL_CHAR.

This allows kgdboc to process multiple polled devices while kgdb is
active.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
 drivers/serial/sh-sci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 42f3333..2cf3b6d 100644
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

