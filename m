Return-Path: <linux-kernel-owner+w=401wt.eu-S1764223AbYEUAbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764223AbYEUAbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760548AbYEUAan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:30:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45292 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636AbYEUAam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:30:42 -0400
To: mchehab@infradead.org
Subject: [PATCH] fix the roothole in av7110_av.c
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycE5-0004kD-Pw@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:30:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


direct dereferencing from user-supplied address

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/ttpci/av7110_av.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110_av.c b/drivers/media/dvb/ttpci/av7110_av.c
index 3e6b650..ec55a96 100644
--- a/drivers/media/dvb/ttpci/av7110_av.c
+++ b/drivers/media/dvb/ttpci/av7110_av.c
@@ -965,8 +965,9 @@ static u8 iframe_header[] = { 0x00, 0x00, 0x01, 0xe0, 0x00, 0x00, 0x80, 0x00, 0x
 
 static int play_iframe(struct av7110 *av7110, char __user *buf, unsigned int len, int nonblock)
 {
-	int i, n;
+	unsigned i, n;
 	int progressive = 0;
+	int match = 0;
 
 	dprintk(2, "av7110:%p, \n", av7110);
 
@@ -975,12 +976,31 @@ static int play_iframe(struct av7110 *av7110, char __user *buf, unsigned int len
 			return -EBUSY;
 	}
 
-	for (i = 0; i < len - 5; i++) {
-		/* get progressive flag from picture extension */
-		if (buf[i] == 0x00 && buf[i+1] == 0x00 &&
-		    buf[i+2] == 0x01 && (unsigned char)buf[i+3] == 0xb5 &&
-		    (buf[i+4] & 0xf0) == 0x10)
-			progressive = buf[i+5] & 0x08;
+	/* search in buf for instances of 00 00 01 b5 1? */
+	for (i = 0; i < len; i++) {
+		unsigned char c;
+		if (get_user(c, buf + i))
+			return -EFAULT;
+		if (match == 5) {
+			progressive = c & 0x08;
+			match = 0;
+		}
+		if (c == 0x00) {
+			match = (match == 1 || match == 2) ? 2 : 1;
+			continue;
+		}
+		switch (match++) {
+		case 2: if (c == 0x01)
+				continue;
+			break;
+		case 3: if (c == 0xb5)
+				continue;
+			break;
+		case 4: if ((c & 0xf0) == 0x10)
+				continue;
+			break;
+		}
+		match = 0;
 	}
 
 	/* setting n always > 1, fixes problems when playing stillframes
-- 
1.5.3.GIT


