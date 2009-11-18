Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZKSQFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZKSQFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZKSQFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:05:09 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:53130 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbZKSQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=M86LUZtLt1QyELcTeLuaOn/YMbWGrnLL2RzJR4hdi80S5MS7gengL0ob5akCp0HJwk
         HNt/OZCKTwgcmVLuFPeeCWJxnGnwFKtDJ36qNRwVwOxKpHii5m58a8egqtHNo5vnqn5d
         Nj4SvzmV0OHA17pLNoeb+auepC20HHZ0CQmGs=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH] parser: remove unnecessary strlen()
Date: Wed, 18 Nov 2009 14:02:59 -0200
Message-Id: <922f652ded6488f697f4b92e47064b41685a41d8.1258559170.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.3.148.g785c5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Cache strlen() result to avoid recalculating it up
to 3 times on the worst case.

Reduces code size a little by 32 bytes:
   text    data     bss     dec     hex filename
   1385       0       0    1385     569 lib/parser.o-BEFORE
   1353       0       0    1353     549 lib/parser.o-AFTER

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/parser.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/lib/parser.c b/lib/parser.c
index b00d020..fb34977 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -56,13 +56,16 @@ static int match_one(char *s, const char *p, substring_t args[])
 
 		args[argc].from = s;
 		switch (*p++) {
-		case 's':
-			if (strlen(s) == 0)
+		case 's': {
+			size_t str_len = strlen(s);
+
+			if (str_len == 0)
 				return 0;
-			else if (len == -1 || len > strlen(s))
-				len = strlen(s);
+			if (len == -1 || len > str_len)
+				len = str_len;
 			args[argc].to = s + len;
 			break;
+		}
 		case 'd':
 			simple_strtol(s, &args[argc].to, 0);
 			goto num;
-- 
1.6.5.3.148.g785c5

