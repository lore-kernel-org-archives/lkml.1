Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZLBGH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZLBGH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZLBGHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1239 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZLBGHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:50 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 11/13] drivers/block/floppy.c: Add function is_ready_state
Date: Tue,  1 Dec 2009 22:07:51 -0800
Message-Id: <7ab46de8d857b9bb5c91ea759b65a7ae5bcce870.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used a couple of times, might simplify the code a bit.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 4a9cb15..e054fae 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1307,6 +1307,12 @@ static inline int is_selected(int dor, int unit)
 	return ((dor & (0x10 << unit)) && (dor & 3) == unit);
 }
 
+static bool is_ready_state(int status)
+{
+	int state = status & (STATUS_READY | STATUS_DIR | STATUS_DMA);
+	return state == STATUS_READY;
+}
+
 static int set_dor(int fdc, char mask, char data)
 {
 	unsigned char unit;
@@ -1348,8 +1354,10 @@ static void twaddle(void)
 	DRS->select_date = jiffies;
 }
 
-/* reset all driver information about the current fdc. This is needed after
- * a reset, and after a raw command. */
+/*
+ * Reset all driver information about the current fdc.
+ * This is needed after a reset, and after a raw command.
+ */
 static void reset_fdc_info(int mode)
 {
 	int drive;
@@ -1688,7 +1696,7 @@ static int output_byte(char byte)
 	if (status < 0)
 		return -1;
 
-	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY) {
+	if (is_ready_state(status)) {
 		fd_outb(byte, FD_DATA);
 #ifdef FLOPPY_SANITY_CHECK
 		output_log[output_log_pos].data = byte;
@@ -1748,8 +1756,10 @@ static int need_more_output(void)
 
 	if (status < 0)
 		return -1;
-	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY)
+
+	if (is_ready_state(status))
 		return MORE_OUTPUT;
+
 	return result();
 }
 
-- 
1.6.6.rc0.57.gad7a

