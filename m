Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690Ab0AVExf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0AVExf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434Ab0AVExL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:53:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1360 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab0AVExC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:02 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 23/24] drivers/block/floppy.c: Add function is_ready_state
Date: Thu, 21 Jan 2010 20:52:53 -0800
Message-Id: <6c36e2c84155593c8f2d1331da8fbbfacd99e032.1264133864.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used a couple of times, might simplify the code a bit.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 2f6ed78..fd56b26 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -782,6 +782,12 @@ static inline int is_selected(int dor, int unit)
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
@@ -823,8 +829,10 @@ static void twaddle(void)
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
@@ -1162,7 +1170,8 @@ static int output_byte(char byte)
 
 	if (status < 0)
 		return -1;
-	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY) {
+
+	if (is_ready_state(status)) {
 		fd_outb(byte, FD_DATA);
 #ifdef FLOPPY_SANITY_CHECK
 		output_log[output_log_pos].data = byte;
@@ -1221,8 +1230,10 @@ static int need_more_output(void)
 
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

