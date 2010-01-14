Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087Ab0ANPJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab0ANPJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106Ab0ANPJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:09:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:47617 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab0ANPAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:00:53 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 13/40] sh,sh-sci: Use NO_POLL_CHAR in the SCIF polled console code
Date: Thu, 14 Jan 2010 08:59:09 -0600
Message-Id: <1263481176-1897-14-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:00:30.0006 (UTC) FILETIME=[50316560:01CA952A]
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
index 37f0de9..d29b3fe 100644
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
1.6.3.1.9.g95405b

