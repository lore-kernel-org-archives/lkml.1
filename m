Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbZFEIYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbZFEIYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZFEIHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37590 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbZFEIGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 55/62] Blackfin: add missing access_ok() checks to user functions
Date: Fri,  5 Jun 2009 04:05:04 -0400
Message-Id: <1244189111-19639-56-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

The core string/clear user functions weren't checking the user pointers
which caused kernel crashes with some bad programs and tests (like LTP).

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/uaccess.h |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/include/asm/uaccess.h b/arch/blackfin/include/asm/uaccess.h
index 3248033..97729be 100644
--- a/arch/blackfin/include/asm/uaccess.h
+++ b/arch/blackfin/include/asm/uaccess.h
@@ -233,16 +233,29 @@ strncpy_from_user(char *dst, const char *src, long count)
 }
 
 /*
- * Return the size of a string (including the ending 0)
+ * Get the size of a string in user space.
+ *   src: The string to measure
+ *     n: The maximum valid length
  *
- * Return 0 on exception, a value greater than N if too long
+ * Get the size of a NUL-terminated string in user space.
+ *
+ * Returns the size of the string INCLUDING the terminating NUL.
+ * On exception, returns 0.
+ * If the string is too long, returns a value greater than n.
  */
-static inline long strnlen_user(const char *src, long n)
+static inline long __must_check strnlen_user(const char *src, long n)
 {
-	return (strlen(src) + 1);
+	if (!access_ok(VERIFY_READ, src, 1))
+		return 0;
+	return strnlen(src, n) + 1;
 }
 
-#define strlen_user(str) strnlen_user(str, 32767)
+static inline long __must_check strlen_user(const char *src)
+{
+	if (!access_ok(VERIFY_READ, src, 1))
+		return 0;
+	return strlen(src) + 1;
+}
 
 /*
  * Zero Userspace
@@ -251,6 +264,8 @@ static inline long strnlen_user(const char *src, long n)
 static inline unsigned long __must_check
 __clear_user(void *to, unsigned long n)
 {
+	if (!access_ok(VERIFY_WRITE, to, n))
+		return n;
 	memset(to, 0, n);
 	return 0;
 }
-- 
1.6.3.1

