Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbZEFCBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbZEFCBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbZEFCAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:00:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:50560 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbZEFCAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:00:30 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/5] usb,early_printk: insert cr prior to nl as needed
Date: Tue,  5 May 2009 21:00:03 -0500
Message-Id: <1241575205-12199-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241575205-12199-3-git-send-email-jason.wessel@windriver.com>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-2-git-send-email-jason.wessel@windriver.com>
 <1241575205-12199-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 06 May 2009 02:00:02.0409 (UTC) FILETIME=[5E426590:01C9CDEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rs232 drivers send a carriage return prior to a new line in the
early printk code.

The usb debug driver should do the same because you want to be able to
use the same terminal programs and tools for analysis of early printk
data.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/early_printk.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 335f049..e38c467 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -853,17 +853,27 @@ static int __init early_dbgp_init(char *s)
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
1.6.3.rc0.1.gf800

