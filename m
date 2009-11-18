Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZKRVb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZKRVb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbZKRVb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:31:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34820 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbZKRVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:31:56 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Andreas Schwab <schwab@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] strcmp: fix overflow and possibly signedness error
Date: Wed, 18 Nov 2009 22:31:52 +0100
Message-Id: <1258579912-24520-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain>
References: <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

	signed char __res = *cs - *ct;

is wrong for two reasons.  The subtraction can overflow because __res
doesn't use a type big enough.  Moreover the compared bytes should be
interpreted as unsigned char as specified by POSIX.

The same problem is fixed in strncmp.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
Hello Linus,

I resend with a (hopefully) nice commit log as this didn't appear in
your tree up to now.

Best regards
Uwe

 lib/string.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index b19b87a..e96421a 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -246,13 +246,17 @@ EXPORT_SYMBOL(strlcat);
 #undef strcmp
 int strcmp(const char *cs, const char *ct)
 {
-	signed char __res;
+	unsigned char c1, c2;
 
 	while (1) {
-		if ((__res = *cs - *ct++) != 0 || !*cs++)
+		c1 = *cs++;
+		c2 = *ct++;
+		if (c1 != c2)
+			return c1 < c2 ? -1 : 1;
+		if (!c1)
 			break;
 	}
-	return __res;
+	return 0;
 }
 EXPORT_SYMBOL(strcmp);
 #endif
@@ -266,14 +270,18 @@ EXPORT_SYMBOL(strcmp);
  */
 int strncmp(const char *cs, const char *ct, size_t count)
 {
-	signed char __res = 0;
+	unsigned char c1, c2;
 
 	while (count) {
-		if ((__res = *cs - *ct++) != 0 || !*cs++)
+		c1 = *cs++;
+		c2 = *ct++;
+		if (c1 != c2)
+			return c1 < c2 ? -1 : 1;
+		if (!c1)
 			break;
 		count--;
 	}
-	return __res;
+	return 0;
 }
 EXPORT_SYMBOL(strncmp);
 #endif
-- 
1.6.5.2

