Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZGTUJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZGTUJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZGTUJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:09:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:36136 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZGTUJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:09:32 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 02/10] usb,early_printk: insert cr prior to nl as needed
Date: Mon, 20 Jul 2009 15:06:24 -0500
Message-Id: <1248120392-8372-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.3.523.g304d0
In-Reply-To: <1248120392-8372-2-git-send-email-jason.wessel@windriver.com>
References: <1248120392-8372-1-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Jul 2009 20:06:38.0676 (UTC) FILETIME=[973E8140:01CA0975]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rs232 drivers send a carriage return prior to a new line in the
early printk code.

The usb debug driver should do the same because you want to be able to
use the same terminal programs and tools for analysis of early printk
data.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/usb/early/ehci-dbgp.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index c7aa0aa..51ec414 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -700,17 +700,27 @@ int __init early_dbgp_init(char *s)
 static void early_dbgp_write(struct console *con, const char *str, u32 n)
 {
 	int chunk, ret;
+	char buf[DBGP_MAX_PACKET];
+	int use_cr = 0;
 
 	if (!ehci_debug)
 		return;
 	while (n > 0) {
-		chunk = n;
-		if (chunk > DBGP_MAX_PACKET)
-			chunk = DBGP_MAX_PACKET;
+		for (chunk = 0; chunk < DBGP_MAX_PACKET && n > 0;
+		     str++, chunk++, n--) {
+			if (!use_cr && *str == '\n') {
+				use_cr = 1;
+				buf[chunk] = '\r';
+				str--;
+				n++;
+				continue;
+			}
+			if (use_cr)
+				use_cr = 0;
+			buf[chunk] = *str;
+		}
 		ret = dbgp_bulk_write(USB_DEBUG_DEVNUM,
-			dbgp_endpoint_out, str, chunk);
-		str += chunk;
-		n -= chunk;
+			dbgp_endpoint_out, buf, chunk);
 	}
 }
 
-- 
1.6.0.3.523.g304d0

