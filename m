Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913Ab0ARPX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0ARPX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512Ab0ARPX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:23:26 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46353 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0ARPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:23:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=sWMT670RaXrz52DffIDb6BmJc0lZb2QUEzAobQiakwZ5Qi9BpW0Muj7ykPgLrrgmWv
         Lbc436nSUkYL1g/vj52Ekjkp9URXvlUqt/VRgsesMrOwZSMIq2OHVC28oRJ5sin3kECp
         8qutKWU+5x5BVP8iElQLXKfCxpnHRRJYyBu8w=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Joe Perches <joe@perches.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] string: simplify stricmp() and strnstr()
Date: Sun, 17 Jan 2010 13:20:36 -0200
Message-Id: <4779b88ff8d4ee1f9f157ce687b406dbbc92149c.1263741553.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.6.201.g56119
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the code and removes an unneeded variable.

It removes 32 bytes on my core2 with gcc 4.4.1:
   text    data     bss     dec     hex filename
   3196       0       0    3196     c7c lib/string-BEFORE.o
   3164       0       0    3164     c5c lib/string-AFTER.o

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
cc: Li Zefan <lizf@cn.fujitsu.com>
cc: Joe Perches <joe@perches.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/string.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index a1cdcfc..f71bead 100644
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
@@ -693,13 +689,13 @@ EXPORT_SYMBOL(strstr);
  */
 char *strnstr(const char *s1, const char *s2, size_t len)
 {
-	size_t l1 = len, l2;
+	size_t l2;
 
 	l2 = strlen(s2);
 	if (!l2)
 		return (char *)s1;
-	while (l1 >= l2) {
-		l1--;
+	while (len >= l2) {
+		len--;
 		if (!memcmp(s1, s2, l2))
 			return (char *)s1;
 		s1++;
-- 
1.6.6.201.g56119

