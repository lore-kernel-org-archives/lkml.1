Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728Ab0AQVAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0AQVAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702Ab0AQU77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 15:59:59 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:48733 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0AQU74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 15:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=d3kXcBQeqRSPKIsKhEIhXIztmBCJqTZX3DjsDf0TZg6tnXEzlkXeTxrmwjxDL37Oiu
         kzWa2Uz59sWfaGK88RuFVOPxVftDGFKsUqLXXWMXv/uwy9rREuf7ELPK3VIzwHMNBt5p
         lzAB/VtOmSOsNrewm0GvAuTbis6OFi/7cxJb8=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Joe Perches <joe@perches.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] string: simplify stricmp()
Date: Sat, 16 Jan 2010 18:57:00 -0200
Message-Id: <16ee7c5e218e89f22a28247e4bd3877355f5ae5c.1263675077.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.6.201.g56119
In-Reply-To: <cover.1263675077.git.andre.goddard@gmail.com>
References: <cover.1263675077.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes 32 bytes on core2 with gcc 4.4.1:
   text    data     bss     dec     hex filename
   3196       0       0    3196     c7c lib/string-BEFORE.o
   3164       0       0    3164     c5c lib/string-AFTER.o

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
cc: Joe Perches <joe@perches.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/string.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index a1cdcfc..0f86245 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -36,25 +36,21 @@ int strnicmp(const char *s1, const char *s2, size_t len)
 	/* Yes, Virginia, it had better be unsigned */
 	unsigned char c1, c2;
 
-	c1 = c2 = 0;
-	if (len) {
-		do {
-			c1 = *s1;
-			c2 = *s2;
-			s1++;
-			s2++;
-			if (!c1)
-				break;
-			if (!c2)
-				break;
-			if (c1 == c2)
-				continue;
-			c1 = tolower(c1);
-			c2 = tolower(c2);
-			if (c1 != c2)
-				break;
-		} while (--len);
-	}
+	if (!len)
+		return 0;
+
+	do {
+		c1 = *s1++;
+		c2 = *s2++;
+		if (!c1 || !c2)
+			break;
+		if (c1 == c2)
+			continue;
+		c1 = tolower(c1);
+		c2 = tolower(c2);
+		if (c1 != c2)
+			break;
+	} while (--len);
 	return (int)c1 - (int)c2;
 }
 EXPORT_SYMBOL(strnicmp);
-- 
1.6.6.201.g56119

