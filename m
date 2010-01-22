Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299Ab0AVE5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0AVE5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244Ab0AVE4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:56:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1354 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab0AVEw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/24] drivers/block/floppy.c: Remove LAST_OUT macro
Date: Thu, 21 Jan 2010 20:52:37 -0800
Message-Id: <8f868db48369288d76d4081c3ee2d35df5f5c726.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros with hidden returns are not nice.
Convert the 2 uses to use direct code.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 461c99a..9f7a658 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1198,8 +1198,6 @@ static int output_byte(char byte)
 	return -1;
 }
 
-#define LAST_OUT(x) if (output_byte(x)<0){ reset_fdc();return;}
-
 /* gets the response from the fdc */
 static int result(void)
 {
@@ -1679,7 +1677,10 @@ static void seek_floppy(void)
 	do_floppy = seek_interrupt;
 	output_byte(FD_SEEK);
 	output_byte(UNIT(current_drive));
-	LAST_OUT(track);
+	if (output_byte(track) < 0) {
+		reset_fdc();
+		return;
+	}
 	debugt("seek command:");
 }
 
@@ -1809,7 +1810,10 @@ static void recalibrate_floppy(void)
 	debugt("recalibrate floppy:");
 	do_floppy = recal_interrupt;
 	output_byte(FD_RECALIBRATE);
-	LAST_OUT(UNIT(current_drive));
+	if (output_byte(UNIT(current_drive)) < 0) {
+		reset_fdc();
+		return;
+	}
 }
 
 /*
-- 
1.6.6.rc0.57.gad7a

