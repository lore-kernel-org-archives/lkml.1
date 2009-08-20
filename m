Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbZHTUmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbZHTUmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbZHTUmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:42:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:51312 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbZHTUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:42:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 09/11] ehci-dbgp: errata for EHCI debug/host controller synchronization
Date: Thu, 20 Aug 2009 15:39:56 -0500
Message-Id: <1250800798-31559-10-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1250800798-31559-9-git-send-email-jason.wessel@windriver.com>
References: <1250800798-31559-1-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-2-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-3-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-4-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-5-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-6-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-7-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-8-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-9-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Aug 2009 20:41:08.0617 (UTC) FILETIME=[8BD4AF90:01CA21D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some EHCI debug controllers after the host controller driver is
activated, the debug controller will occasionally fail to submit a
bulk write URB.  On controllers that exhibit this behavior a dummy
bulk write must get submitted to resynchronize the device.

The "dummy bulk write" does not get received by the host attached to
the other end of the usb debug device.  The usb debug device simply
acknowledges the "dummy bulk write" and returns to a usable state.

The behavior, without this patch is that you see missing text from a
complete kernel boot when using the keep option to the earlyprintk
kernel argument.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/usb/early/ehci-dbgp.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index f0a41c6..1206a26 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -245,16 +245,9 @@ static inline void dbgp_get_data(void *buf, int size)
 		bytes[i] = (hi >> (8*(i - 4))) & 0xff;
 }
 
-static int dbgp_bulk_write(unsigned devnum, unsigned endpoint,
-			 const char *bytes, int size)
+static int dbgp_out(u32 addr, const char *bytes, int size)
 {
-	u32 pids, addr, ctrl;
-	int ret;
-
-	if (size > DBGP_MAX_PACKET)
-		return -1;
-
-	addr = DBGP_EPADDR(devnum, endpoint);
+	u32 pids, ctrl;
 
 	pids = readl(&ehci_debug->pids);
 	pids = dbgp_pid_update(pids, USB_PID_OUT);
@@ -267,10 +260,34 @@ static int dbgp_bulk_write(unsigned devnum, unsigned endpoint,
 	dbgp_set_data(bytes, size);
 	writel(addr, &ehci_debug->address);
 	writel(pids, &ehci_debug->pids);
+	return dbgp_wait_until_done(ctrl);
+}
 
-	ret = dbgp_wait_until_done(ctrl);
-	if (ret < 0)
-		return ret;
+static int dbgp_bulk_write(unsigned devnum, unsigned endpoint,
+			 const char *bytes, int size)
+{
+	int ret;
+	int loops = 5;
+	u32 addr;
+	if (size > DBGP_MAX_PACKET)
+		return -1;
+
+	addr = DBGP_EPADDR(devnum, endpoint);
+try_again:
+	if (loops--) {
+		ret = dbgp_out(addr, bytes, size);
+		if (ret == -DBGP_ERR_BAD) {
+			int try_loops = 3;
+			do {
+				/* Emit a dummy packet to re-sync communication
+				 * with the debug device */
+				if (dbgp_out(addr, "12345678", 8) >= 0) {
+					udelay(2);
+					goto try_again;
+				}
+			} while (try_loops--);
+		}
+	}
 
 	return ret;
 }
-- 
1.6.3.1.9.g95405b

